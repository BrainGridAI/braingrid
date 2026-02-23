# CLI UX Patterns

Use for: terminal interfaces, command-line tools, developer tools.

## Command Structure

### Standard pattern
```
tool <command> [subcommand] [arguments] [--flags]
```

Examples:
```
git commit -m "message"
npm install react --save
kubectl get pods --namespace=prod
```

### Command hierarchy
```
tool                    → Show help/usage
tool help              → Detailed help
tool <command>          → Run command
tool <command> --help   → Command-specific help
```

## Input Patterns

### Arguments vs flags

| Type | Use for | Example |
|------|---------|---------|
| Positional args | Required, common inputs | `git add file.txt` |
| Flags (--name) | Options, modifiers | `--verbose`, `--output=file` |
| Short flags (-n) | Frequent options | `-v`, `-o file` |

### Flag conventions
- Boolean: `--verbose` (presence = true)
- Value: `--output=file` or `--output file`
- Short: `-v`, `-o file`
- Combined short: `-vf` (verbose + force)

### Smart defaults
- Most common action requires fewest args
- Sensible defaults for all optional flags
- Allow overrides for advanced use

```
# Minimal (defaults applied)
deploy

# Explicit (override defaults)
deploy --env=staging --dry-run
```

## Output Patterns

### Progressive output
For long operations, show progress:
```
Deploying application...
  ✓ Building image
  ✓ Pushing to registry
  → Running migrations
  ○ Starting containers
```
- Checkmark for complete
- Arrow for in-progress
- Circle for pending

### Structured output
Default: human-readable
```
NAME          STATUS    AGE
frontend      Running   2h
backend       Running   2h
```

Machine-readable option:
```
tool list --json
tool list --output=yaml
```

### Verbosity levels
```
tool command           → Normal output
tool command -v        → Verbose
tool command -vv       → Very verbose (debug)
tool command -q        → Quiet (errors only)
```

## Feedback Patterns

### Success
```
✓ Deployment complete
  URL: https://app.example.com
```
- Clear success indicator
- Relevant next-step info

### Error
```
Error: Invalid configuration file

  → config.yaml line 12: unexpected key 'databse'
    Did you mean 'database'?

Run 'tool validate' to check your config
```
- Clear error label
- Specific location/cause
- Suggest fix
- Provide recovery command

### Warning
```
Warning: API key expires in 3 days
  Run 'tool auth refresh' to renew
```
- Non-blocking, operation continues
- Actionable suggestion

## Interactive Patterns

### Confirmation prompts
```
This will delete 47 files. Continue? [y/N]
```
- Default in brackets (N = default no)
- Capital letter = default
- Require explicit y/yes for destructive

### Selection prompts
```
Select environment:
  > production
    staging
    development
```
- Arrow keys to navigate
- Enter to select
- Type to filter (optional)

### Input prompts
```
Enter project name: my-project
Enter description (optional):
```
- Show required vs optional
- Validate inline when possible

### Non-interactive mode
```
tool deploy --yes          # Skip confirmations
tool deploy --no-input     # Fail if input needed
```
- CI/CD must work non-interactively
- `--yes` or `-y` to auto-confirm
- Fail clearly if interaction required

## Help Patterns

### Command help
```
Usage: tool deploy [options] <target>

Deploy application to target environment

Arguments:
  target              Deployment target (prod|staging|dev)

Options:
  -e, --env <name>    Environment name
  -d, --dry-run       Preview without executing
  -v, --verbose       Show detailed output
  -h, --help          Show this help

Examples:
  tool deploy prod
  tool deploy staging --dry-run
```

Structure:
1. Usage line
2. Description
3. Arguments
4. Options (short, long, description)
5. Examples

### Discoverability
```
tool --help             → All commands
tool <command> --help   → Command details
tool help <command>     → Same as above
tool commands           → List all commands
```

## Error Handling

### Validation errors
Catch before execution:
```
Error: Missing required flag --target

Usage: tool deploy --target=<env>

Run 'tool deploy --help' for more information
```

### Runtime errors
```
Error: Connection refused to database

Troubleshooting:
  1. Check if database is running
  2. Verify DATABASE_URL is correct
  3. Check network/firewall settings

See: https://docs.example.com/troubleshooting
```

### Exit codes
| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Invalid usage/args |
| 130 | Interrupted (Ctrl+C) |

## Bad Examples

**Don't**: Wall of text with no structure
**Do**: Formatted tables, sections, progress

**Don't**: Silent failure (exit 0 with no output on error)
**Do**: Clear error message + non-zero exit

**Don't**: Require flags for common operations
**Do**: Smart defaults, flags for overrides

**Don't**: `--no-dry-run` (double negative)
**Do**: `--dry-run` (opt-in) or `--execute` (opt-in)

**Don't**: Interactive prompts with no --yes flag
**Do**: Support non-interactive mode for CI/CD
