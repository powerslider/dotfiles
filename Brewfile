# vim: ft=ruby
#
# Run `brew bundle install` (or `brew bundle install --file=Brewfile`)
# from the repo root to install everything.
#
# Curated from `brew bundle dump` on 2026-04-30, then trimmed
# (removed asdf/jenv/nvm in favour of mise; removed autojump in
# favour of zoxide) and extended with the modernisation picks.

# ---------------------------------------------------------------------
# Taps
# ---------------------------------------------------------------------
tap "ethereum/ethereum"
tap "hashicorp/tap"

# ---------------------------------------------------------------------
# Dotfile + runtime + bootstrap
# ---------------------------------------------------------------------
brew "chezmoi"             # dotfile manager (this repo)
brew "mise"                # one runtime manager (replaces nvm + jenv + asdf)
brew "sheldon"             # declarative zsh plugin manager (replaces antigen)

# ---------------------------------------------------------------------
# Modern CLI replacements / additions
# ---------------------------------------------------------------------
brew "starship"            # prompt (replaces the manual oh-my-zsh theme)
brew "fzf"                 # fuzzy finder
brew "zoxide"              # smarter cd (replaces autojump)
brew "atuin"               # cloud-sync'd shell history
brew "eza"                 # modern ls
brew "bat"                 # modern cat with syntax highlighting
brew "git-delta"           # better git diffs (already wired in dot_gitconfig)
brew "direnv"              # per-directory env vars
brew "ripgrep"             # modern grep
brew "fd"                  # modern find
brew "yt-dlp"              # replaces the binary blob we deleted

# ---------------------------------------------------------------------
# Editor + terminal multiplexing
# ---------------------------------------------------------------------
brew "neovim"              # for LazyVim
brew "tmux"                # in case
brew "lazygit"             # TUI git client, complements gh

# ---------------------------------------------------------------------
# Shell utilities
# ---------------------------------------------------------------------
brew "bash"                # current Bash, not the macOS-shipped 3.2
brew "coreutils"           # GNU versions (gls, gcp, …)
brew "gnu-tar"             # GNU tar (gtar)
brew "grep"                # GNU grep (ggrep, also gives gnubin/grep)
brew "jq"                  # JSON query
brew "ncdu"                # disk-usage TUI
brew "duti"                # set default macOS file-type handlers

# ---------------------------------------------------------------------
# Linting / format (used by repo CI)
# ---------------------------------------------------------------------
brew "shellcheck"
brew "shfmt"

# ---------------------------------------------------------------------
# Security / git ops
# ---------------------------------------------------------------------
brew "gh"                  # GitHub CLI
brew "kubernetes-cli"      # kubectl — backs the `k=kubectl` alias
brew "git"                 # current git, not the Xcode-bundled one
brew "gitleaks"            # secret scanning
brew "gnupg"               # for commit signing
brew "pre-commit"          # pre-commit hook framework

# ---------------------------------------------------------------------
# Cloud / infra
# ---------------------------------------------------------------------
brew "awscli"
brew "cloud-sql-proxy"
brew "hashicorp/tap/terraform"

# ---------------------------------------------------------------------
# Languages & build tools
# ---------------------------------------------------------------------
brew "bazelisk"            # Bazel launcher
brew "buildifier"          # Bazel BUILD formatter
brew "ethereum"            # geth
brew "exercism"            # exercism.io CLI
brew "ffmpeg"              # media swiss-army-knife
brew "delve"               # Go debugger (used by Zed's DAP integration)
brew "goreleaser"          # Go release tooling
brew "graphviz"            # dot
brew "libpq"               # Postgres client lib
brew "act", args: ["HEAD"] # local GitHub Actions runner

# ---------------------------------------------------------------------
# Casks
# ---------------------------------------------------------------------
# Cursor is installed manually from https://cursor.com — the Homebrew
# cask fights with Cursor's own auto-updater and tripped xattr errors
# on adoption. Settings + extensions are still managed via
# ./install-cursor.sh (see below).
cask "raycast"                         # launcher + clipboard history + window management
cask "ghostty"                         # modern terminal
cask "t3-code"                         # AI coding GUI
cask "font-fira-code-nerd-font"        # primary coding font (Nerd Font for icons)
cask "font-jetbrains-mono-nerd-font"   # alt coding font

# ---------------------------------------------------------------------
# Cursor / VS Code extensions
# Managed separately from Homebrew via ./install-cursor.sh, which
# uses the cursor CLI directly. The list of extensions lives in
# cursor/cursor-extensions.txt.
# ---------------------------------------------------------------------
