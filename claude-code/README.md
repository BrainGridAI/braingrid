<h1>BrainGrid for Claude Code</h1>

<div align="center">
<img src="https://www.braingrid.ai/logos/braingrid-symbol-800.png" width="80"/>

**Prompt AI Coding Tools Like a Rockstar Developer**

Turn messy thoughts into detailed specs and perfectly-prompted tasks to build well-structured, maintainable software with AI.

[![npm version](https://img.shields.io/npm/v/@braingrid/cli.svg?color=blue&logo=npm)](https://www.npmjs.com/package/@braingrid/cli)
[![Downloads](https://img.shields.io/npm/dm/@braingrid/cli.svg?color=green)](https://www.npmjs.com/package/@braingrid/cli)
[![GitHub](https://img.shields.io/github/stars/BrainGridAI/braingrid?style=social)](https://github.com/BrainGridAI/braingrid)

</div>

---

## Overview

**BrainGrid** helps you turn half-baked thoughts into build-ready specs and perfectly-prompted tasks that AI coding agents like Claude Code build fast without breaking things.

This integration provides:

- **Slash Commands** - Quick access to key BrainGrid workflows (``/specify`, `/breakdown`, `/build`, `/save-requirement`)
- **BrainGrid CLI Skill** - Comprehensive guidance on spec-driven development workflows
- **Status Line** - Real-time display of your BrainGrid context (project, requirement, task progress)

### Core Workflow

```
Vague Idea → AI-Refined Requirement → Breakdown into Tasks → Build with AI
```

**Resources:**

- **Projects** - Your software projects
- **Requirements** - Detailed specifications (refined from vague ideas)
- **Tasks** - Perfectly-prompted, AI-ready implementation steps

---

## Installation

### 1. Install BrainGrid CLI

```bash
npm install -g @braingrid/cli
```

### 2. Authenticate

```bash
braingrid login
```

This opens an OAuth2 flow in your browser. After authentication, verify:

```bash
braingrid whoami
```

### 3. Initialize Your Project

In your project directory:

```bash
braingrid init
```

This creates `.braingrid/project.json` to track your active project. The CLI will auto-detect project context from this file.

### 4. Install Claude Code Integration

```bash
braingrid setup claude-code
```

This command installs:

- **Slash commands** in `.claude/commands/`:
  - `specify.md` - Create AI-refined requirements
  - `breakdown.md` - Break requirements into tasks
  - `build.md` - Get complete implementation plan
  - `save-requirement.md` - Save discussed plans
- **BrainGrid skill** in `.claude/skills/braingrid-cli/`:
  - Comprehensive workflow guidance
  - Command reference with examples
  - Best practices documentation
- **Status line** in `.claude/statusline.sh`:
  - Shows project context: `PROJ-3`
  - Shows requirement context: `REQ-128`
  - Shows task progress: `[2/5]` (2 of 5 tasks completed)
  - Updates in real-time as you work
- **Content injection** into `CLAUDE.md`:
  - BrainGrid workflow overview
  - Quick command reference
  - Auto-detection features

**File Conflicts:** If files already exist, you'll be prompted to overwrite, skip, or cancel. Use `--force` to overwrite all without prompting.

---

## Status Line

The BrainGrid status line shows your current context at the top of Claude Code:

```
BrainGrid: PROJ-3 > REQ-128 [2/5]
~/Dropbox/Projects/my-app • ctx: 42k tokens (26%) • Sonnet 4.5
```

**Line 1** (when BrainGrid context exists):

- `PROJ-3` - Current project (from `.braingrid/project.json`)
- `REQ-128` - Current requirement (auto-detected from git branch like `feature/REQ-128-auth`)
- `[2/5]` - Task progress (2 of 5 tasks completed)

**Line 2** (always shown):

- Working directory
- Context usage with color coding:
  - Cyan (0-80%): Normal usage
  - Yellow (80-90%): Getting full
  - Red (90-100%): Near limit
- Model name (e.g., Sonnet 4.5)

The status line updates automatically as you switch branches, complete tasks, or change projects.

---

## Available Commands

BrainGrid provides four powerful slash commands in Claude Code:

| Command             | Description                                        | Example                                        |
| ------------------- | -------------------------------------------------- | ---------------------------------------------- |
| `/specify`          | Create AI-refined requirement from vague idea      | `/specify Add user auth with OAuth2`           |
| `/save-requirement` | Save a detailed plan as a requirement              | `/save-requirement User Authentication System` |
| `/breakdown`        | Break requirement into perfectly-prompted tasks    | `/breakdown REQ-123`                           |
| `/build`            | Get complete implementation plan (markdown format) | `/build REQ-123`                               |

### Command Details

#### `/specify [prompt]`

Creates an AI-refined requirement from a brief idea (10-5000 characters). The AI expands your prompt into a detailed specification with:

- Clear problem statement
- Acceptance criteria
- Implementation considerations
- Edge cases and constraints

**Usage:**

```bash
/specify Add real-time collaboration to document editor with WebSockets
```

**Output:** Creates a new requirement (e.g., `REQ-123`) with detailed specification.

---

#### `/save-requirement [title]`

Saves a detailed plan that you've discussed with Claude Code as a structured requirement in BrainGrid.

**Usage:**

```bash
/save-requirement User Authentication System
```

**When to use:** After discussing a feature in detail with Claude Code and you want to save the plan for tracking and breakdown.

---

#### `/breakdown [req-id]`

Breaks down a requirement into 5-10 perfectly-prompted tasks ready for AI coding tools.

**Usage:**

```bash
/breakdown REQ-123
/breakdown 123          # Short format
```

**Auto-detection:** If you're on a git branch like `feature/REQ-123-auth`, you can omit the ID:

```bash
/breakdown              # Auto-detects REQ-123 from branch name
```

---

#### `/build [req-id] [additional-instructions]`

Fetches the complete implementation plan with all tasks and their prompts in markdown format (perfect for AI agents).

**Usage:**

```bash
/build REQ-123
/build REQ-123 focus on security best practices
/build                  # Auto-detects from git branch name
```

**Optional instructions:** Provide additional context to guide implementation (e.g., "focus on security", "add comprehensive tests").

---

## Typical Workflow

### Starting a New Feature

```bash
# 1. Create specification from idea
/specify Add dark mode toggle in settings with theme persistence

# 2. Review and break down into tasks
/breakdown REQ-1

# 3. Create git branch (enables auto-detection)
git checkout -b feature/REQ-1-dark-mode

# 4. Get complete build plan
/build

# 5. Start implementing tasks
# Claude Code will help implement each task

# 6. Update task status as you progress
braingrid task update TASK-1 -r REQ-1 --status IN_PROGRESS
braingrid task update TASK-1 -r REQ-1 --status COMPLETED
```

### Working on Existing Requirements

```bash
# List requirements
braingrid requirement list

# Show specific requirement
braingrid requirement show REQ-123

# List tasks
braingrid task list -r REQ-123

# Update requirement status
braingrid requirement update REQ-123 --status IN_PROGRESS
```

---

## Key Features

### Auto-Detection

BrainGrid CLI automatically detects context:

- **Project**: Reads from `.braingrid/project.json`
- **Requirement ID**: Parses from git branch names
  - `feature/REQ-123-description` → `REQ-123`
  - `req-456-fix-bug` → `REQ-456`
  - `123-new-feature` → `REQ-123`

### Flexible ID Formats

Accept multiple formats for convenience:

- `REQ-456` (canonical)
- `req-456` (lowercase)
- `456` (number only)
- Full UUID

### Output Formats

Choose formats based on use case:

- **table** - Quick human-readable view (default for lists)
- **json** - Machine-readable for scripts
- **xml** - Alternative structured format
- **markdown** - Full content with formatting (best for AI agents)

Example:

```bash
braingrid requirement list --format json
braingrid task list -r REQ-1 --format markdown
```

### Status Flows

**Requirements:**

```
IDEA → PLANNED → IN_PROGRESS → REVIEW → COMPLETED
                                      ↘ CANCELLED
```

**Tasks:**

```
PLANNED → IN_PROGRESS → COMPLETED
                      ↘ CANCELLED
```

---

## BrainGrid CLI Skill

For detailed guidance on using BrainGrid, invoke the `braingrid-cli` skill in Claude Code. The skill provides:

- Complete command reference
- Best practices for effective prompts
- Workflow guidance
- Troubleshooting tips
- Advanced features

**To use:** Type `@braingrid-cli` in Claude Code to activate the skill.

---

## Usage Examples

### Example 1: Creating a Feature from Scratch

```bash
# Create requirement
/specify Implement user profile page with avatar upload, bio editing, and privacy settings

# Output: ✅ Created requirement REQ-234: User Profile Management

# Break down into tasks
/breakdown REQ-234

# Output: ✅ Created 6 tasks for REQ-234

# Create git branch
git checkout -b feature/REQ-234-user-profile

# Get build plan with security focus
/build focus on input validation and XSS prevention

# Start implementing with Claude Code
# ... implement tasks ...

# Update statuses
braingrid task update TASK-1 -r REQ-234 --status COMPLETED
```

### Example 2: Saving a Discussed Plan

```
User: "I want to add caching to our API"
Claude: "Let me help design a caching strategy..."
[Discussion continues with detailed planning]

User: /save-requirement API Caching Layer

# Output: ✅ Saved requirement REQ-345: API Caching Layer

/breakdown REQ-345
/build REQ-345
```

### Example 3: Working with Auto-Detection

```bash
# On branch: feature/REQ-456-notifications
git branch
# * feature/REQ-456-notifications

# Commands auto-detect REQ-456
/build
braingrid requirement show
braingrid task list

# Update status without specifying ID
braingrid requirement update --status IN_PROGRESS
```

---

## Command Reference

### Authentication

```bash
braingrid login              # OAuth2 login
braingrid whoami            # Show current user
braingrid logout            # Sign out
```

### Projects

```bash
braingrid project list
braingrid project show
braingrid project create --name "Project Name"
```

### Requirements

```bash
braingrid specify --prompt "Your idea"
braingrid requirement list [--status PLANNED|IN_PROGRESS|...]
braingrid requirement show [REQ-ID]
braingrid requirement update REQ-ID --status IN_PROGRESS
braingrid requirement breakdown REQ-ID
braingrid requirement build REQ-ID [--format markdown]
```

### Tasks

```bash
braingrid task list -r REQ-ID [--format markdown]
braingrid task show TASK-ID
braingrid task update TASK-ID -r REQ-ID --status IN_PROGRESS
braingrid task create -r REQ-ID --title "Task Title"
```

### Utility

```bash
braingrid status             # Show CLI status
braingrid update            # Update to latest version
braingrid --version         # Show version
braingrid --help            # Show help
```

---

## Tips for Effective Use

### Writing Good Prompts for `/specify`

Include:

- **Problem statement**: What needs solving?
- **Context**: Why is this needed?
- **Constraints**: Technical limitations
- **Users**: Who will use this?
- **Success criteria**: What does "done" look like?

**Example:**

```bash
/specify Add real-time collaboration to our document editor. Users should see
others' cursors and edits instantly. We use WebSockets already for chat. Must
support 50+ concurrent users per document. Success means <200ms latency for
cursor updates and no conflicts in concurrent edits.
```

### Using Additional Instructions with `/build`

Provide context to guide implementation:

```bash
/build REQ-123 prioritize security and add comprehensive error handling
/build REQ-123 focus on performance optimization
/build REQ-123 ensure full test coverage with unit and integration tests
```

### Git Branch Workflow

1. Create requirement: `/specify "..."`
2. Break down: `/breakdown REQ-123`
3. Create branch: `git checkout -b feature/REQ-123-description`
4. Build: `/build` (auto-detects from branch)
5. Implement with Claude Code
6. Update statuses as you progress

---

## Learn More

- **BrainGrid Documentation**: [https://braingrid.ai](https://braingrid.ai)
- **GitHub Repository**: [https://github.com/BrainGridAI/braingrid](https://github.com/BrainGridAI/braingrid)
- **NPM Package**: [https://www.npmjs.com/package/@braingrid/cli](https://www.npmjs.com/package/@braingrid/cli)
- **Web App**: [https://app.braingrid.ai](https://app.braingrid.ai)

---

## Support

- **Issues**: [GitHub Issues](https://github.com/BrainGridAI/braingrid/issues)
- **Discussions**: [GitHub Discussions](https://github.com/BrainGridAI/braingrid/discussions)
- **Email**: support@braingrid.ai

---

## License

MIT License - See [LICENSE](../LICENSE) file for details
