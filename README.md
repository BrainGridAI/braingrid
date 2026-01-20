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

## IDE Integration

### Claude Code

```bash
braingrid setup claude-code
```

Installs slash commands (`/specify`, `/breakdown`, `/build`), BrainGrid skill, and status line showing your project/requirement/task context in real-time.

[→ Full Claude Code setup guide](./.braingrid/README.md)

### Cursor

```bash
braingrid setup cursor
```

Installs slash commands, always-on rules, and AGENTS.md integration for seamless BrainGrid workflows in Agent mode.

[→ Full Cursor setup guide](./.cursor/README.md)

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

For detailed usage guides, see [Claude Code setup](./.braingrid/README.md) or [Cursor setup](./.cursor/README.md).

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
braingrid requirement breakdown [id]
braingrid requirement build [id] [--format markdown|json|xml]
braingrid requirement create-branch [id] [--name <branch-name>] [--base <branch>]
braingrid requirement review [id] [--pr <number>]

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
>
> **Note:** The `create-branch` command creates a GitHub branch for a requirement. It auto-generates a branch name in the format `{username}/REQ-123-slug` if not provided.
>
> **Note:** The `review` command runs an AI-powered acceptance review on a pull request, validating it against the requirement's acceptance criteria. It auto-detects the PR number from the current branch if not provided.

### Task Commands

```bash
# Working with the initialized project
braingrid task list -r REQ-456 [--format table|json|xml|markdown]
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
> **Note:** Task status values are: `PLANNED`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED` (tasks do not have `IDEA` or `REVIEW` status).

### Informational Commands

```bash
braingrid status       # Show CLI status (authentication, git repo, configuration)
braingrid --version    # Show CLI version
braingrid --help       # Show help information
```

---

## Shell Completion

BrainGrid CLI supports tab completion for bash and zsh shells, making it faster to type commands and discover available options.

### Quick Setup (Recommended)

Automatically install completion for your current shell:

```bash
braingrid completion --setup
```

Then restart your terminal or source your shell config:

```bash
# For bash
source ~/.bashrc

# For zsh
source ~/.zshrc
```

### Manual Installation

#### Bash

Add to your `~/.bashrc`:

```bash
# Option 1: Add to shell config
braingrid completion bash >> ~/.bashrc

# Option 2: Eval in current session (temporary)
eval "$(braingrid completion bash)"
```

#### Zsh

Add to your `~/.zshrc`:

```bash
# Option 1: Add to shell config
braingrid completion zsh >> ~/.zshrc

# Option 2: Eval in current session (temporary)
eval "$(braingrid completion zsh)"
```

### What Gets Completed

- **Commands**: `login`, `logout`, `project`, `requirement`, `task`, etc.
- **Subcommands**: `list`, `show`, `create`, `update`, `delete`, `breakdown`, `build`, `create-branch`, `review`
- **Options**: `--help`, `--format`, `--status`, `--project`, `--requirement`
- **Values**: Status values (`IDEA`, `PLANNED`, `IN_PROGRESS`, etc.), format options (`table`, `json`, `xml`, `markdown`)

### Fish Shell

Fish shell support is planned for a future release.

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
