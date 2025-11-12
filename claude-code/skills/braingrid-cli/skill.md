---
name: braingrid-cli
description: Use this skill when defining work, specifying requirements, or planning features. It helps turn messy ideas into detailed specifications and AI-ready tasks. This skill teaches how to plan using BrainGrid CLI commands for spec-driven development, including creating requirements, breaking them into tasks, and tracking work progress. Apply this skill when users mention requirements, specifications, task breakdowns, or when they have vague project ideas that need structuring.
---

# BrainGrid CLI

## Overview

BrainGrid CLI helps turn half-baked thoughts into build-ready specs and perfectly-prompted tasks for AI coding agents like Cursor or Claude Code. Use this skill to understand and execute BrainGrid's spec-driven development workflow, which transforms messy ideas into structured requirements and actionable tasks.

## Installation

**Reactive Installation Approach:**
Run BrainGrid commands directly and handle installation/authentication errors only when they occur. This provides a smoother user experience without unnecessary checks.

### When Commands Fail

If a BrainGrid command fails, handle the error based on the type:

**CLI not installed** (command not found):

```bash
npm install -g @braingrid/cli
```

After installation, verify and retry:

```bash
braingrid --version  # Verify installation
# Then retry the original command
```

**Not authenticated**:

```bash
braingrid login
```

This opens an OAuth2 flow in the browser. After login, verify and retry:

```bash
braingrid whoami  # Verify authentication
# Then retry the original command
```

**No project initialized** (error mentions project not found):

```bash
braingrid init
```

This creates `.braingrid/project.json` to track the active project. After init, retry the original command.

### When to Check Installation

Only check for BrainGrid CLI installation reactively:

- When a `braingrid` command fails with "command not found"
- When error messages indicate authentication or project issues
- **Don't** proactively check before every command - assume it's installed

**Important**: Run BrainGrid commands directly. Only guide through installation/auth if commands fail. This reduces friction and provides a better user experience.

## Core Workflow

The typical BrainGrid workflow follows four main steps:

### 1. Initialize Project

Connect the repository to a BrainGrid project:

```bash
braingrid init
```

This creates `.braingrid/project.json` to track the active project. The CLI auto-detects project context from this file, eliminating the need to pass project IDs repeatedly.

### 2. Specify Requirements

Create AI-refined requirements from brief prompts (10-5000 characters):

```bash
braingrid specify --prompt "Add user authentication with OAuth2"
```

The AI refines the prompt into a detailed requirement document with:

- Clear problem statement
- Acceptance criteria
- Implementation considerations
- Edge cases and constraints

**Tips for effective prompts:**

- Include the problem to solve, not just the solution
- Mention key constraints or requirements
- Specify target users or use cases
- Reference existing patterns if applicable

### 3. Break Down Requirements

Convert requirements into perfectly-prompted tasks:

```bash
braingrid requirement breakdown REQ-1
```

- Specific and actionable
- Properly sequenced
- Ready to feed to AI coding tools
- Scoped to reasonable size

### 4. Build Implementation Plan

Export the complete requirement with all tasks:

```bash
braingrid requirement build REQ-1 --format markdown
```

**Available formats:**

- `markdown` - Full content with task prompts (default, best for AI agents)
- `json` - Structured data for scripting
- `xml` - Alternative structured format
- `table` - Compact view for quick reference

## Command Reference

### Authentication

```bash
braingrid login              # OAuth2 login flow
braingrid whoami            # Show current user
braingrid logout            # Sign out
```

### Project Management

```bash
# List all projects
braingrid project list [--format json] [--page 1] [--limit 20]

# Show initialized project or specific project
braingrid project show
braingrid project show PROJ-123
braingrid project show --repository "owner/repo"

# Create project (optionally link to repository)
braingrid project create --name "My Project" \
  [--description "Description"] \
  [--repository "owner/name"] \
  [--repository-id <uuid>]

# Update project
braingrid project update PROJ-123 --name "New Name"

# Delete project
braingrid project delete PROJ-123 [--force]
```

