# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.58] - 2026-03-06

### Added

- **Frontmatter fields for build skill** — added frontmatter metadata to the `/build` skill for improved skill discovery and configuration

### Fixed

- **Vercel protection bypass header missing from auth API calls** — added the `x-vercel-protection-bypass` header to authentication requests so the CLI can reach Vercel-protected dev/staging environments

## [0.2.57] - 2026-03-03

### Fixed

- **Missing build skill** — added build skill that was not included in previous release

## [0.2.56] - 2026-03-03

### Changed

- **`/build` converted from command to skill** — moved `.claude/commands/build.md` to `.claude/skills/build/skill.md` with skill-style frontmatter; setup handler now auto-detects and removes the deprecated command file on install, init, and update paths
- **Removed `braingrid requirement build` and `braingrid requirement breakdown` CLI commands** — build workflow now handled entirely by the `/build` skill; `/specify` and `/save-requirement` updated to reference the skill
- **Updated E2E and unit tests** — setup tests now expect 5 skill directories and validate deprecated file cleanup

## [0.2.55] - 2026-02-26

### Fixed

- **SSH git remote URLs rejected by Zod validation** — `loadProjectConfig()` failed when `.braingrid/project.json` contained an SSH URL (`git@github.com:owner/repo.git`) because Zod's `.url()` validator only accepts WHATWG URLs; relaxed to `.string()` since the field is informational

## [0.2.54] - 2026-02-25

### Added

- **Logger file writing enabled by default** — `logToFile` now defaults to `true` so all `logger.debug()` calls in auth, JWT, and services actually write to `~/.braingrid/logs/braingrid-cli.log`
- **Silent catch block logging** — 7 catch blocks in `auth.ts` and 1 in `jwt.ts` that silently swallowed errors now log debug messages with error context
- **jq installer** — new cross-platform `jq-installer.ts` following the established git/gh installer pattern; `braingrid init` now checks for and offers to install jq (required by all hooks)
- **jq in CLI tools registry** — `braingrid status` now shows jq version in "Installed Coding Tools" section
- **Hook error wrapper** — new `log_braingrid_call()` function in `log-helper.sh` captures stderr separately and logs failed CLI calls with exit codes
- **Hook jq availability check** — `log-helper.sh` warns on stderr if jq is not installed
- **Hook early-exit logging** — sentinel and status skip conditions now log INFO events for audit trail
- **Hook SIGTERM traps** — `sync-braingrid-task.sh` and `create-braingrid-task.sh` log timeout kills instead of dying silently
- **JSON validation in sync hook** — validates `jq` can parse task list output before processing
- **Debug Logs section in status** — `braingrid status` now shows CLI log and hook log file paths with sizes
- **Log correlation** — Logger supports optional `sessionId` for requirement-scoped log entries
- **Flush guarantee** — `flushLogger()` in cli-logger ensures write stream is drained before closing, with 1-second safety timeout

### Fixed

- **`$?` capture bug** — `sync-braingrid-task.sh` and `create-braingrid-task.sh` captured exit code after `log_time_end` (which reset `$?` via `date`)
- **Error formatter `[object Object]`** — plain objects now JSON.stringify instead of showing `[object Object]`
- **Error formatter context** — regular `Error` objects now include resource context prefix when provided

### Changed

- **Error formatter** — stack traces logged at debug level for Error objects

## [0.2.53] - 2026-02-25

### Added

- **Structured hook logging** — new leveled log format (`HH:MM:SS [LEVEL] hook | event | details`) with INFO/WARN/ERROR levels across all build hook scripts
- **REQ-X prefixed temp files** — build-debug.log, build-verification, and verify-prev-unchecked files now use REQ-X prefix for multi-build isolation
- **Build session delimiter** — log files show `=== BUILD REQ-X started ... ===` separator when a new build begins
- **Comprehensive hook coverage** — every hook now logs start, decision, and early exits; `post-task-update-prompt` previously had zero logging
- **CLI debug logging** — new `cli-logger.ts` utility with structured debug logs for `braingrid init` and `braingrid setup` commands (writes to `.braingrid/temp/init-debug.log` and `.braingrid/temp/setup-debug.log`)
- **GitHub API logging** — log retries, auth fallbacks, and file fetches in setup-service

### Fixed

- **Silent error swallowing** — five catch blocks in init/setup handlers that discarded errors now log them with full context
- **Session delimiter race** — delimiter check now runs before `exec 2>>` redirect which was creating the file prematurely
- **Empty REQ_ID fallback** — `verify-acceptance-criteria` falls back to unprefixed paths when sentinel is empty instead of producing malformed paths
- **Double initLogger leak** — guard against file descriptor leak when init triggers setup (which re-initializes the logger)

### Changed

- **Log noise reduction** — removed noisy SKIP log entries from sync-braingrid-task for non-status TaskUpdate calls

## [0.2.52] - 2026-02-24

### Fixed

- **Project discovery** — surface real error when `.braingrid/project.json` exists but fails to load (e.g., corrupted JSON, Zod validation error) instead of misleading "no local project found" message

### Changed

- **Docs** — sync OpenAPI spec from braingrid-app

## [0.2.51] - 2026-02-23

### Fixed

- **Docs sync** — add `log-helper.sh` to docs sync script so it gets distributed to the BrainGridAI/braingrid repo alongside hook scripts

## [0.2.50] - 2026-02-23

### Fixed

- **Setup GitHub auth** — fall back to unauthenticated requests when `gh auth` token is expired, instead of failing every API call with 401

