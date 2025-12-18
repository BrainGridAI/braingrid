## BrainGrid Integration

Spec-driven development: turn ideas into AI-ready tasks.

**Slash Commands:**

| Command                      | Description                    |
| ---------------------------- | ------------------------------ |
| `/specify [prompt]`          | Create AI-refined requirement  |
| `/breakdown [req-id]`        | Break into tasks               |
| `/build [req-id]`            | Get implementation plan        |
| `/save-requirement [title]`  | Save plan as requirement       |

**Workflow:**

```bash
/specify "Add auth"  # → REQ-123
/breakdown REQ-123   # → tasks
/build REQ-123       # → plan
```

**Auto-detection:** Project from `.braingrid/project.json`, requirement from branch (`feature/REQ-123-*`).

**Full documentation:** [.braingrid/README.md](./.braingrid/README.md)
