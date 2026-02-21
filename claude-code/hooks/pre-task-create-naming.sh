#!/bin/bash
# PreToolUse hook for TaskCreate: enforce TASK N naming convention
# Only active during /build sessions (sentinel file present)

# Structured logging
source "$(dirname "$0")/log-helper.sh"
HOOK="pre-task-create-naming"

BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# Read tool input from stdin
input=$(cat)

# Extract subject from tool_input
subject=$(echo "$input" | jq -r '.tool_input.subject // empty')
[ -z "$subject" ] && exit 0

# Validate subject matches: TASK N: type: description
# Hash is NOT expected at creation time — it gets added after commit via TaskUpdate
# Optional scope in parentheses after type, optional (blocked by N,...) suffix
if echo "$subject" | grep -qE '^TASK [0-9]+: (feat|fix|docs|style|refactor|perf|test|chore)(\([^)]+\))?: .+'; then
	log_event "$HOOK" "validate" "ALLOW" "subject=$subject"
	jq -n '{
		"decision": "allow",
		"additionalContext": "Use sequential task numbering. N must be the next sequential number (1, 2, 3, ...) based on existing tasks in the current session.\n\nExamples:\n  TASK 1: feat: add user login\n  TASK 2: fix: resolve null pointer\n  TASK 3: feat(auth): add OAuth support (blocked by 1,2)\n\nWhen a task has addBlockedBy dependencies, append '\'' (blocked by N,N,...)'\'' at the end of the subject using the blocking task IDs."
	}'
	exit 0
fi

# Subject does not match convention - deny with explanation
log_event "$HOOK" "validate" "DENY" "subject=$subject"
jq -n \
	--arg subject "$subject" \
	'{
		"decision": "deny",
		"reason": "Task subject must follow the format: TASK N: type: description\nValid types: feat, fix, docs, style, refactor, perf, test, chore\nOptional scope: TASK N: type(scope): description\nOptional blockers suffix: ... (blocked by 1,2)\nCommit hash is added later via TaskUpdate after committing.\nGot: " + $subject
	}'

exit 0
