# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

If you discover a security vulnerability, please send an email to:
- **Email:** security@example.com (replace with your email)
- **Subject:** [SECURITY] Safe-RM Vulnerability Report

### What to Include

Please include the following information:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Fix Timeline:** Depends on severity
  - Critical: < 7 days
  - High: < 14 days
  - Medium: < 30 days
  - Low: Next release

## Security Best Practices

When using safe-rm:

1. **Regular Updates**
   ```bash
   cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/safe-rm
   git pull
   ```

2. **Audit Logs**
   - Regularly review the audit log (default: `~/.local/state/safe-rm/audit.log`, override with `SAFE_RM_AUDIT_LOG`)
   - Look for unexpected deletions
   - Monitor bypass attempts

3. **Permissions**
   - Don't run with unnecessary sudo privileges
   - Keep audit log readable only by your user
   - Protect config (default: `~/.config/safe-rm/safe-rm-rules.yaml`, override with `SAFE_RM_CONFIG_DIR`) if it contains sensitive paths

4. **AI Agent Security**
   - Review what AI agents delete in audit logs
   - Use BLOCK patterns for critical paths
   - Monitor the audit log for AI operations

## Known Security Considerations

### Bypass Mechanisms

Safe-rm includes bypass mechanisms for emergencies:
- `rm --real-rm`: Bypasses protection
- `command rm`: Uses system rm directly
- `/usr/bin/rm`: Direct binary access

**All bypasses are logged** to the audit log.

### Audit Log

The audit log (default `~/.local/state/safe-rm/audit.log`, or `SAFE_RM_AUDIT_LOG`) contains:
- Timestamps
- File paths (potentially sensitive)
- Classification decisions
- Action taken

**Recommendation:** Protect this file if it contains sensitive path information.

### Symbolic Links

Safe-rm follows symbolic links. Be aware:
- Deleting a symlink deletes the link, not the target
- The wrapper resolves paths for classification

## Dependencies

Safe-rm depends on:
- `trash-cli` (external package)
- `git` (for repository detection)
- `zsh` (shell)

Keep these updated through your package manager:
```bash
# OpenSUSE
sudo zypper update trash-cli git zsh

# Ubuntu/Debian
sudo apt update && sudo apt upgrade trash-cli git zsh

# macOS
brew upgrade trash-cli git zsh
```

## Disclosure Policy

When we receive a security bug report, we will:

1. Confirm the problem and determine affected versions
2. Audit code to find similar problems
3. Prepare fixes for supported versions
4. Release patches as soon as possible
5. Credit the reporter (unless they wish to remain anonymous)

## Security Hall of Fame

We appreciate security researchers who responsibly disclose vulnerabilities:

<!-- Researchers will be listed here -->

## Comments on This Policy

If you have suggestions on how this process could be improved, please submit a pull request.
