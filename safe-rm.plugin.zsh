#!/usr/bin/env zsh
SAFE_RM_PLUGIN_DIR="${0:A:h}"
SAFE_RM_BIN="${SAFE_RM_PLUGIN_DIR}/bin/safe-rm"
SAFE_RM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/safe-rm"
SAFE_RM_AUDIT_LOG="${SAFE_RM_AUDIT_LOG:-$SAFE_RM_STATE_DIR/audit.log}"

if [[ ! -x "$SAFE_RM_BIN" ]]; then
    echo "[safe-rm] Warning: safe-rm binary not found at $SAFE_RM_BIN" >&2
    echo "[safe-rm] Run: cd ${SAFE_RM_PLUGIN_DIR} && ./install.sh" >&2
    return 1
fi

rm() {
    if [[ ! -t 0 ]] && [[ -z "$SAFE_RM_FORCE" ]]; then
        "$SAFE_RM_BIN" "$@"
    elif [[ "$1" == "--real-rm" ]]; then
        shift
        command rm "$@"
    else
        "$SAFE_RM_BIN" "$@"
    fi
}

alias rm-dry='rm -n'
alias rm-force='rm -f'
alias rm-real='command rm'
alias rm-log='tail -50 "${SAFE_RM_AUDIT_LOG}"'
alias rm-stats='grep "$(date +%Y-%m-%d)" "${SAFE_RM_AUDIT_LOG}" 2>/dev/null | wc -l'

alias trash='trash-put'
alias untrash='trash-restore'
alias trash-ls='trash-list'
alias trash-today='trash-list 2>/dev/null | grep "$(date +%Y-%m-%d)"'
alias trash-clean='trash-empty 30'

alias git-clean-dry='git clean -n -d'
alias git-clean-safe='git clean -i -d'

safe-to-delete() {
    echo "Build artifacts and dependencies (safe to delete):"
    echo "======================================================"
    find . -maxdepth 2 -type d \( \
        -name "node_modules" -o \
        -name "dist" -o \
        -name "build" -o \
        -name "target" -o \
        -name "__pycache__" -o \
        -name ".cache" -o \
        -name ".venv" -o \
        -name "venv" \
    \) 2>/dev/null | while read -r dir; do
        local size=$(du -sh "$dir" 2>/dev/null | cut -f1)
        echo "  $dir ($size)"
    done
    
    echo ""
    echo "Untracked files (will be moved to trash):"
    echo "=========================================="
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git ls-files --others --exclude-standard | head -20
        local count=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
        if [[ $count -gt 20 ]]; then
            echo "  ... and $((count - 20)) more"
        fi
    else
        echo "  (not in a git repository)"
    fi
}

safe-rm-status() {
    echo "Safe-RM Status"
    echo "=============="
    echo ""

    if [[ -x "$SAFE_RM_BIN" ]]; then
        echo "[OK] safe-rm installed: $SAFE_RM_BIN"
    else
        echo "[FAIL] safe-rm not found"
        return 1
    fi

    if command -v trash-put >/dev/null 2>&1; then
        echo "[OK] trash-cli installed"
    else
        echo "[FAIL] trash-cli not installed"
        echo "  Install: sudo zypper install trash-cli  (OpenSUSE)"
        echo "           sudo apt install trash-cli      (Ubuntu/Debian)"
        echo "           brew install trash-cli          (macOS)"
    fi

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "[OK] In Git repository: $(git rev-parse --show-toplevel)"
        local untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l)
        echo "  -> $untracked untracked files"
    else
        echo "[--] Not in a Git repository"
    fi

    if [[ -f "$SAFE_RM_AUDIT_LOG" ]]; then
        local today_count=$(grep "$(date +%Y-%m-%d)" "$SAFE_RM_AUDIT_LOG" 2>/dev/null | wc -l)
        local total_count=$(wc -l < "$SAFE_RM_AUDIT_LOG" 2>/dev/null)
        echo "[OK] Audit log: $SAFE_RM_AUDIT_LOG ($total_count total, $today_count today)"
    else
        echo "[--] No audit log yet"
    fi

    local trash_count=$(trash-list 2>/dev/null | wc -l)
    echo "[OK] Trashed files: $trash_count items"

    if command -v snapper >/dev/null 2>&1; then
        echo "[OK] Snapper available (additional protection layer)"
    fi

    if [[ -f "${SAFE_RM_PLUGIN_DIR}/skills/safe-rm/SKILL.md" ]]; then
        echo "[OK] IDE skill available: ${SAFE_RM_PLUGIN_DIR}/skills/safe-rm/SKILL.md"
    fi
}

safe_rm_preexec_hook() {
    local cmd="$1"
    case "$cmd" in
        *"rm -rf /"*|*"rm -rf ~"*|*"rm -rf /home"*)
            echo "WARNING: Extremely dangerous command detected!" >&2
            echo "   This will be BLOCKED by safe-rm" >&2
            ;;
        *"command rm"*|*"/bin/rm"*|*"/usr/bin/rm"*)
            echo "WARNING: Bypassing safe-rm protection!" >&2
            ;;
    esac
}

if [[ -z "${preexec_functions[(r)safe_rm_preexec_hook]}" ]]; then
    preexec_functions+=(safe_rm_preexec_hook)
fi

if [[ -z "$SAFE_RM_QUIET" ]] && [[ -t 1 ]]; then
    echo "safe-rm protection active (use 'safe-rm-status' for details)"
fi

export -f rm 2>/dev/null || true
export -f safe-to-delete 2>/dev/null || true
export -f safe-rm-status 2>/dev/null || true
