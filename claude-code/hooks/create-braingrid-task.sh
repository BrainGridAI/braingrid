#!/bin/bash
# Create a BrainGrid task when Claude Code creates an internal task.
#
# This hook is triggered by PostToolUse when TaskCreate is called.
# It uses the git branch to determine the requirement context (e.g., feature/REQ-4-description)
# and creates a linked BrainGrid task with the Claude task ID as external_id.
# The task is created as PLANNED (default). The sync-braingrid-task.sh hook
# handles subsequent status transitions (IN_PROGRESS, COMPLETED) on TaskUpdate.

# Only active during /build sessions (sentinel file present)
BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Structured logging
source "$(dirname "$0")/log-helper.sh"
HOOK="create-braingrid-task"

input=$(cat)
log_event "$HOOK" "start" "info" ""

# Extract task details from tool_input
subject=$(echo "$input" | jq -r '.tool_input.subject // empty')
description=$(echo "$input" | jq -r '.tool_input.description // empty')

[ -z "$subject" ] && exit 0

# Extract Claude task ID from tool_response (try multiple field names)
claude_task_id=$(echo "$input" | jq -r '.tool_response.id // .tool_response.taskId // empty')
[ -z "$claude_task_id" ] && exit 0

# Get requirement ID from git branch
branch=$(git -C "$PROJECT_DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
req_id=$(echo "$branch" | grep -oE "REQ-[0-9]+" | head -1)
[ -z "$req_id" ] && exit 0

# Create BrainGrid task (defaults to PLANNED status) with external_id linking to Claude task
create_args=(task create -r "$req_id" --title "$subject" --external-id "$claude_task_id")
[ -n "$description" ] && create_args+=(--content "$description")
log_time_start
if braingrid "${create_args[@]}" >> "$LOG_FILE" 2>&1; then
	dur=$(log_time_end)
	log_event "$HOOK" "create" "success" "req=$req_id ext_id=$claude_task_id duration=$dur"
else
	exit_code=$?
	dur=$(log_time_end)
	log_event "$HOOK" "create" "FAILED" "req=$req_id ext_id=$claude_task_id exit=$exit_code duration=$dur"
fi

# Always exit 0 to not block the workflow
exit 0
