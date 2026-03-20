<h1>BrainGrid for VS Code</h1>

<div align="center">
<img src="https://www.braingrid.ai/logos/braingrid-symbol-800.png" width="80"/>

**Spec-Driven Development — Built Into Your Editor**

Turn vague ideas into detailed specs and perfectly-prompted tasks, without leaving VS Code.

[![npm version](https://img.shields.io/npm/v/@braingrid/cli.svg?color=blue&logo=npm)](https://www.npmjs.com/package/@braingrid/cli)
[![Downloads](https://img.shields.io/npm/dm/@braingrid/cli.svg?color=green)](https://www.npmjs.com/package/@braingrid/cli)

</div>

---

## Overview

BrainGrid integrates with VS Code through the tools you already use:

- **VS Code Tasks** — Run any BrainGrid command from the Command Palette (`Ctrl+Shift+P` → `Run Task`) with interactive input prompts
- **Cline Rules** — Teach the [Cline](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev) extension about BrainGrid automatically (like `.cursorrules`, but for Cline)
- **Continue.dev Slash Commands** — Use `/specify`, `/breakdown`, `/build` inside the [Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue) chat panel
- **Status Bar** — Real-time BrainGrid context shown in the VS Code status bar

### Core Workflow

```
Vague Idea → /specify → REQ-123 → /breakdown → Tasks → /build → AI implements
```

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

This opens an OAuth2 flow in your browser. After login, verify:

```bash
braingrid whoami
```

### 3. Initialize Your Project

In your project directory:

```bash
braingrid init
```

Creates `.braingrid/project.json` to track your active project.

### 4. Install VS Code Integration

```bash
braingrid setup vscode
```

This installs:

- **VS Code Tasks** into `.vscode/tasks.json` — BrainGrid commands accessible from Command Palette
- **Cline Rules** into `.clinerules` — Automatic BrainGrid context for Cline
- **Continue Config** into `.continue/config.json` — Slash commands for Continue.dev
- **Status Bar Script** into `.braingrid/statusline.sh` — Live context in status bar

---

## VS Code Tasks

The fastest way to run BrainGrid without leaving VS Code.

**Access via:** `Ctrl+Shift+P` → `Tasks: Run Task` → select a BrainGrid task

Or bind tasks to keyboard shortcuts (see [Keyboard Shortcuts](#keyboard-shortcuts) below).

### Available Tasks

| Task | Description | Input Required |
|------|-------------|----------------|
| `BrainGrid: Specify` | Create AI-refined requirement from an idea | Your prompt |
| `BrainGrid: Breakdown` | Break requirement into tasks | REQ-ID |
| `BrainGrid: Build` | Fetch complete implementation plan | REQ-ID (optional) |
| `BrainGrid: Status` | Show auth, project, and git context | None |
| `BrainGrid: Requirement List` | List all requirements | None |
| `BrainGrid: Task List` | List tasks for a requirement | REQ-ID |
| `BrainGrid: Update` | Update BrainGrid CLI to latest | None |

### How Tasks Work

When you run a task that needs input (like `BrainGrid: Specify`), VS Code shows an input box at the top of the screen. Type your prompt and press Enter — the terminal opens and runs the command.

---

## Cline Integration

[Cline](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev) is a VS Code AI coding agent that reads `.clinerules` from your project root automatically — just like Cursor reads `.cursorrules`.

After running `braingrid setup vscode`, BrainGrid's context is injected into your `.clinerules`, giving Cline:

- Full BrainGrid workflow knowledge
- Understanding of REQ-X / TASK-X references
- Proactive suggestions to use `/specify` when ideas are vague
- Correct task status update patterns

### Using BrainGrid with Cline

In the Cline panel, you can type naturally:

```
I want to add OAuth2 login to my app
```

Cline will recognize this as a vague idea, suggest running `braingrid specify`, and guide you through the full spec-driven workflow.

Or be explicit:

```
Run: braingrid specify --prompt "Add OAuth2 login with Google and GitHub providers"
```

---

## Continue.dev Integration

[Continue](https://marketplace.visualstudio.com/items?itemName=Continue.continue) is an open-source AI coding assistant for VS Code that supports slash commands.

After setup, type `/` in the Continue chat panel to access:

| Command | Description | Usage |
|---------|-------------|-------|
| `/specify` | Create AI-refined requirement | `/specify Add dark mode toggle` |
| `/breakdown` | Break requirement into tasks | `/breakdown REQ-123` |
| `/build` | Get full implementation plan | `/build REQ-123` |
| `/save-requirement` | Save current plan as requirement | `/save-requirement Auth System` |

### How to Enable

1. Install the [Continue extension](https://marketplace.visualstudio.com/items?itemName=Continue.continue)
2. Run `braingrid setup vscode`
3. The BrainGrid slash commands are added to your `.continue/config.json`

---

## Keyboard Shortcuts

Add these to your VS Code `keybindings.json` (`Ctrl+Shift+P` → `Open Keyboard Shortcuts (JSON)`):

```json
[
  {
    "key": "ctrl+shift+g s",
    "command": "workbench.action.tasks.runTask",
    "args": "BrainGrid: Specify",
    "when": "editorFocus"
  },
  {
    "key": "ctrl+shift+g b",
    "command": "workbench.action.tasks.runTask",
    "args": "BrainGrid: Build",
    "when": "editorFocus"
  },
  {
    "key": "ctrl+shift+g d",
    "command": "workbench.action.tasks.runTask",
    "args": "BrainGrid: Breakdown",
    "when": "editorFocus"
  },
  {
    "key": "ctrl+shift+g l",
    "command": "workbench.action.tasks.runTask",
    "args": "BrainGrid: Requirement List",
    "when": "editorFocus"
  }
]
```

**Chord shortcut pattern:** `Ctrl+Shift+G` then a letter — `S`pecify, `B`uild, `D`breakdown, `L`ist.

---

## Typical Workflow

### Starting a New Feature

```bash
# 1. In VS Code: Ctrl+Shift+P → "Tasks: Run Task" → "BrainGrid: Specify"
#    Input: "Add dark mode toggle in settings with theme persistence"
#    → Creates REQ-1

# 2. Ctrl+Shift+P → "BrainGrid: Breakdown"
#    Input: REQ-1
#    → Creates 5-8 tasks under REQ-1

# 3. Create git branch (auto-enables requirement detection)
git checkout -b feature/REQ-1-dark-mode

# 4. In Cline or Continue: /build
#    → Fetches full plan, auto-detects REQ-1 from branch

# 5. Implement with Cline or Continue
#    → Cline understands BrainGrid tasks from .clinerules

# 6. Update statuses as you go
braingrid task update TASK-1 -r REQ-1 --status COMPLETED
```

### Working on Existing Requirements

```bash
# Check status
braingrid status

# List what's in progress
braingrid requirement list --status IN_PROGRESS

# View specific requirement
braingrid requirement show REQ-123

# Get full plan in terminal
braingrid requirement show REQ-123 --format markdown

# Or use Continue: /build REQ-123
```

---

## Auto-Detection

BrainGrid CLI detects context automatically:

- **Project**: Reads from `.braingrid/project.json`
- **Requirement ID**: Parsed from git branch name
  - `feature/REQ-123-description` → `REQ-123`
  - `req-456-fix-bug` → `REQ-456`
  - `123-new-feature` → `REQ-123`

This means once you're on a feature branch, most commands work without specifying IDs.

---

## Recommended VS Code Extensions

| Extension | Purpose | Link |
|-----------|---------|------|
| **Cline** | AI coding agent with `.clinerules` support | [Install](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev) |
| **Continue** | AI assistant with slash command support | [Install](https://marketplace.visualstudio.com/items?itemName=Continue.continue) |
| **GitLens** | Enhanced git for feature branch workflows | [Install](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) |

---

## File Reference

After `braingrid setup vscode`, these files are installed in your project:

| File | Purpose |
|------|---------|
| `.vscode/tasks.json` | BrainGrid VS Code tasks |
| `.clinerules` | BrainGrid context for Cline |
| `.continue/config.json` | Slash commands for Continue.dev |
| `.braingrid/project.json` | Active project tracking |

---

## Command Reference

### Authentication

```bash
braingrid login              # OAuth2 login flow
braingrid whoami            # Show current user
braingrid logout            # Sign out
```

### Requirements

```bash
braingrid specify --prompt "Your idea"
braingrid requirement list [--status PLANNED|IN_PROGRESS|REVIEW|COMPLETED]
braingrid requirement show [REQ-ID]
braingrid requirement show REQ-ID --format markdown
braingrid requirement update REQ-ID --status IN_PROGRESS
```

### Tasks

```bash
braingrid task list -r REQ-ID
braingrid task show TASK-ID
braingrid task update TASK-ID -r REQ-ID --status IN_PROGRESS
braingrid task create -r REQ-ID --title "Task Title"
```

### Utility

```bash
braingrid status             # Auth + project + git context
braingrid update            # Update to latest version
braingrid --version
braingrid --help
```

---

## Learn More

- **BrainGrid Docs**: [https://braingrid.ai](https://braingrid.ai)
- **GitHub**: [https://github.com/BrainGridAI/braingrid](https://github.com/BrainGridAI/braingrid)
- **NPM**: [https://www.npmjs.com/package/@braingrid/cli](https://www.npmjs.com/package/@braingrid/cli)
- **Web App**: [https://app.braingrid.ai](https://app.braingrid.ai)

## Support

- **Issues**: [GitHub Issues](https://github.com/BrainGridAI/braingrid/issues)
- **Email**: support@braingrid.ai

---

## License

MIT License - See [LICENSE](../LICENSE) file for details
