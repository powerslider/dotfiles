#!/usr/bin/env bash
# vim: set ft=sh sw=4 sts=4 et :
#
# Install custom keyboard layouts (Bulgarian Dvorak Phonetic) into
# ~/Library/Keyboard Layouts/. After install, log out and back in,
# then enable the layout in System Settings → Keyboard → Input Sources.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO_DIR/dvorak"
DEST="$HOME/Library/Keyboard Layouts"

mkdir -p "$DEST"

shopt -s nullglob
for f in "$SRC"/*.keylayout "$SRC"/*.icns; do
    cp -v "$f" "$DEST/"
done

echo
echo "Done. Log out and log back in, then add the layout in"
echo "  System Settings → Keyboard → Input Sources → +"
