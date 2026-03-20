---
name: ux
description: |
  Design excellent UX for digital products (web, mobile, CLI). Use when:
  (1) designing new features/flows, (2) creating information architecture,
  (3) specifying interaction patterns, (4) planning screen states/transitions.
  Complements frontend-design (visuals) by focusing on structure and behavior.
---
# Product Design UX

Design user experiences that are intuitive, efficient, and delightful. This skill focuses on structure, flow, and interaction—not visual styling (use `frontend-design` for aesthetics).

## Core Principles

| Principle | Apply By |
|-----------|----------|
| **General → Specific** | IA before screens, screens before components |
| **Clear Next Step** | Single primary action per view, obvious affordances |
| **Progressive Disclosure** | Hide complexity until needed, reveal on demand |
| **Immediate Feedback** | Every action has visible consequence within 100ms |
| **Constraint-Based** | Smart defaults, limit choices to prevent errors |
| **Reversibility** | Always allow undo/back, confirm destructive actions |
| **Epicenter First** | Design core feature before periphery; what's the one thing this must do? |
| **Build Half, Not Half-Ass** | Ship complete subset vs incomplete whole; cut scope, not quality |
| **Words Are UI** | Labels, errors, empty states—treat copy as design, not afterthought |
| **Context Over Consistency** | Break patterns when context demands; sensible > uniform |

## Workflow: UNDERSTAND → STRUCTURE → FLOW → SPECIFY → VALIDATE

### Phase 1: UNDERSTAND

Gather context before designing:
- **User goal**: What are they trying to accomplish?
- **Entry points**: How do users arrive at this feature?
- **Constraints**: Technical, business, accessibility requirements
- **Existing patterns**: What conventions exist in this product/domain?

Output: Problem statement in one sentence.

### Phase 2: STRUCTURE

Define the information architecture:
- **Objects**: What entities exist? (user, project, task, etc.)
- **Hierarchy**: How do objects relate? Parent/child, peer, linked?
- **Navigation model**: How do users move between objects?

Output: Object map or simple IA diagram.

### Phase 3: FLOW

Map the user journey:
- **Happy path**: Primary flow to achieve goal
- **Alternative paths**: Secondary options, shortcuts
- **Edge cases**: Empty states, errors, limits reached
- **Exit points**: How/where can users abandon?

Output: Flow diagram or numbered step list.

### Phase 4: SPECIFY

Detail each screen/state:
- **Layout zones**: Header, content, actions, navigation
- **Content**: What information appears, in what priority?
- **Interactions**: What can user do? Primary/secondary actions?
- **States**: Loading, empty, error, success, partial

Output: Screen specs using the UX Spec Format below.

### Phase 5: VALIDATE

Check against principles:
- [ ] Can user achieve goal in minimal steps?
- [ ] Is the next action always clear?
- [ ] Are all states designed (empty, error, loading)?
- [ ] Can user undo/go back at every point?
- [ ] Are edge cases handled gracefully?

## UX Spec Format

Use this format for handing off to implementation or `frontend-design`:

```markdown
## [Screen/Component Name]

**Purpose**: One sentence describing what this enables.

**Entry**: How user arrives here.

### Layout
- [Zone]: [Content description]
- ...

### Content
| Element | Source | Priority |
|---------|--------|----------|
| ... | ... | P1/P2/P3 |

### Interactions
| Trigger | Action | Feedback |
|---------|--------|----------|
| Click [X] | [Result] | [Visual feedback] |

### States
- **Loading**: [Description]
- **Empty**: [Description + action to resolve]
- **Error**: [Description + recovery path]
- **Success**: [Description]

### Constraints
- Max [N] items displayed
- [Field] required before [action]
- ...
```

## Pattern Selection

Choose pattern files based on what you're designing:

| Designing... | Reference File |
|--------------|----------------|
| Multi-step process, onboarding | `references/patterns-wizard.md` |
| Data entry, settings | `references/patterns-forms.md` |
| Collections, data display | `references/patterns-lists-tables.md` |
| Finding content, filtering | `references/patterns-search.md` |
| Moving between screens | `references/patterns-navigation.md` |
| Loading, success, errors | `references/patterns-feedback.md` |
| Empty, error, edge cases | `references/patterns-states.md` |
| Terminal interfaces | `references/patterns-cli.md` |
| Product philosophy, tone, scope | `references/philosophy-37signals.md` |
| What NOT to do | `references/anti-patterns.md` |

## Interface-Specific Notes

### Web
- Assume mouse + keyboard input
- Design for multiple viewport sizes
- Consider URL structure (each state = shareable URL?)
- Keyboard navigation for power users

### Mobile
- Touch targets minimum 44x44px
- Thumb-zone placement for primary actions
- Consider one-handed use
- Pull-to-refresh, swipe gestures
- Offline states critical

### CLI
- Command structure: `verb noun --flags`
- Progressive output for long operations
- Sensible defaults, explicit overrides
- Confirmation prompts for destructive ops
- Machine-readable output option (--json)

## Handoff to frontend-design

| This skill specifies | frontend-design handles |
|---------------------|------------------------|
| What screens exist | How they look |
| Information hierarchy | Visual hierarchy |
| Interaction behavior | Animation/motion |
| State definitions | State styling |
| Content structure | Typography/color |

When handing off, provide:
1. UX Spec for each screen
2. Flow diagram showing navigation
3. State matrix (all states per screen)
4. Interaction notes (hover, click, drag behaviors)
