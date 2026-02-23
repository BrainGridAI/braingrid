# Lucide Icons via CSS mask-image

No JavaScript required. Define a base `.lucide` class, then set `mask-image` per icon.

## Base Class

```css
.lucide {
  display: inline-block;
  width: 1em; height: 1em;
  background: currentColor;
  -webkit-mask-size: contain; mask-size: contain;
  -webkit-mask-repeat: no-repeat; mask-repeat: no-repeat;
  -webkit-mask-position: center; mask-position: center;
  vertical-align: -0.125em;
}
```

## Usage

```html
<span class="lucide" style="-webkit-mask-image: url(https://cdn.jsdelivr.net/npm/lucide-static@latest/icons/settings.svg); mask-image: url(https://cdn.jsdelivr.net/npm/lucide-static@latest/icons/settings.svg)"></span>
```

## Styling

- Icons inherit text color via `currentColor`
- Set `background: var(--accent)` for colored icons
- Size with `width/height` or `font-size` on parent
- Icons at ~70% opacity when paired with text (supporting role); colored/accent icons keep full opacity

## Common Icon Names

home, settings, user, search, bell, menu, x, check, chevron-right, chevron-down, plus, trash-2, pencil, eye, download, upload, filter, calendar, clock, mail, star, heart, arrow-left, arrow-right, external-link, folder, file-text, image, grid, list, bar-chart-3, trending-up, alert-triangle, info, circle-check, circle-x, loader, log-out, shield, lock, globe, truck, wrench, map-pin, building, users, credit-card, tag

Browse all: https://lucide.dev/icons
