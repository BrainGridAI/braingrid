# Multi-Step Flow Patterns (Wizards)

Use for: onboarding, checkout, complex form submissions, setup flows.

## Core Rules

1. **One decision per step** - Don't ask user to process multiple unrelated choices
2. **Show progress** - User must know where they are and how much remains
3. **Preserve progress** - Never lose entered data on navigation
4. **Allow back navigation** - User can revisit any completed step
5. **Summarize before commit** - Show review step for consequential actions

## Progress Indicators

### When to use each:

| Pattern | Best for | Avoid when |
|---------|----------|------------|
| Step numbers (1/4) | Fixed, known steps | Steps vary by input |
| Progress bar | Linear progress | Non-linear flows |
| Checklist | Tasks in any order | Strict sequence required |
| Breadcrumb trail | Named stages | Many small steps |

### Progress indicator placement
- Top of screen, sticky if content scrolls
- Show completed, current, and remaining
- Allow click on completed steps to navigate back

## Step Structure

```
┌─────────────────────────────────────┐
│ Progress: ● ● ○ ○                   │
│ Step 2 of 4: Choose your plan      │
├─────────────────────────────────────┤
│                                     │
│ [Step content - single decision]    │
│                                     │
├─────────────────────────────────────┤
│ [← Back]              [Continue →]  │
└─────────────────────────────────────┘
```

## Navigation Buttons

- **Primary action** (right): "Continue", "Next", or step-specific ("Choose Plan")
- **Secondary action** (left): "Back" or "Previous"
- **Escape hatch**: "Save & Exit" or "Cancel" (with confirmation)
- Disable "Continue" until step is complete

## Conditional Steps

When steps depend on previous choices:
- Update progress indicator to reflect actual remaining steps
- Don't show skipped steps in progress
- Alternatively: show steps but mark as "not applicable"

## Data Persistence

- Save after each step completion
- If user abandons: offer to resume on return
- For sensitive data: auto-save to draft, explicit submit for final

## Validation

- Validate on blur for individual fields
- Validate on "Continue" for step as a whole
- Don't allow progression with errors
- Scroll to first error, focus the field

## Review/Confirmation Step

Required before any action that:
- Costs money
- Is difficult to reverse
- Affects other users
- Triggers external systems

Review step shows:
- Summary of all choices made
- Editable links to change individual sections
- Clear primary action: "Confirm", "Place Order", "Submit"

## Bad Examples

**Don't**: Ask for shipping AND billing AND payment in one step
**Do**: Separate into Shipping → Billing → Payment → Review

**Don't**: Linear progress bar when some steps may be skipped
**Do**: Checklist showing applicable steps only

**Don't**: "Next" button with no indication of remaining steps
**Do**: "Continue to Payment (Step 3 of 4)"

## Mobile Considerations

- Full-screen steps, no side content
- Large touch targets for back/next
- Show keyboard-appropriate input types
- Consider swipe for back navigation
