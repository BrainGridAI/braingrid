#!/bin/bash
# Sync Claude Code task status to BrainGrid
#
# This hook is triggered by PostToolUse when TaskUpdate is called.
# It uses the git branch to determine the requirement context (e.g., feature/REQ-4-description)
# and queries BrainGrid for a task with matching external_id (Claude task ID).

# Get the project directory (where .claude folder lives)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Read input from stdin (JSON with tool_input and tool_response)
input=$(cat)

# Debug: log full payload to understand what's available
LOG_FILE="/tmp/braingrid-hook-debug.log"
echo "=== $(date) ===" >> "$LOG_FILE"
echo "$input" | jq . >> "$LOG_FILE"

# Extract task ID and status from tool input
task_id=$(echo "$input" | jq -r '.tool_input.taskId // empty')
new_status=$(echo "$input" | jq -r '.tool_input.status // empty')

# Exit early if no task ID or no status update
[ -z "$task_id" ] && exit 0
[ -z "$new_status" ] && exit 0

# Get requirement ID from git branch (e.g., feature/REQ-4-description)
branch=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
req_id=$(echo "$branch" | grep -oE "REQ-[0-9]+" | head -1)

# Exit if not on a feature branch with REQ-X pattern
[ -z "$req_id" ] && exit 0

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
[ -z "$bg_task_id" ] && exit 0

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

# Sync status to BrainGrid (silent, non-blocking)
braingrid task update "$bg_task_id" -r "$req_id" --status "$bg_status" >/dev/null 2>&1

# Always exit 0 to not block the workflow
exit 0
