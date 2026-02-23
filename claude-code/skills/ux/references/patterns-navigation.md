# Navigation Patterns

Use for: moving between screens, hierarchical structure, wayfinding.

## Navigation Types

| Type | Use for | Location |
|------|---------|----------|
| Global nav | Top-level sections | Header/sidebar |
| Local nav | Within a section | Sidebar/tabs |
| Breadcrumbs | Hierarchical location | Below header |
| Tabs | Parallel views | Content area |
| Bottom nav | Mobile primary nav | Footer (mobile) |

## Global Navigation

### Header nav (horizontal)
```
┌─────────────────────────────────────────────┐
│ Logo   Dashboard  Projects  Settings    [U] │
├─────────────────────────────────────────────┤
│ Page content...                             │
```
- Max 5-7 items
- Current section highlighted
- User menu/avatar on right
- Logo links to home

### Sidebar nav (vertical)
```
┌────────┬────────────────────────────┐
│ Logo   │                            │
├────────┤                            │
│ 📊 Dash│  Page content...           │
│ 📁 Proj│                            │
│ ⚙ Sett │                            │
│        │                            │
│ [User] │                            │
└────────┴────────────────────────────┘
```
- Collapsible (icons only) for more content space
- Nested items for hierarchy
- User/settings at bottom
- Can support more items than header

## Local Navigation

### Tabs
```
┌──────────────────────────────────────┐
│ [Overview] [Activity] [Settings]     │
├──────────────────────────────────────┤
│ Tab content...                       │
```
- Max 5-7 tabs
- Active tab visually distinct
- Don't use for sequential steps (use wizard)
- Content changes without page navigation

### Secondary sidebar
For complex sections with many sub-pages:
```
┌────────┬─────────────┬───────────────┐
│ Global │ Section nav │ Page content  │
│  nav   │ • Overview  │               │
│        │ • Members   │               │
│        │ • Settings  │               │
└────────┴─────────────┴───────────────┘
```

## Breadcrumbs

Show hierarchical path:
```
Home > Projects > Project Alpha > Settings
```
- Each level clickable except current
- Use for 3+ levels of hierarchy
- Don't duplicate with page title
- Mobile: show only parent link "← Projects"

## Mobile Navigation

### Bottom navigation
```
┌─────────────────────────────────────┐
│                                     │
│          Page content               │
│                                     │
├─────────────────────────────────────┤
│  🏠    📁    ➕    🔔    👤         │
│ Home  Proj  New  Notif  Profile    │
└─────────────────────────────────────┘
```
- 3-5 items max
- Icons + labels
- Center item for primary action (optional)
- Current item highlighted

### Hamburger menu
- Use only when items don't fit bottom nav
- Icon in header, opens overlay/drawer
- Full navigation list with nested sections

## URL Design

URLs should reflect navigation hierarchy:
```
/projects                    → Projects list
/projects/123               → Project detail
/projects/123/settings      → Project settings
/projects/123/members       → Project members
```

Benefits:
- Shareable, bookmarkable
- Browser back/forward works
- User knows where they are

## Navigation State

### Current location
- Always indicate where user is
- Active item in nav highlighted
- Breadcrumbs for deep hierarchy
- Page title matches nav item

### History
- Browser back should work
- Preserve filter/scroll state when returning
- Don't break back button with redirects

## Deep Linking

Support direct navigation to:
- Specific items: `/projects/123`
- Filtered views: `/projects?status=active`
- Specific tabs: `/projects/123#members`
- Modal states: `/projects/123/edit`

## Bad Examples

**Don't**: Hamburger menu as only navigation on desktop
**Do**: Visible navigation appropriate to screen size

**Don't**: Navigation that breaks browser back
**Do**: Each screen = unique URL, back works

**Don't**: More than 7 items in horizontal nav
**Do**: Group into fewer top-level items or use sidebar

**Don't**: Breadcrumbs for flat sites
**Do**: Breadcrumbs only for 3+ level hierarchies

**Don't**: Different navigation patterns per section
**Do**: Consistent navigation model throughout app
