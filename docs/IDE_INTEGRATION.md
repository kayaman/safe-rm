# IDE Integration Guide

This guide shows how to integrate safe-rm skills with various IDEs and AI coding assistants.

## Cursor IDE

Cursor IDE can load rules from URLs or local files (Agent Skill format).

### Method 1: Add rule from URL

In Cursor Settings > Rules, add:
`https://raw.githubusercontent.com/kayaman/safe-rm/main/skills/safe-rm/SKILL.md`

### Method 2: Reference local skill

If you have safe-rm cloned:

```json
{
  "cursor.rules": [
    "file:///path/to/safe-rm/skills/safe-rm/SKILL.md"
  ]
}
```

### Method 3: Copy skill to project

```bash
mkdir -p /path/to/your/project/.cursor/rules
cp /path/to/safe-rm/skills/safe-rm/SKILL.md /path/to/your/project/.cursor/rules/
```

### Verify It's Working

1. Open a file in Cursor
2. Ask Cursor: "Can you clean up build artifacts?"
3. Cursor should:
   - Check for untracked files
   - Use `trash-put` for source code
   - Use `rm` for build artifacts
   - Log operations

## VSCode (with Copilot)

### Method 1: Workspace Settings

Create `.vscode/settings.json` in your project:

```json
{
  "github.copilot.advanced": {
    "customInstructions": "@file:///path/to/safe-rm/skills/safe-rm/SKILL.md"
  }
}
```

### Method 2: User Settings

1. Open VSCode Settings (Cmd/Ctrl + ,)
2. Search for "Copilot Custom Instructions"
3. Add:
   ```
   Follow file deletion rules from: /path/to/safe-rm/skills/safe-rm/SKILL.md
   
   When deleting files:
   - Check Git status first
   - Trash untracked source code
   - Delete build artifacts directly
   - Never delete .git or system paths
   ```

### Method 3: Workspace File Reference

Create `.vscode/copilot-instructions.md`:

```markdown
# Safe Deletion Rules

@import /path/to/safe-rm/skills/safe-rm/SKILL.md
```

## Claude Code (MCP)

Claude Code uses the Model Context Protocol (MCP) to load skills.

### Installation

1. **Copy skill to MCP directory:**

```bash
mkdir -p ~/.local/share/claude-skills
cp -r skills/safe-rm ~/.local/share/claude-skills/safe-rm
```

2. **Verify skill is detected:**

```bash
ls -la ~/.local/share/claude-skills/safe-rm/
# Should show: SKILL.md
```

### Verification

When Claude Code runs in a terminal:
1. It automatically detects skills from `~/.local/share/claude-skills/`
2. Before executing `rm` commands, it reads the skill
3. Follows the classification rules

## 🔧 Continue.dev

Continue.dev supports custom prompts via `.continuerc.json`.

### Setup

Create `.continuerc.json` in your project root:

```json
{
  "customCommands": [
    {
      "name": "safe-delete",
      "description": "Safely delete files following safe-rm rules",
      "prompt": "Read the file deletion safety rules from skills/safe-rm/SKILL.md and follow them when deleting files. Always check Git status first, trash untracked source code, and log operations."
    }
  ],
  "systemMessage": "Follow file deletion rules from skills/safe-rm/SKILL.md. Never delete .git directories or untracked source code without moving to trash first."
}
```

## 🦾 Aider

Aider works through the zsh wrapper automatically.

### Verification

```bash
# Aider will use the rm function from your shell
aider
> /run rm -rf node_modules/
# Will trigger safe-rm wrapper
```

No additional configuration needed if oh-my-zsh plugin is installed.

## JetBrains IDEs (AI Assistant)

### Setup Custom Prompt

1. Open Settings > Tools > AI Assistant
2. Add custom context:

```
File Deletion Safety Rules:
- Always check Git status before deleting
- Move untracked source code to trash (use trash-put)
- Delete build artifacts directly (node_modules, dist, __pycache__)
- Never delete .git, /, /home, or system directories
- Log all operations to audit log (~/.local/state/safe-rm/audit.log or SAFE_RM_AUDIT_LOG)
```

## 🌐 Web-based IDEs

### GitHub Codespaces

Add to `.devcontainer/devcontainer.json`:

```json
{
  "postCreateCommand": "git clone https://github.com/kayaman/safe-rm.git ~/.safe-rm && ~/.safe-rm/install.sh",
  "customizations": {
    "codespaces": {
      "openFiles": [
        "skills/safe-rm/SKILL.md"
      ]
    }
  }
}
```

