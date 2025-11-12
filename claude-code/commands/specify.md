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
3. Use the prompt from $ARGUMENTS or ask the user interactively
4. Validate prompt length (10-5000 characters)
5. Suggest complete workflow after creating the requirement

**Accept Prompt Input:**

1. **Get Prompt Text**:
   - If $ARGUMENTS is provided and not empty, use it as the prompt
   - If $ARGUMENTS is empty, ask the user for the prompt text
   - Validate prompt length (must be 10-5000 characters)
   - If too short: "Prompt must be at least 10 characters"
   - If too long: "Prompt must be less than 5000 characters"

2. **Guide Effective Prompts**:
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

   - Use the prompt text from $ARGUMENTS or user input
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

**Example Interaction:**

```
User runs: /specify Add real-time notifications

Claude:
1. Runs: braingrid specify --prompt "Add real-time notifications"
2. Shows created requirement (REQ-123: "Real-time Notification System")
3. Suggests next steps:
   - braingrid requirement breakdown REQ-123
   - git checkout -b feature/REQ-123-realtime-notifications
   - braingrid requirement build REQ-123
```

**Error Handling:**

If the command fails, handle reactively based on the error:

- **CLI not installed** (command not found): Guide through installation, then retry
- **Not authenticated**: Guide through login flow, then retry
- **No project**: Guide through init process, then retry
- **Invalid prompt**: Explain length requirements (10-5000 chars)
- **API errors**: Show error message and suggest retry

**Success Criteria:**
✅ BrainGrid CLI is installed and authenticated
✅ Requirement created successfully with valid ID (REQ-XXX)
✅ User understands the next steps in the workflow
✅ Offered to help with breakdown/build commands

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
