# hpm - Hemlock Package Manager

A package manager for the [Hemlock](https://github.com/hemlang/hemlock) programming language. hpm uses GitHub as its package registry, where packages are identified by their GitHub repository path (e.g., `hemlang/sprout`).

## Installation

hpm requires Hemlock to be installed. Once Hemlock is installed, you can run hpm directly:

```bash
# Clone the repository
git clone https://github.com/hemlang/hpm.git
cd hpm

# Run hpm
./hpm --help
```

Or add the hpm directory to your PATH.

## Quick Start

```bash
# Initialize a new project
hpm init

# Install a package
hpm install hemlang/sprout

# Install a specific version
hpm install hemlang/sprout@^1.0.0

# Install as dev dependency
hpm install --dev hemlang/test-utils

# List installed packages
hpm list

# Run a script
hpm run test
```

## Commands

### `hpm init`

Create a new `package.json` interactively.

```bash
hpm init        # Interactive mode
hpm init --yes  # Use all defaults
```

### `hpm install [package]`

Install all dependencies from `package.json`, or add a new dependency.

```bash
hpm install                       # Install all dependencies
hpm install hemlang/sprout        # Add and install a package
hpm install hemlang/sprout@^1.0.0 # Add with version constraint
hpm install hemlang/test-utils --dev  # Add as dev dependency
```

Flags:
- `--dev, -D` - Add to devDependencies
- `--verbose` - Show detailed output
- `--dry-run` - Show what would be installed without installing

### `hpm uninstall <package>`

Remove a package.

```bash
hpm uninstall hemlang/sprout
```

### `hpm update [package]`

Update dependencies to latest versions within constraints.

```bash
hpm update              # Update all packages
hpm update hemlang/sprout  # Update specific package
```

### `hpm list`

Show installed packages.

```bash
hpm list           # Show full dependency tree
hpm list --depth=0 # Show only direct dependencies
```

### `hpm outdated`

Show packages with newer versions available.

```bash
hpm outdated
```

### `hpm run <script>`

Run a script from `package.json`.

```bash
hpm run test
hpm run build
```

### `hpm test`

Shorthand for `hpm run test`.

### `hpm why <package>`

Explain why a package is installed (show dependency chain).

```bash
hpm why hemlang/router
```

### `hpm cache`

Manage the global cache.

```bash
hpm cache list   # List cached packages
hpm cache clean  # Clear cache
```

## Package Identification

Packages are identified by their GitHub `owner/repo` path:

```
hemlang/sprout
alice/http-client
bob/json-utils
```

## Version Constraints

hpm uses [Semantic Versioning 2.0.0](https://semver.org/):

| Syntax | Meaning |
|--------|---------|
| `1.0.0` | Exact version |
| `^1.2.3` | Compatible with 1.x.x (≥1.2.3 and <2.0.0) |
| `~1.2.3` | Patch updates only (≥1.2.3 and <1.3.0) |
| `>=1.0.0` | Greater than or equal |
| `<2.0.0` | Less than |
| `>=1.0.0 <2.0.0` | Range |
| `*` | Any version |

## package.json

```json
{
  "name": "owner/repo",
  "version": "1.0.0",
  "description": "Package description",
  "author": "Name <email@example.com>",
  "license": "MIT",
  "repository": "https://github.com/owner/repo",
  "main": "src/index.hml",
  "dependencies": {
    "owner/package": "^1.0.0"
  },
  "devDependencies": {
    "owner/test-lib": "^1.0.0"
  },
  "scripts": {
    "test": "hemlock test/run.hml",
    "build": "hemlock compile src/main.hml"
  }
}
```

## Importing Packages

Once installed, packages can be imported using their GitHub path:

```hemlock
// Import from package root (uses "main" from package.json)
import { app, router } from "hemlang/sprout";

// Import from subpath
import { middleware } from "hemlang/sprout/middleware";
import { utils } from "alice/http-client/internal/utils";

// Standard library (built into Hemlock)
import { HashMap } from "@stdlib/collections";
```

## Import Resolution

For `import { x } from "owner/repo/path"`:

1. Check `hem_modules/owner/repo/path.hml`
2. Check `hem_modules/owner/repo/path/index.hml`
3. Check `hem_modules/owner/repo/src/path.hml`
4. Check `hem_modules/owner/repo/src/path/index.hml`

For `import { x } from "owner/repo"` (no subpath):

1. Read `main` field from `hem_modules/owner/repo/package.json`
2. Default to `src/index.hml` if not specified

## Directory Structure

```
my-project/
├── package.json
├── package-lock.json
├── src/
│   └── main.hml
├── test/
│   └── test.hml
└── hem_modules/
    └── hemlang/
        └── sprout/
            ├── package.json
            └── src/
```

## Global Cache

Downloaded packages are cached at `~/.hpm/cache/` to avoid re-downloading.

## GitHub Authentication

For higher rate limits and private repository access, set a GitHub token:

```bash
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

Or create `~/.hpm/config.json`:

```json
{
  "github_token": "ghp_xxxxxxxxxxxx"
}
```

## Publishing Packages

Publishing is just git:

```bash
# Ensure package.json is valid
hpm init

# Commit and tag
git add .
git commit -m "Release v1.0.0"
git tag v1.0.0
git push origin main --tags
```

Users install with:

```bash
hpm install yourname/your-package@1.0.0
```

## Exit Codes

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

## License

MIT
