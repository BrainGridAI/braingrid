---
allowed-tools: Bash(braingrid:*), Bash(git:*), Bash(npm:*), Read, Write, Grep, Glob, Skill(braingrid-cli), TaskCreate, TaskUpdate, TaskList, TeamCreate, TeamDelete, SendMessage, Task
argument-hint: [requirement-id] [additional-instructions]
description: Build a requirement with full task details and optional instructions
---

Fetch a requirement's complete implementation plan and start building it with additional context.

**Use BrainGrid CLI Skill:**
If the `braingrid-cli` skill is available, invoke it for detailed workflow guidance and best practices. The skill provides comprehensive context about BrainGrid commands, auto-detection features, and recommended workflows.

**About This Command:**
Use this command to fetch a requirement's complete implementation plan using `braingrid requirement build`. This retrieves the requirement details along with all task prompts in markdown format (perfect for AI coding tools). You can optionally provide additional instructions or context to guide the implementation.

**IMPORTANT INSTRUCTIONS:**

1. Run commands directly - assume CLI is installed and user is authenticated
2. Handle errors reactively when they occur
3. Accept requirement ID from $ARGUMENTS or auto-detect from git branch
4. Parse remaining $ARGUMENTS as additional instructions for implementation
5. Use `--format markdown` for AI-ready output
6. If additional instructions provided, use them to guide implementation

**Parse Arguments:**

1. **Get Requirement ID** (first argument):
   - If $ARGUMENTS starts with REQ-, req-, or a number, use as requirement ID
   - Accept flexible formats:
     - `REQ-123` (canonical)
     - `req-123` (lowercase)
     - `123` (number only)
     - Full UUID
   - If no ID in arguments, auto-detect from git branch name
   - If auto-detection fails, ask user for requirement ID

2. **Get Additional Instructions** (remaining arguments):
   - Everything after the requirement ID is additional instructions
   - Example: `/build REQ-123 focus on security and add comprehensive tests`
   - These instructions provide context for implementation
   - If no additional instructions, just show the build plan

**Activate Build Sentinel:**

Before running any build commands or creating tasks, create the sentinel file that activates build-specific hooks:

```bash
mkdir -p .braingrid/temp
```

Then write the requirement ID to the sentinel file:

```bash
echo "REQ-{id}" > .braingrid/temp/build-active.local
```

If the requirement ID is not yet known (auto-detection), create the sentinel after the build command resolves the ID. The sentinel MUST exist before any `TaskCreate` calls so hooks are active.

**Run Build Command:**

1. **Execute Build Command**:

   ```bash
   braingrid requirement build [REQ-ID] --format markdown
   ```

   - Include requirement ID if provided in $ARGUMENTS
   - If $ARGUMENTS has no ID, omit the ID to use auto-detection from git branch
   - Use `--format markdown` for AI-ready output (default)
   - Display the full output showing:
     - Requirement details (ID, name, status, description)
     - All tasks with full prompts
     - Complete implementation plan
   - Capture requirement ID and task count from output
   - Extract requirement UUID for URL construction

2. **Save requirement to temp file**:
   Write the full markdown build output to `.braingrid/temp/REQ-{id}-requirement.md` using the Write tool.
   This persists the requirement so the agent can re-read it if context is compressed.

3. **Handle Errors Reactively**:
   - If command fails, show clear error message and provide guidance
   - Common issues and how to handle them:
     - **CLI not installed** (command not found):
       - Guide user to install: `npm install -g @braingrid/cli`
       - Verify installation: `braingrid --version`
       - Retry the build command

     - **Not authenticated**:
       - Guide user through `braingrid login`
       - This opens an OAuth2 flow in the browser
       - Verify with `braingrid whoami`
       - Retry the build command

     - **No project initialized** (error mentions project not found):
       - Guide user to run `braingrid init`
       - This creates `.braingrid/project.json` to track the active project
       - Retry the build command

     - **Requirement not found**:
       - Suggest running `braingrid requirement list` to see available requirements
       - Or suggest creating one with `/specify`

     - **No git branch/ID**: Ask user to provide requirement ID or create git branch
     - **Network/API errors**: Show full error message and suggest retry

