<div align="center">
<img src="https://www.braingrid.ai/logos/braingrid-symbol-800.png" width="100"/>
  <h1>BrainGrid</h1>

  <p>Prompt AI Coding Tools Like a Rockstar Developer</p>
  <h3>A CLI to turn messy thoughts into detailed specs and perfectly-prompted tasks to build well-structured, maintainable software with AI.</h3>

[![npm version](https://img.shields.io/npm/v/@braingrid/cli.svg?color=blue&logo=npm)](https://www.npmjs.com/package/@braingrid/cli)
[![Downloads](https://img.shields.io/npm/dm/@braingrid/cli.svg?color=green)](https://www.npmjs.com/package/@braingrid/cli)
[![GitHub stars](https://img.shields.io/github/stars/BrainGridAI/braingrid?style=social)](https://github.com/BrainGridAI/braingrid)

</div>

---

## Overview

**BrainGrid** helps you turn half-baked thoughts into build-ready specs and perfectly-prompted tasks that AI coding agents like Cursor, or Claude Code, build fast without breaking things.

## Features

**BrainGrid CLI** is the command-line interface for managing your requirements, and tasks on the BrainGrid platform.

- ✨ **Specify Requirements** - Create build-ready requirement documents from messy ideas
- 🎯 **Break Down into Tasks** - Create perfectly-prompted tasks from requirements
- 🤖 **Build with AI Agents** - Get an implementation plan with prompts for each task to feed to Cursor, Claude Code, and other AI coding tools
- 📊 **Track Progress** - Manage and update task statuses
- 💾 **Multiple Output Formats** - View task prompts as formatted tables, JSON, Markdown, or XML for scripting

---

## Installation

```bash
npm install -g @braingrid/cli
```

---

## AI Coding Tool Integration

BrainGrid integrates natively with AI coding tools like **Cursor IDE** and **Claude Code** through the [AGENTS.md standard](https://agents.md/), providing seamless access to spec-driven development workflows directly in your editor.

### What is AGENTS.md?

[AGENTS.md](https://agents.md/) is an open standard that allows AI coding assistants to automatically load project-specific guidance and commands. BrainGrid uses this standard to provide consistent CLI guidance across multiple tools:

- ✅ **Cursor IDE** - Automatic loading via AGENTS.md + slash commands
- ✅ **Claude Code** - Automatic loading via AGENTS.md or .claude/CLAUDE.md
- ✅ **GitHub Copilot** - Context from AGENTS.md
- ✅ **Growing ecosystem** of AGENTS.md-compatible tools

### Setup for Cursor IDE

**Prerequisites:**

- Cursor IDE installed ([download here](https://cursor.sh/))
- BrainGrid CLI installed and authenticated

**How it works:**

1. **AGENTS.md** at your repository root is automatically loaded by Cursor
2. **.cursor/rules/braingrid.mdc** provides Cursor-specific enhancements (always-on rules)
3. **Slash commands** available via `/` in Cursor's Agent input

**Available Commands:**

Type `/` in Cursor's Agent input to access:

- `/specify` - Create AI-refined requirements from natural language
- `/breakdown` - Break requirements into implementation tasks
- `/save-requirement` - Save requirement content to BrainGrid
- `/build` - Generate complete implementation plan

**Quick Start Example:**

```bash
# In Cursor IDE Agent input
/specify "Add user authentication with OAuth2"
# → Creates REQ-123

/breakdown REQ-123
# → Generates 5-10 implementation tasks

/build REQ-123
# → Shows complete requirement with all task prompts
```

### Setup for Claude Code

BrainGrid's AGENTS.md file also works with Claude Code. You can either:

1. **Use AGENTS.md directly** (Claude Code automatically reads it)
2. **Symlink for compatibility**: `ln -s AGENTS.md .claude/CLAUDE.md`

Claude Code also provides its own slash commands in `.claude/commands/`.

### Cross-IDE Compatibility

The AGENTS.md standard ensures your BrainGrid setup works across tools:

- **AGENTS.md** provides CLI guidance for all compatible tools
- **Tool-specific directories** (.cursor/, .claude/) add enhanced features
- **Single source of truth** for BrainGrid workflows

**Learn more:**

- [AGENTS.md standard](https://agents.md/)
- [BrainGrid documentation](https://www.braingrid.ai)
- Full CLI command reference in [AGENTS.md](./AGENTS.md)

---

## QuickStart: One-Minute Flow

```bash
# 1. Initialize your project
braingrid init

# 2. Create a requirement with AI refinement
braingrid specify --prompt "Add user authentication"

# 3. Break down requirement into tasks with AI
braingrid requirement breakdown REQ-1

# 4. Build requirement with all tasks (markdown with full content)
braingrid requirement build REQ-1
```

---

## Usage

BrainGrid CLI uses a resource-oriented command structure: `braingrid <resource> <action> [options]`

### Authentication Commands

```bash
braingrid login
braingrid whoami
braingrid logout
```

### Initialization

Initialize your repository with a BrainGrid project. The command will show you the detected project and ask for confirmation before proceeding:

```bash
# Step-by-step wizard to initialize your project
braingrid init

# Manually specify project by ID (short ID or UUID)
braingrid init --project PROJ-123

# Skip wizard and force reinitialization (useful for scripts)
braingrid init --force
braingrid init --project PROJ-123 --force
```

The `init` command creates a `.braingrid/project.json` file in the `.braingrid/` directory. This tells the CLI what project it is working on so you don't have to pass it as a parameter.

> **Note:** The init command always asks for confirmation before initializing unless you use the `--force` flag.

### Setup Commands

Install BrainGrid integration files for AI coding tools. These commands fetch integration files from the [BrainGrid repository](https://github.com/BrainGridAI/braingrid) and install them in your project.

**Prerequisites:**

- **GitHub CLI** must be installed and authenticated
  - macOS: `brew install gh`
  - Windows: `winget install GitHub.CLI`
  - Linux: See [GitHub CLI installation](https://cli.github.com/manual/installation)
  - After installing: `gh auth login`

**Commands:**

```bash
# Install Claude Code integration
braingrid setup claude-code

# Install Cursor integration
braingrid setup cursor

# Skip prompts and overwrite all existing files
braingrid setup claude-code --force

# Preview changes without making modifications
braingrid setup cursor --dry-run
```

**What gets installed:**

- **Claude Code integration:**
  - Commands in `.claude/commands/` (specify, breakdown, build, save-requirement)
  - Skills in `.claude/skills/braingrid-cli/`
  - Content injected into `CLAUDE.md` (or creates it if it doesn't exist)

- **Cursor integration:**
  - Commands in `.cursor/commands/` (specify, breakdown, build, save-requirement)
  - Rules in `.cursor/rules/`
  - Content injected into `AGENTS.md` (or creates it if it doesn't exist)

**Options:**

- `--force` - Skip prompts and overwrite all existing files without asking
- `--dry-run` - Show what would be done without making any changes

**File Conflicts:**

When files already exist, you'll be prompted to choose:

- `[O]verwrite` - Replace this file
- `[S]kip` - Keep existing file
- `[A]ll` - Overwrite all remaining files
- `[Q]uit` - Cancel installation

**Marker-based Updates:**

Running setup again will update the BrainGrid sections in `CLAUDE.md` or `AGENTS.md` without duplicating content. The CLI uses HTML comment markers to identify and replace existing BrainGrid content.

**Learn more:**

- [Claude Code integration guide](https://braingrid.ai/docs/integrations/claude-code)
- [Cursor integration guide](https://braingrid.ai/docs/integrations/cursor)

### Project Commands

```bash
braingrid project list [--format json] [--page 1] [--limit 20]
braingrid project show
braingrid project show [<id>] [--repository "owner/repo"]
braingrid project create --name "Project Name" [--description "Description"] [--repository-id <uuid>] [--repository "owner/name"]
braingrid project update <id> [--name "New Name"] [--description "New Description"]
braingrid project delete <id> [--force]
```

> **Note:** `project show` displays the initialized project from your workspace when called without arguments. Use `--repository "owner/repo"` to list all projects for a specific repository, or provide a project ID directly to view a specific project.
>
> **Note:** When creating a project, you can optionally link it to a repository using `--repository-id <uuid>` to link by repository UUID, or `--repository "owner/name"` (e.g., `--repository "microsoft/vscode"`) to link by repository name. If `--repository-id` is provided, it takes precedence.

### Requirement Commands

```bash
# Create requirement with AI refinement (specify command)
# With auto-detected project from workspace:
braingrid specify --prompt "Add user authentication with OAuth2"

# Specify project explicitly:
braingrid specify -p PROJ-123 --prompt "Implement real-time notifications"

# Output in different formats:
braingrid specify --prompt "Add dark mode support" --format json
braingrid specify --prompt "Add export feature" --format markdown

# Working with the initialized project
braingrid requirement list [--status IDEA|PLANNED|IN_PROGRESS|REVIEW|COMPLETED|CANCELLED] [--format json]
braingrid requirement create --name "Name" [--content "Description"] [--assigned-to <uuid>]
braingrid requirement show [id]
braingrid requirement update [id] [--status IDEA|PLANNED|IN_PROGRESS|REVIEW|COMPLETED|CANCELLED] [--name "New Name"]
braingrid requirement delete [id] [--force]
braingrid requirement breakdown [id] [--verbose]
braingrid requirement build [id] [--format markdown|json|xml]

# Working with a different project:
braingrid requirement list -p PROJ-456 [--status PLANNED]
braingrid requirement create -p PROJ-456 --name "Description"
```

> **Note:** The `-p`/`--project` parameter is optional when working in an initialized repository. Use it to work with a different project.
>
> **Note:** For the `specify` command, the prompt must be between 10-5000 characters. The AI will refine your prompt into a detailed requirement document.
>
> **Note:** The `-r`/`--requirement` parameter is optional and accepts formats like `REQ-456`, `req-456`, or `456`. The CLI will automatically detect the requirement ID from your git branch name (e.g., `feature/REQ-123-description` or `REQ-123-fix-bug`) if it is not provided.
>
> **Note:** The `requirement list` command displays requirements with their status, name, branch (if assigned), and progress percentage.

### Task Commands

```bash
# Working with the initialized project
braingrid task list -r REQ-456 [--format table|json|xml|markdown] [--verbose]
braingrid task create -r REQ-456 --title "Task Title" [--content "Description"]
braingrid task show <id>
braingrid task update <id> [--status PLANNED|IN_PROGRESS|COMPLETED|CANCELLED] [--title "New Title"]
braingrid task delete <id> [--force]

# Working with a different project:
braingrid task list -p PROJ-123 -r REQ-456
braingrid task create -p PROJ-123 -r REQ-456 --title "Task Title"
```

> **Note:** The `-p`/`--project` parameter is optional when working in an initialized repository. Use it to work with a different project.
>
> **Note:** The `-r`/`--requirement` parameter is optional and accepts formats like `REQ-456`, `req-456`, or `456`. The CLI will automatically detect the requirement ID from your git branch name (e.g., `feature/REQ-123-description` or `REQ-123-fix-bug`) if it is not provided.
>
> **Note:** Use `--verbose` with `task list` to show full task content in addition to task metadata.
>
> **Note:** Task status values are: `PLANNED`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED` (tasks do not have `IDEA` or `REVIEW` status).

### Informational Commands

```bash
braingrid status       # Show CLI status (authentication, git repo, configuration)
braingrid --version    # Show CLI version
braingrid --help       # Show help information
```

---

## Updating

Update to the latest version:

```bash
braingrid update          # Update to the latest version
braingrid update --check  # Check for updates without installing
```

---

## Community

Join the BrainGrid community to connect with other AI builders, share workflows, and get help:

- [BrainGrid Community](https://www.braingrid.ai/community)

---

## Links

- [BrainGrid](https://www.braingrid.ai)
- [Documentation](https://docs.braingrid.ai)
- [BrainGrid MCP](https://docs.braingrid.ai/mcp-server/overview)
- [npm package](https://www.npmjs.com/package/@braingrid/cli)
