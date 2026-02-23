# Form Patterns

Use for: data entry, settings, user input collection.

## Core Rules

1. **Minimal fields** - Only ask for what's needed now
2. **Logical grouping** - Related fields together, clear sections
3. **Smart defaults** - Pre-fill when possible
4. **Inline validation** - Immediate feedback on errors
5. **Preserve input** - Never clear valid data on error

## Field Organization

### Single column preferred
- Faster completion than multi-column
- Exception: closely related short fields (city/state/zip)

### Group related fields
```
Personal Information
├── Name
├── Email
└── Phone

Shipping Address
├── Street
├── City
├── State/Zip
└── Country
```

### Progressive disclosure
- Show optional fields behind "Add more details" link
- Collapse advanced settings by default

## Field Types Selection

| Data | Use | Avoid |
|------|-----|-------|
| Short text (<50 chars) | Single-line input | Textarea |
| Long text | Textarea | Single-line |
| Date | Date picker | Free text |
| Yes/No | Toggle or checkbox | Dropdown |
| One of few (<5) | Radio buttons | Dropdown |
| One of many (>5) | Dropdown or search | Radio buttons |
| Multiple of few | Checkboxes | Multi-select |
| Multiple of many | Multi-select with search | Checkboxes |

## Labels & Placeholders

- **Labels**: Always visible, above or left of field
- **Placeholders**: Format hints only, never essential info
- **Help text**: Below field for complex requirements

```
Email address              ← Label
┌──────────────────────┐
│ name@example.com     │   ← Placeholder (format hint)
└──────────────────────┘
We'll send a confirmation   ← Help text
```

## Validation

### Timing
| Validation type | When to validate |
|-----------------|------------------|
| Format (email, phone) | On blur |
| Required field | On submit |
| Cross-field (password match) | When dependent field changes |
| Server-side (unique email) | On blur + on submit |

### Error display
- Inline, immediately below the field
- Red border on field
- Icon + message: "✗ Email already registered"
- Focus first error field on submit

### Success indication
- Subtle green check on valid field (optional)
- Don't overdo—too much green is distracting

## Submit States

1. **Default**: "Save", "Submit", "Create [Object]"
2. **Submitting**: Disable button, show spinner, "Saving..."
3. **Success**: Brief confirmation, then navigate or reset
4. **Error**: Restore button, show error summary + inline errors

## Required vs Optional

- Mark required fields OR mark optional fields—not both
- If most fields required: mark optional with "(optional)"
- If most fields optional: mark required with "*"

## Autosave vs Explicit Save

| Use autosave when | Use explicit save when |
|-------------------|------------------------|
| Drafts, notes | Transactions, settings |
| Collaboration | Data integrity critical |
| Long forms | User expects control |

Autosave UI:
- "Saving..." → "Saved" indicator
- "Last saved 2 min ago"
- No submit button needed

## Bad Examples

**Don't**: Clear entire form when one field fails validation
**Do**: Preserve all input, highlight only invalid fields

**Don't**: Use dropdown for yes/no question
**Do**: Use toggle or radio buttons

**Don't**: Placeholder text as the only label
**Do**: Visible label above field, placeholder for format hint

**Don't**: Validate on every keystroke (jumpy UI)
**Do**: Validate on blur or after typing pause

## Accessibility

- Associate labels with inputs (`for`/`id`)
- Error messages linked via `aria-describedby`
- Focus management on error
- Keyboard navigation: Tab through fields
