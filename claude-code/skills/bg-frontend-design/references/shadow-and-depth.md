# Shadow & Depth

## Two-Part Shadows

Always use two shadows together: a contact shadow (tight, dark) + an ambient shadow (large, soft).

## Three Elevation Levels

**Small** (cards):
```css
box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.06);
```

**Medium** (dropdowns, popovers):
```css
box-shadow: 0 4px 6px rgba(0,0,0,0.1), 0 2px 4px rgba(0,0,0,0.06);
```

**Large** (modals, dialogs):
```css
box-shadow: 0 20px 25px rgba(0,0,0,0.1), 0 10px 10px rgba(0,0,0,0.04);
```

## Additional Techniques

- **Accent borders**: use a 4px colored top or left border on cards, alerts, or feature callouts for visual punch
- **Separation**: prefer spacing and background-color differences over borders — fewer borders = cleaner
- **Inset shadows**: use `box-shadow: inset 0 2px 4px rgba(0,0,0,0.06)` on containers for user-uploaded content
