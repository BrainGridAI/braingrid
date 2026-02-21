#!/bin/bash
# TaskCompleted hook: enforce commit before task completion
# Only active during /build sessions (sentinel file present)
# Exit code 2 blocks completion; stderr is feedback to Claude

# Structured logging
source "$(dirname "$0")/log-helper.sh"
HOOK="task-completed-validate"
# Log to both stderr (Claude feedback) and log file
log_err() { echo "$1" | tee -a "$LOG_FILE" >&2; }

BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# Read task info from stdin
input=$(cat)

# Extract task subject
subject=$(echo "$input" | jq -r '.task.subject // empty')
[ -z "$subject" ] && exit 0

# Check for staged but uncommitted changes
if ! git diff --cached --quiet 2>/dev/null; then
	dirty_files=$(git diff --cached --stat 2>/dev/null || true)
	log_event "$HOOK" "check_staged" "DENY" "staged uncommitted changes"
	log_event "$HOOK" "dirty_files" "info" "$dirty_files"
	log_err "DENY task-completed-validate: staged uncommitted changes"
	echo "Task cannot be completed: there are staged changes that haven't been committed. Please commit your staged changes before marking the task as completed." >&2
	exit 2
fi

# Check for unstaged changes to tracked files
if ! git diff --quiet 2>/dev/null; then
	dirty_files=$(git diff --stat 2>/dev/null || true)
	log_event "$HOOK" "check_unstaged" "DENY" "unstaged changes to tracked files"
	log_event "$HOOK" "dirty_files" "info" "$dirty_files"
	log_err "DENY task-completed-validate: unstaged changes to tracked files"
	echo "Task cannot be completed: there are unstaged changes to tracked files. Please stage and commit your changes before marking the task as completed." >&2
	exit 2
fi

# Check task subject contains a commit hash: TASK N (hash): type: description
if ! echo "$subject" | grep -qE '^TASK [0-9]+ \([a-f0-9]+\): '; then
	log_event "$HOOK" "check_hash" "DENY" "missing commit hash subject=$subject"
	log_err "DENY task-completed-validate: missing commit hash in subject: $subject"
	echo "Task subject is missing the commit hash. Update the subject to: 'TASK N (HASH): type: description' where HASH is the short git commit hash (git rev-parse --short HEAD)." >&2
	exit 2
fi

log_event "$HOOK" "validate" "ALLOW" "subject=$subject"

# All checks pass
exit 0
