#!/bin/bash

# Acceptance Criteria Verification Stop Hook
# Prevents session exit when build verification is active
# Checks the acceptance criteria file for unchecked items ([] lines)
# Only allows exit when all criteria show [x] with proof

set -euo pipefail

# Structured logging
source "$(dirname "$0")/log-helper.sh"
HOOK="verify-acceptance-criteria"
# Log to both stderr (Claude feedback) and log file
log_err() { echo "$1" | tee -a "$LOG_FILE" >&2; }
# Track previous unchecked count for stall detection
PREV_UNCHECKED_FILE="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/verify-prev-unchecked.local"

# Only active during /build sessions (sentinel file present)
BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
STATE_FILE=".braingrid/temp/build-verification.local.md"

cleanup() {
	rm -f "$STATE_FILE" "$BUILD_SENTINEL" "${STATE_FILE}.tmp.$$" 2>/dev/null
}

full_cleanup() {
	rm -f "${CLAUDE_PROJECT_DIR:-.}"/.braingrid/temp/* 2>/dev/null
}

trap 'cleanup; exit 0' ERR SIGINT SIGTERM

[ ! -f "$BUILD_SENTINEL" ] && exit 0

# If no active verification loop, allow exit
if [[ ! -f "$STATE_FILE" ]]; then
	rm -f "$BUILD_SENTINEL"
	exit 0
fi

# Parse YAML frontmatter (strip \r for CRLF safety from Dropbox sync)
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE" | tr -d '\r')
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
CRITERIA_FILE=$(echo "$FRONTMATTER" | grep '^criteria_file:' | sed 's/criteria_file: *//')

# Validate numeric fields
if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
	log_err "Warning: Build verification state file corrupted (invalid iteration: '$ITERATION'). Cleaning up."
	cleanup
	exit 0
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
	log_err "Warning: Build verification state file corrupted (invalid max_iterations: '$MAX_ITERATIONS'). Cleaning up."
	cleanup
	exit 0
fi

# Check max iterations safety limit
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
	log_err "Build verification: Max iterations ($MAX_ITERATIONS) reached. Stopping verification loop."
	cleanup
	exit 0
fi

# Check if criteria file exists
if [[ -z "$CRITERIA_FILE" ]] || [[ ! -f "$CRITERIA_FILE" ]]; then
	log_err "Build verification: Criteria file not found ('$CRITERIA_FILE'). Cleaning up."
	cleanup
	exit 0
fi

# Count unchecked and total criteria
# Unchecked: lines starting with "- []" (with optional leading whitespace)
UNCHECKED=$(grep -cE '^[[:space:]]*-[[:space:]]*\[\]' "$CRITERIA_FILE" 2>/dev/null || true)
UNCHECKED="${UNCHECKED//[^0-9]/}"
UNCHECKED=${UNCHECKED:-0}
# Checked: lines starting with "- [x]" or "- [X]"
CHECKED=$(grep -cE '^[[:space:]]*-[[:space:]]*\[[xX]\]' "$CRITERIA_FILE" 2>/dev/null || true)
CHECKED="${CHECKED//[^0-9]/}"
CHECKED=${CHECKED:-0}
TOTAL=$((CHECKED + UNCHECKED))

# If no criteria found at all, clean up and allow exit
if [[ $TOTAL -eq 0 ]]; then
	log_err "Build verification: No criteria found in file. Cleaning up."
	cleanup
	exit 0
fi

# All criteria verified - check for unpushed commits before allowing exit
if [[ $UNCHECKED -eq 0 ]] && [[ $TOTAL -gt 0 ]]; then
	log_event "$HOOK" "complete" "success" "all $TOTAL criteria verified iteration=$ITERATION"
	log_err "All $TOTAL acceptance criteria verified with proof."

	# Enforce git push before exit
	CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
	if [[ -n "$CURRENT_BRANCH" ]] && [[ "$CURRENT_BRANCH" != "main" ]] && [[ "$CURRENT_BRANCH" != "master" ]]; then
		HAS_UPSTREAM=$(git rev-parse --abbrev-ref '@{u}' 2>/dev/null || true)
		if [[ -z "$HAS_UPSTREAM" ]]; then
			log_event "$HOOK" "push_check" "BLOCK" "no upstream for branch=$CURRENT_BRANCH"
			jq -n \
				--arg branch "$CURRENT_BRANCH" \
				'{
					"decision": "block",
					"reason": ("All criteria verified but branch \"" + $branch + "\" has no upstream tracking branch. Run: git push --set-upstream origin " + $branch),
					"systemMessage": "Unpushed commits: push branch to remote before exiting"
				}'
			exit 0
		fi

		AHEAD=$(git rev-list --count '@{u}..HEAD' 2>/dev/null || echo "0")
		AHEAD="${AHEAD//[^0-9]/}"
		AHEAD=${AHEAD:-0}
		if [[ $AHEAD -gt 0 ]]; then
			log_event "$HOOK" "push_check" "BLOCK" "branch=$CURRENT_BRANCH ahead=$AHEAD"
			jq -n \
				--arg branch "$CURRENT_BRANCH" \
				--arg ahead "$AHEAD" \
				'{
					"decision": "block",
					"reason": ("All criteria verified but " + $ahead + " unpushed commit(s) on \"" + $branch + "\". Run: git push"),
					"systemMessage": "Unpushed commits: push before exiting"
				}'
			exit 0
		fi

		log_event "$HOOK" "push_check" "OK" "branch=$CURRENT_BRANCH up-to-date"
	fi

	rm -f "$PREV_UNCHECKED_FILE"
	full_cleanup
	exit 0
fi

# Stall detection: compare unchecked count with previous iteration
PREV_UNCHECKED=""
[ -f "$PREV_UNCHECKED_FILE" ] && PREV_UNCHECKED=$(cat "$PREV_UNCHECKED_FILE" 2>/dev/null)
if [[ -n "$PREV_UNCHECKED" ]] && [[ "$UNCHECKED" -eq "$PREV_UNCHECKED" ]]; then
	log_event "$HOOK" "iterate" "STALL" "iteration=$ITERATION checked=$CHECKED unchecked=$UNCHECKED (unchanged)"
else
	log_event "$HOOK" "iterate" "info" "iteration=$ITERATION checked=$CHECKED unchecked=$UNCHECKED"
fi
echo "$UNCHECKED" > "$PREV_UNCHECKED_FILE"

# Not all verified - block exit and re-inject verification prompt
NEXT_ITERATION=$((ITERATION + 1))

# Extract prompt (everything after the closing ---)
PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$STATE_FILE")

if [[ -z "$PROMPT_TEXT" ]]; then
	log_err "Build verification: State file missing prompt text. Cleaning up."
	cleanup
	exit 0
fi

# Update iteration counter in state file
TEMP_FILE="${STATE_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$STATE_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$STATE_FILE"

# Build system message with progress
SYSTEM_MSG="Verification iteration $NEXT_ITERATION | Progress: $CHECKED/$TOTAL criteria verified | $UNCHECKED remaining"

# Output JSON to block the stop and feed prompt back
jq -n \
	--arg prompt "$PROMPT_TEXT" \
	--arg msg "$SYSTEM_MSG" \
	'{
		"decision": "block",
		"reason": $prompt,
		"systemMessage": $msg
	}'

exit 0
