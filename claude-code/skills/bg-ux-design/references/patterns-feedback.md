# Feedback Patterns

Use for: loading states, success/error messages, progress indication.

## Feedback Timing

| Response time | User perception | Feedback needed |
|---------------|-----------------|-----------------|
| <100ms | Instant | None |
| 100ms-1s | Noticeable | Subtle indicator |
| 1s-10s | Waiting | Progress indicator |
| >10s | Long wait | Progress + explanation |

## Loading Patterns

### Spinner
- Use for: brief, indeterminate waits (1-5s)
- Placement: replace content area or inline with action
- Don't: cover entire page for small loads

### Skeleton screens
- Use for: content loading, known structure
- Shows layout shape before content arrives
- Better than spinner for content-heavy pages

```
┌─────────────────────────────────────┐
│ ████████████                        │  ← Title placeholder
│ ████████████████████████            │  ← Subtitle placeholder
├─────────────────────────────────────┤
│ ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │  ← Content placeholder
│ ░░░░░░░░░░░░░░░░░░░░░░░░░           │
└─────────────────────────────────────┘
```

### Progress bar
- Use for: determinate progress, file uploads, multi-step ops
- Show percentage if known
- Indeterminate bar (animated) if unknown

### Progress with steps
```
Processing data...
Step 2 of 4: Validating records
████████████░░░░░░░░ 60%
```

## Success Feedback

### Inline confirmation
- Brief message near action: "Saved" ✓
- Auto-dismiss after 3-5 seconds
- Non-blocking, user can continue

### Toast/snackbar
```
┌─────────────────────────────────────┐
│ ✓ Project created successfully      │
│                              [View] │
└─────────────────────────────────────┘
```
- Bottom or top of screen
- Auto-dismiss (5-10s) or dismissible
- Optional action link

### Success page
- Use for: significant completions (checkout, signup)
- Summarize what happened
- Clear next steps
- Don't dead-end—provide navigation

## Error Feedback

### Inline errors
- Placement: immediately below failed field/action
- Timing: on blur or submit
- Content: what went wrong + how to fix

```
Email address
┌──────────────────────────────┐
│ invalid@                     │
└──────────────────────────────┘
✗ Please enter a valid email address
```

### Error summary
- For multiple errors: list at top of form
- Link to each error field
- Count: "Please fix 3 errors below"

### Error toast
- For non-field errors: network, server issues
- Dismissible
- Include retry action if applicable

```
┌─────────────────────────────────────┐
│ ✗ Couldn't save. Check connection   │
│                             [Retry] │
└─────────────────────────────────────┘
```

### Error page
- For fatal errors: 404, 500, no permission
- Explain simply: "Page not found"
- Suggest actions: search, go home, contact support
- Don't show technical details to users

## Confirmation Patterns

### When to confirm
- Destructive actions (delete, remove)
- Irreversible actions (send, publish)
- High-impact changes (bulk updates)
- NOT for routine saves—just show success

### Confirmation dialog
```
┌─────────────────────────────────────┐
│ Delete project?                     │
│                                     │
│ This will permanently delete        │
│ "Project Alpha" and all its data.   │
│ This cannot be undone.              │
│                                     │
│            [Cancel]  [Delete]       │
└─────────────────────────────────────┘
```
- Clear title stating action
- Explain consequences
- Cancel = safe option (left)
- Confirm = dangerous (right, styled as danger)

### Soft delete / Undo
- Better than confirmation for reversible actions
- "Item deleted. [Undo]"
- Undo available for 10-30 seconds
- Actually deletes after timeout

## Progress Communication

### Operation status
- Starting: "Starting export..."
- In progress: "Exporting records (45%)..."
- Almost done: "Finishing up..."
- Complete: "Export complete. [Download]"

### Background operations
- Toast: "Export started. We'll notify you when ready."
- Status indicator in nav/header for ongoing ops
- Email/notification when complete

## Bad Examples

**Don't**: Spinner for 30+ second operations
**Do**: Progress bar with status updates

**Don't**: Silent success (user unsure if action worked)
**Do**: Brief confirmation message

**Don't**: Generic "An error occurred"
**Do**: Specific error + recovery action

**Don't**: Confirmation dialog for every delete
**Do**: Soft delete with undo for reversible actions

**Don't**: Modal spinner blocking entire page
**Do**: Loading indicator scoped to loading content
