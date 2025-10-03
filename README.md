<div align="center">
<img src="https://www.braingrid.ai/logos/braingrid-symbol-800.png" width="100"/>
  <h1>BrainGrid</h1>

  <p>Turn thoughts into AI-ready specs and ship 100 faster.</p>
  <h3>A CLI for spec-driven development.</h3>

  [![npm version](https://img.shields.io/npm/v/@braingrid/cli.svg?color=blue&logo=npm)](https://www.npmjs.com/package/@braingrid/cli)
  [![Downloads](https://img.shields.io/npm/dm/@braingrid/cli.svg?color=green)](https://www.npmjs.com/package/@braingrid/cli)
  [![GitHub stars](https://img.shields.io/github/stars/BrainGridAI/braingrid?style=social)](https://github.com/BrainGridAI/braingrid)
</div>

---

## Overview

**BrainGrid** helps you turn half-baked thoughts into build-ready specs and perfectly-prompted tasks that AI coding agents like Cursor, or Claude Code, can build fast without breaking things.

**Spec-driven development** means AI agents work from crystal-clear requirements and tasks—not vague ideas—so they build exactly what you need, faster and with fewer bugs.

## Features

**BrainGrid CLI** is the command-line interface for managing your requirements, and tasks on the BrainGrid platform.

- 📋 **Add Requirements to Your Backlog** - Create requirements from prompts and link to repositories
- ✨ **Refine Requirements** - Update and manage requirements to get them build-ready
- 🎯 **Break Down into Tasks** - Create perfectly-prompted tasks from requirements
- 🤖 **Fetch Tasks for AI Agents** - Get task prompts to feed to Cursor, Claude Code, and other AI coding tools
- 📊 **Track Progress** - Manage and update task statuses
- 💾 **Multiple Output Formats** - View data as formatted tables or JSON for scripting
- 🔍 **Environment Detection** - Automatically detect git repository info and installed AI coding tools

---

## Installation

```bash
npm install -g @braingrid/cli
```

> Requires Node.js 18+

---

## QuickStart: One-Minute Flow

```bash
# 1. Authenticate
braingrid login

# 2. Initialize your project (auto-detects from git remote)
braingrid init

# 3. Create a requirement
braingrid requirement create --prompt "Add user authentication"

# 4. List requirements
braingrid requirement list

# 5. Create tasks for a requirement
braingrid task create -r REQ-1 --title "Implement login endpoint"

# 6. View tasks for a requirement
braingrid task list -r REQ-1
```
---

## Usage

BrainGrid CLI uses a resource-oriented command structure: `braingrid <resource> <action> [options]`

### Authentication Commands

```bash
braingrid login                # Authenticate with BrainGrid (OAuth2 PKCE flow)
braingrid logout               # Sign out and clear credentials
braingrid whoami               # Show current user information
```

### Initialization

Initialize your repository with a BrainGrid project:

```bash
braingrid init                       # Auto-detects project from git remote (owner/name)
braingrid init --project PROJ-123    # Manually specify project by ID (short ID or UUID)
braingrid init --wizard              # Run interactive wizard with confirmation prompt
braingrid init --force               # Force reinitialization if already initialized
braingrid init --project PROJ-123 --force  # Manually specify and force reinitialization
```

The `init` command:
- **Auto-detect mode** (default): Fetches the project linked to your current git repository
- **Manual mode** (`--project`): Fetches a specific project by ID, bypassing git detection
- Creates a `.braingrid/project.json` file in the `.braingrid/` directory
- Fails if already initialized unless `--force` is provided

### Project Commands

```bash
braingrid project list [--format json] [--page 1] [--limit 20]
braingrid project show                                       # Auto-detects project from current repo
braingrid project show [<id>] [--repository "owner/repo"]   # Show specific repo's project (--repo also works)
braingrid project create --name "Project Name" [--description "Description"] [--repositories "owner/repo,owner/repo2"]
braingrid project update <id> [--name "New Name"] [--description "New Description"]
braingrid project delete <id> [--force]
```

> **Note:** `project show` automatically detects the current git repository and shows its associated project when called without arguments. You can also specify `--repository "owner/repo"` (or the shorter `--repo`) to show a specific repository's project, or provide a project ID directly.

### Requirement Commands

```bash
# After running braingrid init (project auto-detected):
braingrid requirement list [--status PLANNED|IN_PROGRESS|COMPLETED|CANCELLED] [--format json]
braingrid requirement create --prompt "Requirement description" [--repositories "owner/repo"]
braingrid requirement show <id>
braingrid requirement update <id> [--status STATUS] [--name "New Name"]
braingrid requirement delete <id> [--force]

# Working with a different project:
braingrid requirement list -p PROJ-456 [--status PLANNED]
braingrid requirement create -p PROJ-456 --prompt "Description"
```

> **Note:** The `-p`/`--project` parameter is optional when working in an initialized repository. Use it to work with a different project.

### Task Commands

```bash
# After running braingrid init (project auto-detected):
braingrid task list -r REQ-456 [--format json]
braingrid task create -r REQ-456 --title "Task Title" [--content "Description"]
braingrid task show <id>
braingrid task update <id> [--status STATUS] [--title "New Title"]
braingrid task delete <id> [--force]

# Working with a different project (full format):
braingrid task list -r PROJ-123/REQ-456
braingrid task create -r PROJ-123/REQ-456 --title "Task Title"
```

> **Note:** The `-r`/`--requirement` parameter accepts either `REQ-456` (auto-detects project from `.braingrid/project.json`) or full format `PROJ-123/REQ-456` for working with other projects.

### Informational Commands

```bash
braingrid status               # Show CLI status (authentication, git repo, configuration)
braingrid --version            # Show CLI version
braingrid --help               # Show help information
```

---

## Updating

Update to the latest version:

```bash
braingrid update                # Update to the latest version
braingrid update --check        # Check for updates without installing
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
