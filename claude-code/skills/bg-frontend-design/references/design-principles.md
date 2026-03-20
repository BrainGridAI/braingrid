# Design Principles

## Six Core Principles

**1. Hierarchy governs everything.** Every screen has 3 levels: primary (epicenter — large, bold, dominant), secondary (supporting context — clear but receding), tertiary (metadata, labels — small, muted). Squint test: if everything blurs to the same weight, hierarchy has failed. Uniform card treatment across sections = failed hierarchy.

**2. Every element earns its place.** No decoration without function. If an icon doesn't clarify meaning — remove it. If a border doesn't separate meaningful groups — remove it. Emoji never earn their place; use inline SVG or CSS shapes when icons are needed.

**3. Typography is the design.** Type does 80% of the visual work. Define a type scale (8 sizes minimum) and use weight contrast (300-800) to create hierarchy. Uppercase labels need letter-spacing. Data displays need tabular-nums. Great type + nothing else > weak type + heavy decoration.

**4. Composition follows content.** Layout reflects the content's natural structure, not a template. A color picker, a tag cloud, and a data list are fundamentally different — design them differently. Never apply the same container treatment uniformly.

**5. Restraint signals craft.** Fewer visual devices = each one matters more. One accent color > three gradients. One precise animation > twelve micro-interactions. White space around an element signals importance.

**6. De-emphasize to emphasize.** Making surrounding elements lighter/smaller often beats enlarging the target. Hierarchy is relative — full toolkit: size, weight, color, contrast, spacing, opacity. Semantic hierarchy (h1) does not equal visual hierarchy.

## Greenfield vs Brownfield Detection

Before designing, determine which mode applies:

### Greenfield (no existing UI)
- Establish a fresh, distinctive design direction
- Pick a bold aesthetic tone (warm/approachable, sharp/professional, brutalist/raw, luxurious/refined) — commit fully
- Choose distinctive font pairing (display + body) — NEVER Inter, Roboto, Arial, or system fonts
- Define color palette as HSL-based CSS custom properties (see `color-system.md`)
- Pick spacing philosophy: generous whitespace OR controlled density

### Brownfield (existing app with components, styles, theme)
- Study the app's existing design system and match it
- Use extracted tokens directly — copy CSS custom properties, follow existing font imports
- Follow the identified component library's patterns for buttons, cards, inputs, nav
- Match the established visual language. Consistency > novelty.
- If no design system exists, inspect tailwind config, CSS variables, or theme files to extract patterns
