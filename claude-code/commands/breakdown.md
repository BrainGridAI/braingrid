---
allowed-tools: Bash(braingrid:*), Bash(git:*), Bash(npm:*), Read, Grep, Glob, Skill(braingrid-cli)
argument-hint: [requirement-id]
description: Break down a requirement into AI-generated tasks
---

Break down a requirement into AI-generated, perfectly-prompted tasks using the BrainGrid CLI.

**Use BrainGrid CLI Skill:**
If the `braingrid-cli` skill is available, invoke it for detailed workflow guidance and best practices. The skill provides comprehensive context about BrainGrid commands, auto-detection features, and recommended workflows.

**About BrainGrid Breakdown:**
The `breakdown` command uses AI to convert a requirement into specific, actionable tasks that are properly sequenced and scoped. Tasks are ready to feed directly to AI coding tools like Cursor or Claude Code, with detailed prompts for each step.

**IMPORTANT INSTRUCTIONS:**

1. Run commands directly - assume CLI is installed and user is authenticated
2. Handle errors reactively when they occur
3. Accept requirement ID from $ARGUMENTS or auto-detect from git branch
4. Suggest next steps after breaking down the requirement

**Get Requirement ID:**

1. **Accept from $ARGUMENTS**:
   - If $ARGUMENTS is provided, use it as the requirement ID
   - Accept flexible formats:
     - `REQ-123` (canonical)
     - `req-123` (lowercase)
     - `123` (number only)
     - Full UUID

2. **Auto-detect from Git Branch**:
   - If $ARGUMENTS is empty, the CLI will auto-detect from git branch name
   - The CLI parses branch names like:
     - `feature/REQ-123-description`
     - `REQ-123-fix-bug`
     - `req-456-new-feature`
   - Let the CLI handle auto-detection by running without `-r` flag

3. **Ask User if Needed**:
   - If $ARGUMENTS is empty and auto-detection fails, ask user for requirement ID
   - Suggest running `braingrid requirement list` to see available requirements

**Run Breakdown:**

1. **Execute Breakdown Command**:

   ⏱️ **IMPORTANT - Be Patient:**
   The breakdown process uses AI to analyze the requirement and generate detailed task prompts.
   This typically takes 1-3 minutes to complete. **Always wait for the command to finish** - do not
   timeout or abort the operation. The CLI will show progress and eventually return the complete
   task breakdown.

   ```bash
   braingrid requirement breakdown [REQ-ID]
   ```

   - Include requirement ID if provided in $ARGUMENTS
   - If $ARGUMENTS is empty, omit the ID to use auto-detection
   - Command returns full task details with content in markdown format by default
   - Display the full output showing created tasks
   - Capture task IDs and count from the output

2. **Handle Errors Reactively**:
   - If command fails, show clear error message and provide guidance
   - Common issues and how to handle them:
     - **CLI not installed** (command not found):
       - Guide user to install: `npm install -g @braingrid/cli`
       - Verify installation: `braingrid --version`
       - Retry the breakdown command

     - **Not authenticated**:
       - Guide user through `braingrid login`
       - This opens an OAuth2 flow in the browser
       - Verify with `braingrid whoami`
       - Retry the breakdown command

     - **No project initialized** (error mentions project not found):
       - Guide user to run `braingrid init`
       - This creates `.braingrid/project.json` to track the active project
       - Retry the breakdown command

     - **Requirement not found**:
       - Suggest running `braingrid requirement list` to see available requirements
       - Or suggest creating one with `/specify`

     - **No git branch/ID**: Ask user to provide requirement ID or create git branch
     - **Network/API errors**: Show full error message and suggest retry

**Suggest Next Steps:**

After successfully breaking down the requirement, guide the user through the workflow:

1. **View Tasks with Full Content**:

   ```bash
   braingrid task list -r REQ-{id}
   ```

   - Returns full task prompts in markdown format by default
   - Each task has a detailed prompt ready for AI coding tools
   - Use `braingrid task summary -r REQ-{id}` for quick table overview without content

2. **Build Complete Implementation Plan**:

   ```bash
   braingrid requirement build REQ-{id} --format markdown
   ```

   - Exports the complete requirement with all task prompts
   - Markdown format is best for AI coding agents
   - This gives you a single document with the entire implementation plan

3. **Create Git Branch** (if not already on one):

   ```bash
   git checkout -b feature/REQ-{id}-{description}
   ```

   - Include the requirement ID in the branch name
   - Enables auto-detection for future commands
   - Example: `feature/REQ-123-user-authentication`

4. **Update Requirement Status**:

   ```bash
   braingrid requirement update REQ-{id} --status IN_PROGRESS
   ```

   - Status workflow: IDEA → PLANNED → IN_PROGRESS → REVIEW → COMPLETED
   - Update as work progresses

**Workflow Context:**

The typical BrainGrid workflow is:

1. ✅ Create requirement: `braingrid specify --prompt "..."` (or `/specify`)
2. **➡️ Break into tasks**: `braingrid requirement breakdown REQ-X` (this command)
3. View tasks: `braingrid task list -r REQ-X` (full content in markdown)
4. Get build plan: `braingrid requirement build REQ-X` (complete implementation plan)
5. Work through tasks, updating status as you go

**Example Interaction:**

```
User runs: /breakdown REQ-123

Claude:
1. Runs: braingrid requirement breakdown REQ-123
2. Shows task breakdown with full content in markdown format
3. Reports: "Created 5 tasks for REQ-123"
4. Suggests next steps:
   - braingrid task list -r REQ-123 (view all task prompts)
   - braingrid task summary -r REQ-123 (quick table overview)
   - braingrid requirement build REQ-123 (complete implementation plan)
   - git checkout -b feature/REQ-123-description (create branch)
```

**Alternative: Auto-detect from branch**

```
User runs: /breakdown
(User is on branch: feature/REQ-123-user-auth)

Claude:
1. Runs: braingrid requirement breakdown
2. CLI auto-detects REQ-123 from branch name
3. Shows task breakdown with full content for REQ-123
4. Suggests viewing tasks and building plan
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
✅ Requirement exists and was successfully broken down
✅ Tasks created with detailed prompts
✅ User understands how to view tasks and build plan
✅ Offered to help with next steps in workflow

**Final Output:**

After successful breakdown, show:

- ✅ Breakdown complete for REQ-{id}
- 📋 Created {count} tasks
- 🎯 Tasks are ready for implementation
- 🔗 View requirement: https://app.braingrid.ai/requirements/overview?id={requirement-uuid}&tab=requirements
- 🔗 View tasks: https://app.braingrid.ai/requirements/overview?id={requirement-uuid}&tab=tasks

Note: Extract the requirement UUID from the command output to construct the URLs.

**Next Steps:**

1. View task prompts: `braingrid task list -r REQ-{id}` (full content in markdown)
2. Quick overview: `braingrid task summary -r REQ-{id}` (table without content)
3. Build implementation plan: `braingrid requirement build REQ-{id}` (complete plan)
4. Create git branch: `git checkout -b feature/REQ-{id}-{description}` (if needed)
5. Update status: `braingrid requirement update REQ-{id} --status IN_PROGRESS`

**Ask**: "Would you like me to help you build the implementation plan or start working on the first task?"