**REQUIRED - Create BrainGrid Branch:**

CRITICAL: You MUST run `braingrid requirement create-branch` to create the branch. Do NOT skip this step. Do NOT use `git checkout -b` instead. The BrainGrid CLI command creates the branch on GitHub AND registers it with BrainGrid for requirement tracking. A local `git checkout -b` does neither.

1. **Check if already on the correct branch**:

   ```bash
   git rev-parse --abbrev-ref HEAD
   ```

   If the current branch name already contains `REQ-{id}` (e.g., `tyler/REQ-12-some-feature` or `feature/REQ-12-foo`), skip to Task Creation. Otherwise, continue to step 2.

2. **Run BrainGrid create-branch** (REQUIRED):

   ```bash
   braingrid requirement create-branch REQ-{id}
   ```

   The command will output:

   ```
   ✅ Created branch: {branch-name}

   SHA: abc123d

   To checkout: git fetch origin && git checkout {branch-name}
   ```

3. **Checkout the branch** - extract the checkout command from the output and run it:

   ```bash
   git fetch origin && git checkout {branch-name}
   ```

   Replace `{branch-name}` with the actual branch name from the `✅ Created branch:` line (e.g., `tyler/REQ-12-user-authentication`).

4. **Fallback** - ONLY if `create-branch` fails with an actual error (not found, network error, GitHub not configured):
   - Create a local branch as a last resort:
     ```bash
     git checkout -b feature/REQ-{id}-{slug}
     ```
   - Warn: "⚠️ Branch created locally only. It is not tracked in BrainGrid. Run `braingrid requirement create-branch REQ-{id}` later to register it."

---

**Extract Acceptance Criteria:**

After fetching the build plan, extract the acceptance criteria into a checklist file for tracking during implementation.

1. **Parse acceptance criteria** from the build output:
   - Find everything after the `## Acceptance Criteria` heading in the requirement content
   - The section may contain `###` sub-headings that group related criteria — **ignore all headings**
   - Each criterion starts with `- Given` or `- **Given**` (bullet-prefixed)
   - A criterion may span multiple lines (continuation lines not starting with `- `)
   - Collect all criteria into a flat list, stripping any heading structure

2. **Write checklist file** using the Write tool:

   File path: `.braingrid/temp/REQ-{id}-acceptance-criteria.md`

   Format — `## Acceptance Criteria` heading followed by `- []` lines, no subheadings, no blank lines between items:

   ```
   ## Acceptance Criteria
   - [] Given a user visits the root URL, When the page loads, Then the hero section displays the tagline and CTA.
   - [] Given a valid JWT and allowed model, When POST to messages endpoint, Then request is forwarded to Anthropic and response returned.
   - [] Given stream: true in request body, When request succeeds, Then SSE response is piped through to client.
   ```

   Rules:
   - Start file with `## Acceptance Criteria` heading
   - Each criterion prefixed with `- []` (dash, space, brackets, space)
   - Strip markdown bold formatting (`**Given**` → `Given`)
   - Join multi-line criteria into a single line (collapse line breaks within one criterion)
   - Preserve the full text of each clause
   - No blank lines between items
   - No subheadings — just the `## Acceptance Criteria` heading and `- []` lines
   - If no `## Acceptance Criteria` section exists in the requirement, skip this step silently

3. **Confirm**: "📋 Extracted {count} acceptance criteria to `.braingrid/temp/REQ-{id}-acceptance-criteria.md`"

**Create Verification State File:**

After extracting acceptance criteria (only if criteria count > 0), create the verification state file that enables the Stop hook to enforce acceptance criteria verification after all tasks complete.

