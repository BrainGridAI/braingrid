# CLAUDE.md — BrainGrid Repository Guide

> This file provides AI assistants with the context needed to work effectively on the BrainGrid repository.

## Project Overview

**BrainGrid** is an AI Product Planner that helps developers turn vague ideas into build-ready specs and perfectly-prompted tasks for AI coding agents (Cursor, Claude Code, etc.). It implements a **spec-driven development** workflow:

```
Vague Idea → AI-Refined Requirement → Breakdown into Tasks → Build with AI
```

**This repository** is a **distribution/template repository** — it contains IDE integration files, slash commands, hook scripts, skills, and documentation that get installed into user projects via `braingrid setup claude-code` or `braingrid setup cursor`. The main CLI source code lives in a separate repository (published as `@braingrid/cli` on npm).

- **Current Version:** 0.2.60
- **License:** Proprietary (Braingrid AI, Inc 2025)
- **npm Package:** `@braingrid/cli`

---

## Repository Structure

```
braingrid/
├── CLAUDE.md                          # This file — repository guide for AI assistants
├── README.md                          # Main project documentation (QuickStart, CLI reference)
├── CHANGELOG.md                       # Version history (Keep a Changelog format, SemVer)
├── LICENSE.md                         # Proprietary license
│
├── claude-code/                       # Claude Code IDE integration files
│   ├── CLAUDE.md                      # Quick-reference injected into user CLAUDE.md
│   ├── README.md                      # Full Claude Code setup guide
│   ├── statusline.sh                  # Real-time BrainGrid context status bar
│   ├── commands/                      # Slash commands (installed to .claude/commands/)
│   │   ├── specify.md                 # /specify — create AI-refined requirement
│   │   ├── breakdown.md               # /breakdown — break requirement into tasks
│   │   └── save-requirement.md        # /save-requirement — save plan as requirement
│   ├── hooks/                         # Build automation hooks (installed to .claude/hooks/)
│   │   ├── log-helper.sh              # Shared structured logging utility
│   │   ├── sync-braingrid-task.sh     # PostToolUse: sync task status to BrainGrid
│   │   ├── create-braingrid-task.sh   # PostToolUse: create linked BrainGrid task
│   │   ├── verify-acceptance-criteria.sh  # StopSession: enforce criteria verification
│   │   ├── task-completed-validate.sh     # TaskCompleted: enforce committed changes
│   │   ├── pre-task-create-naming.sh      # PreToolUse: enforce task naming convention
│   │   ├── pre-task-update-instructions.sh # PreToolUse: validate subject + inject guidance
│   │   ├── post-task-update-prompt.sh     # PostToolUse: inject auto-continue instructions
│   │   └── check-stale-build-sentinel.sh  # SessionStart: clean stale sentinel files
│   └── skills/                        # AI skills (installed to .claude/skills/)
│       ├── braingrid-cli/SKILL.md     # Spec-driven development workflow guide
│       ├── build/SKILL.md             # Implementation planning and execution
│       ├── ux/SKILL.md                # UX and product design patterns
│       └── frontend-design/SKILL.md   # Design system and frontend best practices
│
└── cursor/                            # Cursor IDE integration files
    ├── README.md                      # Full Cursor setup guide
    ├── AGENTS.md                      # Quick-reference injected into user AGENTS.md
    ├── commands/                      # Slash commands (installed to .cursor/commands/)
    │   ├── specify.md                 # /specify — create AI-refined requirement
    │   ├── breakdown.md               # /breakdown — break requirement into tasks
    │   ├── build.md                   # /build — fetch implementation plan
    │   └── save-requirement.md        # /save-requirement — save plan as requirement
    └── rules/                         # Always-on rules (installed to .cursor/rules/)
        └── braingrid.mdc             # System rule for spec-driven workflow
```

---

## Key Conventions

### File Naming

| Category    | Pattern                          | Examples                                    |
|-------------|----------------------------------|---------------------------------------------|
| Commands    | `{action}.md`                    | `specify.md`, `breakdown.md`, `build.md`    |
| Skills      | `{domain}/SKILL.md` (uppercase)  | `braingrid-cli/SKILL.md`, `ux/SKILL.md`     |
| Hooks       | `{trigger}-{purpose}.sh`         | `sync-braingrid-task.sh`, `log-helper.sh`   |
| Rules       | `{tool-name}.mdc`                | `braingrid.mdc`                             |
| Injected    | Uppercase standard names         | `CLAUDE.md`, `AGENTS.md`                    |

