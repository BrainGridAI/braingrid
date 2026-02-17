#!/bin/bash
# TaskCompleted hook: enforce commit before task completion
# Only active during /build sessions (sentinel file present)
# Exit code 2 blocks completion; stderr is feedback to Claude

BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# Read task info from stdin
input=$(cat)

# Extract task subject
subject=$(echo "$input" | jq -r '.task.subject // empty')
[ -z "$subject" ] && exit 0

# Check for staged but uncommitted changes
if ! git diff --cached --quiet 2>/dev/null; then
	echo "Task cannot be completed: there are staged changes that haven't been committed. Please commit your staged changes before marking the task as completed." >&2
	exit 2
fi

# Check for unstaged changes to tracked files
if ! git diff --quiet 2>/dev/null; then
	echo "Task cannot be completed: there are unstaged changes to tracked files. Please stage and commit your changes before marking the task as completed." >&2
	exit 2
fi

# Check task subject contains a commit hash: TASK N (hash): type: description
if ! echo "$subject" | grep -qE '^TASK [0-9]+ \([a-f0-9]+\): '; then
	echo "Task subject is missing the commit hash. Update the subject to: 'TASK N (HASH): type: description' where HASH is the short git commit hash (git rev-parse --short HEAD)." >&2
	exit 2
fi

# All checks pass
exit 0
