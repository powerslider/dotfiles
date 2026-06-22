# Claude Code config

Managed by chezmoi under `~/.claude/`. Skills, commands, agents, and
hooks are NOT managed here. They come from the
[nitpickle](https://github.com/powerslider/nitpickle) plugin.

## Layout

- `CLAUDE.md` - global user instructions
- `modify_settings.json` - chezmoi modify script. On every apply it
  merges the nitpickle marketplace registration, the enabled-plugin
  entry, and Serena's hooks into `settings.json`, preserving whatever
  machine-local state is already there (Superset's hooks, model,
  runtime-written plugin state). MCP servers are not configured here:
  Claude Code reads those from `~/.claude.json`, so `bootstrap.sh`
  registers Serena with `claude mcp add` and installs its binary with
  `uv tool install`.
- `nitpickle/` - global NitPickle defaults (policy and preferences),
  used by any repo without a local `.nitpickle/`

## Plugin auto-install flow

1. `chezmoi apply` guarantees `settings.json` registers the `nitpickle`
   marketplace with `autoUpdate: true` and enables
   `nitpickle@nitpickle` at user scope.
2. Claude Code refreshes the marketplace and updates the installed
   plugin at every launch.
3. On a fresh machine `bootstrap.sh` runs
   `claude plugin install nitpickle@nitpickle --scope user` once, right
   after `chezmoi apply`. After that, step 2 keeps it current.
