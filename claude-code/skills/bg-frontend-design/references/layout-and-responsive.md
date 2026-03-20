# Layout & Responsive Design

## Layout Constraints

- Don't stretch content to fill the screen — use `max-width` on content areas
- NEVER use fixed `width` on any container wider than an icon/avatar — always `width: 100%; max-width: Xpx`
- Prose/paragraph text: `max-width` 600-700px (45-75 characters per line)
- Within wide canvases, still constrain text columns even if the overall layout is full-width
- Baseline-align mixed-size text (not center) — especially inline stat/label pairings

## Mandatory Fluid Patterns

Use these instead of fixed widths:

**All containers:**
```css
width: 100%; max-width: Xpx; margin: 0 auto;
```

**Card grids** (auto-collapses without media queries):
```css
display: grid;
grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
gap: 24px;
```

**Side-by-side layouts** (wraps naturally):
```css
display: flex; flex-wrap: wrap; gap: 24px;
/* children: */ flex: 1 1 300px;
```

NEVER use `grid-template-columns: 300px 500px` or any fixed-px column definitions.

## Required @media Block

Every design MUST include a `@media (max-width: 600px)` block:

```css
@media (max-width: 600px) {
  .container, .card, .section { padding: 16px; }
  .grid, .row, [class*="columns"] {
    grid-template-columns: 1fr;
    flex-direction: column;
    gap: 12px;
  }
  h1 { font-size: var(--text-2xl); }
  h2 { font-size: var(--text-xl); }
  .btn { width: 100%; min-height: 44px; }
  .sidebar, .decorative { display: none; }
}
```

Rules for the mobile block:
- Stack all multi-column/flex-row/grid layouts
- Reduce padding and gaps by ~40%
- Scale heading font sizes down 1-2 steps
- Full-width buttons
- Touch targets: minimum 44px height on interactive elements
- Hide purely decorative elements that waste vertical space

## BAD vs GOOD

BAD (will NOT reflow):
```html
<div style="width: 800px; display: grid; grid-template-columns: 250px 550px">
```

GOOD (auto-reflows):
```html
<div style="width: 100%; max-width: 800px; margin: 0 auto; display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px">
```
