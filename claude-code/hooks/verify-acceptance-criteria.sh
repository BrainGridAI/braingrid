#!/bin/bash

# Acceptance Criteria Verification Stop Hook
# Prevents session exit when build verification is active
# Checks the acceptance criteria file for unchecked items ([] lines)
# Only allows exit when all criteria show [x] with proof

set -euo pipefail

# Only active during /build sessions (sentinel file present)
BUILD_SENTINEL="${CLAUDE_PROJECT_DIR:-.}/.braingrid/temp/build-active.local"
[ ! -f "$BUILD_SENTINEL" ] && exit 0

# State file location
STATE_FILE=".braingrid/temp/build-verification.local.md"

# If no active verification loop, allow exit
if [[ ! -f "$STATE_FILE" ]]; then
	exit 0
fi

# Parse YAML frontmatter
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE")
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
CRITERIA_FILE=$(echo "$FRONTMATTER" | grep '^criteria_file:' | sed 's/criteria_file: *//')

# Validate numeric fields
if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
	echo "Warning: Build verification state file corrupted (invalid iteration: '$ITERATION'). Cleaning up." >&2
	rm -f "$STATE_FILE" "$BUILD_SENTINEL"
	exit 0
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
	echo "Warning: Build verification state file corrupted (invalid max_iterations: '$MAX_ITERATIONS'). Cleaning up." >&2
	rm -f "$STATE_FILE" "$BUILD_SENTINEL"
	exit 0
fi

# Check max iterations safety limit
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
	echo "Build verification: Max iterations ($MAX_ITERATIONS) reached. Stopping verification loop." >&2
	rm -f "$STATE_FILE" "$BUILD_SENTINEL"
	exit 0
fi

# Check if criteria file exists
if [[ -z "$CRITERIA_FILE" ]] || [[ ! -f "$CRITERIA_FILE" ]]; then
	echo "Build verification: Criteria file not found ('$CRITERIA_FILE'). Cleaning up." >&2
	rm -f "$STATE_FILE" "$BUILD_SENTINEL"
	exit 0
fi

# Count unchecked and total criteria
# Unchecked: lines starting with "- []" (with optional leading whitespace)
UNCHECKED=$(grep -cE '^\s*-\s*\[\]' "$CRITERIA_FILE" 2>/dev/null || echo "0")
# Checked: lines starting with "- [x]" or "- [X]"
CHECKED=$(grep -cE '^\s*-\s*\[[xX]\]' "$CRITERIA_FILE" 2>/dev/null || echo "0")
TOTAL=$((CHECKED + UNCHECKED))

# If no criteria found at all, clean up and allow exit
if [[ $TOTAL -eq 0 ]]; then
	echo "Build verification: No criteria found in file. Cleaning up." >&2
	rm -f "$STATE_FILE" "$BUILD_SENTINEL"
	exit 0
fi

# All criteria verified - allow exit
if [[ $UNCHECKED -eq 0 ]] && [[ $TOTAL -gt 0 ]]; then
	echo "All $TOTAL acceptance criteria verified with proof." >&2
	rm -f "$STATE_FILE" "$BUILD_SENTINEL"
	exit 0
fi

# Not all verified - block exit and re-inject verification prompt
NEXT_ITERATION=$((ITERATION + 1))

# Extract prompt (everything after the closing ---)
PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$STATE_FILE")

if [[ -z "$PROMPT_TEXT" ]]; then
	echo "Build verification: State file missing prompt text. Cleaning up." >&2
	rm -f "$STATE_FILE" "$BUILD_SENTINEL"
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