## [0.2.49] - 2026-02-23

### Added

- **Build command** — save requirement content to temp file for context persistence across build sessions

### Fixed

- **Setup hooks** — distribute `log-helper.sh` utility script alongside hook scripts so hooks don't fail with "No such file or directory"

## [0.2.48] - 2026-02-23

### Added

- **Frontend design skill** — new skill for creating production-grade frontend interfaces with design system references (color, typography, spacing, shadows, layout, accessibility, icons)
- **UX skill** — new skill for designing excellent UX across web, mobile, and CLI with pattern references (forms, navigation, search, feedback, wizards, states, lists/tables)

### Changed

- **Setup command** — `braingrid setup claude-code` now installs frontend-design and ux skills alongside braingrid-cli skill
- **Docs sync** — sync script updated to distribute both new skills to BrainGridAI/braingrid repo (17 → 39 files)

## [0.2.47] - 2026-02-20

### Fixed

- **Build hooks** — enforce git push before build session exit, source shared log-helper instead of duplicating logging setup

## [0.2.46] - 2026-02-20

### Fixed

- **Build sync errors** — log sync errors and add bulk status fallback
- **Cut-release command** — restore `/cut-release` slash command lost during previous refactor

## [0.2.45] - 2026-02-20

### Fixed

- **Slash command plan reading** — read plan from `~/.claude/plans/` instead of conversation transcript
- **Build task creation** — enforce sequential task creation to avoid hook runner errors

### Changed

- **Settings formatting** — reformat settings.json to use tabs for consistency

## [0.2.44] - 2026-02-17

### Fixed

- **Hardened verify-acceptance-criteria.sh** — added `cleanup()` function replacing 7 inline `rm -f` calls; moved ERR/SIGINT/SIGTERM trap before first file check to prevent orphan sentinel files; sanitized `grep -c` output with `${VAR//[^0-9]/}` to prevent arithmetic errors
- **POSIX portability** — replaced non-standard `\s` with `[[:space:]]` in grep patterns
- **CRLF safety** — strip `\r` from YAML frontmatter parsing for Dropbox sync compatibility
- **Build task naming** — aligned task subject templates with `TASK N` naming convention

### Added

- **E2E test script for setup** — added test-setup skill and E2E test script for `braingrid setup claude-code`
- **Stale sentinel cleanup** — delete build sentinel when no state file exists

## [0.2.43] - 2026-02-17

### Fixed

- **grep -c newline bug in verify-acceptance-criteria.sh** — `grep -c` exits non-zero on 0 matches, causing `|| echo "0"` to produce `"0\n0"` artifacts that break arithmetic expansion; replaced with `|| true` and `${VAR:-0}` default

## [0.2.42] - 2026-02-17

### Added

- **SessionStart and TaskCompleted hook installation** — `braingrid setup claude-code` now installs two additional hook scripts: `check-stale-build-sentinel.sh` (SessionStart) for cleaning up stale build sentinels, and `task-completed-validate.sh` (TaskCompleted) for commit validation before marking tasks complete
- **Sync script updated** — `sync-claude-code-to-braingrid.sh` now syncs 16 files (up from 14), including the two new hook scripts

## [0.2.41] - 2026-02-17

### Fixed

- **Tasks invisible to teammates in parallel build mode** — reordered `/build` command to discover tasks and select mode before calling `TaskCreate`; in parallel mode, `TeamCreate` now runs first so tasks land in the team's task list instead of the default session list
- **Acceptance criteria format** — checklist files now use `## Acceptance Criteria` heading with `- []` list items; updated `verify-acceptance-criteria.sh` grep patterns to match new format
- **Renamed teammate agents** — parallel build teammates renamed from `builder-{n}` to `braingrid-builder-{n}` for clarity

### Changed

- **Update handler uses subprocess for IDE setup** — `braingrid update` now runs IDE setup via a spawned subprocess so the newly installed binary is used instead of the old code still loaded in memory

## [0.2.40] - 2026-02-17

### Fixed

- **Converted prompt-type hooks to command-type in setup service**
  - `braingrid setup claude-code` now generates command-type hooks pointing to shell scripts instead of inline prompt-type hooks, matching the local `.claude/settings.json` configuration
  - Affected hooks: PostToolUse TaskUpdate prompt, PreToolUse TaskCreate, PreToolUse TaskUpdate
  - Setup now fetches and installs 3 additional hook scripts: `pre-task-create-naming.sh`, `pre-task-update-instructions.sh`, `post-task-update-prompt.sh`
- **Added missing hook scripts to docs sync**
  - `verify-acceptance-criteria.sh`, `pre-task-create-naming.sh`, `pre-task-update-instructions.sh`, and `post-task-update-prompt.sh` are now synced to the remote repository

## [0.2.39] - 2026-02-17

### Fixed

- **Restored lost prompt guidance in command hooks**
  - `pre-task-create-naming.sh` now outputs `additionalContext` on valid path with sequential numbering instructions, concrete examples, and blocked-by suffix guidance
  - `pre-task-update-instructions.sh` completed-path guidance enriched with project config detection examples and blocked-by stripping example
  - Converting prompt-type hooks to command-type hooks had lost behavioral guidance that Claude relied on; this restores it via `additionalContext`

## [0.2.38] - 2026-02-17

### Added

- **`--content` option for `requirement update` command**
  - Allows updating a requirement's content directly from the CLI with `--content`
