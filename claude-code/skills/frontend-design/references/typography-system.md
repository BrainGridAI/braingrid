# Typography System

## Type Scale

Define as CSS custom properties:

```css
--text-xs: 0.75rem;
--text-sm: 0.875rem;
--text-base: 1rem;
--text-lg: 1.125rem;
--text-xl: 1.25rem;
--text-2xl: 1.5rem;
--text-3xl: 1.875rem;
--text-4xl: 2.25rem;
```

## Font Loading

Load via CDN or project font system — always include a fallback stack (serif/sans-serif).

## Weight Hierarchy

Weight contrast creates hierarchy across content levels:

| Role | Weight |
|------|--------|
| Body text | 300-400 |
| Labels | 500 |
| Subheadings | 600 |
| Headings | 700 |
| Display | 800 |

## Rules

- **Uppercase labels**: ALWAYS add letter-spacing (0.05-0.1em), reduce font-size one step, use medium weight (500)
- **Display numbers** (stats, KPIs): use `font-variant-numeric: tabular-nums`, heavier weight (600-700), larger size
- **Headings**: tight line-height (1.1-1.2), heavier weight
- **Body**: relaxed line-height (1.5-1.6), regular weight (400)
- **Small muted text** (timestamps, metadata): `--text-xs` or `--text-sm`, color: `var(--muted)`, weight 400
