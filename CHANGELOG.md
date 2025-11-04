# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
