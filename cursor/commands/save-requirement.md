Save a requirement plan or specification to BrainGrid.

## Instructions

1. **Get the requirement content:**
   - If the user provides a title argument, prompt for the full requirement content
   - Accept content from:
     - Editor selection (highlighted text)
     - User input (paste or type)
     - Current conversation context
   - Content should include:
     - Title/name
     - Description
     - Goals or objectives
     - Functional requirements
     - Acceptance criteria (optional)

2. **Execute the BrainGrid CLI command:**

   For new requirements:

   ```bash
   braingrid requirement create --name "<title>" --description "<content>"
   ```

   For updating existing requirements:

   ```bash
   braingrid requirement update REQ-{id} --description "<content>"
   ```

3. **Handle errors reactively:**
   - If CLI not installed: Guide user to `npm install -g @braingrid/cli`
   - If not authenticated: Guide user through `braingrid login`
   - If no project initialized: Guide user to run `braingrid init`
   - If validation errors: Show which fields are invalid and provide guidance
   - For other errors: Display error message and suggest solutions

4. **After successful save:**
   - Display the requirement ID (e.g., REQ-123)
   - Show the requirement name and status
   - Provide the URL to view in BrainGrid web app
   - Suggest next steps:
     - `braingrid requirement breakdown REQ-{id}` to break into tasks
     - `braingrid requirement build REQ-{id}` to get implementation plan
     - `git checkout -b feature/REQ-{id}-description` to create branch

## Example

User provides title: "User Authentication System"

Prompt for content, then execute:

```bash
braingrid requirement create --name "User Authentication System" --description "Add OAuth2 authentication with password reset and email verification. Include JWT token management and session handling."
```

Output: "✅ Created requirement REQ-123: User Authentication System"

Next steps:

- `braingrid requirement breakdown REQ-123`
- `git checkout -b feature/REQ-123-user-auth`