### Frontmatter Format

Commands and skills use YAML frontmatter:

```yaml
# Commands
---
allowed-tools: Bash(braingrid:*), Bash(git:*), Read, Grep, Glob, Skill(braingrid-cli)
argument-hint: [prompt-text]
description: Short description of the command
---

# Skills
---
name: skill-name
description: When and how to use this skill
allowed-tools: Bash(braingrid:*), Read, Write, ...
argument-hint: [args]
---

# Cursor Rules
---
alwaysApply: true
---
```

### Shell Script Conventions (Hooks)

- **Always exit 0** — hooks must never block the workflow via exit code (except `task-completed-validate.sh` which uses `exit 2` to deny)
- **JSON decisions** — use `{"decision": "allow"}` or `{"decision": "block", "reason": "..."}` for hook responses
- **Structured logging** — format: `TIMESTAMP [LEVEL] HOOK | EVENT | DETAILS`
  - Example: `14:23:45 [INFO] create-braingrid-task | api_call | req=REQ-9 duration=1.2s`
- **Stderr isolation** — all logs go to file; stdout stays clean for JSON parsing
- **REQ-prefixed log files** — `${REQ_ID}-build-debug.log` for request correlation
- **Timing instrumentation** — wrap CLI calls with `log_time_start()` / `log_time_end()`
- **SIGTERM trap** — hooks handle `SIGTERM` gracefully with log and `exit 0`
- **Build sentinel gating** — hooks check for `.braingrid/temp/build-active.local` before activating
- **Source log-helper.sh** — all hooks source `$(dirname "$0")/log-helper.sh`
- **CRLF safety** — use `tr -d '\r'` when parsing text content
- **jq for JSON** — required dependency; used for parsing stdin and API responses

### Task Naming Convention

Enforced by `pre-task-create-naming.sh`:

```
TASK N: type: description           # Before commit
TASK N (abcdef1): type: description  # After commit (with hash)
```

Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

### Status Flows

**Requirements:** `IDEA → PLANNED → IN_PROGRESS → REVIEW → COMPLETED` (or `CANCELLED`)

**Tasks:** `PLANNED → IN_PROGRESS → COMPLETED` (or `CANCELLED`)

**Status mapping (Claude Code → BrainGrid):** `pending` → `PLANNED`, `in_progress` → `IN_PROGRESS`, `completed` → `COMPLETED`

### ID Formats

Requirement and task IDs accept flexible formats:
- `REQ-123` / `TASK-456` (canonical)
- `req-123` / `task-456` (lowercase)
- `123` / `456` (number only)
- Full UUID

### Context Auto-Detection

- **Project:** Read from `.braingrid/project.json`
- **Requirement:** Parsed from git branch name (`feature/REQ-123-description` → `REQ-123`)
- **Branch patterns recognized:** `feature/REQ-123-*`, `req-456-*`, `123-*`

---

## Integration Architecture

### Claude Code Integration

When users run `braingrid setup claude-code`, files from `claude-code/` are installed into the user's project:

| Source                       | Destination                      |
|------------------------------|----------------------------------|
| `claude-code/commands/*.md`  | `.claude/commands/`              |
| `claude-code/skills/*/`      | `.claude/skills/`                |
| `claude-code/hooks/*.sh`     | `.claude/hooks/`                 |
| `claude-code/statusline.sh`  | `.claude/statusline.sh`          |
| `claude-code/CLAUDE.md`      | Injected into root `CLAUDE.md`   |

**Marker-based injection:** BrainGrid content in `CLAUDE.md` is wrapped in `<!-- BEGIN BRAINGRID INTEGRATION -->` / `<!-- END BRAINGRID INTEGRATION -->` HTML comments. Re-running setup updates content without duplication.

### Cursor Integration

When users run `braingrid setup cursor`, files from `cursor/` are installed:

| Source                    | Destination               |
|---------------------------|---------------------------|
| `cursor/commands/*.md`    | `.cursor/commands/`       |
| `cursor/rules/*.mdc`     | `.cursor/rules/`          |
| `cursor/AGENTS.md`       | Injected into `AGENTS.md` |

### Hook System (Claude Code)

Hooks are triggered by Claude Code lifecycle events:

