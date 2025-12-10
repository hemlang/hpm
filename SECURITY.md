# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability in hpm, please report it responsibly.

### How to Report

1. **Do NOT open a public issue** for security vulnerabilities.
2. Email the security report to the Hemlock team or create a private security advisory on GitHub.
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Acknowledgment**: We will acknowledge your report within 48 hours.
- **Assessment**: We will assess the vulnerability and determine its severity.
- **Fix Timeline**: Critical vulnerabilities will be addressed within 7 days. Others within 30 days.
- **Credit**: We will credit you in the security advisory (unless you prefer anonymity).

## Security Considerations

### Package Installation

hpm downloads packages from GitHub releases. Be aware of the following:

1. **Trust**: Only install packages from authors you trust. hpm executes code during the build process if a package has build scripts.

2. **Version Pinning**: Use exact versions or tight ranges in production to avoid unexpected updates:
   ```json
   {
     "dependencies": {
       "owner/package": "1.0.0"
     }
   }
   ```

3. **Lock Files**: Always commit `package-lock.json` to ensure reproducible builds.

### GitHub Authentication

When using GitHub tokens:

1. **Token Scope**: Use tokens with minimal required permissions (only `read:packages` for public repos).
2. **Token Storage**: Store tokens in `~/.hpm/config.json` with restricted file permissions:
   ```bash
   chmod 600 ~/.hpm/config.json
   ```
3. **Environment Variables**: When using `GITHUB_TOKEN`, be careful not to expose it in logs or shell history.

### Known Limitations

1. **Integrity Checking**: Package integrity verification via SHA256 checksums is planned but not yet implemented.

2. **Signature Verification**: Package signature verification is not implemented. Trust is currently based on the GitHub account.

3. **Dependency Confusion**: hpm uses GitHub paths (owner/repo), which reduces but doesn't eliminate dependency confusion risks.

## Best Practices

### For Package Authors

1. Use semantic versioning correctly
2. Document breaking changes
3. Keep dependencies minimal and up-to-date
4. Don't include sensitive data in packages

### For Package Consumers

1. Review packages before installing
2. Keep dependencies updated (`hpm outdated`)
3. Use lock files for reproducible builds
4. Audit your dependency tree periodically (`hpm list`)

## Security Updates

Security updates will be announced through:
- GitHub Security Advisories
- Release notes in CHANGELOG.md
- GitHub releases

Subscribe to repository notifications to stay informed.