- **Parallel mode with agent teams for `/build` command**
  - `/build` now supports a parallel execution mode that spawns agent teams for concurrent task implementation
- **Verify acceptance criteria hook in Claude Code setup**
  - `braingrid setup claude-code` now installs a hook that verifies acceptance criteria during builds
- **PostToolUse TaskUpdate prompt hook in Claude Code setup**
  - Setup installs a prompt hook that updates task status on PostToolUse events

### Changed

- **Synced README and Claude Code guide with CLI implementation**
  - Documentation updated to reflect latest CLI features and usage

## [0.2.37] - 2026-02-14

### Added

- **Add `.braingrid/temp/` to `.gitignore` during update**
  - `braingrid update` now ensures `.braingrid/temp/` is in `.gitignore` (previously only `init` did this)
  - Runs in both the "already up-to-date" and "after successful update" code paths

### Changed

- **Per-directory install counts in setup success message**
  - Setup success message now shows "Commands: 4" and "Skills: 1" instead of "Commands: 6 files"
  - Each skill directory counts as 1 skill regardless of supporting files inside it
  - Cursor setup shows separate "Commands" and "Rules" counts

### Refactored

- **Extract `addBraingridTempToGitignore` to shared utility**
  - Moved from `init.handlers.ts` to `src/utils/gitignore.ts` for reuse across handlers

## [0.2.36] - 2026-02-14

### Added

- **Add `.braingrid/temp/` to `.gitignore` during init**
  - `braingrid init` now automatically appends `.braingrid/temp/` to the project's `.gitignore`
  - Prevents session-specific temp files (e.g., acceptance criteria checklists) from being committed
  - Skips if the entry already exists; creates `.gitignore` if none exists

### Fixed

- **Always offer Claude Code setup updates during init**
  - `braingrid init` now prompts to update Claude Code integration even when it's already installed
  - Ensures users get the latest slash commands, skills, and status line configuration

## [0.2.35] - 2026-02-14

### Added

- **Acceptance criteria extraction in `/build` skill**
  - `/build` now parses the `## Acceptance Criteria` section from requirement content
  - Extracts all criteria into a flat `[]` checklist at `.braingrid/temp/REQ-{id}-acceptance-criteria.md`
  - Handles both flat and sub-sectioned (`###` headings) criteria formats
  - Strips markdown bold formatting and collapses multi-line criteria
  - Added `Write` to allowed tools in build command

### Fixed

- **Add `create-braingrid-task.sh` to Claude Code sync script**
  - The setup handler was fetching this hook from GitHub but the sync script never pushed it
  - Without this fix, `braingrid setup claude-code` would fail to install the TaskCreate hook

## [0.2.34] - 2026-02-05

### Fixed

- **Deep merge `.claude/settings.json` during setup**
  - `updateClaudeSettings()` now deep-merges statusLine and hooks instead of overwriting
  - Preserves user customizations (extra pipes, additional hooks, other event types)
  - Updates TaskUpdate hook in-place without duplicating entries
  - Gracefully handles malformed hooks (non-object) and PostToolUse (non-array)
  - Removed stale `| bunx cc-safety-net --statusline` pipe from default settings

## [0.2.33] - 2026-02-03

### Changed

- **README documentation update**
  - Updated "What gets installed" section to document all Claude Code setup files
  - Added status line script (`.claude/statusline.sh`)
  - Added hook script (`.claude/hooks/sync-braingrid-task.sh`)
  - Added settings configuration (`.claude/settings.json`)

## [0.2.32] - 2026-02-03

### Added

- **Hooks configuration in settings.json**
  - `braingrid setup claude-code` now configures PostToolUse hooks in `.claude/settings.json`
  - Hooks trigger sync-braingrid-task.sh on TaskUpdate events with 10s timeout
  - Enables automatic task status synchronization between Claude Code and BrainGrid

## [0.2.31] - 2026-02-03

### Added

- **Hook script installation during setup**
  - `braingrid setup claude-code` now installs sync-braingrid-task.sh hook
  - Hook automatically syncs task status between Claude Code and BrainGrid
  - Installed to `.claude/hooks/` with executable permissions

## [0.2.30] - 2025-02-02

### Fixed

- **Validation error handling crash**
  - Fixed `TypeError: errors is not iterable` when API returns single string errors
  - Error handler now handles both array and string formats for validation errors

## [0.2.29] - 2025-02-02

### Added

- **Tree view for requirements listing**
  - `requirement list --tree` displays requirements with nested tasks
  - Shows task status indicators and completion counts
  - Hierarchical view improves requirement-to-task visibility

- **Automatic context detection for specify command**
  - Detects project context from `.braingrid/project.json`
  - Auto-enhances prompts with relevant codebase context
  - Improves AI-generated requirement quality

- **Auto-generated tab completions**
  - Tab completions now generated from CLI command definitions
  - Ensures completions stay in sync with available commands
  - Run `pnpm generate:completions` to regenerate

### Changed

- **Task status synchronization**
  - Requirement status now auto-syncs when all tasks are completed
  - Status sync hook triggers on task status updates

- **Breakdown command validation**
  - Prevents breakdown of requirements that already have tasks
  - Avoids duplicate task generation

### Fixed

- **Build configuration**
  - Removed stale mapping file reference from build

### Tests

- **Comprehensive tests for review acceptance handler**
  - Added full test coverage for `handleReviewAcceptance`

## [0.2.28] - 2025-01-28

### Added

