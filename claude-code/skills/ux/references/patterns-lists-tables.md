# List & Table Patterns

Use for: displaying collections, data grids, item management.

## Choosing List vs Table

| Use List when | Use Table when |
|---------------|----------------|
| Items have varied content | Items have uniform attributes |
| Visual presentation matters | Data comparison matters |
| Few attributes per item | Many attributes per item |
| Mobile-first design | Desktop data work |

## List Patterns

### Basic list item structure
```
┌─────────────────────────────────────┐
│ [Icon] Primary text                 │
│        Secondary text        [Action]│
└─────────────────────────────────────┘
```

### List item components
- **Leading**: Avatar, icon, checkbox, thumbnail
- **Primary text**: Main identifier (name, title)
- **Secondary text**: Supporting info (date, status, excerpt)
- **Trailing**: Action button, chevron, metadata

### Interaction patterns
| Affordance | Indicates |
|------------|-----------|
| Chevron `>` | Navigate to detail |
| Checkbox | Multi-select for bulk actions |
| Action button | Inline action |
| No affordance | Tap entire row for detail |

### Grouping
- **Alphabetical**: A-Z headers with sticky behavior
- **Chronological**: Today, Yesterday, This Week
- **Categorical**: By status, type, or custom attribute
- Show group header counts: "Pending (12)"

## Table Patterns

### Column design
- Left-align text, right-align numbers
- First column: primary identifier (linkable)
- Last column: actions (if any)
- Hide less important columns on smaller screens

### Headers
- Sortable columns show sort indicator: `Name ↑`
- Current sort column highlighted
- Click header to toggle sort direction

### Row interactions
| Need | Pattern |
|------|---------|
| View detail | Click row → navigate |
| Edit inline | Double-click cell |
| Select for bulk action | Checkbox column |
| Row-level actions | Actions column (overflow menu) |

### Pagination vs Infinite scroll

| Pagination | Infinite scroll |
|------------|-----------------|
| User needs specific pages | Browsing/discovery |
| SEO important | Single-page app |
| Precise position matters | Volume unknown |
| Data changes between pages | Real-time updates |

Pagination UI:
```
← Previous  1 2 3 ... 10  Next →
Showing 21-40 of 234 results
```

## Bulk Actions

When multi-select enabled:
1. Show selection count: "3 items selected"
2. Reveal bulk action bar
3. Actions: Delete, Export, Move, Tag, etc.
4. "Select all" with "Select all [X] items" for full set

```
┌─────────────────────────────────────┐
│ ☑ 3 selected    [Delete] [Export]  │
├─────────────────────────────────────┤
│ Table/list content...               │
```

## Filtering

- Inline filters above list (chips or dropdown)
- Filter panel for complex criteria
- Show active filter count: "Filters (2)"
- Clear all filters button
- Persist filters in URL for sharing

## Empty State

When no items:
- Explain why empty: "No projects yet"
- Suggest action: "Create your first project"
- Show illustration (optional)
- If filtered with no results: "No matches. Try adjusting filters."

## Loading State

- Skeleton loader matching item structure
- Show 3-5 skeleton items
- Progressive loading: show items as they arrive

## Error State

- Explain what failed: "Couldn't load projects"
- Offer retry: "Try again" button
- If partial failure: show loaded items + error banner

## Bad Examples

**Don't**: Horizontal scroll on tables (mobile)
**Do**: Responsive columns or switch to cards

**Don't**: Delete without confirmation for bulk actions
**Do**: Confirm with item count: "Delete 3 items?"

**Don't**: Pagination that reloads entire page
**Do**: Update list content only, preserve filters

**Don't**: Show "No results" without context
**Do**: "No projects match your filters. Clear filters?"
