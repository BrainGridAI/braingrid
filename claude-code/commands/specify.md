---
allowed-tools: Bash(braingrid:*), Bash(git:*), Bash(npm:*), Read, Grep, Glob, Skill(braingrid-cli)
argument-hint: [prompt-text]
description: Create AI-refined requirement from a prompt using BrainGrid
---

Create a detailed, AI-refined requirement specification using the BrainGrid CLI.

**Use BrainGrid CLI Skill:**
If the `braingrid-cli` skill is available, invoke it for detailed workflow guidance and best practices. The skill provides comprehensive context about BrainGrid commands, auto-detection features, and recommended workflows.

**About BrainGrid CLI:**
BrainGrid CLI helps turn half-baked thoughts into build-ready specs and perfectly-prompted tasks for AI coding agents. The `specify` command takes a brief prompt (10-5000 characters) and uses AI to refine it into a detailed requirement document with problem statement, acceptance criteria, implementation considerations, and edge cases.

**IMPORTANT INSTRUCTIONS:**

1. Run commands directly - assume CLI is installed and user is authenticated
2. Handle errors reactively when they occur
3. **Context Detection**: Automatically detect prompts from conversation context when $ARGUMENTS is empty
4. Validate prompt length (10-5000 characters) after context detection and enhancement
5. Suggest complete workflow after creating the requirement

---

## Context Detection Algorithm

When $ARGUMENTS is empty, automatically detect context from the conversation using this algorithm:

### Step 1: Check for Explicit Prompt

If `$ARGUMENTS` is provided and not empty, use it as the base prompt. Skip to **Prompt Enhancement**.

### Step 2: Search for ExitPlanMode Tool Outputs (Structured Plans)

If no explicit prompt, search the conversation history for `ExitPlanMode` tool outputs:

- Look for tool calls or results containing `ExitPlanMode`
- These indicate the user created a structured plan earlier in the conversation
- Extract the plan content including:
  - Goals and objectives
  - Implementation steps
  - Technical details and decisions
- If multiple plans exist, use the **most recent** one
- Use the complete plan content as the base prompt

**Detection patterns:**

- `<tool_name>ExitPlanMode</tool_name>`
- Plan file content referenced in conversation
- Structured implementation plans with numbered steps

### Step 3: Search for Markdown Patterns (Fallback)

If no ExitPlanMode plan found, scan the conversation for markdown-formatted content:

**Detect these patterns:**

- Headers: `#`, `##`, `###` (h1, h2, h3)
- Bullet lists: `-`, `*`, `+` at line start
- Numbered lists: `1.`, `2.`, `3.` at line start
- Code blocks: ``` or indented code

**Extraction rules:**

- Look for **contiguous blocks** of structured content (not scattered fragments)
- Prefer content with **multiple structural elements** (headers + lists)
- Extract content that appears to describe a feature, requirement, or task
- Prioritize recent content over older content

**Example markdown that should be detected:**

```
# User Authentication
- Login with email/password
- JWT token management
- Password reset flow

## Technical Requirements
1. Use bcrypt for password hashing
2. Store tokens in HTTP-only cookies
```

### Step 4: No Context Found

If neither ExitPlanMode plans nor markdown patterns are found:

- Display error: "Could not figure out what you want to specify. Please provide a prompt or create a plan first."
- Suggest: "Use /plan to create a structured plan, or provide an explicit prompt: /specify 'your requirement description'"
- **Do NOT call the BrainGrid API**
- Exit the command

---

## Prompt Enhancement

After detecting the base prompt, automatically enhance it with relevant codebase context. This happens BEFORE validation and API call.

### Enhancement Categories (in priority order)

**1. Architecture Context** (highest priority - preserve if truncating)

- **Framework**: Detect from package.json (React, Vue, Angular, Express, etc.)
- **API Pattern**: REST, GraphQL, tRPC based on codebase analysis
- **State Management**: Redux, Zustand, Context API, etc.
- **Architecture Style**: Microservices, monolith, serverless

Example injection:

```
[Architecture: React 18 + TypeScript, REST API with Express.js backend,
Zustand for state management, monolithic architecture]
```

**2. Technical Constraints** (from conversation)

- Performance targets mentioned in discussion
- Security requirements discussed
- Compliance/regulatory constraints
- Data model relationships

Example injection:

```
[Constraints: Must handle 10k concurrent users, HIPAA compliance required,
integrate with existing PostgreSQL database]
```

**3. Related Files** (from conversation mentions)

- File paths referenced in the conversation
- Components or modules discussed
- API endpoints mentioned
- Existing implementations referenced

Example injection:

```
[Related files: src/auth/login.ts, src/components/UserProfile.tsx,
API: POST /api/auth/login, GET /api/users/:id]
```

**4. Convention Adherence** (from CLAUDE.md)

- Parse project's CLAUDE.md file if it exists
- Extract naming conventions (kebab-case, camelCase, PascalCase)
- Directory structure patterns
- Testing requirements and patterns

Example injection:

```
[Conventions: Files use kebab-case, components use PascalCase,
tests colocated with source files, use Vitest for testing]
```

**5. Dependency Context** (lowest priority - trim first if over limit)

- Extract from package.json
- Key dependencies relevant to the feature
- Version constraints
- Available libraries

Example injection:

```
[Dependencies: zod@3.22 for validation, axios@1.6 for HTTP,
@tanstack/react-query@5 for data fetching]
```

### Enhancement Composition

Combine base prompt with enhancement context:

```
{Base Prompt}