- **Tag management CLI commands for requirements**
  - `requirement tag list [id]` - List all tags for a requirement
  - `requirement tag add [id] --name <name> --color <hex>` - Add a tag with name and hex color
  - `requirement tag remove [id] --name <name>` - Remove a tag by name
  - All commands support auto-detection of requirement ID from git branch
  - Multiple output formats supported (table, json, xml, markdown)
  - Hex color validation for #RGB and #RRGGBB formats

## [0.2.27] - 2025-01-27

### Added

- **Requirement tagging support**
  - New `--tags` option for `requirement create` and `specify` commands
  - Accepts comma-separated tags (max 5 per requirement)
  - Tags are validated, trimmed, and empty values filtered
  - Tags displayed in all output formats (table, markdown, XML, JSON)

## [0.2.26] - 2025-01-20

### Added

- **BRAINGRID_API_TOKEN environment variable support**
  - Enables authentication via JWT token for sandbox/CI environments
  - Allows CLI usage without interactive OAuth login flow
  - Useful for automated pipelines and testing scenarios

### Changed

- **README documentation updates**
  - Added `requirement create-branch` and `requirement review` commands to docs
  - Updated shell completion subcommands list

## [0.2.25] - 2025-12-22

### Added

- **New CLI commands for AI workflow integration**
  - `task specify` - Create new tasks from natural language prompts using AI
  - `requirement create-branch` - Create git branches for requirements via GitHub API
  - `requirement review` - Stream AI-powered acceptance review for pull requests

- **Branch name generation enhancements**
  - Auto-generates branch names: `{username}/REQ-123-slugified-name`
  - Slugifies username from email prefix to handle special characters (e.g., `john+test@` → `john-test`)

- **PR auto-detection for review command**
  - Automatically detects PR number from current branch using `gh pr view`
  - Falls back to interactive prompt if no PR is found

### Fixed

- **Empty PR number handling**
  - Fixed edge case where `gh pr view` returns empty string (branch has no associated PR)
  - Now properly triggers fallback to interactive PR number input

## [0.2.24] - 2025-12-18

### Added

- **Status line task name display**
  - Shows task title in status line: `TASK 19: Implement feature (Planned)`
  - Task info (number, name, status) displayed in yellow
  - Task counts `[x/y]` displayed in green (matches REQ color)

### Changed

- **OAuth callback server binding**
  - Binds to `0.0.0.0` instead of `127.0.0.1` for broader accessibility

## [0.2.23] - 2025-12-18

### Added

- **Automatic README.md installation**
  - Copies `.braingrid/README.md` documentation during `init`, `update`, and `setup` commands
  - Ensures users always have the latest BrainGrid integration documentation
  - Fails silently if GitHub is unreachable (non-blocking operation)

## [0.2.22] - 2025-12-18

### Added

- **Task commands documentation**
  - Added `braingrid task` command examples to CLAUDE.md and AGENTS.md
  - Documents `task list`, `task show`, and `task update` usage

### Changed

- **IDE integration update prompts**
  - Now prompts for IDE integration updates even when CLI is already up to date
  - Ensures users can update BrainGrid integration files independently of CLI version

- **Token efficiency optimizations**
  - Optimized AGENTS.md and CLAUDE.md for reduced token usage
  - Moved README.md from `.claude/` to `.braingrid/` for better organization

### Fixed

- **Duplicate BRAINGRID INTEGRATION markers**
  - Fixed issue where setup could add duplicate integration markers to CLAUDE.md
  - Content injection now properly checks for existing markers before adding

- **Flaky test in cli-tools**
  - Fixed parallel timing assertion test that was too strict (50ms → 100ms threshold)
  - Prevents intermittent test failures in CI environments

## [0.2.21] - 2025-12-18

### Fixed

- **Status line TASK null bug**
  - Fixed jq query returning `TASK null` when no IN_PROGRESS tasks exist
  - Added `select(. != null)` after `first` to properly trigger fallback to PLANNED tasks

### Changed

- **Setup prompt default option**
  - "Overwrite all" is now the first/default option in file conflict prompts
  - Makes it easier to update all BrainGrid integration files at once

## [0.2.20] - 2025-12-18

### Added

- **IDE setup prompts after update**
  - After running `braingrid update`, CLI detects installed Claude Code and Cursor
  - Prompts user to update BrainGrid integration for each detected IDE
  - Uses force mode to streamline the setup process

### Changed

- **Enhanced status line display**
  - Task display now shows status: `TASK 19 (In-Progress)` or `(Planned)`
  - Added third line showing current git branch: `Branch: feature/REQ-12-something`

## [0.2.19] - 2025-12-17

### Added

- **Pagination options for task commands**
  - Added `--page` and `--limit` options to `task list` and `task summary` commands
  - Consistent with existing pagination options on `requirement list`

### Changed

- **has_more pagination warnings**
  - Task and requirement list commands now show a warning when more items exist beyond current page
  - Warning message: "⚠️ More tasks/requirements exist. Use --limit to see more."
  - `getCurrentTask` auto-detection warns if results may be incomplete due to pagination

- **Status line uses higher limit**
  - Claude Code status line script now fetches up to 100 tasks for accurate counts
  - Ensures task progress display `[completed/total]` is accurate for larger requirements

## [0.2.18] - 2025-12-17

### Added

- **Current task auto-detection**
  - `task show` now works without a task ID - automatically detects the current task
  - `task update` now works without a task ID - updates the current task
  - Current task is determined by: first IN_PROGRESS task, or first PLANNED task if none in progress
  - `task delete` still requires explicit task ID for safety

