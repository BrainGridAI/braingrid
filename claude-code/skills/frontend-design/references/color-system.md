# Color System

## 9-Shade Scales

Define per semantic color (50-900):

```css
--primary-50: ...;
--primary-100: ...;
/* through */
--primary-900: ...;
```

Same pattern for: `--accent`, `--success`, `--error`, `--warning`, `--info`.

Also define convenience aliases: `--bg`, `--text`, `--muted` mapping to appropriate shades.

## HSL Reasoning

- **Lighter shades**: raise Lightness + bump Saturation
- **Darker shades**: lower Lightness + lower Saturation

## Neutral Grays

Tint warm (mix with yellow/orange) or cool (mix with blue) to match brand temperature. **NEVER use pure gray** (`#gray`, `hsl(0, 0%, ...)`).

## Rules

- NEVER use gray text on colored backgrounds — use a lighter or white-at-reduced-opacity version of the background color instead
