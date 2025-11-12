Fetch a requirement's complete implementation plan and start building it with additional context.

## Instructions

1. **Get the requirement ID:**
   - Check if provided in command arguments (first argument)
   - Accept flexible formats: `REQ-123`, `req-123`, or `123`
   - If not provided, try to auto-detect from git branch name (e.g., `feature/REQ-123-description`)
   - If auto-detection fails, ask user for requirement ID

2. **Parse additional instructions:**
   - Everything after the requirement ID is additional context/instructions
   - Example: `/build REQ-123 focus on security and add comprehensive tests`
   - These instructions guide the implementation approach
   - If no additional instructions provided, just show the build plan

3. **Execute the BrainGrid CLI command:**

   ```bash
   braingrid requirement build REQ-{id} --format markdown
   ```

   Available formats:
   - `markdown` (default) - Full content with task prompts, best for AI coding tools
   - `json` - Structured data for scripting
   - `xml` - Alternative structured format
   - `table` - Compact view for quick reference

4. **Handle errors reactively:**
   - If CLI not installed: Guide user to `npm install -g @braingrid/cli`
   - If not authenticated: Guide user through `braingrid login`
   - If no project initialized: Guide user to run `braingrid init`
   - If requirement not found: Suggest running `braingrid requirement list`
   - For other errors: Display error message and suggest solutions

5. **Use additional instructions (if provided):**
   - Acknowledge what context was provided
   - Review tasks with the additional context in mind
   - Highlight relevant tasks or add notes
   - Example: If user said "focus on security", emphasize security-related tasks

6. **After successful build fetch:**
   - Display the requirement details (ID, name, status, description)
   - Show all tasks with full prompts
   - Report task count
   - Extract requirement UUID for URL construction
   - If additional instructions provided, apply them to the implementation plan

7. **Suggest next steps:**
   - Create git branch: `git checkout -b feature/REQ-{id}-description` (if not on one)
   - Review task prompts in the output
   - Start implementing tasks
   - Update task status: `braingrid task update TASK-{id} --status IN_PROGRESS`
   - Update requirement status: `braingrid requirement update REQ-{id} --status IN_PROGRESS`
   - Ask if user wants help implementing specific tasks

## Example 1: Basic Build

Command: `/build REQ-123`

Execute: `braingrid requirement build REQ-123 --format markdown`

Output: Complete requirement with all task prompts

Next steps: Review tasks and start implementing

## Example 2: With Additional Instructions

Command: `/build REQ-123 focus on security best practices and add extensive error handling`

Execute: `braingrid requirement build REQ-123 --format markdown`

Then:

- Acknowledge: "I'll focus on security best practices and add extensive error handling"
- Review tasks and highlight security-related ones
- Suggest starting with auth/security tasks first
- Offer: "Would you like me to start implementing with security as the priority?"

## Example 3: Auto-detect from Branch

Command: `/build` (on branch `feature/REQ-456-api-integration`)

Execute: `braingrid requirement build --format markdown`

CLI auto-detects REQ-456 from branch name

## Output Format

After successful build:

- ✅ Build plan fetched: REQ-{id}
- 📋 Name: {requirement name}
- 🔄 Status: {current status}
- 📋 Tasks: {count} tasks ready for implementation
- 🔗 View requirement: https://app.braingrid.ai/requirements/overview?id={uuid}&tab=requirements
- 🔗 View tasks: https://app.braingrid.ai/requirements/overview?id={uuid}&tab=tasks

If additional instructions provided:

- 📝 Context: {additional instructions}
- Highlight relevant tasks
- Offer to start implementing