---
## Technical Context (auto-generated)

{Architecture Context}

{Technical Constraints}

{Related Files}

{Conventions}

{Dependencies}
```

**Rules:**

- Enhancement supports the base prompt, doesn't overwhelm it
- Keep enhancement concise and relevant
- Only include context that's directly relevant to the prompt
- If no relevant context exists for a category, omit it

---

## Prompt Input Flow

1. **Get Base Prompt** (using Context Detection Algorithm above):
   - If $ARGUMENTS provided → use as base prompt
   - Else if ExitPlanMode plan found → use plan content as base prompt
   - Else if markdown patterns found → use extracted content as base prompt
   - Else → show error and exit (no API call)

2. **Enhance Prompt** (using Prompt Enhancement above):
   - Gather architecture context from repository
   - Extract related files from conversation
   - Collect technical constraints discussed
   - Parse CLAUDE.md for conventions
   - Read relevant dependencies from package.json
   - Compose enhanced prompt

3. **Validate Enhanced Prompt** (see Length Validation section below):
   - Must be 10-5000 characters (after enhancement)
   - If too short: Show error and exit
   - If too long: Trigger intelligent truncation

---

## Length Validation and Intelligent Truncation

### Validation Rules

The final enriched prompt (base prompt + enhancement context) must be **10-5000 characters**.

**Too Short (< 10 characters):**

- Display error: "Prompt too short after context enhancement (minimum 10 characters)"
- Do NOT call BrainGrid API
- Suggest user provide more detailed prompt or context

**Too Long (> 5000 characters):**

- Trigger intelligent truncation (see below)
- After truncation, call API with valid prompt

### Intelligent Truncation Algorithm

When the enhanced prompt exceeds 5000 characters, truncate enhancement sections in this order (lowest priority first):

**Truncation Order:**

1. **Dependencies** (trim first) - Remove dependency context entirely
2. **Conventions** - Remove CLAUDE.md conventions
3. **Related Files** - Remove file path references
4. **Technical Constraints** - Remove constraint context
5. **Architecture** (trim last) - Only trim if absolutely necessary

**Critical Rule:** ALWAYS preserve the base prompt. Never truncate user-provided or auto-detected content.

**Truncation Process:**

```
1. Calculate current length
2. If > 5000 chars:
   a. Remove Dependencies section → recalculate
   b. Still > 5000? Remove Conventions → recalculate
   c. Still > 5000? Remove Related Files → recalculate
   d. Still > 5000? Remove Constraints → recalculate
   e. Still > 5000? Trim Architecture (keep framework only)
3. If still > 5000 after all truncation:
   - Base prompt alone is too long
   - Show error: "Prompt exceeds 5000 character limit"
   - Do NOT call API
