---
allowed-tools: Bash(braingrid:*), Bash(git:*), Bash(npm:*), Read, Grep, Glob, Skill(braingrid-cli)
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

2. **Handle Errors Reactively**:
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

**Use Additional Instructions:**

If additional instructions were provided in $ARGUMENTS:

1. **Acknowledge Instructions**:
   - Show what additional context was provided
   - Example: "I'll focus on security and add comprehensive tests as requested"

2. **Apply to Implementation**:
   - Review the tasks with the additional context in mind
   - Highlight relevant tasks or add notes
   - Example: If user said "focus on security", emphasize security-related tasks

3. **Offer to Start**:
   - Ask if user wants to start implementing with that context
   - Example: "Would you like me to start with the first task, keeping security best practices in mind?"

**Suggest Next Steps:**

After successfully fetching the build plan:

1. **Create/Checkout Git Branch** (if not already on one):

   ```bash
   git checkout -b feature/REQ-{id}-{description}
   ```

   - Include the requirement ID in the branch name
   - Enables auto-detection for future commands

2. **Review Tasks**:
   - The build output shows all tasks with full prompts
   - Review which tasks to tackle first
   - Tasks are sequenced in logical order

3. **Start Implementation**:
   - Begin working on the first task (or task suggested by additional instructions)
   - Update task status as you work:
     ```bash
     braingrid task update TASK-{id} --status IN_PROGRESS
     ```

4. **Update Requirement Status**:

   ```bash
   braingrid requirement update REQ-{id} --status IN_PROGRESS
   ```

   - Mark requirement as in progress when starting work

5. **View in BrainGrid App**:
   - Click the URL to see the requirement in the web app
   - Track progress and view task details

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

Claude:
1. Runs: braingrid requirement build REQ-123 --format markdown
2. Shows complete requirement and all task prompts
3. Reports: "REQ-123: User Authentication System (5 tasks)"
4. Suggests:
   - Review the tasks and decide where to start
   - Create git branch if not on one
   - Start with first task
```

**With additional instructions**

```
User runs: /build REQ-123 focus on security best practices and add extensive error handling

Claude:
1. Runs: braingrid requirement build REQ-123 --format markdown
2. Shows complete build plan
3. Acknowledges: "I'll focus on security best practices and add extensive error handling"
4. Reviews tasks and highlights security-related ones
5. Suggests starting with auth/security tasks first
6. Offers: "Would you like me to start implementing with security as the priority?"
```

**Auto-detect from branch**

```
User runs: /build
(User is on branch: feature/REQ-123-user-auth)

Claude:
1. Runs: braingrid requirement build --format markdown
2. CLI auto-detects REQ-123 from branch name
3. Shows build plan for REQ-123
4. Suggests next steps
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
6. Reviews tasks with logging/monitoring focus
7. Offers to start implementation
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
✅ All tasks shown with full prompts
✅ Additional instructions acknowledged and applied (if provided)
✅ User understands next steps and is ready to implement

**Final Output:**

After successful build fetch, show:

- ✅ Build plan fetched: REQ-{id}
- 📋 Name: {requirement name}
- 🔄 Status: {current status}
- 📋 Tasks: {count} tasks ready for implementation
- 🔗 View requirement: https://app.braingrid.ai/requirements/overview?id={requirement-uuid}&tab=requirements
- 🔗 View tasks: https://app.braingrid.ai/requirements/overview?id={requirement-uuid}&tab=tasks

Note: Extract the requirement UUID from the command output to construct the URLs.

**If additional instructions provided:**

- 📝 Context: {additional instructions}
- Highlight relevant tasks based on instructions
- Offer to start implementing

**Next Steps:**

1. Create git branch: `git checkout -b feature/REQ-{id}-{description}` (if needed)
2. Review task prompts in the output
3. Start implementing tasks
4. Update task status: `braingrid task update TASK-{id} --status IN_PROGRESS`
5. Update requirement status: `braingrid requirement update REQ-{id} --status IN_PROGRESS`

**Ask**: "Would you like me to help implement {specific task based on context}?"

**Available Output Formats:**

While markdown is default and best for AI coding tools, the build command supports:

- `markdown` - Full content with task prompts (default, best for AI)
- `json` - Structured data for scripting
- `xml` - Alternative structured format
- `table` - Compact view for quick reference

If user wants a different format, they can specify it in additional instructions.
