# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.2] - 2026-02-01

### Fixed
- CI: shellcheck fixes (SC2155, SC2086) in bin/safe-rm and safe-rm.plugin.zsh
- CI: source plugin from workspace instead of ~/.zshrc for robust test steps
- CI: replace deprecated gaurav-nelson/github-action-markdown-link-check with tcort/github-action-markdown-link-check

## [1.0.1] - 2026-02-01

### Added
- Git-aware file deletion protection
- AI agent integration (Cursor, VSCode, Claude Code)
- Oh-my-zsh plugin support
- Agent Skill skills/safe-rm/SKILL.md (Agent Skills spec)
- One-liner install: curl -LsSf .../get-safe-rm.sh | sh (optional --oh-my-zsh)
- XDG config/log paths (~/.config/safe-rm/, ~/.local/state/safe-rm/audit.log; SAFE_RM_CONFIG_DIR, SAFE_RM_AUDIT_LOG)
- Trash-cli integration, Btrfs/Snapper support
- IDE integration guides, install.sh and get-safe-rm.sh
- Comprehensive documentation, MIT License

### Features
- Smart file classification (ALLOW/TRASH/BLOCK), dry-run by default
- Helper aliases (rm-log, trash-restore, safe-rm-status), preexec hooks

### Platform Support
- Linux (OpenSUSE, Ubuntu, Fedora), macOS (experimental), zsh 5.8+, oh-my-zsh optional

[1.0.1]: https://github.com/kayaman/safe-rm/releases/tag/v1.0.1
[1.0.2]: https://github.com/kayaman/safe-rm/releases/tag/v1.0.2