- **Status line shows current task**
  - Claude Code status line now displays: `BrainGrid: PROJ-X > REQ-Y > TASK-Z [completed/total]`
  - Shows the current task being worked on alongside progress count
  - Automatically updates as tasks are completed

## [0.2.17] - 2025-12-17

### Added

- **Update notifications and interactive prompts**
  - CLI now shows update warning after every command when a newer version is available on npm
  - New interactive update prompt at the start of `braingrid init` offers to update before proceeding
  - Version check results are cached for 12 hours to minimize network requests
  - Silent failure on network errors ensures CLI functionality is never impacted
  - Extracted reusable version utilities for consistent version handling across the CLI

## [0.2.16] - 2025-12-17

### Added

- **--format option for show commands**
  - Added `--format` option to `requirement show` command
  - Added `--format` option to `task show` command
  - Supports all standard formats: table (default), json, xml, markdown
  - Consistent with other commands that already support `--format`

## [0.2.15] - 2025-12-15

### Changed

- **CI/CD: Switch to OIDC-based npm publishing**
  - GitHub Actions workflow now uses OpenID Connect (Trusted Publishing) for npm authentication
  - No longer requires NPM_TOKEN secret - authentication is handled via OIDC
  - More secure and eliminates token expiration issues

## [0.2.14] - 2025-12-15

### Added

- **Requirement auto-detection for task commands**
  - Task commands now auto-detect the requirement ID from git branch names (e.g., `feature/REQ-123-something` → `REQ-123`)
  - Matches the existing behavior of requirement commands
  - Applies to all task commands: `list`, `summary`, `show`, `create`, `update`, `delete`
  - Explicit `-r/--requirement` flag still works and takes precedence over auto-detection

## [0.2.13] - 2025-12-08

### Added

- **Shell tab completion support**
  - Added `braingrid completion` command to generate shell completion scripts
  - Support for bash and zsh shells (fish support planned for future release)
  - Automated setup with `braingrid completion --setup` flag
  - Auto-detects shell from `$SHELL` environment variable
  - Completes commands, subcommands, options, and values
  - Includes status values (IDEA, PLANNED, IN_PROGRESS, REVIEW, COMPLETED, CANCELLED)
  - Includes format options (table, json, xml, markdown)
  - Comprehensive documentation in README.md with installation instructions
  - Uses omelette library for cross-shell compatibility

## [0.2.12] - 2025-12-05

### Changed

- **Production authentication domain updated**
  - Updated production WorkOS auth URL from `sensitive-harvest-60.authkit.app` to `auth.braingrid.ai`
  - Custom domain provides better branding and user trust during OAuth login flow
  - Development auth domain remains unchanged

### Improved

- **Test maintainability for config tests**
  - Extracted mock configuration objects into reusable constants (`MOCK_PROD_CONFIG`, `MOCK_DEV_CONFIG`)
  - Reduced code duplication in `config.test.ts`
  - Test assertions now reference constants instead of hardcoded strings

## [0.2.11] - 2025-11-25

### Fixed

- **Claude Code skill installation path**
  - Fixed issue where skill files were installed to nested directory (`.claude/skills/braingrid-cli/braingrid-cli`)
  - Skills now correctly install to flat directory structure (`.claude/skills/braingrid-cli/`)
  - Updated sourceDirs configuration to start recursive walk from skill directory itself
  - Ensures proper skill detection and loading in Claude Code

## [0.2.10] - 2025-11-25

### Fixed

- **Organization ID handling in project initialization**
  - Fixed issue where `organization_id` was set to "default" in `.braingrid/project.json`
  - Login flow now automatically fetches organization ID from validation endpoint when missing from JWT token
  - Init command validates and fixes any existing sessions with "default" organization_id
  - Added clear user feedback with warnings and success messages during organization ID updates
  - Prevents invalid "default" organization IDs from being stored in project configuration

### Changed

- **Enhanced breakdown command documentation**
  - Added patience messages to both Claude Code and Cursor breakdown slash commands
  - Commands now explicitly instruct AI agents to wait 1-3 minutes for AI task generation
  - Prevents AI agents from prematurely aborting breakdown operations before completion
  - Improves reliability of AI-powered task breakdown workflow

## [0.2.9] - 2025-11-12

### Fixed

- **Documentation URLs updated to docs subdomain**
  - Updated Claude Code documentation URL from `https://braingrid.ai/docs/claude-code` to `https://docs.braingrid.ai/claude-code`
  - Updated Cursor documentation URL from `https://braingrid.ai/docs/cursor` to `https://docs.braingrid.ai/cursor`
  - URLs displayed in setup command success messages now point to correct documentation location
  - Affects `braingrid setup claude-code` and `braingrid setup cursor` output

## [0.2.8] - 2025-11-12

### Fixed

- **Recursive directory processing for setup commands**
  - Fixed critical bug where nested directories weren't installed during `braingrid setup claude-code`
  - Skills directory (`.claude/skills/braingrid-cli/`) now properly installed with all files
  - Added recursive `processDirectory()` helper to traverse subdirectory structures
  - Setup commands now correctly handle both files and nested directories from GitHub

### Changed

- **Enhanced skill reference in CLAUDE.md**
  - Expanded skill reference from 7 words to comprehensive 8-line section
  - Added engaging question format: "Need help with planning or requirements?"
  - Listed 5 specific benefits: guided workflows, best practices, proactive suggestions, examples, installation help
  - Added CLAUDE.md to sync script for distribution to users
  - Improves skill discoverability in Claude Code

