# BrainGrid Integration

You are working in a BrainGrid-enabled project. BrainGrid is a spec-driven development tool that turns vague ideas into structured requirements and AI-ready implementation tasks.

## What is BrainGrid

BrainGrid CLI (`@braingrid/cli`) manages three resource types:
- **Projects** — software projects (PROJ-X)
- **Requirements** — detailed specifications refined from ideas (REQ-X)
- **Tasks** — perfectly-prompted, AI-ready implementation steps (TASK-X)

## Core Workflow

```
Vague Idea → braingrid specify → REQ-X → braingrid breakdown → Tasks → Build
```

## When to Suggest BrainGrid

Proactively suggest BrainGrid when the user:
- Has a vague or unstructured feature idea
- Says things like "I want to add...", "I need to build...", "let's implement..."
- Needs to break down a complex feature before coding
- Asks about planning or tracking work

Example response:
> "Let me help you turn that into a structured requirement first. I'll run `braingrid specify` to refine your idea into a detailed spec with acceptance criteria."

## CLI Commands

### Specify a requirement from an idea
```bash
braingrid specify --prompt "Your idea here (10-5000 chars)"
```
Output: Creates REQ-X with full spec including acceptance criteria, implementation notes, and edge cases.

### Break requirement into tasks
```bash
braingrid requirement breakdown REQ-X
```
Output: Creates 5-10 implementation tasks under REQ-X.

### View full build plan
```bash
braingrid requirement show REQ-X --format markdown
```
Output: Full requirement + all task prompts in markdown format.

### List requirements
```bash
braingrid requirement list [--status IDEA|PLANNED|IN_PROGRESS|REVIEW|COMPLETED]
```

### List tasks
```bash
braingrid task list -r REQ-X [--format markdown|json|table]
```

### Update status
```bash
braingrid requirement update REQ-X --status IN_PROGRESS
braingrid task update TASK-X -r REQ-X --status IN_PROGRESS
braingrid task update TASK-X -r REQ-X --status COMPLETED
```

### Check context
```bash
braingrid status   # shows auth, active project, git branch, detected requirement
braingrid whoami   # verify authentication
```

## Auto-Detection

BrainGrid auto-detects context from:
- **Project**: `.braingrid/project.json` in project root
- **Requirement ID**: git branch name patterns
  - `feature/REQ-123-description` → REQ-123
  - `req-456-fix-bug` → REQ-456
  - `123-my-feature` → REQ-123

Once on a feature branch, most commands work without specifying IDs:
```bash
braingrid requirement show          # auto-detects from branch
braingrid task list                 # auto-detects REQ from branch
braingrid requirement update --status IN_PROGRESS
```

## ID Formats

All IDs accept flexible formats:
- `REQ-123` (canonical)
- `req-123` (lowercase)
- `123` (number only)
- Full UUID

## Status Flows

**Requirements:** `IDEA → PLANNED → IN_PROGRESS → REVIEW → COMPLETED` (or `CANCELLED`)

**Tasks:** `PLANNED → IN_PROGRESS → COMPLETED` (or `CANCELLED`)

## Git Branch Workflow

```bash
# 1. Specify the requirement
braingrid specify --prompt "..."
# → Creates REQ-123

# 2. Break it down
braingrid requirement breakdown REQ-123
# → Creates tasks

# 3. Create feature branch (enables auto-detection)
git checkout -b feature/REQ-123-description

# 4. Now commands auto-detect REQ-123
braingrid requirement show --format markdown
braingrid task list
```

## Error Handling

Handle errors reactively (don't check upfront):
- `command not found` → `npm install -g @braingrid/cli`
- auth error → `braingrid login`
- project not found → `braingrid init`

## Output Formats

- `table` — human-readable (default for lists)
- `json` — machine-readable for scripts
- `markdown` — full content with formatting (best for AI agents)

## Best Practices

1. **Specify before coding** — always create a requirement before jumping into implementation
2. **Use markdown format** for AI-ready task prompts: `--format markdown`
3. **Keep branch names aligned** — `feature/REQ-X-description` for auto-detection
4. **Update statuses** — mark tasks IN_PROGRESS when starting, COMPLETED when done
5. **Re-read the plan** — `braingrid requirement show REQ-X --format markdown` anytime you need context
