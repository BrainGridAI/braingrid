#!/bin/bash
# PostToolUse hook for TaskUpdate: inject auto-continue instructions
# Only active during /build sessions (sentinel file present)

source "$(dirname "$0")/log-helper.sh"

BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# Read stdin (required for PostToolUse hooks)
cat > /dev/null

# Output auto-continue instructions
jq -n '{
	"hookSpecificOutput": {
		"additionalContext": "After every task status change, follow these rules:\n\n1. **On completion**: Verify you committed your changes and updated the task subject with the commit hash (e.g. '\''TASK 2 (abc1234): feat: add login'\''). If you forgot to commit, do it now before moving on.\n\n2. **Continue immediately**: After completing a task, check TaskList for the next pending task. Mark it as in_progress and start implementing it right away. Do NOT stop to ask the user for permission.\n\n3. **Do not stop until done**: Keep iterating through tasks until ALL tasks are completed. The only valid reason to pause is a genuine blocking question that cannot be answered from the requirement, task descriptions, or codebase.\n\n4. **Never ask to continue**: Do NOT say '\''Would you like me to continue?'\'', '\''Ready for the next task?'\'', '\''Shall I proceed?'\'', or any variation. Just continue."
	}
}'

exit 0
