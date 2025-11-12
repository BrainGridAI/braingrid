<h1>BrainGrid for Cursor</h1>

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

**BrainGrid** helps you turn half-baked thoughts into build-ready specs and perfectly-prompted tasks that AI coding agents like Cursor build fast without breaking things.

This integration provides:

- **Slash Commands** - Quick access to key BrainGrid workflows (`/specify`, `/breakdown`, `/build`, `/save-requirement`)
- **Always-On Rules** - Cursor automatically understands BrainGrid context without prompting
- **AGENTS.md Integration** - Seamless BrainGrid guidance loaded automatically by Cursor

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

### 4. Install Cursor Integration

```bash
braingrid setup cursor
```

This command installs:

- **Slash commands** in `.cursor/commands/`:
  - `specify.md` - Create AI-refined requirements from natural language
  - `breakdown.md` - Break requirements into implementation tasks
  - `build.md` - Get complete implementation plan with all task prompts
  - `save-requirement.md` - Save discussed plans as structured requirements
- **Always-on rules** in `.cursor/rules/`:
  - `braingrid.mdc` - Provides Cursor with BrainGrid context automatically
  - No need to explain BrainGrid workflow in every chat
  - Cursor understands project/requirement/task structure
- **Content injection** into `AGENTS.md`:
  - BrainGrid workflow overview
  - Quick command reference
  - Auto-detection features
  - Loaded automatically by Cursor's Agent mode

**File Conflicts:** If files already exist, you'll be prompted to overwrite, skip, or cancel. Use `--force` to overwrite all without prompting.

---

## Available Commands

BrainGrid provides four powerful slash commands in Cursor Agent mode:

| Command             | Description                                        | Example                                        |
| ------------------- | -------------------------------------------------- | ---------------------------------------------- |
| `/specify`          | Create AI-refined requirement from vague idea      | `/specify Add user auth with OAuth2`           |
| `/save-requirement` | Save a detailed plan as a requirement              | `/save-requirement User Authentication System` |
| `/breakdown`        | Break requirement into perfectly-prompted tasks    | `/breakdown REQ-123`                           |
| `/build`            | Get complete implementation plan (markdown format) | `/build REQ-123`                               |

### How to Access Commands

In Cursor's Agent input (Cmd+K or Cmd+L), type `/` to see available commands. The BrainGrid commands will appear alongside Cursor's built-in commands.

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

Saves a detailed plan that you've discussed with Cursor as a structured requirement in BrainGrid.

**Usage:**

```bash
/save-requirement User Authentication System
```

**When to use:** After discussing a feature in detail with Cursor and you want to save the plan for tracking and breakdown.

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

## Always-On Rules

The `.cursor/rules/braingrid.mdc` file teaches Cursor about BrainGrid automatically. This means:

- **No explaining needed** - Cursor already knows what BrainGrid is
- **Context-aware responses** - Cursor understands PROJ-X, REQ-Y, TASK-Z references
- **Workflow guidance** - Cursor suggests next steps in the BrainGrid workflow
- **Better task execution** - Cursor follows BrainGrid task prompts more accurately

The rules are always active - you don't need to do anything to enable them.

---

## Typical Workflow

### Starting a New Feature

```bash
# 1. Create specification from idea (in Cursor Agent)
/specify Add dark mode toggle in settings with theme persistence

# 2. Review and break down into tasks
/breakdown REQ-1

# 3. Create git branch (enables auto-detection)
git checkout -b feature/REQ-1-dark-mode

# 4. Get complete build plan (in Cursor Agent)
/build

# 5. Start implementing tasks with Cursor
# Cursor will help implement each task with full context

# 6. Update task status as you progress (in terminal)
braingrid task update TASK-1 -r REQ-1 --status IN_PROGRESS
braingrid task update TASK-1 -r REQ-1 --status COMPLETED
```

### Working on Existing Requirements

```bash
# List requirements (in terminal)
braingrid requirement list

# Show specific requirement
braingrid requirement show REQ-123

# In Cursor Agent - get build plan
/build REQ-123

# List tasks (in terminal)
braingrid task list -r REQ-123

# Update requirement status (in terminal)
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

## Usage Examples

### Example 1: Creating a Feature from Scratch

```bash
# In Cursor Agent (Cmd+K)
/specify Implement user profile page with avatar upload, bio editing, and privacy settings

# Output: ✅ Created requirement REQ-234: User Profile Management

# Break down into tasks
/breakdown REQ-234

# Output: ✅ Created 6 tasks for REQ-234

# Create git branch (in terminal)
git checkout -b feature/REQ-234-user-profile

# Get build plan with security focus (in Cursor Agent)
/build focus on input validation and XSS prevention

# Start implementing with Cursor
# Cursor understands the task context and helps implement

# Update statuses (in terminal)
braingrid task update TASK-1 -r REQ-234 --status COMPLETED
```

### Example 2: Saving a Discussed Plan

```
User: "I want to add caching to our API"
Cursor: "Let me help design a caching strategy..."
[Discussion continues with detailed planning]

User (in Cursor Agent): /save-requirement API Caching Layer

# Output: ✅ Saved requirement REQ-345: API Caching Layer

User: /breakdown REQ-345
User: /build REQ-345
```

### Example 3: Working with Auto-Detection

```bash
# On branch: feature/REQ-456-notifications
git branch
# * feature/REQ-456-notifications

# Commands auto-detect REQ-456 (in Cursor Agent)
/build
# Or in terminal
braingrid requirement show
braingrid task list

# Update status without specifying ID (in terminal)
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

1. Create requirement: `/specify "..."` (in Cursor Agent)
2. Break down: `/breakdown REQ-123` (in Cursor Agent)
3. Create branch: `git checkout -b feature/REQ-123-description` (in terminal)
4. Build: `/build` (in Cursor Agent - auto-detects from branch)
5. Implement with Cursor Agent
6. Update statuses as you progress (in terminal)

---

## AGENTS.md Integration

The `AGENTS.md` file at your repository root provides BrainGrid guidance that Cursor automatically loads. This file:

- **Automatically loaded** - No manual activation needed
- **Persistent context** - Available throughout your Cursor session
- **Consistent guidance** - Same BrainGrid workflow across all projects
- **Growing ecosystem** - Compatible with other AGENTS.md-enabled tools

BrainGrid's setup command injects BrainGrid-specific guidance into your existing AGENTS.md (or creates it if it doesn't exist), using HTML comment markers to enable updates without duplication.

---

## Learn More

- **BrainGrid Documentation**: [https://braingrid.ai](https://braingrid.ai)
- **GitHub Repository**: [https://github.com/BrainGridAI/braingrid](https://github.com/BrainGridAI/braingrid)
- **NPM Package**: [https://www.npmjs.com/package/@braingrid/cli](https://www.npmjs.com/package/@braingrid/cli)
- **Web App**: [https://app.braingrid.ai](https://app.braingrid.ai)
- **AGENTS.md Standard**: [https://agents.md](https://agents.md)

---

## Support

- **Issues**: [GitHub Issues](https://github.com/BrainGridAI/braingrid/issues)
- **Discussions**: [GitHub Discussions](https://github.com/BrainGridAI/braingrid/discussions)
- **Email**: support@braingrid.ai

---

## License

MIT License - See [LICENSE](../LICENSE) file for details