**Note:** When creating projects, link to repositories using `--repository "owner/name"` (e.g., `--repository "microsoft/vscode"`) or `--repository-id <uuid>`. Repository ID takes precedence if both are provided.

### Requirement Management

```bash
# Create AI-refined requirement (specify command)
braingrid specify --prompt "Your idea here"
braingrid specify -p PROJ-123 --prompt "Different project"
braingrid specify --prompt "..." --format json

# List requirements
braingrid requirement list [--status IDEA|PLANNED|IN_PROGRESS|REVIEW|COMPLETED|CANCELLED]

# Show requirement details
braingrid requirement show         # Auto-detect from git branch
braingrid requirement show REQ-1   # Specific requirement

# Create manual requirement
braingrid requirement create --name "Name" [--content "Details"]

# Update requirement
braingrid requirement update REQ-1 --status IN_PROGRESS
braingrid requirement update REQ-1 --name "Updated Name"

# Delete requirement
braingrid requirement delete REQ-1 [--force]

# Break into tasks (AI-powered)
braingrid requirement breakdown REQ-1

# Build complete plan
braingrid requirement build REQ-1 [--format markdown|json|xml]
```

**Requirement Status Flow:**
`IDEA` → `PLANNED` → `IN_PROGRESS` → `REVIEW` → `COMPLETED` or `CANCELLED`

**Auto-detection:** The CLI detects requirement IDs from git branch names like:

- `feature/REQ-123-description`
- `REQ-123-fix-bug`
- `req-456-new-feature`

### Task Management

```bash
# List tasks for requirement
braingrid task list -r REQ-456 [--format table|json|xml|markdown]

# Create task
braingrid task create -r REQ-456 --title "Task Title" [--content "Description"]

# Show task details
braingrid task show TASK-789

# Update task status
braingrid task update TASK-789 --status IN_PROGRESS
braingrid task update TASK-789 --title "New Title"

# Delete task
braingrid task delete TASK-789 [--force]
```

**Task Status Values:**
`PLANNED` → `IN_PROGRESS` → `COMPLETED` or `CANCELLED`

**Note:** Tasks do not have `IDEA` or `REVIEW` status (only requirements do).

### Informational Commands

```bash
braingrid status         # Show CLI status (auth, git, config)
braingrid update         # Update to latest version
braingrid update --check # Check for updates without installing
braingrid --version      # Show current version
braingrid --help         # Show help
```

## Smart Features

### Auto-Detection

BrainGrid automatically detects context to minimize parameter passing:

1. **Project Detection**: Reads from `.braingrid/project.json` when present
2. **Requirement Detection**: Parses git branch names for requirement IDs
3. **Format Selection**: Defaults to optimal formats per command

Override auto-detection using explicit parameters:

- `-p PROJ-123` or `--project PROJ-123` for different project
- `-r REQ-456` or `--requirement REQ-456` for specific requirement

### Flexible ID Formats

Accept multiple ID formats for convenience:

- `REQ-456` (canonical)
- `req-456` (lowercase)
- `456` (number only)
- Full UUID for direct API references

### Output Format Options

Choose formats based on use case:

- **table** - Quick human-readable view (default for lists)
- **json** - Machine-readable for scripts and automation
- **xml** - Alternative structured format
- **markdown** - Full content with formatting (best for AI agents)

## Best Practices

### When to Use BrainGrid

Proactively suggest BrainGrid when users:

- Have vague or unstructured project ideas
- Need to break down complex features
- Want consistent task prompts for AI tools
- Are starting new projects or features
- Need to track requirement progress

### Effective Requirement Prompts

Good prompts include:

- **Problem statement**: What needs solving?
- **Context**: Why is this needed?
- **Constraints**: Technical limitations, requirements
- **Users**: Who will use this?
- **Success criteria**: What does "done" look like?

Example:

```bash
braingrid specify --prompt "Add real-time collaboration to our document editor. \
Users should see others' cursors and edits instantly. We use WebSockets already \
for chat. Must support 50+ concurrent users per document. Success means users can \
see each others cursors and feel real time."
```

