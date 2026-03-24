## BrainGrid Integration

Spec-driven development in VS Code: turn ideas into AI-ready tasks.

**VS Code Tasks** (`Ctrl+Shift+P` → `Tasks: Run Task`):

| Task | What It Does |
|------|-------------|
| `BrainGrid: Specify` | Create requirement from idea (prompts for input) |
| `BrainGrid: Build` | Fetch full implementation plan |
| `BrainGrid: Breakdown` | Break requirement into tasks |
| `BrainGrid: Requirement List` | List all requirements |
| `BrainGrid: Task List` | List tasks for a requirement |
| `BrainGrid: Status` | Show auth + project context |

**Keyboard Shortcuts** (add to `keybindings.json`):

```json
{ "key": "ctrl+shift+g s", "command": "workbench.action.tasks.runTask", "args": "BrainGrid: Specify" },
{ "key": "ctrl+shift+g b", "command": "workbench.action.tasks.runTask", "args": "BrainGrid: Build" }
```

**Workflow:**

```bash
# In VS Code Task runner:
BrainGrid: Specify → "Add OAuth login"  → REQ-123
BrainGrid: Breakdown → REQ-123          → 6 tasks

# In terminal:
git checkout -b feature/REQ-123-oauth

# In Cline or Continue chat:
/build   # auto-detects REQ-123 from branch
```

**AI Extensions:**

- **Cline** — reads `.clinerules` automatically for BrainGrid context
- **Continue** — use `/specify`, `/breakdown`, `/build` slash commands

**Auto-detection:** Project from `.braingrid/project.json`, requirement from branch (`feature/REQ-123-*`).

**Full documentation:** [.vscode/braingrid-readme.md](./.vscode/braingrid-readme.md)
