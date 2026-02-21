---
allowed-tools: Bash(braingrid:*), Bash(git:*), Bash(npm:*), Read, Grep, Glob, Skill(braingrid-cli)
argument-hint: [plan-title]
description: Save a plan as a BrainGrid requirement
---

Save a detailed plan as a BrainGrid requirement, ready for implementation.

**Use BrainGrid CLI Skill:**
If the `braingrid-cli` skill is available, invoke it for detailed workflow guidance and best practices. The skill provides comprehensive context about BrainGrid commands, auto-detection features, and recommended workflows.

**About This Command:**
Use this command to save well-thought-out plans (like those from Claude Code plan mode) as BrainGrid requirements. Unlike the `/specify` command which uses AI to refine brief prompts into detailed requirements, `/save-requirement` saves your content as-is without AI refinement. The requirement will be ready to be broken down into tasks and implemented.

**IMPORTANT INSTRUCTIONS:**

1. Run commands directly - assume CLI is installed and user is authenticated
2. Handle errors reactively when they occur
3. Capture plan content from conversation or ask user
4. Use title from $ARGUMENTS or ask user
5. Create requirement (ready for implementation)
6. Suggest next steps (create branch, build)

**Get Plan Title:**

1. **Accept from $ARGUMENTS**:
   - If $ARGUMENTS is provided and not empty, use it as the plan title
   - This will be the requirement name

2. **Extract from Plan**:
   - If $ARGUMENTS is empty, look for a plan heading in recent conversation
   - Extract the main title or summary from the plan

3. **Ask User**:
   - If no title found, ask user: "What should we call this requirement?"
   - Encourage descriptive titles (e.g., "Implement user authentication system")

**Get Plan Content:**

1. **From Session Plan File** (primary):
   - Find the plan file path from the current session's plan mode context (`~/.claude/plans/{name}.md`)
   - Read it with the Read tool
   - Use the **entire file content exactly as-is** as the requirement content — do not summarize, extract, filter, or modify it in any way

2. **Fallback — Most Recent Plan File**:
   - If the plan file path isn't known from context, run `ls -t ~/.claude/plans/*.md | head -1` to get the most recently modified plan file
   - Read and use its entire content verbatim

3. **Fallback — Ask User**:
   - If no plan files exist, ask user to provide the content or a file path

**Create Requirement:**

1. **Run Create Command**:

   ```bash
   braingrid requirement create --name "{title}" --content "{plan-content}"
   ```

   - Use the title from $ARGUMENTS or user input
   - Use the captured plan content
   - Display the full output showing the created requirement
   - Capture the requirement ID (e.g., REQ-123) from the output
   - Extract the requirement UUID for URL construction

2. **Handle Errors Reactively**:
   - If command fails, show clear error message and provide guidance
   - Common issues and how to handle them:
     - **CLI not installed** (command not found):
       - Guide user to install: `npm install -g @braingrid/cli`
       - Verify installation: `braingrid --version`
       - Retry the create command

     - **Not authenticated**:
       - Guide user through `braingrid login`
       - This opens an OAuth2 flow in the browser
       - Verify with `braingrid whoami`
       - Retry the create command

     - **No project initialized** (error mentions project not found):
       - Guide user to run `braingrid init`
       - This creates `.braingrid/project.json` to track the active project
       - Retry the create command

     - **Content too long**: BrainGrid may have content length limits
       - Suggest summarizing the plan or splitting into multiple requirements

     - **Network/API errors**: Show full error message and suggest retry

**Suggest Next Steps:**

After successfully creating the requirement, guide the user through the workflow:

1. **Create Git Branch**:

   ```bash
   git checkout -b feature/REQ-{id}-{description}
   ```

   - Include the requirement ID in the branch name
   - Enables auto-detection for future commands
   - Example: `feature/REQ-123-user-authentication`

2. **Build Implementation Plan**:

   ```bash
   braingrid requirement build REQ-{id} --format markdown
   ```

   - Exports the complete requirement with all task prompts
   - Markdown format is best for AI coding agents

3. **View in BrainGrid App**:
   - Click the URL to see the requirement in the web app
   - Review and refine as needed

**Workflow Context:**

The typical workflow after saving a plan:

1. **➡️ Save plan**: `/save-requirement "Plan Title"` (this command)
2. Create git branch: `git checkout -b feature/REQ-X-description`
3. Build implementation plan: `braingrid requirement build REQ-X`
4. Start implementation, updating task status as you go

**Example Interaction:**

```
User runs: /save-requirement Implement user authentication system
(Claude has a detailed plan in the conversation)

Claude:
1. Captures the plan content from conversation
2. Runs: braingrid requirement create --name "Implement user authentication system" \
   --content "{plan-content}"
3. Shows created requirement (REQ-123)
4. Suggests next steps:
   - git checkout -b feature/REQ-123-user-auth
   - braingrid requirement build REQ-123
```

**Alternative: Interactive mode**

```
User runs: /save-requirement
(No recent plan in conversation)

Claude:
1. Asks: "What should we call this requirement?"
2. User responds: "User authentication system"
3. Asks: "Please provide the plan content or describe what needs to be built"
4. User provides content
5. Creates requirement
6. Suggests next steps (create branch, build)
```

**Error Handling:**

If the command fails, handle reactively based on the error:

- **CLI not installed** (command not found): Guide through installation, then retry
- **Not authenticated**: Guide through login flow, then retry
- **No project**: Guide through init process, then retry
- **Content too long**: Suggest summarizing or splitting
- **API errors**: Show error message and suggest retry

**Success Criteria:**
✅ BrainGrid CLI is installed and authenticated
✅ Requirement created successfully with valid ID (REQ-XXX)
✅ Requirement is ready for implementation
✅ User understands the next steps in the workflow
✅ Offered to create branch and build implementation plan

**Final Output:**

After successful requirement creation, show:

- ✅ Requirement saved: REQ-{id}
- 📋 Name: {requirement name}
- 🔄 Status: {status from API response}
- 📁 Project: {project name}
- 🔗 View: https://app.braingrid.ai/requirements/overview?id={requirement-uuid}&tab=requirements

Note: Extract the requirement UUID from the command output to construct the URL.

**Next Steps:**

1. Create git branch: `git checkout -b feature/REQ-{id}-{description}`
2. Build implementation plan: `braingrid requirement build REQ-{id}`

**Ask**: "Would you like me to create a branch and build the implementation plan?"

**Difference from `/specify`:**

- Use `/specify` when you have a vague idea that needs AI refinement
- Use `/save-requirement` when you have a detailed plan ready to implement
