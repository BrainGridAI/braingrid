# Accessibility Checklist (WCAG 2.1)

Build these in from the start — don't bolt on after.

## Critical

- [ ] All `<img>` have meaningful `alt` text (decorative images: `alt=""`)
- [ ] Icon-only buttons have `aria-label`
- [ ] Form inputs have associated `<label>` or `aria-label`
- [ ] Interactive elements use semantic HTML (`<button>`, `<a href>`) — never `<div onClick>`
- [ ] Never remove `:focus` outline without a visible replacement (e.g. `focus-visible` ring)

## Serious

- [ ] Keyboard handlers on all interactive elements (`onKeyDown` alongside `onClick`)
- [ ] Color is never the only way to convey information — supplement with icon or text
- [ ] Touch targets minimum 44×44px
- [ ] Heading hierarchy: no skipping levels (`h1` → `h2` → `h3`)
- [ ] Text contrast ratio ≥ 4.5:1 (large text ≥ 3:1)
- [ ] `aria-live` regions for dynamic content updates (toasts, notifications)

## Component States

Every interactive component must account for:

- **Buttons**: default, hover, active, focus, disabled, loading
- **Form fields**: default, focus, filled, error, success, disabled
- **Error states**: indicated by more than just color (icon + text + border)
- **Loading states**: skeleton or spinner with `aria-busy="true"`

## Quick Patterns

```tsx
// Icon-only button
<button aria-label="Close dialog" onClick={onClose}>
  <XIcon aria-hidden="true" />
</button>

// Visually hidden label
<label className="sr-only" htmlFor="search">Search</label>
<input id="search" type="search" />

// Skip to content link
<a href="#main-content" className="sr-only focus:not-sr-only">
  Skip to main content
</a>
```

## Review

After implementation, run `/rams` to review for accessibility and visual design issues.
