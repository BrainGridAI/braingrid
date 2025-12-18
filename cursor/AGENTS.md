<!-- BEGIN BRAINGRID INTEGRATION -->

## BrainGrid Integration

Spec-driven development: turn ideas into AI-ready tasks.

**Key Commands:**

| Command                                | Description                   |
| -------------------------------------- | ----------------------------- |
| `braingrid specify --prompt "idea"`    | Create AI-refined requirement |
| `braingrid requirement breakdown REQ-X`| Break into tasks              |
| `braingrid requirement build REQ-X`    | Get implementation plan       |

**Workflow:**

```bash
braingrid specify --prompt "Add auth"  # → REQ-123
braingrid requirement breakdown REQ-123 # → tasks
braingrid requirement build REQ-123     # → plan
```

**Auto-detection:** Project from `.braingrid/project.json`, requirement from branch (`feature/REQ-123-*`).

**Full documentation:** [.braingrid/README.md](./.braingrid/README.md)

<!-- END BRAINGRID INTEGRATION -->
