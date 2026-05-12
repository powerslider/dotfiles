#!/usr/bin/env bash
# vim: set ft=sh sw=4 sts=4 et :
#
# macOS system defaults.
#
# Idempotent — `defaults write` is set-not-toggle, so re-running is safe.
# Some changes need a logout or app relaunch (Finder, Dock, SystemUIServer)
# to take effect; the trailing `killall` block handles that.
#
# Run via bootstrap.sh, or standalone:
#   ./defaults.sh

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "defaults.sh is macOS-only — got $(uname -s)" >&2
    exit 1
fi

log() { printf '\033[1;34m▸\033[0m %s\n' "$*"; }

# Close System Preferences first, otherwise it can override changes
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

# Ask for sudo upfront and keep alive for the duration
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ---------------------------------------------------------------------
# General UI/UX
# ---------------------------------------------------------------------
log "General UI/UX"

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Auto-quit printer app when print jobs finish
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable smart quotes/dashes (they're hostile to writing code)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ---------------------------------------------------------------------
# Keyboard
# ---------------------------------------------------------------------
log "Keyboard"

# Full keyboard access for all controls (Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favour of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Fast key repeat. UI minima are KeyRepeat=2 (15ms) and InitialKeyRepeat=15 (225ms);
# going lower can cause input issues in some apps.
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# ---------------------------------------------------------------------
# Trackpad / mouse
# ---------------------------------------------------------------------
log "Trackpad"

# Tap-to-click for the current user and the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ---------------------------------------------------------------------
# Power management (requires sudo)
# ---------------------------------------------------------------------
log "Power management"

# Disable hibernation (speeds up sleep, kills the giant /var/vm/sleepimage)
sudo pmset -a hibernatemode 0

# Sudden motion sensor: useless on SSDs/current MacBooks
sudo pmset -a sms 0

# ---------------------------------------------------------------------
# Finder
# ---------------------------------------------------------------------
log "Finder"

# Show hidden files and all filename extensions
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Don't warn when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Don't write .DS_Store on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# ---------------------------------------------------------------------
# Dock + Mission Control
# ---------------------------------------------------------------------
log "Dock + Mission Control"

# Keep the Dock visible (no auto-hide). If you later want auto-hide,
# flip this to `-bool true` and the two timing tweaks below kick in to
# make it appear instantly when you hit the screen edge.
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2

# Smaller Dock icons
defaults write com.apple.dock tilesize -int 42

# Speed up Mission Control + group windows by application
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock expose-group-by-app -bool true

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# ---------------------------------------------------------------------
# Screenshots
# ---------------------------------------------------------------------
log "Screenshots"

mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ---------------------------------------------------------------------
# Safari (debug + privacy)
#
# Safari prefs live inside ~/Library/Containers/com.apple.Safari/ and
# require the executing process (Terminal / iTerm / Ghostty) to hold
# "Full Disk Access" to be writable. If you haven't granted that, these
# writes will print a "Could not write domain" warning and be skipped —
# everything else above still applies.
# ---------------------------------------------------------------------
log "Safari (requires Full Disk Access for the terminal app)"

safari_defaults() {
    if ! defaults write "$@" 2>/dev/null; then
        echo "  (skipped — grant Full Disk Access to your terminal to enable Safari prefs)"
        return 0
    fi
}

# Privacy: don't send search queries to Apple
safari_defaults com.apple.Safari UniversalSearchEnabled -bool false
safari_defaults com.apple.Safari SuppressSearchSuggestions -bool true

# Developer menu + Web Inspector
safari_defaults com.apple.Safari IncludeInternalDebugMenu -bool true
safari_defaults com.apple.Safari IncludeDevelopMenu -bool true
safari_defaults com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
safari_defaults com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# ---------------------------------------------------------------------
# Default apps (file type → handler) via duti
# ---------------------------------------------------------------------
if command -v duti >/dev/null 2>&1; then
    log "Default app handlers"
    duti -s com.mitchellh.ghostty public.shell-script         all 2>/dev/null || true
    duti -s com.mitchellh.ghostty public.unix-executable      all 2>/dev/null || true
    duti -s com.mitchellh.ghostty com.apple.terminal.shell-script all 2>/dev/null || true
else
    echo "  (duti not installed — skip default-app registration; brew install duti)"
fi

# ---------------------------------------------------------------------
# Apply
# ---------------------------------------------------------------------
log "Restarting affected services…"
for app in Finder Dock SystemUIServer cfprefsd; do
    killall "$app" >/dev/null 2>&1 || true
done

log "Done. Some changes (e.g. keyboard repeat) require a logout to fully apply."