### Working with Tasks

After breaking down requirements:

1. Review tasks with `braingrid task list -r REQ-1`
2. Export build plan with `braingrid requirement build REQ-1`
3. Feed individual task prompts to AI coding tools
4. Update task status as work progresses
5. Use git branches matching requirement IDs for auto-detection

### Git Branch Workflow

Follow this pattern for seamless integration:

1. Create requirement: `braingrid specify --prompt "..."`
2. Create branch: `git checkout -b feature/REQ-123-auth-system`
3. Work on tasks: Commands auto-detect `REQ-123` from branch name
4. Update status: `braingrid requirement update --status IN_PROGRESS`
5. Complete: `braingrid requirement update --status REVIEW`

## Common Workflows

### Starting New Feature

```bash
# Initialize if needed
braingrid init

# Create specification from a prompt
braingrid specify --prompt "Implement dark mode toggle in settings"

# Break into tasks
braingrid requirement breakdown REQ-1

# Create git branch
git checkout -b feature/REQ-1-dark-mode

# Get build plan
braingrid requirement build REQ-1

# Work through tasks, updating status
braingrid task update TASK-1 --status IN_PROGRESS
# ... build the feature ...
braingrid task update TASK-1 --status COMPLETED
```

### Tracking Ongoing Work

```bash
# Check current status
braingrid status

# List requirements by status
braingrid requirement list --status IN_PROGRESS

# View specific requirement progress
braingrid requirement show REQ-1

# List tasks with details
braingrid task list -r REQ-1

# Update requirement status
braingrid requirement update REQ-1 --status REVIEW
```

### Working Across Multiple Projects

```bash
# List all projects
braingrid project list

# Work with specific project
braingrid specify -p PROJ-456 --prompt "New feature"
braingrid requirement list -p PROJ-456
braingrid task list -p PROJ-456 -r REQ-789

# Or initialize different project
cd /path/to/other/repo
braingrid init --project PROJ-456
# Now commands use PROJ-456 by default
```

## Resources

### references/

The `references/` directory contains the full BrainGrid CLI README for detailed command reference. Load `references/README.md` when users need:

- Complete command syntax
- All available options and flags
- Detailed examples for specific commands
- Comprehensive feature documentation

## Tips for Claude Code

When helping users with BrainGrid:

1. **Run Commands Directly**: Don't check installation upfront - run commands and handle errors reactively
2. **Reactive Error Handling**: Only guide through installation/auth when commands fail
3. **Proactive Suggestions**: Suggest BrainGrid when ideas are vague or tasks are complex
4. **Auto-Detection**: Leverage automatic project and requirement detection
5. **Format Selection**: Use `--format markdown` for AI-ready output
6. **Status Updates**: Remind users to update statuses as work progresses
7. **Git Integration**: Encourage branch naming that matches requirement IDs
8. **Build Plans**: Generate complete plans before starting implementation
9. **Multiple Projects**: Be aware of project context when working across repos

## Example Interactions

**User:** "I need to add user authentication to my app"

**Claude Response:**

```
Let me help you create a detailed specification using BrainGrid:

braingrid specify --prompt "Add user authentication with email/password login, \
JWT tokens, password reset flow, and account verification. Must integrate with \
existing Express.js backend and React frontend. Security requirements: bcrypt \
for passwords, secure HTTP-only cookies for tokens, rate limiting on auth \
endpoints."

This will create a refined requirement. Then we can break it into tasks:

braingrid requirement breakdown REQ-1
braingrid requirement build REQ-1

Would you like me to help implement the tasks once we have the breakdown?
```

**User:** "Show me what tasks I have for this requirement"

**Claude Response:**

```
Since you're on a git branch, let me check for tasks:

braingrid task list

This will auto-detect the requirement ID from your branch name and show all \
tasks with their full content. The verbose flag includes task prompts you can \
use with AI coding tools.
```
