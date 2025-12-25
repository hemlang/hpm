# HPM 1.1.0 Release Plan

This document outlines the improvements implemented for hpm 1.1.0 release.

## Executive Summary

HPM is a well-structured package manager with solid foundations. The codebase is modular (~4,000 LOC), has good test coverage (~160+ tests), and comprehensive documentation (11 files). Version 1.1.0 addresses critical security features, version consistency, and UX improvements.

---

## Priority 1: Critical - COMPLETED

### 1.1 SHA256 Integrity Verification ✅
**File:** `src/installer.hml`
**Implementation:**
- [x] Compute SHA256 hash of downloaded tarballs using `@stdlib/hash`
- [x] Store hash in package-lock.json during first install
- [x] Verify hash on subsequent installs (re-download if mismatch)
- [x] Add `--skip-integrity` flag for offline/cache-only scenarios
- [x] Integrity failures throw with descriptive error

### 1.2 Version Number Consistency ✅
**Implementation:**
- [x] Updated to version 1.1.0 in both files
- [x] `package.json`: 1.1.0
- [x] `src/main.hml`: HPM_VERSION = "1.1.0"

### 1.3 Integration Tests ✅
**Implementation:**
- [x] Added `test/test_resolver.hml` with cycle detection and tree building tests
- [x] Added `test/test_installer.hml` with uninstall and verification tests
- [x] Updated test runner to include new tests
- [x] Updated Makefile with new test targets

---

## Priority 2: High - COMPLETED

### 2.1 Enhanced `hpm init` ✅
**File:** `src/main.hml` (cmd_init function)
**Implementation:**
- [x] Command-line flags for non-interactive use (--name, --version, --description, --author, --license, --main)
- [x] Auto-detect git remote for repository field
- [x] --yes flag skips tips display
- [x] Shows helpful usage tips when not using --yes

