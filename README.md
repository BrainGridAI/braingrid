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

# 2. Create a project
braingrid project create --name "My Awesome Project"
# Returns: PROJ-1

# 3. Create a requirement for your project
braingrid requirement create -p PROJ-1 --prompt "Add user authentication"

# 4. List requirements for the project
braingrid requirement list -p PROJ-1

# 5. Create tasks for a requirement
braingrid task create -r PROJ-1/REQ-1 --title "Implement login endpoint"

# 6. View tasks for a requirement
braingrid task list -r PROJ-1/REQ-1
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

### Project Commands

```bash
braingrid project list [--format json] [--page 1] [--limit 20]
braingrid project show <id>
braingrid project create --name "Project Name" [--description "Description"]
braingrid project update <id> [--name "New Name"] [--description "New Description"]
braingrid project delete <id> [--force]
```

### Requirement Commands

```bash
braingrid requirement list -p <project-id> [--status PLANNED|IN_PROGRESS|COMPLETED|CANCELLED] [--format json]
braingrid requirement show <id>
braingrid requirement create -p <project-id> --prompt "Requirement description" [--repositories "owner/repo,owner/repo2"]
braingrid requirement update <id> [--status STATUS] [--name "New Name"]
braingrid requirement delete <id> [--force]
```

> **Note:** Use `-p` (short) or `--project` (long) for the project parameter.

### Task Commands

```bash
braingrid task list -r <req-id> [--format json]
braingrid task show <id>
braingrid task create -r <req-id> --title "Task Title" [--content "Description"]
braingrid task update <id> [--status STATUS] [--title "New Title"]
braingrid task delete <id> [--force]
```

> **Note:** Use `-r` (short) or `--requirement` (long) for the requirement parameter.

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
# npm
npm install -g @braingrid/cli@latest

# yarn
yarn global add @braingrid/cli@latest

# pnpm
pnpm add -g @braingrid/cli@latest
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
