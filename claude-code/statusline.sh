#!/bin/bash
# BrainGrid Status Line for Claude Code
# Displays single-line status with BrainGrid project/requirement context and workspace info

# Exit on pipeline failures (ensures we catch braingrid command errors)
set -o pipefail

# ANSI color codes
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

# Read stdin JSON from Claude Code
INPUT=$(cat)

# Extract workspace info from JSON
CURRENT_DIR=$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd // empty')
MODEL_NAME=$(echo "$INPUT" | jq -r '.model.display_name // .model.name // .model.id // empty')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Parse transcript JSONL file for actual token usage
# Claude Code's JSON doesn't include token_budget fields, so we need to parse the transcript
CURRENT_TOKENS=0
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
	# Read last 100 lines of transcript and extract token usage from last assistant message
	# Sum: input_tokens + output_tokens + cache_creation_input_tokens + cache_read_input_tokens
	CURRENT_TOKENS=$(tail -n 100 "$TRANSCRIPT_PATH" 2>/dev/null | \
		jq -s 'map(select(.type == "assistant" and .message.usage and (.isSidechain // false) == false)) |
		       last | .message.usage |
		       (.input_tokens // 0) + (.output_tokens // 0) +
		       (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)' 2>/dev/null || echo "0")
fi

# Use 160K tokens as threshold (80% of 200K context limit, auto-compact trigger point)
BUDGET_TOKENS=160000

# Get git root directory
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

# Initialize BrainGrid context variables
PROJECT_ID=""
REQ_ID=""
CURRENT_TASK=""
TASK_COUNTS=""

# Check if .braingrid/project.json exists
if [ -n "$GIT_ROOT" ] && [ -f "$GIT_ROOT/.braingrid/project.json" ]; then
	# Read project short_id from project.json
	PROJECT_ID=$(jq -r '.project_short_id // empty' "$GIT_ROOT/.braingrid/project.json" 2>/dev/null)
fi

# Get current branch and parse requirement ID
if [ -n "$GIT_ROOT" ]; then
	BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
	if [ -n "$BRANCH" ]; then
		# Extract REQ-XXX pattern from branch name (case-insensitive)
		REQ_ID=$(echo "$BRANCH" | grep -ioE 'REQ-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]')
	fi
fi

# If requirement ID exists, get task counts and current task
if [ -n "$REQ_ID" ]; then
	# Make API call to get tasks (filter out spinner and loading messages)
	TASKS_JSON=$(braingrid task list -r "$REQ_ID" --format json --limit 100 2>/dev/null | tr '\r' '\n' | grep -v 'Loading tasks' | grep -v '⠋\|⠙\|⠹\|⠸\|⠼\|⠴\|⠦\|⠧\|⠇\|⠏' | sed '/^\s*$/d')

	if [ $? -eq 0 ] && [ -n "$TASKS_JSON" ]; then
		# Count total and completed tasks (JSON is an array directly)
		TOTAL_TASKS=$(echo "$TASKS_JSON" | jq 'length' 2>/dev/null || echo "0")
		COMPLETED_TASKS=$(echo "$TASKS_JSON" | jq '[.[] | select(.status == "COMPLETED")] | length' 2>/dev/null || echo "0")

		# Find current task: first IN_PROGRESS, or first PLANNED if none in progress
		# Extract number, status, and title
		# Note: select(. != null) is needed because first returns null on empty arrays,
		# and string interpolation on null produces "null|null|null" which is a valid string
		CURRENT_TASK_INFO=$(echo "$TASKS_JSON" | jq -r '
			(map(select(.status == "IN_PROGRESS")) | first | select(. != null) | "\(.number)|\(.status)|\(.title)") //
			(map(select(.status == "PLANNED")) | first | select(. != null) | "\(.number)|\(.status)|\(.title)") //
			empty
		' 2>/dev/null)

		CURRENT_TASK=$(echo "$CURRENT_TASK_INFO" | cut -d'|' -f1)
		CURRENT_TASK_STATUS=$(echo "$CURRENT_TASK_INFO" | cut -d'|' -f2)
		CURRENT_TASK_TITLE=$(echo "$CURRENT_TASK_INFO" | cut -d'|' -f3)

		if [ "$TOTAL_TASKS" != "0" ]; then
			TASK_COUNTS="[$COMPLETED_TASKS/$TOTAL_TASKS]"
		fi
	fi
fi

# Build BrainGrid context line (only if context exists)
LINE1=""
if [ -n "$PROJECT_ID" ] || [ -n "$REQ_ID" ] || [ -n "$CURRENT_TASK" ] || [ -n "$TASK_COUNTS" ]; then
	LINE1="BrainGrid: "

	if [ -n "$PROJECT_ID" ]; then
		LINE1="${LINE1}${CYAN}${PROJECT_ID}${RESET}"
	fi

	if [ -n "$REQ_ID" ]; then
		if [ -n "$PROJECT_ID" ]; then
			LINE1="${LINE1} > "
		fi
		LINE1="${LINE1}${GREEN}${REQ_ID}${RESET}"
	fi

	if [ -n "$CURRENT_TASK" ]; then
		# Format status: IN_PROGRESS -> In-Progress, PLANNED -> Planned
		case "$CURRENT_TASK_STATUS" in
			IN_PROGRESS) STATUS_DISPLAY="In-Progress" ;;
			PLANNED) STATUS_DISPLAY="Planned" ;;
			*) STATUS_DISPLAY="" ;;
		esac

		if [ -n "$PROJECT_ID" ] || [ -n "$REQ_ID" ]; then
			LINE1="${LINE1} > "
		fi

		# Build task display: TASK 19: Task name (Status)
		TASK_DISPLAY="TASK ${CURRENT_TASK}"
		if [ -n "$CURRENT_TASK_TITLE" ]; then
			TASK_DISPLAY="${TASK_DISPLAY}: ${CURRENT_TASK_TITLE}"
		fi
		if [ -n "$STATUS_DISPLAY" ]; then
			TASK_DISPLAY="${TASK_DISPLAY} (${STATUS_DISPLAY})"
		fi

		LINE1="${LINE1}${YELLOW}${TASK_DISPLAY}${RESET}"
	fi

	if [ -n "$TASK_COUNTS" ]; then
		LINE1="${LINE1} ${GREEN}${TASK_COUNTS}${RESET}"
	fi
