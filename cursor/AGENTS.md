# BrainGrid: Spec-Driven Development

BrainGrid turns vague ideas into structured specifications and AI-ready tasks for building well-structured, maintainable software with AI coding agents.

## Core Workflow

**Resources:** Projects → Requirements (specs) → Tasks (AI-generated prompts for coding agents)

**Typical Flow:**
1. Create AI-refined requirement from idea: `braingrid requirement specify "<prompt>"`
2. Break down into tasks: `braingrid requirement breakdown REQ-123`
3. Get implementation plan: `braingrid requirement build REQ-123`
4. Create feature branch: `git checkout -b feature/REQ-123-description`
5. Update task status as you work: `braingrid task update TASK-X -r REQ-123 --status COMPLETED`

## Installation and Setup

```bash
# Install CLI globally
npm install -g @braingrid/cli

# Authenticate (opens OAuth2 flow in browser)
braingrid login

# Verify authentication
braingrid whoami

# Initialize project (links repository to BrainGrid project)
braingrid init
```

After initialization, a `.braingrid/project.json` file is created to track the active project. The CLI automatically detects project context from this file.

## Key Features

### Auto-Detection
- **Project**: Reads from `.braingrid/project.json` when present
- **Requirement ID**: Parses git branch names for requirement IDs
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
- `table` - Quick human-readable view (default for lists)
- `json` - Machine-readable for scripts
- `xml` - Alternative structured format
- `markdown` - Full content with formatting (best for AI agents)

Example: `braingrid task list -r REQ-1 --format markdown`

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

## Common Commands

### Authentication
```bash
braingrid login              # OAuth2 login
braingrid whoami            # Show current user
braingrid logout            # Sign out
```

### Project Management
```bash
# List all projects
braingrid project list

# Show current project (from .braingrid/project.json)
braingrid project show

# Show specific project
braingrid project show PROJ-123

# Create project
braingrid project create --name "Project Name"
```

### Requirement Management

#### Create Requirements
```bash
# Create AI-refined requirement from prompt (specify command)
braingrid requirement specify --prompt "Add user authentication with OAuth2"

# Create manual requirement
braingrid requirement create --name "Feature Name" --content "Description"
```

#### List and View Requirements
```bash
# List all requirements
braingrid requirement list

# List by status
braingrid requirement list --status PLANNED
braingrid requirement list --status IN_PROGRESS

# Show specific requirement
braingrid requirement show REQ-123

# Show with auto-detection from git branch
braingrid requirement show
```

#### Update Requirements
```bash
# Update status
braingrid requirement update REQ-123 --status IN_PROGRESS
braingrid requirement update REQ-123 --status COMPLETED

# Update name or content
braingrid requirement update REQ-123 --name "New Name"
```

#### Break Down and Build
```bash
# Break requirement into AI-generated tasks
braingrid requirement breakdown REQ-123

# Use verbose mode to see task generation progress
braingrid requirement breakdown REQ-123 --verbose

# Build complete implementation plan
braingrid requirement build REQ-123
braingrid requirement build REQ-123 --format markdown
braingrid requirement build REQ-123 --format json
```

### Task Management
```bash
# List tasks for requirement
braingrid task list -r REQ-123
braingrid task list -r REQ-123 --format markdown
braingrid task list -r REQ-123 --verbose

# Show specific task
braingrid task show TASK-789 -r REQ-123

# Update task status
braingrid task update TASK-789 -r REQ-123 --status IN_PROGRESS
braingrid task update TASK-789 -r REQ-123 --status COMPLETED

# Create manual task
braingrid task create -r REQ-123 --title "Task Title" --content "Description"
```

### Utility Commands
```bash
braingrid status         # Show CLI status (auth, git, config)
braingrid update         # Update to latest version
braingrid --version      # Show current version
braingrid --help         # Show help
```

## End-to-End Workflow Examples

### Starting a New Feature

