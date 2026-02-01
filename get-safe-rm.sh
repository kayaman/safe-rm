#!/bin/bash
set -euo pipefail

SAFE_RM_REPO="${SAFE_RM_REPO:-https://github.com/kayaman/safe-rm.git}"
SAFE_RM_BRANCH="${SAFE_RM_BRANCH:-main}"
OH_MY_ZSH=0

for arg in "$@"; do
    case "$arg" in
        --oh-my-zsh) OH_MY_ZSH=1 ;;
    esac
done

if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: git is required. Install git and run again." >&2
    exit 1
fi

if [[ "$OH_MY_ZSH" -eq 1 ]]; then
    INSTALL_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/safe-rm"
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}" ]]; then
        echo "ERROR: Oh My Zsh custom dir not found. Install Oh My Zsh first or use standalone: curl -LsSf .../get-safe-rm.sh | sh" >&2
        exit 1
    fi
else
    INSTALL_DIR="${HOME}/.local/share/safe-rm"
fi

mkdir -p "$(dirname "$INSTALL_DIR")"
if [[ -d "$INSTALL_DIR/.git" ]]; then
    echo "Updating safe-rm at $INSTALL_DIR"
    (cd "$INSTALL_DIR" && git fetch origin && git checkout "$SAFE_RM_BRANCH" && git pull --ff-only)
else
    echo "Installing safe-rm to $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"
    git clone --depth 1 --branch "$SAFE_RM_BRANCH" "$SAFE_RM_REPO" "$INSTALL_DIR"
fi

if [[ ! -x "$INSTALL_DIR/install.sh" ]]; then
    echo "ERROR: install.sh not found in $INSTALL_DIR" >&2
    exit 1
fi

if [[ "$OH_MY_ZSH" -eq 1 ]]; then
    "$INSTALL_DIR/install.sh" --oh-my-zsh
else
    "$INSTALL_DIR/install.sh"
fi