fi

# Format current directory (replace home with ~)
DISPLAY_DIR=$(echo "$CURRENT_DIR" | sed "s|^$HOME|~|")

# Calculate token usage percentage and color
CURRENT_K=$((CURRENT_TOKENS / 1000))
if [ "$BUDGET_TOKENS" != "0" ]; then
	PERCENTAGE=$((CURRENT_TOKENS * 100 / BUDGET_TOKENS))

	# Choose color based on percentage (cyan: 0-80%, yellow: 80-90%, red: 90-100%)
	if [ "$PERCENTAGE" -ge 90 ]; then
		TOKEN_COLOR="$RED"
	elif [ "$PERCENTAGE" -ge 80 ]; then
		TOKEN_COLOR="$YELLOW"
	else
		TOKEN_COLOR="$CYAN"
	fi

	TOKEN_DISPLAY="${TOKEN_COLOR}${CURRENT_K}k tokens (${PERCENTAGE}%)${RESET}"
else
	TOKEN_DISPLAY="${CYAN}${CURRENT_K}k tokens${RESET}"
fi

# Add model name if available
if [ -n "$MODEL_NAME" ]; then
	MODEL_SECTION=" • ${MODEL_NAME}"
else
	MODEL_SECTION=""
fi

# Build Line 2: Always shown (path, token info, and model)
LINE2="${DISPLAY_DIR} • ctx: ${TOKEN_DISPLAY}${MODEL_SECTION}"

# Build Line 3: Branch name (only if in git repo)
LINE3=""
if [ -n "$BRANCH" ]; then
	LINE3="Branch: ${CYAN}${BRANCH}${RESET}"
fi

# Output lines (Line 1 only if BrainGrid context exists)
if [ -n "$LINE1" ]; then
	echo -e "$LINE1"
fi
echo -e "$LINE2"
if [ -n "$LINE3" ]; then
	echo -e "$LINE3"
fi