```

**Example:**

Original enhanced prompt (6200 chars):

```
[Base prompt: 2800 chars]
[Architecture: 500 chars]
[Constraints: 800 chars]
[Files: 700 chars]
[Conventions: 800 chars]
[Dependencies: 600 chars]
```

After truncation:

```
[Base prompt: 2800 chars] ← preserved
[Architecture: 500 chars] ← preserved (high priority)
[Constraints: 800 chars] ← preserved
[Files: 700 chars] ← preserved
[Conventions: 800 chars] ← REMOVED (5600 - 800 = 4800 < 5000)
[Dependencies: 600 chars] ← REMOVED first (6200 - 600 = 5600 > 5000)
```

Final: 4800 chars ✓

3. **Guide Effective Prompts** (when asking user interactively):
   - Encourage users to include:
     - **Problem statement**: What needs solving?
     - **Context**: Why is this needed?
     - **Constraints**: Technical limitations, requirements
     - **Users**: Who will use this?
     - **Success criteria**: What does "done" look like?

   Example good prompt:

   ```
   Add user authentication with email/password login, JWT tokens, password
   reset flow, and account verification. Must integrate with existing
   Express.js backend and React frontend. Security requirements: bcrypt
   for passwords, secure HTTP-only cookies for tokens.
   ```

**Create Requirement:**

1. **Run Specify Command**:

   ```bash
   braingrid specify --prompt "..."
   ```

   - Use the prompt from context detection (explicit argument, plan, or markdown)
   - The prompt is passed to the CLI which handles enhancement and API calls
   - Display the full output showing the created requirement
   - Capture the requirement ID (e.g., REQ-123) from the output
   - The output will show the AI-refined requirement with full details

2. **Handle Errors Reactively**:
   - If command fails, show clear error message and provide guidance
   - Common issues and how to handle them:
     - **CLI not installed** (command not found):
       - Guide user to install: `npm install -g @braingrid/cli`
       - Verify installation: `braingrid --version`
       - Retry the specify command

     - **Not authenticated**:
       - Guide user through `braingrid login`
       - This opens an OAuth2 flow in the browser
       - Verify with `braingrid whoami`
       - Retry the specify command

     - **No project initialized** (error mentions project not found):
       - Guide user to run `braingrid init`
       - This creates `.braingrid/project.json` to track the active project
       - The CLI auto-detects project context from this file
       - Retry the specify command

     - **Prompt too short/long**: "Prompt must be 10-5000 characters"
     - **Network/API errors**: Show full error message and suggest retry

**Suggest Next Steps:**

After successfully creating the requirement, guide the user through the typical BrainGrid workflow:

1. **Break Down into Tasks** (AI-powered):

   ```bash
   braingrid requirement breakdown REQ-{id}
   ```

   - This uses AI to convert the requirement into specific, actionable tasks
   - Tasks are properly sequenced and ready to feed to AI coding tools

2. **Create Git Branch** (enables auto-detection):

   ```bash
   git checkout -b feature/REQ-{id}-{description}
   ```

   - Use a descriptive branch name based on the requirement
   - Include the requirement ID in the branch name (e.g., `feature/REQ-123-oauth-auth`)
   - The CLI will auto-detect the requirement ID from branch names like:
     - `feature/REQ-123-description`
     - `REQ-123-fix-bug`
     - `req-456-new-feature`

3. **Build Implementation Plan**:

   ```bash
   braingrid requirement build REQ-{id} --format markdown
   ```

   - Exports the complete requirement with all task prompts
   - Available formats: `markdown` (default, best for AI), `json`, `xml`, `table`
   - Perfect for feeding to AI coding tools like Cursor or Claude Code

4. **Update Requirement Status**:

   ```bash
   braingrid requirement update REQ-{id} --status IN_PROGRESS
   ```

   - Status workflow: IDEA → PLANNED → IN_PROGRESS → REVIEW → COMPLETED (or CANCELLED)
   - Update as work progresses

**Workflow Summary:**

The complete BrainGrid workflow is:

1. `braingrid specify --prompt "..."` - Create AI-refined requirement
2. `braingrid requirement breakdown REQ-X` - Break into tasks
3. `git checkout -b feature/REQ-X-description` - Create branch
4. `braingrid requirement build REQ-X` - Get implementation plan
5. Work through tasks, updating status as you go
6. `braingrid requirement update REQ-X --status REVIEW` - Mark for review

**Example Interactions:**

**Example 1: Explicit Prompt**

```
User runs: /specify Add real-time notifications

Claude:
1. Uses "Add real-time notifications" as base prompt
2. Runs: braingrid specify --prompt "Add real-time notifications"
3. Shows created requirement (REQ-123: "Real-time Notification System")
4. Suggests next steps
```

**Example 2: Auto-Detect from Plan (ExitPlanMode)**

```
User: /plan
Claude: [Creates structured plan with ExitPlanMode tool]

User: /specify
Claude:
1. Detects no $ARGUMENTS provided
2. Searches conversation for ExitPlanMode tool outputs
3. Finds recent plan: "Implement user authentication with JWT..."
4. Uses plan content as base prompt
5. Runs: braingrid specify --prompt "Implement user authentication with JWT..."
6. Shows created requirement
```

**Example 3: Auto-Detect from Markdown**

```
User: "I need to add:
# User Authentication
- Login with email/password
- JWT token management
- Password reset flow"

User: /specify
Claude:
1. Detects no $ARGUMENTS provided
2. Searches for ExitPlanMode plans → none found
3. Searches for markdown patterns → finds structured content
4. Extracts markdown as base prompt
5. Runs: braingrid specify --prompt "# User Authentication\n- Login with email/password..."
6. Shows created requirement
```

**Example 4: No Context Found**

```
User: /specify
(No plans or markdown in conversation)

