# Safe-RM

**Intelligent file deletion protection for Git projects with AI coding agent support**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ZSH](https://img.shields.io/badge/shell-zsh-green.svg)](https://www.zsh.org/)
[![Oh My Zsh](https://img.shields.io/badge/framework-oh--my--zsh-blue.svg)](https://ohmyz.sh/)

Prevent accidental deletion of unstaged files in Git repositories while allowing efficient cleanup of build artifacts. Works seamlessly with both **human users** and **AI coding agents** (Cursor IDE, VSCode Copilot, Claude Code).

## Why Safe-RM?

- **Protects untracked Git files** - Never lose work-in-progress code again
- **AI agent compatible** - Works with Cursor, Copilot, Claude Code (non-interactive)
- **Recoverable deletions** - Move important files to trash instead of permanent deletion
- **Smart classification** - Automatically knows what's safe to delete
- **Zero friction** - Drop-in `rm` replacement, no workflow changes
- **Complete audit trail** - Log every deletion with timestamps

## Quick Start

### One-liner installation

```bash
# Standalone
curl -LsSf https://raw.githubusercontent.com/kayaman/safe-rm/main/get-safe-rm.sh | sh

# Oh-my-zsh plugin
curl -LsSf https://raw.githubusercontent.com/kayaman/safe-rm/main/get-safe-rm.sh | sh -s -- --oh-my-zsh
```

### Installation (oh-my-zsh)

```bash
# Clone the repository
git clone https://github.com/kayaman/safe-rm.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/safe-rm

# Add to your .zshrc plugins
plugins=(... safe-rm)

# Reload zsh
source ~/.zshrc
```

### Installation (manual)

```bash
# Clone the repository
git clone https://github.com/kayaman/safe-rm.git ~/.safe-rm

# Run installer
cd ~/.safe-rm
./install.sh

# Reload shell
source ~/.zshrc
```

### For IDE Skills (Cursor, VSCode)

**Cursor:** Add rule from URL: `https://raw.githubusercontent.com/kayaman/safe-rm/main/skills/safe-rm/SKILL.md`  
**VSCode / local:** Reference `skills/safe-rm/SKILL.md` or `file:///path/to/safe-rm/skills/safe-rm/SKILL.md`

See [IDE Integration Guide](docs/IDE_INTEGRATION.md) for detailed setup.

## How It Works

```
You type: rm -rf src/
           ↓
Safe-RM analyzes and classifies:
  src/__pycache__/   → DELETE (build artifact)
  src/draft.py       → TRASH (untracked source - recoverable)
  src/notes.md       → TRASH (untracked docs - recoverable)
  .git/              → BLOCKED (protected path)
```

### Classification System

| Category | Action | Files |
|----------|--------|-------|
| **AUTO_ALLOW** | Delete directly (logged) | `node_modules/`, `dist/`, `build/`, `*.pyc`, `*.log` |
| **AUTO_TRASH** | Move to trash (recoverable) | Untracked `*.py`, `*.js`, `*.md`, config files |
| **BLOCK** | Refuse (error) | `.git/`, `/`, `/home`, `*important*` |

## Usage Examples

### Basic Commands

```bash
# Dry run (see what would happen)
rm -n somefile.txt

# Execute deletion
rm -f somefile.txt

# Recursive deletion
rm -rf node_modules/

# View deletion log
rm-log

# Check status
safe-rm-status
```

### Recovery

```bash
# List trashed files
trash-list

# Restore interactively
trash-restore

# View today's trashed items
trash-today
```

### Real-World Examples

**Clean project (mixed content):**
```bash
$ rm -rf src/
DELETED: src/__pycache__/ (build artifact)
TRASHED: src/draft.py (recoverable)
TRASHED: src/experimental.js (recoverable)
```

**Protection in action:**
```bash
$ rm -rf .git/
BLOCKED: Refusing to delete protected path: .git/
```

## AI Agent Integration

Safe-RM is designed to work seamlessly with AI coding agents:

### Supported Agents
- **Cursor IDE** – Load Agent Skill from `skills/safe-rm/SKILL.md` or raw URL
- **VSCode GitHub Copilot** – Reference skill in workspace
- **Claude Code** – Copy `skills/safe-rm/` to `~/.local/share/claude-skills/safe-rm/`
- **Continue.dev** – Custom prompt integration
- **Aider** – Compatible via zsh wrapper

### How Agents Use It

1. **Agent reads skill** from `skills/safe-rm/SKILL.md`
2. **Learns classification rules** (what's safe to delete)
3. **Executes safely** (check untracked files, trash source, delete artifacts, log to audit log)
4. **All operations logged** to `~/.local/state/safe-rm/audit.log` (or `SAFE_RM_AUDIT_LOG`)

See [IDE Integration](docs/IDE_INTEGRATION.md) for details.

## 🔧 Configuration

### Custom Rules

Create `~/.config/safe-rm/safe-rm-rules.yaml` (or set `SAFE_RM_CONFIG_DIR`). This project uses the `.yaml` extension for all YAML config files.

```yaml
auto_trash_patterns:
  - "*.secret"
  - "experiments/*"
  
block_patterns:
  - "*CRITICAL*"
  - "production-data/*"

settings:
  recent_hours: 24
  trash_retention_days: 30
```

### Environment Variables

```bash
SAFE_RM_AUDIT_LOG    # Audit log path (default: ~/.local/state/safe-rm/audit.log)
SAFE_RM_CONFIG_DIR   # Config directory (default: ~/.config/safe-rm)
SAFE_RM_FORCE=1      # Bypass wrapper temporarily
SAFE_RM_QUIET=1      # Silent mode
```

**Migration:** If you used the old `~/.rm-audit.log`, move it to `~/.local/state/safe-rm/audit.log` or set `SAFE_RM_AUDIT_LOG`.

## Features

- **Git-aware** - Detects repositories and untracked files
- **Non-interactive** - Perfect for AI agents and automation
- **Audit logging** - Complete deletion history
- **Trash integration** - Uses FreeDesktop.org trash spec
- **Btrfs/Snapper** - Additional snapshot protection
- **Customizable** - YAML-based configuration
- **Fast** - < 10ms classification overhead
- **Safe by default** - Dry-run mode

## 🧪 Testing

```bash
# Create test environment
mkdir test-project && cd test-project
git init
echo "test" > draft.py
echo "build" > file.pyc

# Test safe-rm
rm -n -rf .           # Dry run - see what would happen
```

## Documentation

- [Quick Start](docs/QUICKSTART.md)
- [IDE Setup (Cursor/VSCode)](docs/IDE_INTEGRATION.md)

## Requirements

**Required:**
- zsh (5.8+)
- git
- trash-cli

**Optional:**
- oh-my-zsh (recommended)
- snapper (for btrfs snapshots)

**Platform:**
- Linux (tested on OpenSUSE Tumbleweed)
- macOS (experimental support)

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md).

### Development Setup

```bash
# Fork and clone
git clone https://github.com/kayaman/safe-rm.git
cd safe-rm

# Lint (optional)
shellcheck bin/safe-rm safe-rm.plugin.zsh install.sh
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Credits

Built for developers using:
- Git for version control
- zsh and oh-my-zsh for shell
- AI coding agents (Cursor, Copilot, Claude Code)
- Linux (OpenSUSE Tumbleweed, Ubuntu, etc.)

Inspired by:
- [trash-cli](https://github.com/andreafrancia/trash-cli)
- [safe-rm](https://launchpad.net/safe-rm)
- The need for AI-agent-compatible file protection

## Support

- 📖 [Documentation](docs/)
- 🐛 [Issue Tracker](https://github.com/kayaman/safe-rm/issues)
- 💬 [Discussions](https://github.com/kayaman/safe-rm/discussions)

## Star History

If this project helped you, please consider giving it a star.

---

**Made for safe coding with AI assistants**