Write `.braingrid/temp/build-verification.local.md` using the Write tool:

```markdown
---
active: true
iteration: 0
max_iterations: 15
requirement_id: REQ-{id}
criteria_file: .braingrid/temp/REQ-{id}-acceptance-criteria.md
started_at: "{ISO timestamp}"
---

Continue verifying acceptance criteria for REQ-{id}.

Read the acceptance criteria at `.braingrid/temp/REQ-{id}-acceptance-criteria.md`.

If you need to re-read the full requirement, it is saved at `.braingrid/temp/REQ-{id}-requirement.md`.

For each unchecked criterion (line starting with `- []`):
1. Examine the implementation code to verify the criterion is satisfied
2. Run relevant tests or check behavior if applicable
3. Change `- []` to `- [x]`
4. Add a `Proof:` line immediately below explaining HOW it's satisfied

Keep going until ALL criteria show `[x]` with proof.
```

Replace `{id}` with the actual requirement ID and `{ISO timestamp}` with the current ISO 8601 timestamp.

**Important**: Only create this file if acceptance criteria were extracted. If no `## Acceptance Criteria` section was found (step was skipped), do NOT create the verification state file.

---

**Task Discovery & Mode Selection (After Branch Setup):**

After ensuring you're on the correct branch, discover tasks and choose implementation mode BEFORE creating Claude Code tasks:

1. **Fetch requirement with JSON format** (to check for tasks):

   ```bash
   braingrid requirement build [REQ-ID] --format json
   ```

   Parse the JSON response to check if `tasks` array exists and has items.

2. **Determine task list**:

   - If tasks EXIST in the BrainGrid response, use them directly
   - If NO tasks exist, analyze the requirement content (description, acceptance criteria) and determine the logical tasks needed — but do NOT call `TaskCreate` yet

3. **Count tasks and choose implementation mode**:

   a. **Check for agent teams**: Run `echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` in Bash.
   b. If output is `1` (or any non-empty value) AND there are 3+ tasks: use **Parallel Mode**.
   c. Otherwise: use **Sequential Mode**.

**Use Additional Instructions:**

If additional instructions were provided in $ARGUMENTS:

- **Acknowledge Instructions**: Show what additional context was provided
  - Example: "I'll focus on security and add comprehensive tests as requested"
  - This acknowledgment applies to both sequential and parallel modes

---

**Task Creation (After Mode Selection):**

Now create the Claude Code tasks. If parallel mode was selected, create the team FIRST so tasks land in the team's task list.

**If Parallel Mode**: Call `TeamCreate` with name `build-REQ-{id}` (e.g., `build-REQ-123`) BEFORE creating any tasks.

**If Sequential Mode**: Skip team creation; tasks go into the default session list.

**IMPORTANT — Create tasks ONE AT A TIME (sequentially, not in parallel).** Hook scripts run on each TaskCreate and TaskUpdate call. Issuing multiple task tool calls in a single parallel batch causes hook runner errors. Create each task, wait for the response, then create the next. Same for TaskUpdate calls (e.g., setting blockedBy) — issue them one at a time after all tasks exist.

Then create the tasks:

1. **If tasks EXIST in BrainGrid**:

   For each task in the BrainGrid response:

   a. **Create local Claude Code task** with TaskCreate:

   ```
   TaskCreate:
     subject: "TASK {N}: {type}: {description}"
     description: [Task content/prompt from BrainGrid]
     activeForm: "{type}: {description}"
   ```

   Where:
   - `{N}` = sequential number (1, 2, 3...)
   - `{type}` = conventional commit type inferred from the task (feat/fix/test/refactor/docs/chore/style/perf)
   - `{description}` = lowercase imperative derived from the BrainGrid task title

   b. **Capture the Claude Code task ID** from TaskCreate response (e.g., "1", "2", etc.)

   c. **Update the BrainGrid task with external_id** to link it to the Claude Code task:

   ```bash
   braingrid task update TASK-X -r REQ-Y --external-id "[Claude task ID]"
   ```

   This links the BrainGrid task to the local Claude Code task via `external_id`.
   The status sync hook will use this to automatically sync status updates.

