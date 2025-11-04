<div align="center">
<img src="https://www.braingrid.ai/logos/braingrid-symbol-800.png" width="100"/>
  <h1>BrainGrid</h1>

  <p>Prompt AI Coding Tools like a rockstar developer</p>
  <h3>A CLI to turn messy thoughts into detailed specs and perfectly-prompted tasks to build well-structured, maintainable software.</h3>

[![npm version](https://img.shields.io/npm/v/@braingrid/cli.svg?color=blue&logo=npm)](https://www.npmjs.com/package/@braingrid/cli)
[![Downloads](https://img.shields.io/npm/dm/@braingrid/cli.svg?color=green)](https://www.npmjs.com/package/@braingrid/cli)
[![GitHub stars](https://img.shields.io/github/stars/BrainGridAI/braingrid?style=social)](https://github.com/BrainGridAI/braingrid)

</div>

---

## Overview

**BrainGrid** helps you turn half-baked thoughts into build-ready specs and perfectly-prompted tasks that AI coding agents like Cursor, or Claude Code, can build fast without breaking things.

## Features

**BrainGrid CLI** is the command-line interface for managing your requirements, and tasks on the BrainGrid platform.

- 📋 **Add Requirements to Your Backlog** - Create requirements from prompts and link to repositories
- ✨ **Refine Requirements** - Update and manage requirements to get them build-ready
- 🎯 **Break Down into Tasks** - Create perfectly-prompted tasks from requirements
- 🤖 **Fetch Tasks for AI Agents** - Get task prompts to feed to Cursor, Claude Code, and other AI coding tools
- 📊 **Track Progress** - Manage and update task statuses
- 💾 **Multiple Output Formats** - View data as formatted tables or JSON for scripting
- 🔍 **Environment Detection** - Automatically detect git repository info and installed AI coding tools
- 🔌 **JSON-RPC Mode** - Programmatic access via JSON-RPC 2.0 protocol for IDE integration

---

## Installation

```bash
npm install -g @braingrid/cli
```

> **Requirements:** Node.js 20+ and Git
>
> **Note:** If Git is not installed, the CLI will offer to install it automatically when you run `braingrid init`.
>
> **Recommended:** GitHub CLI (`gh`) is highly recommended for seamless GitHub integration. The CLI will offer to install it during initialization.

---

## QuickStart: One-Minute Flow

```bash
# 1. Initialize your project
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
braingrid login
braingrid whoami
braingrid logout
```

### Initialization

Initialize your repository with a BrainGrid project. The command will show you the detected project and ask for confirmation before proceeding:

```bash
# Step-by-step wirzard to initialize your project
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
braingrid project create --name "Project Name" [--description "Description"] [--repository "owner/repo"]
braingrid project update <id> [--name "New Name"] [--description "New Description"]
braingrid project delete <id> [--force]
```

> **Note:** `project show` displays the initialized project from your workspace when called without arguments. Use `--repository "owner/repo"` to list all projects for a specific repository, or provide a project ID directly to view a specific project.

### Requirement Commands

```bash
# After running braingrid init (project auto-detected):
braingrid requirement list [--status PLANNED|IN_PROGRESS|COMPLETED|CANCELLED] [--format json]
braingrid requirement create --prompt "Requirement description" [--repository "owner/repo"]
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
