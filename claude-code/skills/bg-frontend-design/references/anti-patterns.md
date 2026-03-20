# Design Anti-Patterns

These violate the core design principles. Avoid all of them.

1. **Gray-on-gray wireframe aesthetic** — no hierarchy, no craft
2. **Generic fonts** (Inter, Roboto, Arial, system-ui) — typography isn't doing its job
3. **Emoji as icons or decoration** — use Lucide icons via CSS mask-image instead
4. **Flat typography** (same size/weight everywhere) — define a type scale, use weight contrast
5. **Uppercase labels without letter-spacing** — always add 0.05-0.1em tracking
6. **Every section in identical cards/containers** — composition not following content
7. **Placeholder text** ("Lorem ipsum", "Click here") — content not driving design
8. **Hover-dependent discoverability** — hierarchy should be visible at rest
9. **Blank empty states without guidance**
10. **Gray text on colored backgrounds** — use lighter/transparent version of the background color instead
11. **Labels on self-evident data** (emails, dates, prices) — emphasize the data itself
12. **Center-aligned mixed-size text** — baseline-align instead
13. **Single-value box-shadow** — always use two-part (contact + ambient)
14. **Content stretched edge-to-edge** without max-width constraints
15. **Fixed-width containers** (`width: 600px`) instead of fluid (`width: 100%; max-width: 600px`) — breaks at narrow viewports
16. **Fixed-px grid columns** (`grid-template-columns: 300px 500px`) — use `repeat(auto-fit, minmax(280px, 1fr))` instead
17. **Missing @media (max-width: 600px) block** — every design needs one for mobile reflow