### Gitpod

Add to `.gitpod.yml` (Gitpod's expected filename; this project uses `.yaml` for its own config files):

```yaml
tasks:
  - name: Install safe-rm
    init: |
      git clone https://github.com/kayaman/safe-rm.git ~/.safe-rm
      cd ~/.safe-rm && ./install.sh
    command: |
      source ~/.zshrc
      safe-rm-status
```

## Testing IDE Integration

### Test Script

Create `test-ide-integration.sh`:

```bash
#!/bin/bash

echo "Testing IDE Integration..."
echo ""

# Test 1: Check if Cursor rule/skill is configured
if [[ -f .cursor/rules/SKILL.md ]] || [[ -f skills/safe-rm/SKILL.md ]]; then
    echo "[OK] Local skill found"
else
    echo "[--] Add Cursor rule from URL or copy skills/safe-rm/SKILL.md"
fi

# Test 2: Check if Claude skill is accessible
if [[ -f ~/.local/share/claude-skills/safe-rm/SKILL.md ]]; then
    echo "[OK] MCP skill found"
else
    echo "[--] MCP skill not found (Claude Code only)"
fi

# Test 3: Create test files
mkdir -p test-project
cd test-project
git init

echo "test" > draft.py
echo "build" > file.pyc

# Test 4: Ask AI to delete
echo ""
echo "Now ask your AI assistant:"
echo "  'Clean up this test-project directory'"
echo ""
echo "Expected behavior:"
echo "  - draft.py should be TRASHED (untracked source)"
echo "  - file.pyc should be DELETED (build artifact)"
echo ""

# Cleanup
cd ..
rm -rf test-project
```

### Manual Test

1. Create a test project:
   ```bash
   mkdir test-project && cd test-project
   git init
   echo "test" > draft.py
   mkdir node_modules && touch node_modules/test.js
   ```

2. Ask your AI assistant:
   > "Clean up this directory"

3. Expected behavior:
   - AI checks: `git ls-files --others --exclude-standard`
   - AI finds: `draft.py` (untracked)
   - AI executes: `trash-put draft.py`
   - AI executes: `rm -rf node_modules/`
   - AI logs to audit log (~/.local/state/safe-rm/audit.log)

## IDE-Specific Notes

### Cursor IDE
- Best integration via Agent Skill (skills/safe-rm/SKILL.md or rule URL)
- Can reference external file or add from URL
- Rules apply per-project

### VSCode Copilot
- Global settings available
- Workspace overrides
- Custom instructions support varies by Copilot version
- Use workspace `.vscode/settings.json` for consistency

### Claude Code
- Native MCP support
- Auto-detects from `~/.local/share/claude-skills/`
- Works across all projects
- Best for terminal-based workflows

### JetBrains
- Limited AI Assistant customization
- Relies on zsh wrapper in terminal
- Add to AI Assistant system prompt

## Troubleshooting

### Issue: AI not following rules

**Check 1: Verify file exists**
```bash
# For Cursor (rule URL or local)
ls -la .cursor/rules/ skills/safe-rm/SKILL.md 2>/dev/null

# For Claude Code
ls -la ~/.local/share/claude-skills/safe-rm/SKILL.md
```

**Check 2: Verify AI can read file**
Ask AI: "What are the file deletion rules you should follow?"
AI should mention: Git status, trash-put, classification

**Check 3: Check logs**
```bash
tail ~/.local/state/safe-rm/audit.log
# Or: tail "$SAFE_RM_AUDIT_LOG"
```

### Issue: Skills not loading in Cursor

1. Ensure rule URL or skills/safe-rm/SKILL.md is added in Cursor settings
2. Restart Cursor
3. Try absolute path to SKILL.md in Cursor rules

### Issue: VSCode Copilot ignoring rules

1. Check VSCode version (needs recent Copilot)
2. Use workspace settings, not user settings
3. Add to `.vscode/settings.json` directly

## Additional Resources

- [Cursor Documentation](https://cursor.sh/docs)
- [VSCode Copilot Guide](https://code.visualstudio.com/docs/copilot)
- [Claude Code MCP](https://docs.anthropic.com/claude/docs/mcp)
- [Safe-RM Repository](https://github.com/kayaman/safe-rm)

## Contributing

Found a working integration for another IDE? Please submit a PR!

Template for new IDE:

```markdown
## Your IDE Name

### Setup

1. Step 1
2. Step 2

### Verification

How to test it works

### Notes

- Important details
- Known limitations
```