- **Documentation improvements**
  - Removed deprecated `--verbose` flag references from all documentation
  - Added full CLI command reference to skill documentation
  - Updated project configuration with organization UUID

## [0.2.7] - 2025-11-11

### Fixed

- **Claude Code status line token usage accuracy**
  - Fixed token stats displaying "0k tokens" instead of actual context usage
  - Now parses transcript JSONL file to extract real token counts from API responses
  - Extracts token usage from last assistant message in conversation transcript
  - Sums all Anthropic API token types: input_tokens, output_tokens, cache_creation_input_tokens, cache_read_input_tokens
  - Uses 160K tokens (80% of 200K context limit) as auto-compact threshold for percentage calculation
  - Color coding now accurately reflects context usage: cyan (0-80%), yellow (80-90%), red (90-100%)
  - Provides real-time visibility into actual Claude Code context consumption

## [0.2.6] - 2025-11-11

### Added

- **Cursor IDE detection and setup prompts**
  - Cross-platform Cursor IDE detection (macOS, Windows, Linux)
  - Checks platform-specific app paths and config directories
  - Version detection via cursor CLI when available
  - Auto-prompts to install BrainGrid integration after `braingrid init`
  - Shows Claude Code and Cursor setup prompts when IDEs are detected
  - Skips prompt if integration files already exist
  - Graceful error handling with manual setup instructions

### Changed

- **Status command improvements**
  - Now shows only installed IDEs (cleaner output)
  - Removed "not installed" messages for undetected tools
  - Displays Claude Code and Cursor versions when detected
  - Focus on what's actually available in the environment

- **Claude Code status line enhancements**
  - Added "BrainGrid:" prefix to context line for clarity
  - Display model name at end of status line (e.g., "Sonnet 4.5")
  - Updated token format: "ctx: Xk tokens" instead of "Xk/XXXk tokens"
  - Improved JSON field extraction to match Claude Code's actual structure
  - Added RED color code for future high token usage warnings
  - Synced statusline.sh to distribution via sync script

### Fixed

- **Init flow message display**
  - Success message now uses console.log for better visibility
  - Return message simplified to show only next steps
  - Better spacing and formatting for IDE setup prompts

- **Status line token usage display**
  - Fixed token stats showing "0k tokens" instead of actual usage
  - Now parses transcript JSONL file to extract real token counts from API responses
  - Sums all token types: input, output, cache_creation, cache_read
  - Uses 160K tokens (80% of 200K) as auto-compact threshold for percentage calculation
  - Color coding now works correctly based on actual context usage

## [0.2.5] - 2025-11-11

### Fixed

