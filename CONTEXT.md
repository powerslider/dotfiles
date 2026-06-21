# Context

Domain glossary for this repo. Terminology only.

## How to maintain this file

Add a term when a change introduces a concept a reviewer would need
defined. Keep each entry to one or two sentences of essence. No code, no
file paths, no implementation detail, no decisions (those go in
docs/adr/). Group terms by the flow they belong to, in rough dependency
order.

> Draft status: this starter set was generated from the codebase and has
> not had a human curation pass yet. Confirm, rename, or cut freely.

## Bootstrap flow

- **Bootstrap** - The one-shot, idempotent machine setup: Homebrew, then
  the Brewfile, then chezmoi init and apply, then runtimes, then macOS
  defaults. Re-running it must always be safe.
- **Brewfile** - The declarative manifest of every OS-level dependency
  (formulae, casks, taps, App Store apps). A tool is not a dependency of
  this repo until it appears here.
- **Machine defaults** - macOS system preferences (keyboard, Finder,
  Dock, trackpad) applied as a scripted, reviewable batch rather than
  clicked through System Settings.

## Chezmoi layer

- **Source state** - The chezmoi source tree under `home/`, the single
  source of truth for dotfiles. Files are edited here and deployed to
  `$HOME` with `chezmoi apply`, never edited in place.
- **Identity switching** - The dual git identity scheme: a personal
  identity by default, with the work identity applied automatically to
  repos under the work directories. Identity values are prompted once at
  chezmoi init and live outside the repo.
- **SSH commit signing** - Git commits and tags are signed with an SSH
  key instead of GPG, with a templated allowed-signers list per
  identity.

## Shell environment

- **Shell stack** - The layered zsh configuration: environment-only
  setup that runs for every shell, interactive setup, and a small set of
  sourced fragments for aliases, functions, and path. Expensive tools
  load lazily.
- **Runtime manager** - mise, the single tool that owns all language
  runtime versions (Go, Rust, Node, Python). It replaces nvm, jenv, and
  friends, which are deliberately absent.

## Editor and input

- **Keyboard layout** - The custom Bulgarian Dvorak Phonetic layout,
  shipped as layout and icon files and installed into the user's
  keyboard layouts, then enabled manually in System Settings.
- **Cursor integration** - Cursor is installed manually (its updater
  conflicts with the Homebrew cask) but its settings, keybindings, and
  extension list are version-controlled and deployed by script.
- **Claude Code integration** - The Claude Code configuration managed
  as part of the source state: global instructions, a settings merge
  that registers the NitPickle plugin marketplace and enables the
  plugin, and the global NitPickle defaults. Skills and commands come
  from the plugin itself, not from managed dotfiles.
