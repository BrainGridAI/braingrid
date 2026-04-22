---
name: bg-fix-conflicts
description: Resolve merge conflicts between the current branch and main. Use when the workspace is in CONFLICT state after an automatic rebase failed. Detects, resolves, commits, and pushes — no feature work.
allowed-tools: Bash(git:*), Bash(yarn:*), Bash(npm:*), Read, Write, Edit, Grep, Glob
argument-hint: (no args — operates on current branch)
---

You have one job: bring the current branch up to date with `origin/main` and resolve any merge conflicts.

**Preconditions (bail early with a clear message if any fail):**
1. Current branch is not `main` or `HEAD` (detached): `git rev-parse --abbrev-ref HEAD`
2. Working tree is clean (`git status --porcelain` empty, or only the in-progress merge)
3. No merge already in progress other than one you're about to continue — check `.git/MERGE_HEAD`

**Workflow:**

1. `git fetch origin main`
2. `git merge origin/main --no-edit` (merge policy — do NOT rebase)
3. Clean merge → jump to step 6.
4. Conflicts present (`git status --porcelain` shows `UU` entries):
   - For each conflicted file:
     - Read the file and locate `<<<<<<<` / `=======` / `>>>>>>>` markers.
     - Understand both sides (the current branch's intent + main's intent).
     - Produce a merged version that preserves intent from both sides. Prefer:
       - main's version for platform/config/generated files (lockfiles, migrations already applied elsewhere, schema files).
       - the feature branch's version for in-progress feature code unique to this branch.
       - a true merge when both sides made substantive, compatible changes.
     - Remove all conflict markers.
     - `git add <file>`
   - Do not edit files that are not in the conflict list.
5. Finalize the merge: `git commit --no-edit` (preserves the default merge commit message).
6. Validate: run `yarn validate:fix` (or the project's equivalent from package.json). If it fails because of your resolution, fix those issues. If it fails for reasons pre-existing on either branch, report in your summary but don't attempt to fix them here.
7. `git push origin <current-branch>`.
8. Print a concise summary:
   - Files touched during conflict resolution (one-line rationale each).
   - Whether validation passed.
   - The merge commit SHA.

**When to ask the user (don't silently guess):**
- Semantic conflict where both sides made substantive changes to the same logic and picking one would lose intent.
- Breaking API change on both sides (signature, schema, contract) where merging either way affects behaviour.
- Ambiguous intent — conflict text is unclear and both sides look correct.

Keep the tree in its conflicted state while asking. The user can respond in chat; incorporate their answer and continue. Do **not** abort the merge just to unblock yourself — only abort if the user explicitly asks or a hard failure mode below triggers.

**Hard failure modes — abort and stop:**
- Validation fails due to your merge resolution and you can't fix it after reasonable effort: `git merge --abort`, report, stop.
- `git push` rejected (non-fast-forward, etc.): do not force-push. Report and stop.
- User explicitly asks you to abort.

**Out of scope — do not do any of these:**
- Open a pull request.
- Make feature changes unrelated to resolving conflicts.
- Rebase instead of merge.
- Force-push under any circumstance.
- Continue with general builder work after the merge. This skill is the whole mission.