- **Status line installation in setup command** (#38)
  - Fixed critical bug where `braingrid setup claude-code` failed to install status line
  - Changed to fetch `statusline.sh` from GitHub repository instead of local package
  - Fixed configuration format to use object with `type`, `command`, and `padding` fields
  - Removed unused `fileURLToPath` import from setup handlers
  - Status line now correctly installs and displays BrainGrid context in Claude Code

### Changed

- **CLAUDE.md injection source** (#38)
  - Setup command now fetches `claude-code/CLAUDE.md` instead of `claude-code/README.md`
  - Provides cleaner, more focused BrainGrid workflow instructions for injection
  - Injected content matches the curated `.claude/CLAUDE.md` format

- **AGENTS.md injection consistency** (#38)
  - Created `.cursor/AGENTS.md` with same BrainGrid workflow content as `.claude/CLAUDE.md`
  - Updated `cursor/AGENTS.md` in braingrid repo to match injection pattern (44 lines)
  - Both Claude Code and Cursor now follow consistent injection pattern
  - Provides unified BrainGrid workflow experience across both IDEs

## [0.2.4] - 2025-11-10

### Added

- **BrainGrid context in Claude Code status line** (#36)
  - Two-line status display showing project/requirement/task progress
  - Auto-detects from `.braingrid/project.json` and git branch names
  - Color-coded output: cyan for project, green for requirement, yellow for tasks
  - Displays current task completion (e.g., `PROJ-130 > REQ-128 [2/5]`)
  - Always shows workspace path, model name, and token usage
  - Installed automatically with `braingrid setup claude-code`

- **Setup commands for Claude Code and Cursor integrations** (#35)
  - New `braingrid setup claude-code` command installs slash commands and skills
  - New `braingrid setup cursor` command installs Cursor rules and commands
  - Fetches integration files from BrainGridAI/braingrid repository
  - Injects content into CLAUDE.md or AGENTS.md with markers
  - Interactive prompts for file conflicts with overwrite/skip/all/quit options
  - Dry-run mode with `--dry-run` flag
  - Force mode with `--force` flag to skip all prompts

- **Cursor IDE integration** (#34)
  - Added AGENTS.md standard for Cursor AI agent configuration
  - Supports auto-detection of project and requirement context
  - Works with agent mode for autonomous task execution

- **Claude Code sync automation** (#33)
  - New `pnpm docs:sync-claude` command syncs skills and slash commands
  - Automatically updates BrainGridAI/braingrid repository
  - Keeps Claude Code integration files in sync across repos

### Fixed

- **Status line script path resolution** (code review fixes)
  - Fixed critical bug using `import.meta.url` instead of `process.cwd()`
  - Script now loads from package location, not user's directory
  - Prevents "file not found" errors during setup

- **Shell script error handling**
  - Added `set -o pipefail` to status line script
  - Properly detects braingrid command failures in pipelines
  - More robust JSON parsing with better error detection

- **Token display formatting**
  - Fixed bug showing incorrect token counts (e.g., "24000k/200000k")
  - Now correctly displays as "24k/200k tokens"

## [0.2.3] - 2025-01-10

### Added

- New `task summary` subcommand for quick table overview without content
  - Use `braingrid task summary -r REQ-X` for compact task list
  - Complements full detail view with lightweight summary option

### Changed

- Simplified CLI output format with markdown as default
  - `requirement breakdown` now defaults to markdown format (was table)
  - `task list` now defaults to markdown format with full content (was table)
  - Removed `--verbose` flag - full content always shown by default for AI-ready output
  - Use `--format table` or new `task summary` command for compact view
- Updated `/breakdown` slash command documentation
  - Removed all `--verbose` flag references
  - Updated examples to use new default markdown format
  - Added references to `task summary` for quick overviews

## [0.2.2] - 2025-11-10

### Added

- Concise BrainGrid documentation for project injection (`.claude/CLAUDE.md`)
  - 42-line section explaining BrainGrid workflow for Claude Code
  - Slash commands reference and typical workflow
  - Key features (auto-detection, reactive errors, status flows, output formats)
- BrainGrid CLI slash commands for Claude Code
  - `/specify [prompt]` - Create AI-refined requirement from vague idea
  - `/save-requirement [title]` - Save detailed plan as requirement
  - `/breakdown [req-id]` - Break requirement into AI-prompted tasks
  - `/build [req-id]` - Get complete implementation plan in markdown
  - `/cut-release [patch|minor|major]` - Automate NPM release workflow
- BrainGrid CLI skill for Claude Code with comprehensive workflow guidance
- Installation instructions in braingrid-cli skill
- BrainGrid project configuration files

### Changed

- Updated README tagline capitalization

### Fixed

- Removed unsupported `--status` field from `/save-requirement` slash command
  - API does not accept status field during requirement creation
  - Status is set automatically by the backend

## [0.2.1] - 2025-01-07

### Added

- Repository linking support for `project create` command
  - New `--repository-id <uuid>` option to link project by repository UUID
  - New `--repository <owner/name>` option to link project by repository name (e.g., `microsoft/vscode`)
  - Automatic repository UUID lookup when using owner/name format
  - Repository ID takes precedence when both options provided
- Requirement ID auto-detection from git branch names
  - CLI automatically detects requirement ID from branch patterns like `feature/REQ-123-description` or `REQ-123-fix-bug`
  - Eliminates need to manually specify `-r` parameter in most cases
- Branch field in requirement list output
  - Shows which git branch is assigned to each requirement

### Changed

- Enhanced requirement output with URL and consistent field display
- Improved README documentation wording and fixed numbered list in quickstart section

### Fixed

- All error messages now consistently display with red color and single ❌ emoji
- Task command documentation and parameter formats

### Removed

- Complexity and readiness fields from requirements and tasks
  - Removed from TypeScript type definitions
  - Removed from all test mock data
  - CLI no longer displays or accepts these fields (API still returns them but they are ignored)

## [0.2.0] - 2025-11-04

### Changed

- **BREAKING**: Converted from monorepo to single CLI package architecture
  - Removed `@braingrid/protocol` package (JSON-RPC protocol schemas)
  - Removed `@braingrid/vscode-extension` package
  - Removed JSON-RPC server mode (`--rpc` flag)
  - Removed agent conversation commands (`braingrid agent chat`)
  - Removed conformance testing tools
  - Eliminated monorepo infrastructure (Turbo, Changesets, pnpm workspaces)
  - Restructured to standalone package at repository root
  - All CLI functionality preserved (auth, project, requirement, task commands)
  - Retained Zod dependency for future CLI input validation

### Removed

- JSON-RPC 2.0 server implementation and transport layer
- Agent service and streaming conversation support
- VSCode extension integration
- Protocol package and auto-generated documentation
- Monorepo build orchestration (Turborepo)
- Automated versioning system (Changesets)

## [0.1.3] - 2025-11-04

### Added

- Proprietary license (LICENSE.md) to protect BrainGrid intellectual property
  - Synced to main BrainGrid repository for consistency

### Changed

- Migrated OpenAPI specification from YAML to JSON format
  - Updated `docs:fetch-openapi` script to fetch from new location (`public/openapi.json`)
  - Updated all documentation references from `openapi.yaml` to `openapi.json`
  - Added complete BrainGrid v1 API OpenAPI 3.0 spec (4016 lines)
  - Updated README tagline: "Prompt AI Coding Tools like a rockstar developer"

### Fixed

- npm publish workflow to publish CLI package from correct directory
  - Ensures proper package deployment during releases

## [0.1.1] - 2025-10-07

### Added

- Consistent resource ID normalization across projects, requirements, and tasks
  - Supports multiple input formats: `PROJ-123`, `proj-123`, `PROJ 123`, `123`, or UUID
  - Generic `normalizeId()` utility eliminates code duplication
- Git repository root detection for `.braingrid` folder placement
  - `.braingrid/project.json` now created at git repository root instead of current directory
  - Ensures consistent project configuration across entire repository
- Workspace manager for centralized project resolution
  - Simplifies project auto-detection from local configuration
  - Reduces redundant workspace lookups in task commands
- Configuration path display in `braingrid status` command
  - Shows where user-level credentials are stored (`~/.config/BrainGrid/config.json`)
- Internal API services pattern for GitHub and repository operations
  - Prepares foundation for future repository integration features

### Changed

- Command structure improvements with consistent ID handling
  - Project, requirement, and task commands now accept flexible ID formats
  - `braingrid task list -r REQ-456` and `braingrid task list -r 456` both work
- Improved error messages with better workspace context
  - Task commands provide clearer guidance when project isn't initialized
- Fixed credential storage directory from `BrainGrid-nodejs` to `BrainGrid`
  - **Breaking change**: Users need to re-authenticate after upgrade

### Fixed

- Test script now properly tracks and reports API 500 errors
  - Enhanced error tracking during integration tests
  - No longer exits on first error, displays summary table
- Authentication integration tests handle both logged-in and logged-out states
  - More robust RPC integration test suite

## [0.0.9] - 2025-10-04

### Added

- `-v` shorthand flag for `--version` command

### Fixed

- API response handling for `project show --repo` and `project show --repo --limit` commands
  - Now correctly handles `ListProjectsWithRepositoryResponse` (with `total_count`) vs `ListProjectsResponse` (with `pagination`)
  - Fixed bug where optional `total_count` check could cause pagination info to not display
  - Added `formatProjectListPagination()` helper function to eliminate code duplication
  - Simplified `ProjectService.listProjects()` to use union type consistently

## [0.0.8] - 2025-10-03

### Fixed

- Claude Code detection in `braingrid status` command with 3-tier detection strategy
  - Priority 1: Check `~/.claude/local/claude` (after `claude migrate-installer`)
  - Priority 2: Try executing `claude --version` (shell alias detection)
  - Priority 3: Check PATH with `which claude`
  - Based on GitHub's spec-kit implementation pattern
  - Added comprehensive test coverage for all detection methods

### Changed

- README comment alignment in usage sections for better readability

## [0.0.7] - 2025-10-03

### Added

- `braingrid init` command to initialize repositories with BrainGrid projects
  - Auto-detects project from git remote (owner/name)
  - Manual mode with `--project <id>` to specify project by ID
  - Interactive wizard mode with `--wizard` flag
  - Force reinitialization with `--force` flag
  - Creates `.braingrid/project.json` with project configuration
- `braingrid update` command to update CLI to latest version
  - Automatic package manager detection (npm/pnpm/yarn)
  - Version checking against npm registry
  - `--check` flag for dry run without installing
- Auto-detection of project from `.braingrid/project.json` for simpler commands
  - `braingrid requirement list` (no longer requires `-p PROJ-123`)
  - `braingrid requirement create --prompt "..."` (auto-detects project)
  - `braingrid task list -r REQ-456` (auto-prepends project from config)
  - Explicit project ID still works for managing multiple projects
- Git user storage during authentication in encrypted config
- Package manager detection utility for consistent install/update methods
- Local project configuration schema with Zod validation
- 36 new tests for init, update, and auto-detection features

### Changed

- Updated `--repository` as primary alias for `--repo` in project show command (both still work)
- Project configuration now stores API repository data instead of git-derived data
- Simplified QuickStart workflow with auto-detection examples
- Enhanced error messages to guide users to run `braingrid init` when needed

### Fixed

- Terminal crash issue in status command by removing interactive shell flag
- Data consistency by using API repository values instead of mixing git-derived data

## [0.0.6] - 2025-10-02

### Added

- `/cut-release` slash command for streamlined release workflow
- `pnpm docs:sync` command to sync CLI documentation to main BrainGrid repository
- Repository-aware project commands with automatic git context detection
- Collapsible installation and update command tabs in documentation

### Changed

- Enhanced project commands to automatically detect and include git repository context
- Improved README with spec-driven development explanation

## [0.0.5] - 2025-10-02

### Added

- IDEA and REVIEW requirement statuses for enhanced workflow management
- Emoji mappings: 💡 for IDEA, 👀 for REVIEW
- Natural language keyword parsing for new statuses
  - IDEA keywords: idea, ideas, ideation, brainstorm, concept
  - REVIEW keywords: review, reviewing, in-review, pending-review
- Updated CLI help text to include new statuses

### Changed

- RequirementStatus type now supports 6 statuses: IDEA, PLANNED, IN_PROGRESS, REVIEW, COMPLETED, CANCELLED
- Status workflow: IDEA → PLANNED → IN_PROGRESS → REVIEW → COMPLETED/CANCELLED
- Updated README badges to use @braingrid organization
- Synced OpenAPI specification with latest API changes

## [0.0.4] - 2025-10-02

### Added

- Comprehensive test coverage improvement from 26.15% to 64.9%
- 529 passing tests covering utils, services, and handlers
- Handler layer tests achieving 96.28% coverage (all core handlers 92-100%)
- Complete CLI refactor with resource-oriented command structure
- New OAuth2 authentication flow
- Git repository detection in status command
- CLI tools detection (Claude Code, Cursor, git)

### Changed

- Renamed package from `@braingridai/cli` to `@braingrid/cli`
- Updated repository URL to main braingrid repo
- Refactored from React-based CLI to Commander.js pattern
- Improved error handling and user feedback
- Enhanced status command with authentication, git, and tool information

### Fixed

- Task handler number type (string for proper padding)
- Repository URL format in package.json
- Test coverage for all critical paths

## [0.0.3] - 2024-01-XX

### Changed

- Initial npm publication as `@braingrid/cli`

## [0.0.2] - 2024-01-XX

### Changed

- Initial version as `@braingridai/cli`

## [0.0.1] - 2024-01-XX

### Added

- Initial CLI implementation