2. **If NO tasks exist in BrainGrid** (Claude creates them):

   For EACH task identified during the discovery phase:

   a. **Create local Claude Code task FIRST** with TaskCreate:

   ```
   TaskCreate:
     subject: "TASK {N}: {type}: {description}"
     description: [Detailed implementation instructions]
     activeForm: "{type}: {description}"
   ```

   Where `{N}`, `{type}`, `{description}` follow the same convention as above.

   b. **Capture the task ID** from TaskCreate response (e.g., "1", "2", etc.)

   c. **Create in BrainGrid with external_id**:

   ```bash
   braingrid task create -r [REQ-ID] --title "Task Title" --content "Detailed implementation instructions..." --external-id "[Claude task ID]"
   ```

   This links the BrainGrid task to the local Claude Code task via `external_id`.
   The status sync hook will use this to automatically sync status updates.

3. **Show task list**:

   After creating tasks, call `TaskList` to show the user their work queue.

4. **Update requirement status to IN_PROGRESS**:

   ```bash
   braingrid requirement update REQ-{id} --status IN_PROGRESS
   ```

   Since building a requirement means work is starting, automatically update the status.

**Task Creation Guidelines** (when no tasks exist):

- Create one task per acceptance criterion (or logical grouping)
- Each task should be independently completable
- Task content should include clear implementation instructions
- Consider dependencies between tasks (use TaskUpdate with blockedBy if needed)
- Aim for 3-7 tasks per requirement (not too granular, not too broad)
- Subject format: `TASK N: type: description` (lowercase imperative description)
- Valid types: feat, fix, docs, style, refactor, perf, test, chore
- Optional scope: `TASK N: type(scope): description`
- If task has blockedBy deps, append `(blocked by N,N,...)` to subject
- activeForm = the `type: description` portion (shown as spinner text)
- Commit hash added later on completion: `TASK N (hash): type: description`

**Status Mapping (for synchronization):**

| Claude Code Status | BrainGrid Status |
| ------------------ | ---------------- |
| `pending`          | `PLANNED`        |
| `in_progress`      | `IN_PROGRESS`    |
| `completed`        | `COMPLETED`      |

**How status sync works:**
When you update a local task status using `TaskUpdate`, a PostToolUse hook automatically:

1. Reads the task ID from the update
2. Extracts the requirement ID from the git branch (e.g., `feature/REQ-4-description`)
3. Queries BrainGrid for a task with matching `external_id` (the Claude task ID)
4. Syncs the status to BrainGrid via CLI

**Important:**

- Tasks must be created with `--external-id` for status sync to work
- You must be on a feature branch with `REQ-X` in the name (e.g., `feature/REQ-4-auth`)
- Status sync won't run on `main` or branches without a requirement ID

---

**Parallel Mode (Agent Teams):**

Use this mode when `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` is set and there are 3+ tasks. The team was already created in the Task Creation step above.

1. **Determine teammate count**: `min(independent_task_count, 3)` — cap at 3 teammates to avoid merge conflicts and resource exhaustion.

