# Contributing to hpm

Thank you for your interest in contributing to hpm, the Hemlock Package Manager! This document provides guidelines for contributing.

## Getting Started

### Prerequisites

- [Hemlock](https://github.com/hemlang/hemlock) compiler installed
- Git
- A GitHub account

### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/hemlang/hpm.git
cd hpm

# Create the wrapper script
make

# Verify it works
./hpm --help
```

## Project Structure

```
hpm/
├── src/
│   ├── main.hml       # CLI entry point and command handling
│   ├── manifest.hml   # package.json parsing and validation
│   ├── lockfile.hml   # package-lock.json management
│   ├── resolver.hml   # Dependency resolution algorithm
│   ├── installer.hml  # Package download and extraction
│   ├── semver.hml     # Semantic versioning implementation
│   ├── github.hml     # GitHub API client
│   └── cache.hml      # Global package cache management
├── test/
│   ├── framework.hml  # Test framework
│   ├── run.hml        # Test runner
│   └── test_*.hml     # Test suites
├── Makefile
└── README.md
```

## Development Workflow

### Running Tests

```bash
# Run all tests
make test

# Run specific test suite
make test-semver
make test-manifest
make test-lockfile
make test-cache
```

### Making Changes

1. **Fork the repository** and create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the coding standards below.

3. **Test your changes**:
   ```bash
   make test
   ```

4. **Commit with a clear message**:
   ```bash
   git commit -m "Add feature: description of what you added"
   ```

5. **Push and create a Pull Request**.

## Coding Standards

### Hemlock Style

- Use 4 spaces for indentation
- Use descriptive variable and function names
- Add comments for complex logic
- Keep functions focused and small

### Naming Conventions

- Functions: `snake_case` (e.g., `parse_version`, `resolve_dependencies`)
- Variables: `snake_case` (e.g., `package_name`, `version_constraint`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `EXIT_SUCCESS`, `MAX_RETRIES`)
- Types: `PascalCase` (e.g., `Version`, `Package`, `Manifest`)

### Code Organization

- Keep related functions together
- Export only what's needed by other modules
- Document public functions with comments

## Testing Guidelines

### Writing Tests

Tests use the custom framework in `test/framework.hml`:

```hemlock
import { suite, test, assert, assert_eq } from "./framework.hml";

export fn run() {
    suite("My Feature");

    test("should do something", fn() {
        let result = my_function();
        assert_eq(result, expected, "my_function should return expected value");
    });
}
```

### Test Coverage

- Add tests for new features
- Add tests for bug fixes (to prevent regression)
- Test edge cases and error conditions

## Pull Request Guidelines

### Before Submitting

- [ ] Tests pass locally (`make test`)
- [ ] Code follows the style guidelines
- [ ] Changes are documented if needed
- [ ] Commit messages are clear and descriptive

### PR Description

Include in your PR description:
- What the change does
- Why the change is needed
- How to test the change
- Any breaking changes

### Review Process

1. Maintainers will review your PR
2. Address any feedback
3. Once approved, a maintainer will merge

## Reporting Issues

### Bug Reports

Include:
- hpm version (`hpm version`)
- Hemlock version (`hemlock --version`)
- Operating system
- Steps to reproduce
- Expected vs actual behavior
- Relevant error messages

### Feature Requests

Include:
- Description of the feature
- Use case / motivation
- Proposed implementation (optional)

## Exit Codes

When adding error handling, use appropriate exit codes:

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Dependency conflict |
| 2 | Package not found |
| 3 | Version not found |
| 4 | Network error |
| 5 | Invalid package.json |
| 6 | Integrity check failed |
| 7 | GitHub rate limit exceeded |
| 8 | Circular dependency |

## Questions?

If you have questions about contributing, feel free to open an issue with the "question" label.

## License

By contributing to hpm, you agree that your contributions will be licensed under the MIT License.