| Hook Script                         | Trigger         | Purpose                                     |
|-------------------------------------|-----------------|---------------------------------------------|
| `check-stale-build-sentinel.sh`     | SessionStart    | Clean up stale sentinel files               |
| `pre-task-create-naming.sh`         | PreToolUse      | Enforce `TASK N: type: desc` naming          |
| `pre-task-update-instructions.sh`   | PreToolUse      | Validate subject, inject commit guidance     |
| `create-braingrid-task.sh`          | PostToolUse     | Create linked BrainGrid task on TaskCreate   |
| `sync-braingrid-task.sh`            | PostToolUse     | Sync task status on TaskUpdate               |
| `post-task-update-prompt.sh`        | PostToolUse     | Inject auto-continue instructions            |
| `task-completed-validate.sh`        | TaskCompleted   | Require committed changes + commit hash      |
| `verify-acceptance-criteria.sh`     | StopSession     | Block exit until all criteria verified       |

### Build Sentinel System

The `/build` skill creates `.braingrid/temp/build-active.local` to activate hooks. This sentinel file:
- Gates all hook scripts (they skip silently when absent)
- Contains the REQ-ID for the active build session
- Enables multi-build isolation via REQ-prefixed temp files
- Is cleaned up after acceptance criteria verification

---

## Development Workflow

### Making Changes to This Repository

This repo is a template distribution — changes here affect what users get when they run `braingrid setup`. Key considerations:

1. **Test commands/skills as markdown** — verify frontmatter fields are correct and content renders properly
2. **Test shell scripts** — ensure hooks handle edge cases (missing jq, no git branch, empty stdin)
3. **Maintain both integrations** — changes to shared behavior should be reflected in both `claude-code/` and `cursor/`
4. **Update CHANGELOG.md** — follow [Keep a Changelog](https://keepachangelog.com/) format with SemVer
5. **Keep CLAUDE.md and AGENTS.md concise** — these are injected into user projects and should be quick-references

### Error Handling Philosophy

- **Reactive, not preventive** — assume tools are installed; handle errors only when they occur
- **Never block the workflow** — hooks exit 0 on failure (log errors, don't crash)
- **Graceful degradation** — skip operations when context is missing (no REQ in branch, no sentinel file)

### CLI Command Reference (for hooks and commands)

```bash
# Authentication
braingrid login / logout / whoami

# Project management
braingrid init
braingrid project list / show / create / update / delete

# Requirements
braingrid specify --prompt "..."
braingrid requirement list / show / create / update / delete / create-branch / review

# Tasks
braingrid task list -r REQ-ID / show / create / update / delete / summary / specify

# Utility
braingrid status / update / --version / --help
braingrid setup claude-code / cursor [--force] [--dry-run]
```

### Output Formats

- `table` — human-readable (default for lists)
- `json` — machine-readable for scripts and hooks
- `xml` — alternative structured format
- `markdown` — full content with formatting (best for AI agents)

---

## Dependencies

| Tool              | Required By            | Purpose                                      |
|-------------------|------------------------|----------------------------------------------|
| `@braingrid/cli`  | Commands, hooks, skills| Core CLI for all BrainGrid operations        |
| `git`             | Hooks, auto-detection  | Branch parsing, commit validation            |
| `jq`              | All hook scripts       | JSON parsing for stdin/stdout processing     |
| `bash`            | Hooks, statusline      | Shell script execution                       |
| `gh` (GitHub CLI) | `braingrid setup`      | Fetches integration files from GitHub        |

---

## State Files

| File                                          | Purpose                                             |
|-----------------------------------------------|-----------------------------------------------------|
| `.braingrid/project.json`                     | Stores active project ID and metadata               |
| `.braingrid/temp/build-active.local`          | Sentinel activating build hooks during `/build`     |
| `.braingrid/temp/REQ-{id}-requirement.md`     | Cached requirement content for current build        |
| `.braingrid/temp/REQ-{id}-acceptance-criteria.md` | Extracted acceptance criteria (- [] format)      |
| `.braingrid/temp/REQ-{id}-build-verification.local.md` | Verification state for Stop hook enforcement |
| `.braingrid/temp/REQ-{id}-build-debug.log`    | Structured debug logs from hook execution           |

All temp files use the REQ-ID prefix for multi-build isolation and are cleaned up after acceptance criteria verification.

---

## Versioning

- Follows [Semantic Versioning](https://semver.org/) (currently 0.2.x — pre-1.0 rapid development)
- CHANGELOG uses [Keep a Changelog](https://keepachangelog.com/) format with `[Unreleased]` section
- Versions are synced from the main CLI repository; this repo tracks the distribution state
