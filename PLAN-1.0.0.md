# HPM 1.0.0 Release Plan

This document outlines the improvements needed to prepare hpm for a stable 1.0.0 release.

## Executive Summary

HPM is a well-structured package manager with solid foundations. The codebase is modular (~4,000 LOC), has good test coverage (~135 tests), and comprehensive documentation (11 files). To reach production-ready 1.0.0 status, we need to address critical security features, version consistency, and UX improvements.

---

## Priority 1: Critical (Must Have for 1.0.0)

### 1.1 SHA256 Integrity Verification
**File:** `src/installer.hml:108`
**Current State:** `let integrity = "sha256-unknown"` - downloads are not verified
**Required:**
- [ ] Compute SHA256 hash of downloaded tarballs
- [ ] Store hash in package-lock.json during first install
- [ ] Verify hash on subsequent installs
- [ ] Add `--skip-integrity` flag for offline/cache-only scenarios
- [ ] Add exit code handling for integrity failures (EXIT_INTEGRITY_ERROR = 6)

**Risk:** Without integrity verification, supply chain attacks are possible.

### 1.2 Version Number Consistency
**Current State:** Mismatch between files
- `package.json`: 1.0.1
- `src/main.hml`: 1.0.2 (HPM_VERSION constant)

**Required:**
- [ ] Decide on 1.0.0 as release version
- [ ] Update both files to 1.0.0
- [ ] Add version bump script to Makefile
- [ ] Consider reading version from package.json at runtime

### 1.3 Integration Tests
**Current State:** Unit tests only for semver, manifest, lockfile, cache
**Required:**
- [ ] Add end-to-end install test (create temp project, install package, verify)
- [ ] Add uninstall test (verify cleanup and orphan pruning)
- [ ] Add update test (verify constraint satisfaction)
- [ ] Add conflict resolution test
- [ ] Add circular dependency detection test
- [ ] Test against hemlock stdlib packages

---

## Priority 2: High (Should Have for 1.0.0)

### 2.1 Interactive `hpm init`
**File:** `src/main.hml` (cmd_init function)
**Current State:** Only uses defaults, --yes flag has no effect
**Required:**
- [ ] Implement stdin reading for user prompts
- [ ] Prompt for: name, version, description, author, license
- [ ] Auto-detect git remote for repository field
- [ ] Use --yes to skip prompts and use defaults
- [ ] Add --template flag for common project types

### 2.2 Progress Indicators
**Current State:** Silent during long operations
**Required:**
- [ ] Show download progress (package name, size if known)
- [ ] Show resolution progress for large dependency trees
- [ ] Add spinner or progress bar for extraction
- [ ] Respect --verbose vs quiet modes
- [ ] Show summary: "Installed X packages in Y seconds"

### 2.3 Better Error Messages
**Current State:** Errors are informative but could be improved
**Required:**
- [ ] Add suggestions for common errors (e.g., "Did you mean 'package-name'?")
- [ ] Show network troubleshooting tips on connection failures
- [ ] Improve rate limit message with retry-after time
- [ ] Add `--debug` flag for verbose error stack traces

### 2.4 CI/CD Testing Pipeline
**Current State:** No automated testing on commits
**Required:**
- [ ] Add GitHub Actions workflow
- [ ] Run tests on push/PR to main
- [ ] Test on multiple Hemlock versions (if applicable)
- [ ] Add test coverage reporting

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
