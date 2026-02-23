# Search & Filter Patterns

Use for: finding content, narrowing results, faceted navigation.

## Search Types

| Type | Best for | UI |
|------|----------|-----|
| Global search | Finding anything | Header search bar |
| Scoped search | Within current view | Above list/table |
| Command palette | Power users, actions | Keyboard shortcut modal |
| Inline filter | Quick text filter | Filter input in toolbar |

## Search Input

### Placement
- Global: Header, always visible or icon-triggered
- Scoped: Above content, labeled "Search [items]"
- Don't bury search—if users need it, make it prominent

### Behavior
```
┌──────────────────────────────┐
│ 🔍 Search projects...        │
└──────────────────────────────┘
         ↓ (on focus or type)
┌──────────────────────────────┐
│ 🔍 proj                    ✕ │
├──────────────────────────────┤
│ Recent searches              │
│ • project alpha              │
│ • project beta               │
├──────────────────────────────┤
│ Suggestions                  │
│ • Projects (12)              │
│ • Project settings           │
└──────────────────────────────┘
```

### Features
- Clear button (X) when input has text
- Search on type (debounced 300ms) or on enter
- Show recent searches on focus
- Autocomplete/suggestions while typing

## Filter Patterns

### Filter placement

| Pattern | When to use |
|---------|-------------|
| Inline chips | Few, frequently-used filters |
| Dropdown menus | Moderate options, categorized |
| Filter panel/sidebar | Many facets, complex criteria |
| Modal | Complex filters, infrequent use |

### Filter chips
```
All  Active  Archived  │ + Add filter
```
- Selected state visually distinct
- Mutually exclusive = radio behavior
- Can combine = multi-select

### Faceted filters
```
Status ▾     │  Date ▾      │  Owner ▾
├─ ☑ Active  │  ○ Any time  │  ☑ Me
├─ ☐ Pending │  ○ Today     │  ☐ Team
└─ ☐ Closed  │  ○ This week │  ☐ Anyone
```
- Show count per option: "Active (24)"
- Update counts as filters change
- Hide zero-result options or gray them out

## Active Filter Display

Always show currently active filters:
```
Showing: Active • This week • Assigned to me   [Clear all]
```
- Each filter removable individually (X)
- "Clear all" for quick reset
- Persist in URL for shareability

## No Results Handling

### With search term
```
No results for "xyzzy"

Suggestions:
• Check your spelling
• Try broader search terms
• Remove some filters
```

### With filters applied
```
No projects match your filters

Active filters: Archived • Last year

[Clear filters] to see all 47 projects
```

## Search Results

### Result structure
- Highlight matching text in results
- Show context around match
- Group by type for global search
- Most relevant first

### Result actions
- Click → navigate to item
- Keyboard: ↑↓ to navigate, Enter to select
- Show result count: "12 results"

## Command Palette Pattern

For keyboard-centric interfaces:
```
┌────────────────────────────────────┐
│ 🔍 Type a command or search...     │
├────────────────────────────────────┤
│ Recent                             │
│   • Open settings          ⌘ ,    │
│   • New project            ⌘ N    │
├────────────────────────────────────┤
│ Actions                            │
│   • Create new...                  │
│   • Import data                    │
│   • Export...                      │
└────────────────────────────────────┘
```
- Trigger: Cmd+K or Ctrl+K
- Mix navigation + actions
- Show keyboard shortcuts

## Performance

- Debounce search input (300ms typical)
- Show loading indicator for slow searches
- Cancel previous request on new input
- Cache recent results

## Bad Examples

**Don't**: Require exact match
**Do**: Fuzzy matching, typo tolerance

**Don't**: Clear filters when searching
**Do**: Combine search with active filters

**Don't**: Show empty filter options (count: 0)
**Do**: Hide or disable options that would yield no results

**Don't**: Search button without search-on-type
**Do**: Instant results as user types