```bash
# 1. Initialize project (if not done)
braingrid init

# 2. Create specification from a brief prompt
braingrid requirement specify --prompt "Implement dark mode toggle in settings with theme persistence"

# Output: ✅ Created requirement REQ-234

# 3. Break down into tasks (AI-powered)
braingrid requirement breakdown REQ-234 --verbose

# Output: ✅ Created 6 tasks for REQ-234

# 4. Create git branch (enables auto-detection)
git checkout -b feature/REQ-234-dark-mode

# 5. Get build plan with all task details
braingrid requirement build REQ-234 --format markdown

# 6. Start working and update statuses
braingrid requirement update REQ-234 --status IN_PROGRESS
braingrid task update TASK-1 -r REQ-234 --status IN_PROGRESS

# ... implement the task ...

braingrid task update TASK-1 -r REQ-234 --status COMPLETED
```

### Working on Existing Requirements

```bash
# Check current status
braingrid status

# List requirements in progress
braingrid requirement list --status IN_PROGRESS

# View specific requirement
braingrid requirement show REQ-456

# List tasks with full details
braingrid task list -r REQ-456 --verbose

# Update requirement status
braingrid requirement update REQ-456 --status REVIEW
```

### Using Auto-Detection

```bash
# Create git branch with requirement ID
git checkout -b feature/REQ-789-api-integration

# Commands auto-detect REQ-789 from branch name
braingrid requirement show          # Shows REQ-789
braingrid task list --verbose        # Lists tasks for REQ-789
braingrid requirement build          # Builds REQ-789
```

## Writing Effective Specification Prompts

Good prompts for `braingrid requirement specify` include:

- **Problem statement**: What needs solving?
- **Context**: Why is this needed?
- **Constraints**: Technical limitations
- **Users**: Who will use this?
- **Success criteria**: What does "done" look like?

**Example:**
```bash
braingrid requirement specify --prompt "Add real-time collaboration to document editor. \
Users should see others' cursors and edits instantly. We use WebSockets already for chat. \
Must support 50+ concurrent users per document. Success means <200ms latency for cursor \
updates and no conflicts in concurrent edits."
```

## When to Use BrainGrid

Suggest BrainGrid when users:
- Have vague or unstructured project ideas
- Need to break down complex features
- Want consistent task prompts for AI coding tools
- Are starting new projects or features
- Need to track requirement progress
- Want AI-powered requirement refinement

## Best Practices

### Git Branch Workflow
1. Create requirement: `braingrid requirement specify --prompt "..."`
2. Create branch: `git checkout -b feature/REQ-123-description`
3. Work on tasks: Commands auto-detect `REQ-123` from branch name
4. Update status: `braingrid requirement update --status IN_PROGRESS`
5. Complete: `braingrid requirement update --status REVIEW`

### Reactive Error Handling
- Run commands directly - assume CLI is installed and user is authenticated
- Handle errors reactively when they occur
- **CLI not installed**: Guide user to `npm install -g @braingrid/cli`
- **Not authenticated**: Guide user through `braingrid login`
- **No project**: Guide user to run `braingrid init`

### Task Status Updates
- Mark tasks as IN_PROGRESS before starting work
- Update to COMPLETED immediately after finishing
- Use CANCELLED for tasks that are no longer relevant
- Keep requirement status in sync with task progress

### Output Format Selection
- Use `--format markdown` for AI agents and detailed content
- Use `--format json` for scripting and automation
- Use `--format table` (default) for quick human-readable views
- Use `--verbose` with task lists to see full task content

## Links and Resources

- **CLI Documentation**: https://braingrid.ai
- **GitHub Repository**: https://github.com/BrainGridAI/braingrid
- **NPM Package**: https://www.npmjs.com/package/@braingrid/cli
- **Web App**: https://app.braingrid.ai

## Command Reference Quick Guide

| Operation | Command |
|-----------|---------|
| Install CLI | `npm install -g @braingrid/cli` |
| Authenticate | `braingrid login` |
| Initialize project | `braingrid init` |
| Create requirement | `braingrid requirement specify --prompt "idea"` |
| Break into tasks | `braingrid requirement breakdown REQ-X` |
| Get build plan | `braingrid requirement build REQ-X --format markdown` |
| List requirements | `braingrid requirement list` |
| Show requirement | `braingrid requirement show REQ-X` |
| Update requirement | `braingrid requirement update REQ-X --status IN_PROGRESS` |
| List tasks | `braingrid task list -r REQ-X --verbose` |
| Update task | `braingrid task update TASK-X -r REQ-X --status COMPLETED` |
| Check status | `braingrid status` |
| Get help | `braingrid --help` |
