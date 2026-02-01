# Quick Start Guide

Get started with safe-rm in 5 minutes!

## Installation

### One-liner (curl)

```bash
# Standalone
curl -LsSf https://raw.githubusercontent.com/kayaman/safe-rm/main/get-safe-rm.sh | sh

# Oh-my-zsh plugin
curl -LsSf https://raw.githubusercontent.com/kayaman/safe-rm/main/get-safe-rm.sh | sh -s -- --oh-my-zsh
```

Then run `source ~/.zshrc` and verify with `safe-rm-status`.

### Option 1: Oh-My-Zsh Plugin (Recommended)

```bash
git clone https://github.com/kayaman/safe-rm.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/safe-rm

# Add to .zshrc plugins
plugins=(... safe-rm)

source ~/.zshrc
```

### Option 2: Standalone

```bash
git clone https://github.com/kayaman/safe-rm.git ~/.safe-rm
cd ~/.safe-rm
./install.sh
source ~/.zshrc
```

## First Steps

### 1. Verify Installation

```bash
safe-rm-status
```

Should show [OK] for installed components.

### 2. Try a Dry Run

```bash
# Create test file
echo "test" > /tmp/testfile.txt

# Preview deletion
cd /tmp
rm -n testfile.txt
```

Output: `→ WOULD TRASH: testfile.txt (recoverable)`

### 3. Execute Deletion

```bash
rm -f testfile.txt
```

Output: `TRASHED: testfile.txt (recoverable)`

### 4. Recover It

```bash
trash-restore testfile.txt
```

## IDE Setup (Optional)

### For Cursor IDE

Add rule from URL: `https://raw.githubusercontent.com/kayaman/safe-rm/main/skills/safe-rm/SKILL.md`  
Or copy: `cp ~/.safe-rm/skills/safe-rm/SKILL.md /path/to/project/.cursor/rules/`

### For VSCode

Add to `.vscode/settings.json`:
```json
{
  "github.copilot.advanced": {
    "customInstructions": "@file://~/.safe-rm/skills/safe-rm/SKILL.md"
  }
}
```

### For Claude Code

Copy `skills/safe-rm/` to `~/.local/share/claude-skills/safe-rm/` (SKILL.md will be at `.../safe-rm/SKILL.md`).

## Usage Examples

### Clean Build Artifacts

```bash
rm -rf node_modules/ dist/ build/
# All deleted directly (logged)
```

### Mixed Content

```bash
rm -rf src/
# TRASHED: src/draft.py
# TRASHED: src/notes.md
# DELETED: src/__pycache__/
```

### Protection

```bash
rm -rf .git/
# BLOCKED: Protected path
```

## Useful Commands

```bash
rm-log          # View deletion log
trash-list      # View trashed files
trash-restore   # Recover files
safe-rm-status  # Check status
safe-to-delete  # Show safe deletions
```

## Next Steps

- Read full [README](../README.md)
- Check [IDE Integration](IDE_INTEGRATION.md)
- Config: `~/.config/safe-rm/safe-rm-rules.yaml` (see README Configuration)

Happy safe deleting!
