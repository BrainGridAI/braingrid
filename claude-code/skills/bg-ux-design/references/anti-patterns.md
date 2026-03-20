# UX Anti-Patterns

Common mistakes to avoid. Each pattern includes what goes wrong and the better alternative.

## Navigation Anti-Patterns

### Hidden hamburger (desktop)
**Problem**: Hiding primary navigation in hamburger menu on desktop
**Why bad**: Increases clicks, reduces discoverability, hides key features
**Better**: Visible header or sidebar navigation for desktop

### Mystery meat navigation
**Problem**: Icon-only navigation without labels
**Why bad**: Forces memorization, confuses new users
**Better**: Icons + labels, or labels on hover at minimum

### Broken back button
**Problem**: Page changes don't update URL/history
**Why bad**: Browser back doesn't work as expected, can't bookmark
**Better**: Each state = unique URL, proper history management

### Infinite nesting
**Problem**: Navigation hierarchy 4+ levels deep
**Why bad**: Users get lost, breadcrumbs become unwieldy
**Better**: Flatten hierarchy, use search/filtering instead

## Form Anti-Patterns

### Clear form on error
**Problem**: Form validation fails, all input cleared
**Why bad**: User must re-enter everything, rage-inducing
**Better**: Preserve all input, highlight only invalid fields

### Validate on every keystroke
**Problem**: Error messages appear/disappear while typing
**Why bad**: Jumpy UI, distracting, false errors during input
**Better**: Validate on blur or after typing pause (500ms)

### Required field surprise
**Problem**: Required fields only revealed after submit
**Why bad**: Wasted effort, user didn't know what was needed
**Better**: Mark required fields upfront, validate progressively

### Disabled submit with no explanation
**Problem**: Submit button disabled, user doesn't know why
**Why bad**: No feedback, user stuck guessing
**Better**: Enable button, show validation errors on submit; or tooltip on disabled button

### CAPTCHAs everywhere
**Problem**: CAPTCHA on every form, even low-risk ones
**Why bad**: Friction for legitimate users
**Better**: Risk-based CAPTCHA (only when suspicious), invisible CAPTCHA

## Feedback Anti-Patterns

### Silent failure
**Problem**: Action fails but no error message shown
**Why bad**: User doesn't know something went wrong
**Better**: Always show feedback—success or failure

### Success message that blocks
**Problem**: Modal success dialog requiring click to dismiss
**Why bad**: Interrupts flow, unnecessary friction
**Better**: Toast notification that auto-dismisses

### Generic error messages
**Problem**: "An error occurred. Please try again."
**Why bad**: No information about what went wrong or how to fix
**Better**: Specific error + suggested action: "Email already registered. Try logging in instead."

### Loading spinner forever
**Problem**: Spinner with no timeout, no way to cancel
**Why bad**: User stuck waiting indefinitely
**Better**: Timeout with retry option, cancel button for long operations

## Content Anti-Patterns

### Wall of text
**Problem**: Dense paragraphs with no structure
**Why bad**: Users don't read, miss important information
**Better**: Headers, bullet points, visual hierarchy

### Jargon overload
**Problem**: Technical terms without explanation
**Why bad**: Excludes users who don't know terminology
**Better**: Plain language, tooltips for necessary technical terms

### Buried actions
**Problem**: Primary action hidden in dropdown or at bottom of page
**Why bad**: Users can't find what they came to do
**Better**: Primary action prominent, above the fold

### Confirmation for everything
**Problem**: "Are you sure?" dialog for routine actions
**Why bad**: Users learn to click through, confirmation becomes meaningless
**Better**: Reserve confirmation for destructive/irreversible actions only

## Interaction Anti-Patterns

### Hover-dependent features
**Problem**: Essential features only visible on hover
**Why bad**: Doesn't work on touch devices, discovery problem
**Better**: Visible affordances, hover for enhancement only

### Tiny click targets
**Problem**: Small buttons, tight link spacing
**Why bad**: Hard to tap on mobile, frustrating on desktop too
**Better**: Minimum 44x44px touch targets, adequate spacing

### Scroll hijacking
**Problem**: Custom scroll behavior, parallax that fights user
**Why bad**: Disorienting, accessibility issues
**Better**: Native scroll, parallax subtle and non-blocking

### Auto-advancing carousels
**Problem**: Content rotates automatically
**Why bad**: Users can't read at their pace, loses place
**Better**: User-controlled pagination, static by default

### Unexpected popups
**Problem**: Modal appears without user action
**Why bad**: Interrupts task, feels aggressive
**Better**: Trigger modals from user action only

## Search Anti-Patterns

### Require exact match
**Problem**: Search only finds exact string matches
**Why bad**: Typos and variations yield no results
**Better**: Fuzzy matching, typo tolerance, synonyms

### Clear filters on search
**Problem**: Entering search term clears active filters
**Why bad**: User has to re-apply filters
**Better**: Search within filtered results

### No indication of search scope
**Problem**: User doesn't know what's being searched
**Why bad**: Confusion about why results don't include expected items
**Better**: "Searching in Projects" label, scope selector

## Mobile Anti-Patterns

### Desktop pinch-zoom
**Problem**: Requiring zoom to read/interact on mobile
**Why bad**: Not designed for mobile, poor experience
**Better**: Responsive design, mobile-appropriate sizing

### Bottom navigation overflow
**Problem**: More than 5 items in mobile bottom nav
**Why bad**: Items too small, cluttered
**Better**: Max 5 items, "More" for overflow

### Dropdown for 2 options
**Problem**: Using dropdown when there are only 2 choices
**Why bad**: Extra tap to see options
**Better**: Toggle, segmented control, or radio buttons

## State Anti-Patterns

### Blank empty state
**Problem**: Empty list shows nothing at all
**Why bad**: User doesn't know if loading, error, or genuinely empty
**Better**: Explain why empty, suggest action to populate

### Same error for everything
**Problem**: "Something went wrong" for all errors
**Why bad**: No context, user can't troubleshoot
**Better**: Specific errors with appropriate actions

### Losing draft on navigate
**Problem**: Navigating away loses unsaved work without warning
**Why bad**: User loses work unexpectedly
**Better**: Auto-save drafts, or warn before navigation

## Scope Anti-Patterns

### Feature creep ("while we're at it...")
**Problem**: Adding features during implementation because they seem easy
**Why bad**: Delays ship date, introduces bugs, dilutes focus
**Better**: Note ideas for v2, ship focused v1 first

### Building for everyone
**Problem**: Trying to satisfy every user type with one design
**Why bad**: Satisfies no one well, creates bloated UI
**Better**: Pick your core user, design for them, say no to the rest

### Placeholder copy in specs
**Problem**: Lorem ipsum or "[TBD]" in design specs
**Why bad**: Copy IS design—you can't evaluate UX without real words
**Better**: Write real copy during design; iterate on words like you iterate on layout

### Designing the 90% before the 10%
**Problem**: Polishing happy path while ignoring edge cases
**Why bad**: Edge cases are where users get stuck and blame your product
**Better**: Design empty/error/edge states alongside normal states
