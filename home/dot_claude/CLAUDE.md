# Global Claude Code instructions

These apply to every conversation unless overridden by a project-local
`CLAUDE.md`.

## Who I am

- Tsvetan Dimitrov, Go + Rust developer. Daily stack: Zed (Cursor base
  keymap), Ghostty, zsh with starship.
- Personal projects: `~/git-repos/powerslider/...`
- Work projects (Avalabs / Spectrum Search): `~/git-repos/ava-labs/...`,
  `~/git-repos/spectrum-search/...`, `~/work/...`.
- Personal git identity: `tsvetan.dimitrov23@gmail.com`. Work identity:
  `tsvetan.dimitrov@avalabs.org` (auto-applied via `includeIf` in
  `~/.gitconfig` for any repo under the work directories above).

## Response style

- Terse by default. State results and decisions directly. No "let me
  start by…" / "based on the above…" framing.
- For exploratory questions ("what could we do about X?"), respond in
  2–3 sentences with a recommendation + main tradeoff, then stop.
- End-of-turn summary: one or two sentences. What changed, what's next.
- Don't narrate internal deliberation. Don't restate the task.

## Code style

- Default to writing **no comments**. Only write a comment when the
  *why* is non-obvious (constraint, invariant, bug workaround). Don't
  explain *what* the code does — well-named identifiers do that.
- No backwards-compat shims or "TODO: remove later" stubs. Cut clean.
- For commit messages: conventional commits (`feat:`, `fix:`, `chore:`,
  `ci:`, `docs:`, `refactor:`). Keep the subject ≤72 chars, focus the
  body on **why**, not what.

## Git workflow

- I use **SSH commit signing** (`gpg.format = ssh`,
  `signingkey = ~/.ssh/github_com_powerslider.pub`). All commits + tags
  signed automatically.
- `commit.verbose = true` — the staged diff appears in the editor below
  the message.
- Default branch is `main`. Pull rebases. Rebase autosquash + autostash
  are on.
- I prefer creating new commits over `--amend`. If a pre-commit hook
  fails, fix the issue and create a new commit, never `--amend`.

## Tools to know about

- **mise** manages all language runtimes (Go, Rust, Node, Python).
  Don't use `nvm`, `jenv`, or `pyenv` — they aren't installed.
- **chezmoi** manages my dotfiles from `~/git-repos/dotfiles/home/`.
  Don't write to `~/.zshrc`, `~/.gitconfig`, `~/.config/...` directly —
  edit the chezmoi source then `chezmoi apply`.
- **sheldon** is my zsh plugin manager; **starship** is the prompt.
- **zoxide** is remapped to `j` (e.g., `j foo`, `ji` for interactive).
- **lazygit**, **gh**, **delta** for git ops.
- **delve** for Go debugging, **lldb** (via codelldb in Zed) for Rust.

## When suggesting tools

If a tool isn't already in `~/git-repos/dotfiles/Brewfile`, surface
that and ask before assuming I have it. Don't claim a binary works
unless you've verified.

## Memory notes

- Don't write to my `~/` directly when there's a chezmoi-managed
  alternative in `~/git-repos/dotfiles/home/`.
- Don't suggest `npm install -g` or `pip install --user` — propose
  `mise` / `cargo install` / `brew` instead, in that order.
- Avoid emojis in code, comments, and shell output unless I ask for
  them. Prompt/UI configs (Starship, Ghostty themes) are exceptions.
