---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code and UI design that avoids generic AI aesthetics.
---
This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

## Design Thinking

Before coding, determine your starting point:

1. **Greenfield or brownfield?** Check for existing UI code, design tokens, or theme files. Greenfield = establish a fresh direction. Brownfield = match the existing system. See `references/design-principles.md` for details.
2. **Purpose**: What problem does this interface solve? Who uses it?
3. **Tone**: Pick an extreme: brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, etc. Commit fully.
4. **Constraints**: Technical requirements (framework, performance, accessibility).
5. **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work — the key is intentionality, not intensity.

Then implement working code (HTML/CSS/JS, React, Vue, etc.) that is:
- Production-grade and functional
- Visually striking and memorable
- Cohesive with a clear aesthetic point-of-view
- Meticulously refined in every detail

## Creative Direction

- **Typography**: Choose distinctive, characterful fonts — never generic (Inter, Roboto, Arial, system). Pair a display font with a refined body font.
- **Color**: Commit to a cohesive aesthetic. Dominant colors with sharp accents outperform timid, evenly-distributed palettes. Define HSL-based 9-shade scales.
- **Motion**: CSS animations for entrance reveals (staggered `animation-delay`) + hover transitions on interactive elements. One well-orchestrated page load > scattered micro-interactions.
- **Spatial Composition**: Unexpected layouts. Asymmetry. Overlap. Diagonal flow. Grid-breaking elements. Generous negative space OR controlled density.
- **Backgrounds**: Atmosphere and depth, not solid colors. Gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, grain overlays.

NEVER use generic AI-generated aesthetics. No design should look the same as the last. Vary themes, fonts, and aesthetics across generations.

**Match implementation complexity to the vision.** Maximalist designs need elaborate animations and effects. Minimalist designs need restraint, precision, and careful spacing/typography.

## Technical Execution Reference

Consult these references when implementing specific systems:

| Building... | Reference |
|---|---|
| Any design (start here) | `references/design-principles.md` |
| Font choices, type scale, weights | `references/typography-system.md` |
| Whitespace, gaps, padding | `references/spacing-system.md` |
| Color palette, shades, neutrals | `references/color-system.md` |
| Elevation, cards, modals | `references/shadow-and-depth.md` |
| Page layout, responsive | `references/layout-and-responsive.md` |
| Icons (Lucide via CSS) | `references/icons-lucide.md` |
| Forms, empty states, buttons, nav | `references/ux-patterns.md` |
| Accessibility (WCAG 2.1) | `references/accessibility.md` |
| What NOT to do | `references/anti-patterns.md` |
