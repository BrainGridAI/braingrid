#!/bin/bash
# Structured logging helper for BrainGrid build hooks
# Usage: source "$(dirname "$0")/log-helper.sh"
# Then:  log_event "create-braingrid-task" "api_call" "success" "req=REQ-9 duration=1.2s"

LOG_FILE="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-debug.log"
mkdir -p "$(dirname "$LOG_FILE")"
exec 2>> "$LOG_FILE"

# log_event HOOK EVENT STATUS DETAILS
# Appends: TIMESTAMP | HOOK | EVENT | STATUS | DETAILS
log_event() {
	local hook="${1:-unknown}"
	local event="${2:-unknown}"
	local status="${3:-info}"
	local details="${4:-}"
	printf '%s | %s | %s | %s | %s\n' \
		"$(date '+%H:%M:%S')" "$hook" "$event" "$status" "$details" \
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
