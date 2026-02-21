#!/bin/bash
# Sync Claude Code task status to BrainGrid
#
# This hook is triggered by PostToolUse when TaskUpdate is called.
# It uses the git branch to determine the requirement context (e.g., feature/REQ-4-description)
# and queries BrainGrid for a task with matching external_id (Claude task ID).

# Debug log — declared early so all exit paths can log breadcrumbs
LOG_FILE="/tmp/braingrid-hook-debug.log"

# Only active during /build sessions (sentinel file present)
BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# Get the project directory (where .claude folder lives)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Read input from stdin (JSON with tool_input and tool_response)
input=$(cat)
echo "=== $(date) ===" >> "$LOG_FILE"
echo "$input" | jq . >> "$LOG_FILE"

# Extract task ID and status from tool input
task_id=$(echo "$input" | jq -r '.tool_input.taskId // empty')
new_status=$(echo "$input" | jq -r '.tool_input.status // empty')

# Exit early if no task ID or no status update
[ -z "$task_id" ] && exit 0
if [ -z "$new_status" ]; then
	echo "SKIP: no status in update for task=$task_id" >> "$LOG_FILE"
	exit 0
fi

# Get requirement ID from git branch (e.g., feature/REQ-4-description)
branch=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
req_id=$(echo "$branch" | grep -oE "REQ-[0-9]+" | head -1)

# Exit if not on a feature branch with REQ-X pattern
if [ -z "$req_id" ]; then
	echo "SKIP: no REQ-X in branch '$branch' for task=$task_id status=$new_status" >> "$LOG_FILE"
	exit 0
fi

# Query BrainGrid for task by external_id
# Use temp file to avoid shell variable issues with control characters in JSON content
TEMP_JSON=$(mktemp)
braingrid task list -r "$req_id" --format json > "$TEMP_JSON" 2>/dev/null

# Exit if braingrid command failed or file is empty
[ ! -s "$TEMP_JSON" ] && { rm -f "$TEMP_JSON"; exit 0; }

# Find task with matching external_id
# JSON output is an array, not {tasks: [...]}
bg_task_id=$(jq -r --arg ext_id "$task_id" \
	'.[] | select(.external_id == $ext_id) | .number // empty' "$TEMP_JSON" 2>/dev/null | head -1)

# Clean up temp file
rm -f "$TEMP_JSON"

# Exit if this task isn't linked to BrainGrid via external_id
if [ -z "$bg_task_id" ]; then
	echo "SKIP: no BrainGrid task with external_id=$task_id for req=$req_id status=$new_status" >> "$LOG_FILE"
	exit 0
fi

# Map Claude Code status to BrainGrid status
case "$new_status" in
	"in_progress")
		bg_status="IN_PROGRESS"
		;;
	"completed")
		bg_status="COMPLETED"
		;;
	"pending")
		bg_status="PLANNED"
		;;
	*)
		# Unknown status, don't sync
		exit 0
		;;
esac

# Sync status to BrainGrid (log errors instead of silencing)
if braingrid task update "$bg_task_id" -r "$req_id" --status "$bg_status" >> "$LOG_FILE" 2>&1; then
	echo "SYNCED: task=$bg_task_id req=$req_id status=$bg_status" >> "$LOG_FILE"
else
	echo "SYNC FAILED: task=$bg_task_id req=$req_id status=$bg_status exit=$?" >> "$LOG_FILE"
fi

# Always exit 0 to not block the workflow
exit 0
