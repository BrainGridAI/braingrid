#!/bin/bash
# BrainGrid Status Line for Claude Code
# Displays two-line status with BrainGrid project/requirement context and workspace info

# Exit on pipeline failures (ensures we catch braingrid command errors)
set -o pipefail

# ANSI color codes
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RESET='\033[0m'

# Read stdin JSON from Claude Code
INPUT=$(cat)

# Extract workspace info from JSON
CURRENT_DIR=$(echo "$INPUT" | jq -r '.workspace.current_dir // empty')
MODEL_NAME=$(echo "$INPUT" | jq -r '.model.name // empty')
CURRENT_TOKENS=$(echo "$INPUT" | jq -r '.token_budget.current // 0')
BUDGET_TOKENS=$(echo "$INPUT" | jq -r '.token_budget.budget // 0')

# Get git root directory
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

# Initialize BrainGrid context variables
PROJECT_ID=""
REQ_ID=""
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

# If requirement ID exists, get task counts
if [ -n "$REQ_ID" ]; then
	# Make API call to get tasks (filter out spinner and loading messages)
	TASKS_JSON=$(braingrid task list -r "$REQ_ID" --format json 2>/dev/null | tr '\r' '\n' | grep -v 'Loading tasks' | grep -v '⠋\|⠙\|⠹\|⠸\|⠼\|⠴\|⠦\|⠧\|⠇\|⠏' | sed '/^\s*$/d')

	if [ $? -eq 0 ] && [ -n "$TASKS_JSON" ]; then
		# Count total and completed tasks (JSON is an array directly)
		TOTAL_TASKS=$(echo "$TASKS_JSON" | jq 'length' 2>/dev/null || echo "0")
		COMPLETED_TASKS=$(echo "$TASKS_JSON" | jq '[.[] | select(.status == "COMPLETED")] | length' 2>/dev/null || echo "0")

		if [ "$TOTAL_TASKS" != "0" ]; then
			TASK_COUNTS="[$COMPLETED_TASKS/$TOTAL_TASKS]"
		fi
	fi
fi

# Build Line 1: BrainGrid context (or empty if no context)
LINE1=""
if [ -n "$PROJECT_ID" ] || [ -n "$REQ_ID" ] || [ -n "$TASK_COUNTS" ]; then
	if [ -n "$PROJECT_ID" ]; then
		LINE1="${CYAN}${PROJECT_ID}${RESET}"
	fi

	if [ -n "$REQ_ID" ]; then
		if [ -n "$LINE1" ]; then
			LINE1="${LINE1} > "
		fi
		LINE1="${LINE1}${GREEN}${REQ_ID}${RESET}"
	fi

	if [ -n "$TASK_COUNTS" ]; then
		LINE1="${LINE1} ${YELLOW}${TASK_COUNTS}${RESET}"
	fi
fi

# Format current directory (replace home with ~)
DISPLAY_DIR=$(echo "$CURRENT_DIR" | sed "s|^$HOME|~|")

# Format token usage
CURRENT_K=$((CURRENT_TOKENS / 1000))
if [ "$BUDGET_TOKENS" != "0" ]; then
	BUDGET_K=$((BUDGET_TOKENS / 1000))
	TOKEN_DISPLAY="${CURRENT_K}k/${BUDGET_K}k tokens"
else
	TOKEN_DISPLAY="${CURRENT_K}k tokens"
fi

# Build Line 2: Always shown (workspace info)
LINE2="${DISPLAY_DIR} • ${MODEL_NAME} • ${TOKEN_DISPLAY}"

# Output both lines
echo -e "$LINE1"
echo -e "$LINE2"