2. **Spawn teammates**: Use the `Task` tool with `team_name` and `name` params (`braingrid-builder-1`, `braingrid-builder-2`, `braingrid-builder-3`). Each teammate's spawn prompt MUST include:
   - Requirement ID, name, and branch name
   - Self-claim workflow: call `TaskList` → claim an unowned/unblocked task with `TaskUpdate` (set owner to your name) → implement → mark `completed` → call `TaskList` again → repeat until no tasks remain
   - Full requirement saved at `.braingrid/temp/REQ-{id}-requirement.md` — re-read if you need context
   - Reminder that PreToolUse hooks enforce commit-before-complete and naming conventions
   - `git pull --rebase` before starting each new task (to pick up other teammates' commits)
   - Additional instructions from `$ARGUMENTS` if provided

3. **Lead coordinates (do NOT implement)**: The lead monitors `TaskList`, resolves blockers, and nudges idle teammates. The lead MUST NOT implement tasks itself — this avoids merge conflicts with teammates working in the same repo.

4. **Verify completion**: When all tasks show `completed` in TaskList, run the test suite once more to catch integration issues from parallel work.

5. **Shutdown & cleanup**: Send `shutdown_request` via `SendMessage` to each teammate, then call `TeamDelete` to clean up the team.

6. **Acceptance criteria verification**: The lead proceeds to the existing "Acceptance Criteria Verification Phase" below. The Stop hook continues to work as-is since it only fires for the lead's session.

---

**Sequential Mode (Default):**

Use this mode when agent teams are NOT enabled, or when there are fewer than 3 tasks.

If additional instructions were provided in $ARGUMENTS:

1. **Apply to Implementation**:
   - Review the tasks with the additional context in mind
   - Highlight relevant tasks or add notes
   - Example: If user said "focus on security", emphasize security-related tasks

2. **Start Immediately**:
   - Begin implementing the first task right away with that context applied
   - Do NOT ask the user if they want to start — just start

**Begin Implementation Immediately:**

After successfully fetching the build plan and creating tasks, start implementing immediately. Do NOT wait for user confirmation.

1. **Start First Task**:
   - Mark TASK 1 as `in_progress` using TaskUpdate
   - Read the task description and begin implementation

2. **Iterate Through ALL Tasks Sequentially**:
   - After completing a task, immediately move to the next one
   - Mark each task `in_progress` before starting, then `completed` when done
   - Do NOT stop between tasks to ask the user
   - Continue until ALL tasks are completed

3. **Only Pause for Genuine Blockers**:
   - Stop ONLY if there is a genuine ambiguity that cannot be resolved from the requirement, task descriptions, or codebase
   - Valid: missing credentials, conflicting requirements, unclear acceptance criteria
   - Invalid: "should I continue?", "ready for the next task?", "shall I proceed?"

**Workflow Context:**

The typical workflow with `/build`:

1. Create/breakdown requirement (if not done): `/specify` or `/breakdown`
2. **➡️ Fetch build plan**: `/build REQ-X` (this command)
3. Review tasks and plan approach
4. Start implementing tasks
5. Update statuses as you progress

**Example Interactions:**

**Basic: Fetch build plan**

```
User runs: /build REQ-123
(User is on main branch)

Claude:
1. Runs: braingrid requirement build REQ-123 --format markdown
2. Shows complete requirement and all task prompts
3. Creates branch via BrainGrid CLI:
   - Runs: braingrid requirement create-branch REQ-123
   - On success: git fetch origin && git checkout tyler/REQ-123-user-authentication-system
   - On error: Last resort fallback to local git checkout -b (warns about missing BrainGrid tracking)
4. Creates local Claude Code tasks using TaskCreate with naming convention:
   - TASK 1: feat: implement user login endpoint
   - TASK 2: feat: add session management
   - TASK 3: test: add authentication tests
   - TASK 4: feat(auth): add OAuth support (blocked by 1,2)
   - TASK 5: docs: add authentication API docs
5. Creates BrainGrid tasks with --external-id linking to Claude task IDs
6. Reports: "REQ-123: User Authentication System (5 tasks)"
7. Ready to start implementing
```

**With additional instructions**

```
User runs: /build REQ-123 focus on security best practices and add extensive error handling

Claude:
1. Runs: braingrid requirement build REQ-123 --format markdown
2. Shows complete build plan
3. Acknowledges: "I'll focus on security best practices and add extensive error handling"
4. Reviews tasks and highlights security-related ones
5. Immediately starts implementing TASK 1 (e.g., "TASK 1: feat: implement login endpoint") with security context applied
6. Iterates through all tasks without stopping
```

**Auto-detect from branch**

```
User runs: /build
(User is on branch: feature/REQ-123-user-auth)

Claude:
1. Runs: braingrid requirement build --format markdown
2. CLI auto-detects REQ-123 from branch name
3. Shows build plan for REQ-123
4. Immediately starts implementing tasks sequentially
```

**With instructions, auto-detect ID**

```
User runs: /build add comprehensive logging and monitoring
(User is on branch: feature/REQ-456-api-integration)

Claude:
1. Detects no requirement ID in arguments
2. Runs: braingrid requirement build --format markdown
3. CLI auto-detects REQ-456 from branch
4. Shows build plan
5. Acknowledges: "I'll add comprehensive logging and monitoring"
6. Immediately starts implementing TASK 1 with logging/monitoring focus
7. Continues through all tasks without stopping
```

**Parallel mode (agent teams enabled)**

```
User runs: /build REQ-789
(CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1, requirement has 6 tasks)

Claude:
1. Fetches build plan, creates branch, extracts acceptance criteria
2. Discovers 6 tasks (3 independent, 3 with dependencies)
3. Detects teams enabled + 6 tasks → Parallel Mode
4. Creates team "build-REQ-789" FIRST, then creates 6 tasks with naming convention:
   - TASK 1: feat: implement endpoint handler
   - TASK 2: feat: add data models
   - TASK 3: test: add unit tests (blocked by 1,2)
   - etc.
5. Spawns 3 braingrid-builder teammates
6. Teammates self-claim wave-1 tasks, implement in parallel
7. As blockers complete, wave-2 tasks unlock and get claimed
8. Lead monitors progress, resolves any blockers
9. All tasks completed → lead shuts down teammates, deletes team
10. Acceptance criteria verification phase runs
```

**Error Handling:**

If the command fails, handle reactively based on the error:

- **CLI not installed** (command not found): Guide through installation, then retry
- **Not authenticated**: Guide through login flow, then retry
- **No project**: Guide through init process, then retry
- **Requirement not found**: Suggest listing requirements or creating with `/specify`
- **No branch/ID**: Ask for requirement ID or suggest creating branch
- **API errors**: Show error message and suggest retry

**Success Criteria:**
✅ BrainGrid CLI is installed and authenticated
✅ Requirement exists and build plan fetched successfully
✅ On feature branch with REQ-{id} pattern (auto-created if needed)
✅ Local Claude Code tasks created
✅ BrainGrid tasks created with external_id linking to Claude tasks
✅ Requirement status updated to IN_PROGRESS
✅ All tasks shown with full prompts
✅ Additional instructions acknowledged and applied (if provided)
✅ Implementation started on first task immediately
✅ All acceptance criteria verified with proof in temp file

**If parallel mode used:**
✅ Team created and teammates spawned successfully
✅ All teammates claimed and completed their tasks independently
✅ No merge conflicts from parallel file edits
✅ Final test suite passes after all parallel commits
✅ Teammates shut down cleanly, team deleted

**Final Output:**

After successful build fetch, show:

- ✅ Build plan fetched: REQ-{id}
- 📋 Name: {requirement name}
- 🔄 Status: IN_PROGRESS (updated)
- 🌿 Branch: {branch name} (created or existing)
- 📋 Tasks: {count} tasks ready for implementation
- 🔗 View requirement: https://app.braingrid.ai/requirements/overview?id={requirement-uuid}&tab=requirements
- 🔗 View tasks: https://app.braingrid.ai/requirements/overview?id={requirement-uuid}&tab=tasks
- 🔍 Verification: Acceptance criteria will be verified after all tasks complete

Note: Extract the requirement UUID from the command output to construct the URLs.

**If additional instructions provided:**

- 📝 Context: {additional instructions}
- Apply instructions as context to all task implementations

**Automatic Implementation:**

After displaying the final output summary, immediately begin implementing tasks:

1. Mark TASK 1 as `in_progress` and start working on it
2. Validate, commit, and complete each task (the PreToolUse hook handles commit enforcement)
3. Move to the next task immediately after completing each one
4. Continue until ALL tasks are completed
5. Only pause for genuine clarifying questions that block progress

Do NOT ask "Would you like me to start implementing the first task?" — just start.

**Sync Task Statuses to BrainGrid (Fallback):**

After ALL tasks are marked `completed` in Claude Code (and before acceptance criteria verification), run a bulk sync to catch any statuses the PostToolUse hook missed (network errors, teammate shutdown races, sentinel issues):

1. **Fetch current BrainGrid task states**:

   ```bash
   braingrid task list -r REQ-{id} --format json
   ```

2. **For each BrainGrid task with an `external_id`**:
   - Look up the matching Claude Code task (by ID from `TaskList`)
   - If the Claude Code task is `completed` but the BrainGrid task is NOT `COMPLETED`, sync it:

     ```bash
     braingrid task update TASK-X -r REQ-{id} --status COMPLETED
     ```

3. **Report results**:
   - If any tasks were synced: "🔄 Synced {n} task(s) to COMPLETED in BrainGrid"
   - If all tasks were already synced: "✅ All tasks already synced to BrainGrid"

This is a safety net — most statuses should already be synced by the PostToolUse hook. Check `/tmp/braingrid-hook-debug.log` if any were missed to diagnose root cause.

**Acceptance Criteria Verification Phase:**

After ALL tasks are marked completed, the Stop hook will prevent you from stopping until every acceptance criterion is verified. This ensures nothing slips through.

1. **Read the criteria file**: `.braingrid/temp/REQ-{id}-acceptance-criteria.md`
2. **For each criterion starting with `- []`**:
   - Verify the implementation satisfies it (examine code, run tests, check behavior)
   - Update the file: change `- []` to `- [x]`
   - Add `Proof: [explanation]` on the next line immediately below the criterion
3. **Continue until all criteria show `[x]` with proof**
4. The Stop hook will block exit and re-inject the verification prompt until all criteria are verified

If the verification loop needs to be cancelled, the user can run `/cancel-build-verification`.

**Post-Verification: Update Requirement in BrainGrid:**

After ALL acceptance criteria show `[x]` with proof (verification loop complete):

1. **Read the verified criteria file**:
   Read `.braingrid/temp/REQ-{id}-acceptance-criteria.md`

2. **Fetch current requirement content**:
   ```bash
   braingrid requirement show REQ-{id} --format json
   ```
   Parse the JSON to get the current `content` field.

3. **Replace the acceptance criteria section**:
   - Find `## Acceptance Criteria` in the current content
   - Replace everything from that heading to the next `## ` heading (or end of content) with the verified criteria file contents
   - If no `## Acceptance Criteria` heading exists, append it at the end
   - Write the merged content to `.braingrid/temp/REQ-{id}-updated-content.md`

4. **Update the requirement via CLI**:
   ```bash
   braingrid requirement update REQ-{id} --content "$(cat .braingrid/temp/REQ-{id}-updated-content.md)"
   ```

5. **Update requirement status to REVIEW**:
   ```bash
   braingrid requirement update REQ-{id} --status REVIEW
   ```

6. **Clean up temp files**:
   ```bash
   rm -f .braingrid/temp/*
   ```
   Confirm: "🧹 Cleaned up build temp files"

7. **Confirm**: "✅ Requirement REQ-{id} updated with verified acceptance criteria and moved to REVIEW"

---

**Available Output Formats:**

While markdown is default and best for AI coding tools, the build command supports:

- `markdown` - Full content with task prompts (default, best for AI)
- `json` - Structured data for scripting
- `xml` - Alternative structured format
- `table` - Compact view for quick reference

If user wants a different format, they can specify it in additional instructions.