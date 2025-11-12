Create a detailed, AI-refined requirement specification using the BrainGrid CLI.

## Instructions

1. **Get the requirement prompt from the user** (if not already provided in the command arguments)
   - Prompt should be 10-5000 characters
   - Should include problem statement, context, constraints, users, and success criteria

2. **Execute the BrainGrid CLI command:**

   ```bash
   braingrid requirement specify --prompt "<user's prompt>"
   ```

3. **Handle errors reactively:**
   - If CLI not installed: Guide user to install with `npm install -g @braingrid/cli`
   - If not authenticated: Guide user through `braingrid login`
   - If no project initialized: Guide user to run `braingrid init`
   - For other errors: Display error message and suggest solutions

4. **After successful creation:**
   - Display the created requirement ID (e.g., REQ-123)
   - Show the requirement name and status
   - Provide the URL to view in BrainGrid web app
   - Suggest next steps:
     - `braingrid requirement breakdown REQ-{id}` to break into tasks
     - `git checkout -b feature/REQ-{id}-description` to create branch
     - `braingrid requirement build REQ-{id}` to get implementation plan

## Example

User prompt: "Add user authentication with OAuth2, password reset, and email verification"

Execute: `braingrid requirement specify --prompt "Add user authentication with OAuth2, password reset, and email verification"`

Output: "✅ Created requirement REQ-234: User Authentication System"

Next steps:

- `braingrid requirement breakdown REQ-234`
- `git checkout -b feature/REQ-234-user-auth`
