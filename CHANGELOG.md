# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2024-XX-XX

### Added

- **SHA256 Integrity Verification**: All downloaded packages are now verified using SHA256 hashes
  - Hash is computed after download and stored in `package-lock.json`
  - On subsequent installs, cached packages are verified against stored hash
  - Use `--skip-integrity` flag to bypass verification if needed
  - Integrity mismatches trigger automatic re-download

- **Enhanced `hpm init` Command**:
  - Auto-detects git remote and sets repository field
  - Supports command-line flags for non-interactive use:
    - `--name=owner/repo`
    - `--version=1.0.0`
    - `--description=...`
    - `--author=...`
    - `--license=...`
    - `--main=...`
  - Shows helpful tips when not using `--yes` flag

- **Progress Indicators**:
  - Shows `[1/N]` progress during package installation
  - Displays timing summary: "Installed X package(s) in Y seconds"

- **Improved Error Messages**:
  - Better formatted error output with suggestions
  - Added `--debug` flag for detailed debugging information
  - Network errors now show troubleshooting tips

- **Integration Tests**:
  - Added `test_resolver.hml` with cycle detection and tree building tests
  - Added `test_installer.hml` with uninstall and verification tests
  - Updated test runner and Makefile with new test targets

- **GitHub Actions CI/CD**:
  - Added `.github/workflows/ci.yml`
  - Runs tests on push/PR to main branch
  - Includes lint checks for trailing whitespace

### Changed

- Version updated to 1.1.0 (synchronized in package.json and main.hml)
- `install_package` now accepts expected integrity parameter for verification
- `install_all` now shows progress for each package being installed

### Fixed

- Version number consistency between package.json and src/main.hml

## [1.0.2] - Previous Release

- Initial stable release
- Core package management (install, update, uninstall)
- Dependency resolution with conflict detection
- Circular dependency detection
- GitHub API integration with retry logic
- Global package cache
- Offline mode support
- Lockfile management
