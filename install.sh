#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_METHOD=""

for arg in "$@"; do
    if [[ "$arg" == "--oh-my-zsh" ]]; then
        INSTALL_METHOD="oh-my-zsh"
        break
    fi
done

if [[ -z "$INSTALL_METHOD" ]]; then
    if [[ "$SCRIPT_DIR" == *".oh-my-zsh/custom/plugins/safe-rm"* ]]; then
        INSTALL_METHOD="oh-my-zsh"
    elif [[ "$SCRIPT_DIR" == *"${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/safe-rm"* ]]; then
        INSTALL_METHOD="oh-my-zsh"
    else
        INSTALL_METHOD="standalone"
    fi
fi

echo -e "${BLUE}Safe-RM Installation${NC}"
echo "===================="
echo ""
if [[ "$INSTALL_METHOD" == "oh-my-zsh" ]]; then
    echo "Detected: oh-my-zsh plugin installation"
else
    echo "Detected: standalone installation"
fi

echo ""

echo -e "${BLUE}[1/4]${NC} Checking prerequisites..."

if ! command -v zsh >/dev/null 2>&1; then
    echo -e "${RED}ERROR: zsh is not installed${NC}"
    echo "Install with:"
    echo "  - OpenSUSE: sudo zypper install zsh"
    echo "  - Ubuntu/Debian: sudo apt install zsh"
    echo "  - macOS: brew install zsh"
    exit 1
fi
echo -e "${GREEN}[OK]${NC} zsh found"

if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}ERROR: git is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}[OK]${NC} git found"

# Step 2: Install trash-cli
echo ""
echo -e "${BLUE}[2/4]${NC} Installing trash-cli..."

if command -v trash-put >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} trash-cli already installed"
else
    echo "Installing trash-cli..."

    if command -v zypper >/dev/null 2>&1; then
        # OpenSUSE
        sudo zypper install -y trash-cli
    elif command -v apt >/dev/null 2>&1; then
        # Ubuntu/Debian
        sudo apt install -y trash-cli
    elif command -v dnf >/dev/null 2>&1; then
        # Fedora
        sudo dnf install -y trash-cli
    elif command -v brew >/dev/null 2>&1; then
        # macOS
        brew install trash-cli
    else
        echo -e "${YELLOW}Warning: Could not detect package manager${NC}"
        echo "Please install trash-cli manually:"
        echo "  pip install trash-cli"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi

    if command -v trash-put >/dev/null 2>&1; then
        echo -e "${GREEN}[OK]${NC} trash-cli installed"
    else
        echo -e "${RED}ERROR: Failed to install trash-cli${NC}"
        exit 1
    fi
fi

echo ""
if [[ "$INSTALL_METHOD" == "oh-my-zsh" ]]; then
    echo -e "${BLUE}[3/4]${NC} Configuring oh-my-zsh plugin..."
    ZSHRC="${HOME}/.zshrc"
    
    if grep -q "plugins=.*safe-rm" "$ZSHRC" 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} safe-rm already in plugins"
    else
        echo "Adding safe-rm to oh-my-zsh plugins..."
        cp "$ZSHRC" "${ZSHRC}.backup.$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true

        if grep -q "^plugins=" "$ZSHRC"; then
            sed -i.bak 's/plugins=(/plugins=(safe-rm /' "$ZSHRC"
            echo -e "${GREEN}[OK]${NC} Added safe-rm to plugins"
        else
            echo -e "${YELLOW}Warning: Could not find plugins= line in .zshrc${NC}"
            echo "Please add 'safe-rm' to your plugins manually:"
            echo "  plugins=(git ... safe-rm)"
        fi
    fi
else
    echo -e "${BLUE}[3/4]${NC} Installing standalone..."
    mkdir -p "${HOME}/.local/bin"
    cp "${SCRIPT_DIR}/bin/safe-rm" "${HOME}/.local/bin/safe-rm"
    chmod +x "${HOME}/.local/bin/safe-rm"
    echo -e "${GREEN}[OK]${NC} Installed to ~/.local/bin/safe-rm"
    
    # Setup zsh integration
    ZSHRC="${HOME}/.zshrc"
    
    if grep -q "source.*safe-rm.plugin.zsh" "$ZSHRC" 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} safe-rm already sourced in .zshrc"
    else
        echo "Adding safe-rm to .zshrc..."
        cp "$ZSHRC" "${ZSHRC}.backup.$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true
        
        cat >> "$ZSHRC" << EOF

# Safe-RM protection
source "${SCRIPT_DIR}/safe-rm.plugin.zsh"
EOF
        echo -e "${GREEN}[OK]${NC} Added to .zshrc"
    fi

    if ! grep -q "export PATH.*\.local/bin" "$ZSHRC" 2>/dev/null; then
        echo "" >> "$ZSHRC"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSHRC"
        echo -e "${GREEN}[OK]${NC} Added ~/.local/bin to PATH"
    fi
fi

echo ""
echo -e "${BLUE}[4/4]${NC} IDE Integration..."

echo "Available IDE integrations:"
echo ""
echo "Cursor IDE:"
echo "   Add rule from URL: https://raw.githubusercontent.com/kayaman/safe-rm/main/skills/safe-rm/SKILL.md"
echo "   Or copy skill: cp ${SCRIPT_DIR}/skills/safe-rm/SKILL.md /path/to/your/project/.cursor/rules/"
echo ""
echo "VSCode:"
echo "   Reference skill: ${SCRIPT_DIR}/skills/safe-rm/SKILL.md"
echo ""
echo "Claude Code:"
echo "   Copy skills/safe-rm/ to ~/.local/share/claude-skills/safe-rm/"
echo ""

echo ""
echo -e "${BLUE}Additional Features:${NC}"
if command -v snapper >/dev/null 2>&1; then
    echo -e "${GREEN}[OK]${NC} Snapper detected - btrfs snapshot protection available"
else
    echo -e "${YELLOW}[--]${NC} Snapper not found (optional btrfs feature)"
fi

echo ""
echo -e "${GREEN}=============================================="
echo "Installation Complete!"
echo "==============================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or: source ~/.zshrc"
echo "  2. Check status: safe-rm-status"
echo "  3. Test with: rm --help"
echo ""
echo "Usage:"
echo "  rm -n file.txt        # Dry run"
echo "  rm -f file.txt        # Execute deletion"
echo "  trash-list            # View trashed files"
echo "  trash-restore         # Restore files"
echo "  rm-log                # View deletion log"
echo ""
echo "IDE Setup:"
echo "  See: ${SCRIPT_DIR}/docs/IDE_INTEGRATION.md"
echo ""
echo -e "${BLUE}Documentation:${NC} ${SCRIPT_DIR}/README.md"
echo ""
