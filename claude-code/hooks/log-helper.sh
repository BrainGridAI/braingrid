#!/bin/bash
# Structured logging helper for BrainGrid build hooks
# Usage: source "$(dirname "$0")/log-helper.sh"
# Then:  log_event "INFO" "create-braingrid-task" "api_call" "req=REQ-9 duration=1.2s"

BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
REQ_ID=""
if [ -f "$BUILD_SENTINEL" ]; then
	REQ_ID=$(cat "$BUILD_SENTINEL" | tr -d '[:space:]')
fi
export REQ_ID

if [ -n "$REQ_ID" ]; then
	LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/${REQ_ID}-build-debug.log"
else
	LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-debug.log"
fi
mkdir -p "$(dirname "$LOG_FILE")"

# Write session delimiter before redirecting stderr (which creates the file)
if [ -n "$REQ_ID" ] && [ ! -f "$LOG_FILE" ]; then
	printf '\n=== BUILD %s started %s ===\n\n' "$REQ_ID" "$(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
fi

exec 2>> "$LOG_FILE"

# log_event LEVEL HOOK EVENT DETAILS
# Output: TIMESTAMP [LEVEL] HOOK | EVENT | DETAILS
log_event() {
	local level="${1:-INFO}"
	local hook="${2:-unknown}"
	local event="${3:-unknown}"
	local details="${4:-}"
	printf '%s [%-5s] %s | %s | %s\n' \
		"$(date '+%H:%M:%S')" "$level" "$hook" "$event" "$details" \
		>> "$LOG_FILE"
}

# Measure CLI call duration
# Usage: log_time_start; braingrid ...; log_time_end "hook-name" "api_call"
_LOG_START_TIME=""
log_time_start() {
	_LOG_START_TIME=$(date +%s)
}
log_time_end() {
	local hook="${1:-unknown}"
	local event="${2:-unknown}"
	local end_time
	end_time=$(date +%s)
	local duration=$(( end_time - ${_LOG_START_TIME:-$end_time} ))
	echo "${duration}s"
	_LOG_START_TIME=""
}
