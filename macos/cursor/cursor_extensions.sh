#!/bin/bash
# vim: set sw=4 sts=4 et foldmethod=indent :
#!/bin/bash

EXT_JSON="$HOME/.cursor/extensions/extensions.json"
EXT_LIST="cursor-extensions.txt"

print_usage() {
  echo "Usage: $0 [--backup | --restore]"
  echo "  --backup   Export installed Cursor extensions to $EXT_LIST"
  echo "  --restore  Install extensions listed in $EXT_LIST using VS Code CLI"
}

backup_extensions() {
  if [ ! -f "$EXT_JSON" ]; then
    echo "❌ extensions.json not found at $EXT_JSON"
    exit 1
  fi

  echo "📦 Exporting extensions from $EXT_JSON..."
  jq -r '.[].identifier.id' "$EXT_JSON" | sort -u > "$EXT_LIST"
  echo "✅ Saved $(wc -l < "$EXT_LIST") extensions to $EXT_LIST"
}

restore_extensions() {
  if [ ! -f "$EXT_LIST" ]; then
    echo "❌ $EXT_LIST not found"
    exit 1
  fi

  if ! command -v code &> /dev/null; then
    echo "⚠️ VS Code CLI ('code') not found."
    echo "👉 Open Cursor or VS Code and run:"
    echo "   'Shell Command: Install 'code' command in PATH'"
    exit 1
  fi

  echo "📥 Installing extensions from $EXT_LIST..."
  while IFS= read -r ext; do
    [ -n "$ext" ] && echo "🔧 Installing $ext..." && code --install-extension "$ext"
  done < "$EXT_LIST"
  echo "✅ Done installing extensions."
}

# Main
case "$1" in
  --backup)  backup_extensions ;;
  --restore) restore_extensions ;;
  *)         print_usage ;;
esac

