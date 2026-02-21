#!/bin/bash
# PreToolUse hook for TaskUpdate: validate subject naming + inject commit workflow
# Only active during /build sessions (sentinel file present)

# Structured logging
source "$(dirname "$0")/log-helper.sh"
HOOK="pre-task-update-instructions"

BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# Read tool input from stdin
input=$(cat)

# Extract fields from tool_input
status=$(echo "$input" | jq -r '.tool_input.status // empty')
subject=$(echo "$input" | jq -r '.tool_input.subject // empty')

# If subject is being updated, validate the naming convention
# Accepts both formats:
#   TASK N: type: description              (before commit)
#   TASK N (hash): type: description       (after commit, when completing)
if [ -n "$subject" ]; then
	if ! echo "$subject" | grep -qE '^TASK [0-9]+( \([a-f0-9]+\))?: (feat|fix|docs|style|refactor|perf|test|chore)(\([^)]+\))?: .+'; then
		log_event "$HOOK" "validate_subject" "DENY" "bad_format subject=$subject"
		jq -n \
			--arg subject "$subject" \
			'{
				"decision": "deny",
				"reason": "Task subject must follow one of these formats:\n  Before commit: TASK N: type: description\n  After commit:  TASK N (HASH): type: description\nValid types: feat, fix, docs, style, refactor, perf, test, chore\nGot: " + $subject
			}'
		exit 0
	fi
fi

# If completing, also require the commit hash in the subject
if [ "$status" = "completed" ] && [ -n "$subject" ]; then
	if ! echo "$subject" | grep -qE '^TASK [0-9]+ \([a-f0-9]+\): '; then
		log_event "$HOOK" "validate_completion" "DENY" "missing_hash subject=$subject"
		jq -n '{
			"decision": "deny",
			"reason": "Cannot complete a task without a commit hash in the subject. First commit your changes, then update the subject to: TASK N (HASH): type: description"
		}'
		exit 0
	fi
fi

# If status is completed, inject commit workflow guidance
if [ -n "$subject" ] && [ "$status" != "completed" ]; then
	log_event "$HOOK" "validate_subject" "ALLOW" "subject=$subject"
fi
if [ "$status" = "completed" ]; then
	log_event "$HOOK" "validate_completion" "ALLOW" "subject=${subject:-<no subject>}"
	jq -n '{
		"decision": "allow",
		"additionalContext": "Before completing a task, you MUST validate and commit. If status is being set to completed:\n\n1. Run the project'\''s linter, test suite, and type checker (detect from project config — e.g. package.json, Makefile, pyproject.toml, Cargo.toml, etc.).\n2. If any check fails, DO NOT complete - fix first.\n3. Stage relevant files with git add (specific paths, not -A).\n4. Commit using the conventional commit part of the subject as the message (e.g. '\''feat: add user login'\'').\n5. Get the short hash: git rev-parse --short HEAD\n6. Update the task subject to: '\''TASK N (HASH): type: description'\'' - strip any trailing '\''(blocked by ...)'\'' suffix since blockers are resolved by completion. For example, '\''TASK 3: feat: add OAuth support (blocked by 1,2)'\'' becomes '\''TASK 3 (abc1234): feat: add OAuth support'\''.\n7. Only then mark completed.\n\nFor other status changes, proceed normally."
	}'
	exit 0
fi

exit 0
