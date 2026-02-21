#!/bin/bash
# SessionStart hook: clean up stale build sentinel from crashed sessions
# If the sentinel exists but no verification state file exists,
# the sentinel is stale and should be removed.

BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
VERIFICATION_STATE="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-verification.local.md"

# Structured logging (only if temp dir exists, since this runs at session start)
HOOK="check-stale-build-sentinel"
if [ -d "${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp" ]; then
	source "$(dirname "$0")/log-helper.sh"
fi

# No sentinel = nothing to do
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# If verification state file exists, build is legitimately active
[ -f "$VERIFICATION_STATE" ] && exit 0

# Sentinel exists without verification state = stale from a crashed session
log_event "$HOOK" "cleanup" "info" "stale sentinel detected, cleaning temp dir"
rm -f "${CLAUDE_PROJECT_DIR:-.}"/.braingrid/temp/* 2>/dev/null

exit 0
