#!/bin/bash
# Create a BrainGrid task when Claude Code creates an internal task.
#
# This hook is triggered by PostToolUse when TaskCreate is called.
# It uses the git branch to determine the requirement context (e.g., feature/REQ-4-description)
# and creates a linked BrainGrid task with the Claude task ID as external_id.
# The task is created as PLANNED (default). The sync-braingrid-task.sh hook
# handles subsequent status transitions (IN_PROGRESS, COMPLETED) on TaskUpdate.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

input=$(cat)

# Debug logging
LOG_FILE="/tmp/braingrid-hook-debug.log"
echo "=== CREATE $(date) ===" >> "$LOG_FILE"
echo "$input" | jq . >> "$LOG_FILE" 2>/dev/null

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
braingrid "${create_args[@]}" >/dev/null 2>&1

# Always exit 0 to not block the workflow
exit 0
