# Changelog

All notable changes to hpm will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2024

### Changed
- Default to sequential downloads for improved reliability (parallel mode has issues with HTTP library)
- Use native binary HTTP download instead of curl workaround
- Updated installation documentation

### Fixed
- Resolved Hemlock scoping issues in `lockfile.prune`
- Fixed variable shadowing in lockfile tests

## [1.0.0] - 2024

### Added
- Initial release of hpm (Hemlock Package Manager)
- Core package management commands:
  - `hpm init` - Initialize a new project interactively
  - `hpm install [package]` - Install dependencies or add new packages
  - `hpm uninstall <package>` - Remove packages
  - `hpm update [package]` - Update to latest compatible versions
  - `hpm list` - Show installed packages with tree view
  - `hpm outdated` - Show packages with newer versions available
  - `hpm run <script>` - Execute scripts from package.json
  - `hpm test` - Shorthand for `hpm run test`
  - `hpm why <package>` - Show dependency chain
  - `hpm cache` - Manage global cache (list/clean)
  - `hpm help` - Show help
  - `hpm version` - Show version
- Semantic versioning support (2.0.0 compliant)
  - Exact versions (`1.0.0`)
  - Caret ranges (`^1.2.3`)
  - Tilde ranges (`~1.2.3`)
  - Comparison operators (`>=1.0.0`, `<2.0.0`)
  - Ranges (`>=1.0.0 <2.0.0`)
  - Wildcard (`*`)
- Dependency resolution with conflict detection
- Circular dependency detection
- GitHub as package registry
- GitHub authentication support via `GITHUB_TOKEN` or config file
- Global package cache at `~/.hpm/cache/`
- Network resilience with exponential backoff retry logic
- Offline mode (`--offline` flag)
- Dry-run mode (`--dry-run` flag)
- Dev dependencies support (`--dev` flag)
- Comprehensive exit codes for different error scenarios
- Test suite with custom test framework

[1.0.1]: https://github.com/hemlang/hpm/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/hemlang/hpm/releases/tag/v1.0.0