Claude:
1. Detects no $ARGUMENTS provided
2. Searches for ExitPlanMode plans → none found
3. Searches for markdown patterns → none found
4. Shows error: "Could not figure out what you want to specify."
5. Suggests: "Use /plan or provide: /specify 'your requirement'"
6. Does NOT call BrainGrid API
```

**Error Handling:**

If the command fails, handle reactively based on the error:

**Pre-API Errors (do NOT call API):**

- **No context detected** (no $ARGUMENTS, no plans, no markdown):
  - Display: "❌ Could not figure out what you want to specify. Please provide a prompt or create a plan first."
  - Suggest: "Use /plan to create a structured plan, or provide an explicit prompt: /specify 'your requirement description'"
  - **Do NOT call the BrainGrid API** - exit immediately

- **Prompt too short** (< 10 characters after enhancement):
  - Display: "❌ Prompt too short after context enhancement (minimum 10 characters)"
  - Suggest: "Provide more detailed prompt or context"
  - **Do NOT call the BrainGrid API**

- **Prompt too long** (> 5000 characters after truncation):
  - This only happens if base prompt alone exceeds 5000 chars
  - Display: "❌ Prompt exceeds 5000 character limit"
  - Suggest: "Shorten your prompt - it must be under 5000 characters"
  - **Do NOT call the BrainGrid API**

**CLI/Setup Errors:**

- **CLI not installed** (command not found): Guide through installation, then retry
- **Not authenticated**: Guide through login flow, then retry
- **No project**: Guide through init process, then retry

**API Errors (after successful API call attempt):**

- **API validation error** (422):
  - Display the validation error message from the API
  - Common issues: invalid prompt content, missing required fields
  - Suggest adjusting prompt based on validation feedback

- **API server error** (500):
  - Display: "❌ Server error occurred"
  - Suggest: "Please try again in a moment. If the issue persists, check BrainGrid status."

- **Network errors** (timeout, connection refused):
  - Display: "❌ Network error - could not reach BrainGrid API"
  - Suggest: "Check your internet connection and try again"

**Test Scenarios (for verification):**

| Scenario                         | Expected Behavior                                 |
| -------------------------------- | ------------------------------------------------- |
| Explicit prompt with enhancement | ✓ Works - prompt enhanced and sent to API         |
| Auto-detected plan               | ✓ Works - plan content used as prompt             |
| Auto-detected markdown           | ✓ Works - markdown extracted as prompt            |
| No context                       | ✗ Error shown, no API call                        |
| Prompt too short                 | ✗ Error shown, no API call                        |
| Prompt too long                  | ✓ Truncated, then API called (unless base > 5000) |
| API validation error (422)       | ✗ Error displayed with validation message         |
| API server error (500)           | ✗ Error displayed with retry suggestion           |

**Success Criteria:**

✅ **Context Detection:**

- AC-1: Optional prompt argument works (explicit or auto-detected)
- AC-2: Structured plan detection from ExitPlanMode works
- AC-3: Markdown fallback detection works
- AC-4: No context error shown when appropriate (no API call)

✅ **Prompt Enhancement:**

- AC-5: Architecture context injected
- AC-6: Related files context added
- AC-7: Technical constraints injected
- AC-8: Convention adherence (CLAUDE.md) applied
- AC-9: Dependency context included

✅ **Validation:**

- AC-10: Length validation (10-5000 characters) enforced
- AC-11: Intelligent truncation preserves base prompt

✅ **API Integration:**

- AC-12: Explicit prompt with enhancement works
- AC-13: Existing API contract maintained
- AC-14: Error handling displays appropriate messages

✅ **Workflow:**

- Requirement created with valid ID (REQ-XXX)
- User understands next steps
- Offered to help with breakdown/build commands

**Final Output:**

After successful requirement creation, show:

- ✅ Requirement created: REQ-{id}
- 📋 Name: {requirement name}
- 🔄 Status: IDEA (initial status)
- 📁 Project: {project name}
- 🔗 View: https://app.braingrid.ai/requirements/overview?id={requirement-uuid}&tab=requirements

Note: Extract the requirement UUID from the command output to construct the URL.

**Next Steps:**

1. Break down into tasks: `braingrid requirement breakdown REQ-{id}`
2. Create git branch: `git checkout -b feature/REQ-{id}-{description}`
3. Build implementation plan: `braingrid requirement build REQ-{id}`

**Ask**: "Would you like me to help you break this down into tasks?"
