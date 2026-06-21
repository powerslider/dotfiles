#!/usr/bin/env bash
# Bootstrap a fresh macOS environment from this repo.
#
#   1. Installs Homebrew if missing
#   2. Installs everything in Brewfile (formulae, casks, vscode extensions)
#   3. Removes legacy ~/.dotfile symlinks left by the old install.sh
#   4. Initialises chezmoi with this repo as source and applies it
#   5. Installs language runtimes via mise
#   6. Installs the nitpickle Claude Code plugin and Serena MCP server
#   7. Applies the macOS defaults (defaults.sh)
#
# Idempotent: safe to re-run.
#
# Usage:
#   ./bootstrap.sh                # full bootstrap
#   ./bootstrap.sh --no-defaults  # skip defaults.sh
#   ./bootstrap.sh --dry-run      # show what chezmoi would do without applying

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
APPLY_DEFAULTS=1

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --no-defaults) APPLY_DEFAULTS=0 ;;
        -h | --help)
            sed -n '2,17p' "$0"
            exit 0
            ;;
        *)
            echo "Unknown flag: $arg" >&2
            exit 2
            ;;
    esac
done

log() { printf '\033[1;34m▸\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*" >&2; }

# ---------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------
if ! command -v brew > /dev/null 2>&1; then
    log "Installing Homebrew…"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    log "Homebrew already installed: $(brew --version | head -1)"
fi

# ---------------------------------------------------------------------
# 2. Brewfile
# ---------------------------------------------------------------------
log "Running brew bundle…"
if [[ $DRY_RUN -eq 1 ]]; then
    brew bundle check --file="$REPO_ROOT/Brewfile" --verbose || true
else
    brew bundle install --file="$REPO_ROOT/Brewfile"
fi

# ---------------------------------------------------------------------
# 3. Remove legacy symlinks left behind by the old install.sh
# ---------------------------------------------------------------------
LEGACY_LINKS=(
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.gitconfig"
    "$HOME/.shell"
)

log "Removing legacy symlinks pointing into the dotfiles repo…"
for link in "${LEGACY_LINKS[@]}"; do
    if [[ -L "$link" ]]; then
        target=$(readlink "$link")
        case "$target" in
            *git-repos/dotfiles/* | */dotfiles/*)
                if [[ $DRY_RUN -eq 1 ]]; then
                    echo "  [dry-run] would rm $link (-> $target)"
                else
                    rm -v "$link"
                fi
                ;;
        esac
    fi
done

# ---------------------------------------------------------------------
# 4. chezmoi
# ---------------------------------------------------------------------
if ! command -v chezmoi > /dev/null 2>&1; then
    warn "chezmoi not on PATH after brew bundle — open a new shell and re-run"
    exit 1
fi

log "Initialising chezmoi from local source: $REPO_ROOT"
if [[ $DRY_RUN -eq 1 ]]; then
    chezmoi init --source="$REPO_ROOT" --dry-run
    chezmoi diff --source="$REPO_ROOT"
else
    # init wires up the source-state location and runs the .chezmoi.toml.tmpl
    # prompts on first use; re-runs are no-ops.
    chezmoi init --source="$REPO_ROOT"
    chezmoi apply --source="$REPO_ROOT"
fi

# ---------------------------------------------------------------------
# 5. mise — materialise runtimes from ~/.config/mise/config.toml
# ---------------------------------------------------------------------
if command -v mise > /dev/null 2>&1; then
    log "Installing runtimes via mise (go, rust, …)"
    if [[ $DRY_RUN -eq 1 ]]; then
        mise ls --current 2> /dev/null || true
    else
        mise install --yes
    fi
else
    warn "mise not on PATH — skipping runtime install; open a new shell and run 'mise install'"
fi

# ---------------------------------------------------------------------
# 6. Claude Code plugin + MCP servers
# ---------------------------------------------------------------------
if command -v claude > /dev/null 2>&1; then
    log "Installing Claude Code plugin: nitpickle"
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "  [dry-run] would run: claude plugin install nitpickle@nitpickle --scope user"
    else
        claude plugin install nitpickle@nitpickle --scope user \
            || warn "plugin install failed, run 'claude plugin install nitpickle@nitpickle' manually"
    fi
else
    warn "claude not on PATH, install Claude Code then run 'claude plugin install nitpickle@nitpickle'"
fi

# Serena MCP server binary. Registration in settings.json is handled by
# the chezmoi apply above. This step installs the executable it launches.
if command -v uv > /dev/null 2>&1; then
    log "Installing Serena MCP server via uv"
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "  [dry-run] would run: uv tool install -p 3.13 serena-agent"
    else
        uv tool install -p 3.13 serena-agent \
            || warn "serena install failed, run 'uv tool install -p 3.13 serena-agent' manually"
    fi
else
    warn "uv not on PATH, install it then run 'uv tool install -p 3.13 serena-agent'"
fi

# ---------------------------------------------------------------------
# 7. macOS defaults
# ---------------------------------------------------------------------
if [[ $APPLY_DEFAULTS -eq 1 ]]; then
    log "Applying macOS defaults…"
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "  [dry-run] would run $REPO_ROOT/defaults.sh"
    else
        "$REPO_ROOT/defaults.sh"
    fi
fi

log "Done."
echo
echo "Next steps:"
echo "  • Open a new shell so PATH/env changes take effect"
echo "  • Install Cursor from https://cursor.com (not in Brewfile — manual)"
echo "  • ./install-cursor.sh                    # Cursor settings + extensions"
echo "  • ./install-keyboard-layouts.sh          # Bulgarian Dvorak layout"
