# Contributing to Safe-RM

Thank you for your interest in contributing to Safe-RM! This document provides guidelines and instructions for contributing.

## Ways to Contribute

- Report bugs
- Suggest features
- Improve documentation
- Submit bug fixes
- Add new features
- Add tests
- Add IDE integrations

## Getting Started

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/kayaman/safe-rm.git
cd safe-rm
```

### 2. Install Development Dependencies

```bash
# Install safe-rm in development mode
./install.sh

# Install test dependencies
sudo zypper install shellcheck shfmt  # OpenSUSE
# or
sudo apt install shellcheck shfmt     # Ubuntu/Debian
```

### 3. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

## 🔧 Development Workflow

### Project Structure

```
safe-rm/
├── bin/safe-rm                 # Main executable
├── safe-rm.plugin.zsh          # Oh-my-zsh plugin
├── skills/safe-rm/SKILL.md     # Agent Skill (Agent Skills spec)
├── docs/                       # Documentation
└── .github/                    # GitHub workflows
```

### Code Style

**Shell Scripts (Bash/ZSH):**
- Use `shellcheck` for linting
- Use `shfmt` for formatting
- Follow Google Shell Style Guide
- Add comments for complex logic

```bash
# Lint your changes
shellcheck bin/safe-rm safe-rm.plugin.zsh

# Format code
shfmt -i 4 -w bin/safe-rm
```

**Markdown:**
- Use proper headings hierarchy
- Add code blocks with language tags
- Keep line length reasonable (~100 chars)

### Testing

**Manual Testing:**

```bash
# Create test environment
mkdir test-env && cd test-env
git init

# Create test files
echo "source" > draft.py
mkdir node_modules && touch node_modules/test.js

# Test classification
rm -n -rf .   # Should show what would happen

# Test execution
rm -f -rf .   # Should trash draft.py, delete node_modules

# Verify
trash-list | grep draft.py
tail -5 ~/.local/state/safe-rm/audit.log
```

**Automated Testing:**

See `.github/workflows/ci.yaml` for CI test steps.

### Making Changes

**For Bug Fixes:**
1. Describe the bug in detail
2. Add a test case that reproduces it
3. Fix the bug
4. Verify test passes
5. Update documentation if needed

**For Features:**
1. Open an issue to discuss first
2. Get approval from maintainers
3. Implement feature
4. Add tests
5. Update documentation
6. Add to CHANGELOG.md

## Commit Guidelines

### Commit Message Format

```
type(scope): brief description

Detailed explanation of changes (optional)

Fixes #123
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**

```
feat(classification): add support for Rust projects

Added cargo/target directories to AUTO_ALLOW classification

Fixes #42
```

```
fix(zsh): handle spaces in file paths correctly

Updated rm function to properly quote file paths

Closes #56
```

## 🧪 Testing Checklist

Before submitting:

- [ ] Code passes `shellcheck`
- [ ] Tested on zsh
- [ ] Tested with oh-my-zsh
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Tested with AI agents (if applicable)
- [ ] Manual testing completed

## Documentation

When adding features:

1. Update main README.md
2. Update relevant docs/ files
3. Add examples
4. Update skills/safe-rm/SKILL.md if needed

## Pull Request Process

1. **Create PR from your fork**
   - Use clear title
   - Reference issues
   - Add description

2. **PR Description Template:**
   ```markdown
   ## Description
   Brief description of changes
   
   ## Motivation
   Why is this change needed?
   
   ## Changes
   - Change 1
   - Change 2
   
   ## Testing
   How was this tested?
   
   ## Checklist
   - [ ] Tests pass
   - [ ] Documentation updated
   - [ ] CHANGELOG.md updated
   ```

3. **Review Process:**
   - Maintainers will review
   - Address feedback
   - Get approval
   - PR will be merged

4. **After Merge:**
   - Delete your branch
   - Update your fork

## 🐛 Bug Reports

Use the bug report template:

**Title:** Clear, descriptive title

**Description:**
- What happened?
- What did you expect?
- Steps to reproduce
- Environment details

**Example:**

```markdown
## Bug: Safe-RM doesn't detect Git repo in subdirectory

**Expected:** Should detect Git repo when running from subdirectory
**Actual:** Shows "Not in Git repository"

**Steps:**
1. cd project/src/
2. rm -n file.txt
3. Error: Not in Git repo (but .git is in parent)

**Environment:**
- OS: OpenSUSE Tumbleweed
- Shell: zsh 5.9
- Safe-RM: v1.0.0
```

## Feature Requests

Use the feature request template:

```markdown
## Feature: [Brief description]

**Problem:** What problem does this solve?

**Proposed Solution:** How should it work?

**Alternatives:** Other solutions considered?

**Additional Context:** Screenshots, examples, etc.
```

## 🌍 IDE Integration Contributions

Adding support for a new IDE?

1. Test the integration thoroughly
2. Add to `docs/IDE_INTEGRATION.md`
3. Provide examples
4. Include screenshots if helpful
5. Note any limitations

## 🔐 Security Issues

**DO NOT** open public issues for security vulnerabilities.

Instead:
- Email: security@example.com
- Use GitHub's private reporting
- We'll work with you to fix it

## 📋 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on the code, not the person
- Assume good intentions
- Follow the [Contributor Covenant](https://www.contributor-covenant.org/)

## ❓ Questions?

- 💬 [GitHub Discussions](https://github.com/kayaman/safe-rm/discussions)
- 🐛 [Issue Tracker](https://github.com/kayaman/safe-rm/issues)
- 📧 Email: contributors@example.com

## 🎉 Recognition

Contributors will be:
- Listed in README.md
- Mentioned in release notes
- Added to CONTRIBUTORS.md

Thank you for contributing! 🙏
