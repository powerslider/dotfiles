#!/usr/bin/env bash
# vim: set ft=sh sw=4 sts=4 et :
#
# Install Cursor user settings + extensions.
#
#   ./install-cursor.sh                 # settings + extensions
#   ./install-cursor.sh --settings-only # just copy settings + keybindings
#   ./install-cursor.sh --extensions    # just (re)install extensions
#   ./install-cursor.sh --backup        # write extensions list back to cursor/cursor-extensions.txt

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_DIR="$REPO_DIR/cursor"
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
EXT_LIST="$CURSOR_DIR/cursor-extensions.txt"

log() { printf '\033[1;34m▸\033[0m %s\n' "$*"; }
err() { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }

cmd="cursor"
if ! command -v "$cmd" >/dev/null 2>&1; then
    # Cursor's CLI lives at this path on macOS by default
    cmd="/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
    if [[ ! -x "$cmd" ]]; then
        err "cursor CLI not found. Install Cursor (\`brew install --cask cursor\`) or run 'Shell Command: Install cursor command' from inside Cursor."
    fi
fi

apply_settings() {
    log "Copying settings.json + keybindings.json into $CURSOR_USER_DIR"
    mkdir -p "$CURSOR_USER_DIR"
    cp "$CURSOR_DIR/settings.json"    "$CURSOR_USER_DIR/settings.json"
    cp "$CURSOR_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
}

install_extensions() {
    [[ -f "$EXT_LIST" ]] || err "$EXT_LIST not found"
    log "Installing $(wc -l < "$EXT_LIST" | tr -d ' ') Cursor extensions…"
    while IFS= read -r ext; do
        [[ -z "$ext" || "$ext" =~ ^# ]] && continue
        echo "  • $ext"
        "$cmd" --install-extension "$ext" --force >/dev/null
    done < "$EXT_LIST"
}

backup_extensions() {
    log "Dumping installed extensions to $EXT_LIST"
    "$cmd" --list-extensions | sort -u > "$EXT_LIST"
    echo "  $(wc -l < "$EXT_LIST" | tr -d ' ') extensions saved"
}

case "${1:-all}" in
    all)               apply_settings; install_extensions ;;
    --settings-only)   apply_settings ;;
    --extensions)      install_extensions ;;
    --backup)          backup_extensions ;;
    -h|--help)         sed -n '2,10p' "$0" ;;
    *)                 err "Unknown flag: $1" ;;
esac
