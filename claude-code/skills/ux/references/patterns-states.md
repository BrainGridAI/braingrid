# State Patterns

Use for: designing all screen states, handling edge cases.

## The State Matrix

Every screen/component has multiple states. Design all of them:

| State | When | User sees |
|-------|------|-----------|
| Loading | Fetching data | Progress indicator |
| Empty | No data exists | Explanation + action |
| Partial | Some data loaded | Available data + loading |
| Error | Operation failed | Error + recovery |
| Success | Operation completed | Confirmation |
| Ideal | Normal use | Full content |

## Empty States

### First-time empty
User hasn't created anything yet:
```
┌─────────────────────────────────────┐
│                                     │
│            [Illustration]           │
│                                     │
│        No projects yet              │
│                                     │
│   Create your first project to      │
│   start tracking your work.         │
│                                     │
│        [+ Create project]           │
│                                     │
└─────────────────────────────────────┘
```
- Welcoming tone
- Clear benefit statement
- Single, obvious action

### Filtered empty
Search/filters yield no results:
```
┌─────────────────────────────────────┐
│ No projects match "xyzzy"           │
│                                     │
│ Suggestions:                        │
│ • Check your spelling               │
│ • Try different keywords            │
│ • Remove some filters               │
│                                     │
│ [Clear search]                      │
└─────────────────────────────────────┘
```
- State what was searched
- Provide helpful suggestions
- Easy way to clear and try again

### Cleared empty
User deleted/completed everything:
```
┌─────────────────────────────────────┐
│           ✓ All done!               │
│                                     │
│   You've completed all your tasks.  │
│                                     │
│   [+ Add new task]                  │
└─────────────────────────────────────┘
```
- Celebratory/positive tone
- Action to create more

## Loading States

### Initial load
Screen has no content yet:
- Show skeleton matching expected content
- Or centered spinner with message

### Refresh
Content exists, fetching updates:
- Keep showing existing content
- Subtle loading indicator (spinner in header)
- Don't replace content with spinner

### Paginated load
Loading more items:
```
┌─────────────────────────────────────┐
│ Item 1                              │
│ Item 2                              │
│ Item 3                              │
│ ░░░░░░░░░░░░░░░░░░ Loading...      │
└─────────────────────────────────────┘
```
- Spinner at bottom
- Show loading indicator in list
- Don't block interaction with loaded items

## Error States

### Full page error
Entire page failed to load:
```
┌─────────────────────────────────────┐
│                                     │
│         Something went wrong        │
│                                     │
│    We couldn't load this page.      │
│    This might be a temporary issue. │
│                                     │
│    [Try again]    [Go home]         │
│                                     │
└─────────────────────────────────────┘
```
- Simple, non-technical language
- Suggest it's temporary (if appropriate)
- Offer retry + escape route

### Partial error
Some content failed:
```
┌─────────────────────────────────────┐
│ ✗ Couldn't load recent activity     │
│                           [Retry]   │
├─────────────────────────────────────┤
│ [Rest of page content loads fine]   │
└─────────────────────────────────────┘
```
- Don't break entire page for one section
- Show error in failed section only
- Allow retry of just that section

### Action error
User action failed:
- Show error near the action
- Preserve user input
- Explain what went wrong
- Suggest fix or retry

## Permission States

### No access
User lacks permission:
```
┌─────────────────────────────────────┐
│          Access restricted          │
│                                     │
│   You don't have permission to      │
│   view this project.                │
│                                     │
│   [Request access]  [Go back]       │
└─────────────────────────────────────┘
```
- Clear explanation
- Action to request access (if applicable)
- Way to navigate away

### Logged out
Session expired or not logged in:
- Redirect to login
- Preserve intended destination
- After login, return to original page

## Disabled States

### Disabled controls
When action unavailable:
- Visually dimmed
- Tooltip explaining why disabled
- "Complete profile to enable posting"

### Read-only mode
Viewing without edit permission:
- Hide edit controls, don't disable them
- Or show "Read-only" indicator
- Don't confuse with broken UI

## Offline States

### Full offline
No connection:
```
┌─────────────────────────────────────┐
│         📴 You're offline           │
│                                     │
│   Some features need internet.      │
│   We'll sync when you reconnect.    │
└─────────────────────────────────────┘
```

### Partial offline
Some actions queued:
- Show pending indicator
- "Will send when online"
- Allow canceling queued actions

## Bad Examples

**Don't**: Blank screen while loading
**Do**: Skeleton or spinner with context

**Don't**: Generic "Error" with no context
**Do**: Specific error with recovery action

**Don't**: Empty list with no explanation
**Do**: Empty state with reason + action

**Don't**: Disabled button with no explanation
**Do**: Tooltip or text explaining why disabled
