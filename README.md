# dotfiles

Personal configuration for macOS development environments. Managed with
[chezmoi](https://www.chezmoi.io/) on top of a single-shot bootstrap that
runs [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle), then
applies the chezmoi source state, then applies macOS system defaults.

## Layout

```
dotfiles/
├── Brewfile                          # all brew/cask deps
├── bootstrap.sh                      # one-shot Mac bootstrap
├── defaults.sh                       # macOS system defaults
├── install-cursor.sh                 # Cursor settings + extensions
├── install-keyboard-layouts.sh       # custom keyboard layouts
├── cursor/                           # Cursor settings + extension list
├── dvorak/                           # Bulgarian Dvorak Phonetic layout
└── home/                             # chezmoi source
    ├── dot_zshrc, dot_zshenv, dot_shell/        # shell stack
    ├── dot_gitconfig.tmpl, dot_ssh/             # identity + agent
    └── dot_config/{nvim, starship.toml, …}      # tool configs
```

## Bootstrap a fresh Mac

```bash
git clone git@github.com:powerslider/dotfiles.git ~/git-repos/dotfiles
cd ~/git-repos/dotfiles
./bootstrap.sh
```

`bootstrap.sh` will:
1. Install Homebrew if missing.
2. `brew bundle install` against the `Brewfile`.
3. Remove legacy `~/.zshrc` / `~/.shell` symlinks from any previous setup.
4. `chezmoi init --apply` from this checkout, prompting for git identity.
5. Run `./defaults.sh` for macOS preferences (skip with `--no-defaults`).

Flags:
- `--dry-run` — show changes without applying.
- `--no-defaults` — skip macOS defaults pass.

## Post-install (manual)

- Install Cursor from https://cursor.com, then `./install-cursor.sh`.
- `./install-keyboard-layouts.sh`, log out + back in, enable in System
  Settings → Keyboard → Input Sources.
- `mise install` to materialise runtimes from `~/.config/mise/config.toml`.
- `ssh-add --apple-use-keychain ~/.ssh/<key>` for each SSH key.

