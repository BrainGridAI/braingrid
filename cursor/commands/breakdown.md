Break down a requirement into perfectly-prompted, AI-ready implementation tasks using BrainGrid.

## Instructions

1. **Get the requirement ID:**
   - Check if provided in command arguments
   - If not provided, try to auto-detect from git branch name (e.g., `feature/REQ-123-description`)
   - If auto-detection fails, ask user for requirement ID
   - Accept flexible formats: `REQ-123`, `req-123`, or `123`

2. **Execute the BrainGrid CLI command:**

   ```bash
   braingrid requirement breakdown REQ-{id}
   ```

   For detailed progress output:

   ```bash
   braingrid requirement breakdown REQ-{id}
   ```

3. **Handle errors reactively:**
   - If CLI not installed: Guide user to `npm install -g @braingrid/cli`
   - If not authenticated: Guide user through `braingrid login`
   - If requirement not found: Suggest running `braingrid requirement list`
   - For other errors: Display error message and suggest solutions

4. **After successful breakdown:**
   - Display the number of tasks created
   - Show task IDs and titles
   - Provide URL to view tasks in BrainGrid web app
   - Suggest next steps:
     - `braingrid task list -r REQ-{id}` to view full task details
     - `braingrid requirement build REQ-{id}` to get complete implementation plan
     - `braingrid requirement update REQ-{id} --status IN_PROGRESS` to mark as in progress

## Example

Command: `/breakdown REQ-234`

Execute: `braingrid requirement breakdown REQ-234`

Output: "✅ Created 6 tasks for REQ-234"

Next steps:

- `braingrid task list -r REQ-234`
- `braingrid requirement build REQ-234`
