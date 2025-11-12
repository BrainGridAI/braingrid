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
