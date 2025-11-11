## Working with Specs, Requirements, and Tasks in BrainGrid

BrainGrid turns vague ideas into structured specifications and AI-ready tasks.

**Core Resources:** Projects → Requirements (specs) → Tasks (AI-generated prompts for coding agents)

**Slash Commands:**

- `/specify [prompt]` - Create AI-refined requirement from vague idea
- `/save-requirement [title]` - Save detailed plan as requirement
- `/breakdown [req-id]` - Break requirement into perfectly-prompted tasks (ready for coding agents)
- `/build [req-id]` - Get complete implementation plan (markdown format)

Invoke `braingrid-cli` skill for detailed guidance.

### Workflow

```bash
/specify "Add user auth with OAuth2"     # → REQ-123
/breakdown REQ-123                        # → 5-10 tasks
/build REQ-123                            # → markdown plan
git checkout -b feature/REQ-123-auth      # enables auto-detection
braingrid task update TASK-X --status COMPLETED
```

### Key Features

- **Auto-detection:** Project from `.braingrid/project.json`, requirement ID from branch names (`feature/REQ-123-*`)
- **Reactive errors:** Run commands directly, handle issues only when they occur
- **Status flows:** Requirements (IDEA → PLANNED → IN_PROGRESS → COMPLETED), Tasks (PLANNED → IN_PROGRESS → COMPLETED)
- **Output formats:** `table` (default), `json`, `xml`, `markdown` (use for AI agents)

### When to Use

Suggest BrainGrid when users have vague ideas, plan complex features, or need structured task breakdowns.

### Setup

```bash
npm install -g @braingrid/cli    # Install CLI
braingrid login                   # Authenticate (OAuth2)
braingrid init                    # Link project
```
