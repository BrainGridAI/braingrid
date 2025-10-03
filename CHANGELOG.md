# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
