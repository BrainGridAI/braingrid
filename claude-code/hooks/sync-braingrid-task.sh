#!/bin/bash
# Sync Claude Code task status to BrainGrid
#
# This hook is triggered by PostToolUse when TaskUpdate is called.
# It uses the git branch to determine the requirement context (e.g., feature/REQ-4-description)
# and queries BrainGrid for a task with matching external_id (Claude task ID).

# Structured logging
source "$(dirname "$0")/log-helper.sh"
HOOK="sync-braingrid-task"

# Only active during /build sessions (sentinel file present)
BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# Get the project directory (where .claude folder lives)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Read input from stdin (JSON with tool_input and tool_response)
input=$(cat)
log_event "$HOOK" "start" "info" ""

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
log_time_start
braingrid task list -r "$req_id" --format json > "$TEMP_JSON" 2>/dev/null
list_dur=$(log_time_end)

# Exit if braingrid command failed or file is empty
if [ ! -s "$TEMP_JSON" ]; then
	log_event "$HOOK" "task_list" "FAILED" "req=$req_id empty_response duration=$list_dur"
	rm -f "$TEMP_JSON"
	exit 0
fi

# Count tasks returned and find matching external_id
task_count=$(jq 'length' "$TEMP_JSON" 2>/dev/null || echo 0)
bg_task_id=$(jq -r --arg ext_id "$task_id" \
	'.[] | select(.external_id == $ext_id) | .number // empty' "$TEMP_JSON" 2>/dev/null | head -1)

# Clean up temp file
rm -f "$TEMP_JSON"

log_event "$HOOK" "task_list" "success" "req=$req_id count=$task_count duration=$list_dur"

# Exit if this task isn't linked to BrainGrid via external_id
if [ -z "$bg_task_id" ]; then
	log_event "$HOOK" "match" "skip" "no BrainGrid task with external_id=$task_id req=$req_id"
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
log_time_start
if braingrid task update "$bg_task_id" -r "$req_id" --status "$bg_status" >> "$LOG_FILE" 2>&1; then
	dur=$(log_time_end)
	log_event "$HOOK" "sync" "success" "bg_task=$bg_task_id req=$req_id status=$bg_status duration=$dur"
else
	exit_code=$?
	dur=$(log_time_end)
	log_event "$HOOK" "sync" "FAILED" "bg_task=$bg_task_id req=$req_id status=$bg_status exit=$exit_code duration=$dur"
fi

# Always exit 0 to not block the workflow
exit 0
