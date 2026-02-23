# 37signals Design Philosophy

Principles from Jason Fried, DHH, and the 37signals team. Use when making scope decisions, writing copy, or questioning design conventions.

## Build Less

**Half product > half-ass product.** Ship a complete subset rather than an incomplete whole.

- Cut scope, not quality
- If you can't build it right, don't build it yet
- The best features are the ones you don't build (until needed)
- "Later" is a valid answer; "never" is even better for some features

**Apply by**: When scope creeps, ask "What can we remove and still ship something useful?"

## Useful is Forever

**Utility over novelty.** Trends fade; usefulness doesn't.

- Features that help people get work done outlive features that impress
- Solve real problems, not hypothetical ones
- Ask "Will people still need this in 5 years?"
- Beauty in tools comes from how well they work

## Epicenter First

**Design the core before the periphery.** Start with the one thing this screen/feature MUST do.

- What's the absolute minimum this needs to be useful?
- Navigation, settings, edge cases come later
- If you can't identify the epicenter, you don't understand the problem yet

**Example**: Designing a project page? Start with the task list, not the sidebar.

## Cozy, Not Cold

**Welcoming, human tone.** Software doesn't have to be sterile.

- Write like a human, not a corporation
- It's okay to have personality
- "Invite a teammate" > "Add user to organization"
- Error messages can be friendly without being cutesy

## Context Over Consistency

**Permission to break patterns when sensible.** Foolish consistency is the hobgoblin of boring UX.

- Same interaction in different contexts may need different designs
- Question inherited patterns: "Why do we do it this way?"
- Sensible > uniform

**Example**: Delete confirmation makes sense for projects, not for draft messages.

## The Basics Are Beautiful

**Obvious > clever.** If users need instructions, the design failed.

- Prefer familiar patterns over innovative ones
- Plain labels beat creative naming
- The best UI is invisible—it just works
- Sophistication is knowing when to be simple

## Three-State Rule

**Every component needs: normal, blank, error.** Most designs only address happy path.

- **Normal**: Data present, working as intended
- **Blank/Empty**: No data yet—explain why and how to fix
- **Error**: Something went wrong—be specific, offer recovery

Add to this: loading, partial, success as needed.

## Copywriting as Design

**Words are interface.** Labels, errors, empty states—treat copy as design, not afterthought.

### Good vs Bad Copy

| Context | Bad | Good |
|---------|-----|------|
| Empty state | "No items" | "No projects yet. Create your first one." |
| Error | "Invalid input" | "Email format looks wrong. Try name@example.com" |
| Button | "Submit" | "Save changes" |
| Confirmation | "Are you sure?" | "Delete 'Project Alpha'? This can't be undone." |
| Loading | "Loading..." | "Fetching your projects..." |

### Copy Principles
- Say what happens, not what the system does
- Use the user's language, not internal terminology
- Specific > generic
- Helpful > technically accurate

## Fixed Time, Variable Scope

**Scope is the release valve.** When under pressure, cut features—not corners, not quality, not deadlines.

- Deadlines create pressure that forces decisions
- "What's the smallest useful version?" is always the right question
- Scope grows naturally; you must actively prune it
- Shipping something good beats planning something perfect

## Questioning Design Decisions

Use these prompts when reviewing UX:

1. **"Do we need this at all?"** — Best feature is no feature
2. **"What's the epicenter?"** — Everything else is optional
3. **"Can a user figure this out without help?"** — If not, simplify
4. **"Are we building for us or for users?"** — Build what they need, not what's fun to build
5. **"What would we ship if we had half the time?"** — That's probably what you should ship

## Sources

- [Getting Real](https://basecamp.com/gettingreal)
- [Shape Up](https://basecamp.com/shapeup)
- [Seven Shipping Principles](https://37signals.com/seven-shipping-principles)
