# dotfiles

Personal configuration for macOS development environments, managed with
[chezmoi](https://www.chezmoi.io/) on top of a single idempotent bootstrap
script.

[![lint](https://github.com/powerslider/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/powerslider/dotfiles/actions/workflows/lint.yml)

One command takes a fresh Mac to a working setup: Homebrew packages, shell,
editors, language runtimes, git identities, and system defaults. Everything
is declarative and re-runnable, so the same command also brings an existing
machine back into line.

> This is a personal setup, shared in the open. Read before you run it, and
> fork rather than clone if you want to adapt it. The git identities, signing
> keys, and machine defaults are mine.

## Contents

- [Highlights](#highlights)
- [Prerequisites](#prerequisites)
- [Quick start](#quick-start)
- [What bootstrap does](#what-bootstrap-does)
- [How it is organized](#how-it-is-organized)
- [Daily use](#daily-use)
- [Post-install steps](#post-install-steps)
- [Conventions](#conventions)

## Highlights

- **One-shot bootstrap.** `./bootstrap.sh` is idempotent and safe to re-run.
  A `--dry-run` flag previews every change before it touches the machine.
- **Declarative packages.** Every Homebrew formula, cask, and font lives in
  the [`Brewfile`](Brewfile). A tool is not a dependency until it appears
  there, and CI proves each entry still resolves.
- **chezmoi-managed source state.** Dotfiles are edited in [`home/`](home)
  and applied to `$HOME`, never edited in place. Templating drives the
  per-machine and per-identity differences.
- **Dual git identity.** A personal identity by default, with the work
  identity applied automatically to repos under the work directories via
  `includeIf`. Commits and tags are signed with an SSH key.
- **Modern shell stack.** zsh with [sheldon](https://sheldon.cli.rs/)
  plugins, the [starship](https://starship.rs/) prompt, and
  [mise](https://mise.jdx.dev/) as the single runtime manager for Go, Rust,
  Node, and Python.
- **Superset worktree workflow.** A `ws-new` helper creates and opens
  parallel agent worktrees by name, and the prompt shows which project and
  worktree you are in.

## Prerequisites

- macOS (Apple Silicon or Intel).
- An SSH key registered with GitHub, so the repo clones over SSH and commit
  signing works.
- Command Line Tools for Xcode, which Homebrew installs on first run if they
  are missing.

## Quick start

```bash
git clone git@github.com:powerslider/dotfiles.git ~/git-repos/dotfiles
cd ~/git-repos/dotfiles
./bootstrap.sh
```

Preview first without changing anything:

```bash
./bootstrap.sh --dry-run
```

Flags:

| Flag | Effect |
| --- | --- |
| `--dry-run` | Show what chezmoi and the install steps would do, apply nothing. |
| `--no-defaults` | Skip the macOS system defaults pass. |

## What bootstrap does

`bootstrap.sh` runs these steps in order, each one a no-op when already
satisfied:

1. Install Homebrew if it is missing.
2. `brew bundle install` against the [`Brewfile`](Brewfile).
3. Remove legacy `~/.zshrc` and `~/.shell` symlinks from any previous setup.
4. `chezmoi init --apply` from this checkout, prompting once for git
   identity values.
5. `mise install` to materialise language runtimes.
6. Install the [nitpickle](https://github.com/powerslider/nitpickle) Claude
   Code plugin.
7. Run [`defaults.sh`](defaults.sh) for macOS preferences, unless
   `--no-defaults` is passed.

## How it is organized

Two things are worth knowing, the rest follows chezmoi's own conventions:

- [`home/`](home) is the chezmoi **source state**. Everything under it is
  applied to `$HOME`, with chezmoi's naming translating `dot_zshrc` to
  `~/.zshrc`, `private_` to restricted permissions, and `.tmpl` to a
  templated file. This is the directory you edit.
- The repo root holds the **bootstrap machinery** that runs once per
  machine: the `Brewfile`, `bootstrap.sh`, `defaults.sh`, and the `cursor/`
  and `dvorak/` install helpers. These are not deployed to `$HOME`.

Browse [`home/`](home) to see exactly what is managed.

## Daily use

**Change a dotfile.** Edit the source under `home/`, then apply it. Never
edit the deployed file in `$HOME` directly, chezmoi will overwrite it on the
next apply.

```bash
chezmoi edit ~/.zshrc      # opens home/dot_zshrc
chezmoi diff               # preview pending changes
chezmoi apply              # deploy
```

**Add a tool.** Add the line to the `Brewfile`, run `brew bundle install`,
and commit. CI checks that every entry still resolves.

**Create a Superset worktree.** The `ws-new` shell helper wraps the Superset
CLI to create a workspace, name it, and open it in the app. With a branch
argument it uses that branch, otherwise it names the workspace sequentially.

```bash
ws-new avalanchego powerslider/5435-min-price-excess-header
```

## Post-install steps

A few things are intentionally manual:

- **Cursor.** Install from [cursor.com](https://cursor.com), then run
  `./install-cursor.sh`. The Homebrew cask fights Cursor's own auto-updater,
  so it stays out of the `Brewfile`.
- **Keyboard layout.** Run `./install-keyboard-layouts.sh`, log out and back
  in, then enable the layout under System Settings, Keyboard, Input Sources.
- **SSH keys.** Add each key to the agent and keychain with
  `ssh-add --apple-use-keychain ~/.ssh/<key>`.

## Conventions

- **Commits** follow [Conventional Commits](https://www.conventionalcommits.org/).
- **Decisions** that are hard to reverse are recorded as ADRs under
  [`docs/adr/`](docs/adr).
- **Domain terms** specific to this repo live in [`CONTEXT.md`](CONTEXT.md).
- **Linting** runs in CI: `shellcheck` and `shfmt` over every shell script,
  plus a check that all `Brewfile` entries resolve. Run the same checks
  locally with `shellcheck` and `shfmt -d -i 4 -ci -bn -sr`.