### 2.2 Progress Indicators ✅
**Implementation:**
- [x] Show [1/N] progress during package installation
- [x] Show timing summary: "Installed X package(s) in Y seconds"
- [x] Respects --verbose mode (doesn't duplicate output)

### 2.3 Better Error Messages ✅
**Implementation:**
- [x] Improved error output with suggestions
- [x] Added `--debug` flag for detailed debugging information
- [x] Network errors show troubleshooting tips
- [x] Formatted error blocks with clear messaging

### 2.4 CI/CD Testing Pipeline ✅
**Implementation:**
- [x] Added `.github/workflows/ci.yml`
- [x] Runs tests on push/PR to main
- [x] Includes lint checks for trailing whitespace
- [x] Tests hpm --help and --version commands

---

## Priority 3: Medium (Nice to Have for 1.0.0)

### 3.1 Scoped Package Support
**Current State:** Packages are `owner/repo` format only
**Required:**
- [ ] Support `@scope/package` naming convention
- [ ] Map scopes to GitHub organizations
- [ ] Update resolver and installer for scoped packages
- [ ] Update documentation

### 3.2 Stabilize Parallel Downloads
**File:** `src/installer.hml`
**Current State:** Marked experimental with potential race conditions
**Required:**
- [ ] Audit parallel download code for race conditions
- [ ] Add proper synchronization if needed
- [ ] Benchmark parallel vs sequential
- [ ] Document performance characteristics
- [ ] Consider making parallel the default if stable

### 3.3 `hpm audit` Command
**Current State:** No security vulnerability checking
**Required:**
- [ ] Define security advisory format
- [ ] Create advisory database location (GitHub repo or separate service)
- [ ] Implement audit command to check installed packages
- [ ] Add `--fix` flag to auto-update vulnerable packages
- [ ] Add exit codes for audit results

### 3.4 `hpm info <package>` Command
**Current State:** No way to inspect package metadata without installing
**Required:**
- [ ] Fetch package.json from GitHub without downloading tarball
- [ ] Display: name, version, description, dependencies, repository
- [ ] Show available versions with `--versions` flag
- [ ] Show readme with `--readme` flag

### 3.5 Better `hpm list` Output
**Current State:** Basic tree output
**Required:**
- [ ] Add `--json` flag for machine-readable output
- [ ] Add `--parseable` flag for one-package-per-line
- [ ] Highlight dev dependencies differently
- [ ] Show package sizes

---

## Priority 4: Post-1.0.0 Roadmap

These features are documented for future releases:

### 4.1 Workspaces / Monorepo Support
- [ ] Support `workspaces` field in package.json
- [ ] Link local packages automatically
- [ ] Run commands across all workspace packages
- [ ] Hoist shared dependencies

### 4.2 Plugin System
- [ ] Define plugin API
- [ ] Support custom commands via plugins
- [ ] Support lifecycle hooks (preinstall, postinstall)
- [ ] Plugin discovery and installation

### 4.3 Private Registry Support
- [ ] Support custom registry URLs
- [ ] Authentication for private registries
- [ ] Registry configuration in config file
- [ ] Support for multiple registries

### 4.4 Additional Package Sources
- [ ] GitLab support
- [ ] Bitbucket support
- [ ] Direct tarball URLs
- [ ] Local file path dependencies

### 4.5 Performance Optimizations
- [ ] Package metadata caching
- [ ] Incremental lockfile updates
- [ ] Lazy dependency loading
- [ ] Parallel dependency resolution

---

## Technical Debt

### Known Issues to Address

1. **Bundler Bug** (Hemlock compiler limitation)
   - Document that standalone executable builds are not supported
   - Keep shell wrapper script as primary distribution method
   - Track upstream Hemlock issue

2. **Variable Shadowing** (commit fcf258c)
   - Recent fix shows Hemlock scoping issues
   - Audit codebase for similar patterns
   - Add tests for edge cases

3. **Manual Array Operations**
   - Consider helper functions for common patterns
   - Document Hemlock stdlib limitations

---

## Documentation Updates for 1.0.0

### Required Updates

- [ ] Update version numbers in all docs
- [ ] Add CHANGELOG.md with release notes
- [ ] Update installation.md with verified instructions
- [ ] Add CONTRIBUTING.md for contributors
- [ ] Update README.md badges (version, tests, etc.)
- [ ] Review and test all command examples

### New Documentation

- [ ] Migration guide (if any breaking changes)
- [ ] FAQ section in troubleshooting.md
- [ ] Performance tuning guide
- [ ] Security best practices

---

## Testing Strategy

### Test Matrix

| Module | Unit Tests | Integration Tests | Status |
|--------|------------|-------------------|--------|
| semver | 45 ✓ | - | Complete |
| manifest | 25 ✓ | - | Complete |
| lockfile | 35 ✓ | - | Complete |
| cache | 10 ✓ | - | Complete |
| resolver | - | Needed | **Gap** |
| installer | - | Needed | **Gap** |
| github | - | Needed | **Gap** |
| main (CLI) | - | Needed | **Gap** |

### Test Improvements

- [ ] Add resolver unit tests for conflict detection
- [ ] Add installer tests (mock HTTP)
- [ ] Add github module tests (mock API)
- [ ] Add CLI integration tests
- [ ] Add regression tests for fixed bugs

---

## Release Checklist

### Pre-Release

- [ ] All Priority 1 items complete
- [ ] All Priority 2 items complete or documented as known limitations
- [ ] Test suite passes
- [ ] Documentation updated
- [ ] CHANGELOG.md written
- [ ] Version numbers consistent (1.0.0)

### Release

- [ ] Create git tag v1.0.0
- [ ] Push tag to GitHub
- [ ] Create GitHub release with notes
- [ ] Update README with installation instructions
- [ ] Announce release

### Post-Release

- [ ] Monitor issue tracker
- [ ] Prepare 1.0.1 hotfix if needed
- [ ] Begin work on 1.1.0 features

---

## Estimated Effort

| Priority | Items | Complexity |
|----------|-------|------------|
| P1: Critical | 3 | Medium-High |
| P2: High | 4 | Medium |
| P3: Medium | 5 | Low-Medium |
| P4: Future | 5 | High |

**Recommendation:** Focus on P1 items first. P2 items improve user experience significantly. P3 items can be included if time permits or deferred to 1.1.0.

---

## Success Criteria for 1.0.0

1. ✅ All packages install correctly with integrity verification
2. ✅ Dependency resolution handles conflicts properly
3. ✅ Clear error messages for all failure modes
4. ✅ Comprehensive documentation
5. ✅ Test coverage for core functionality
6. ✅ Stable API for package.json format
7. ✅ GitHub integration works reliably
8. ✅ Cache system works correctly
9. ✅ Offline mode functions as expected
10. ✅ Version constraints (^, ~, ranges) work correctly
