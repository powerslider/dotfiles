#!/usr/bin/env bash
# Generic Superset workspace setup. Referenced from per-project user
# overrides at ~/.superset/projects/<project-id>/config.json, e.g.
#
#   {"setup": ["/Users/<you>/.config/superset/setup.sh"]}
#
# so repos that must stay clean (work repos) need no committed
# .superset/ dir. Project ids: sqlite3 ~/.superset/local.db \
#   "SELECT id, name, main_repo_path FROM projects;"
set -euo pipefail

log() { printf '▸ %s\n' "$*"; }

# Worktrees do not carry gitignored files. Copy the usual suspects
# from the main repo checkout.
if [[ -n ${SUPERSET_ROOT_PATH:-} ]]; then
    for f in .env .env.local; do
        if [[ -f "$SUPERSET_ROOT_PATH/$f" && ! -f $f ]]; then
            log "copying $f from main repo"
            cp "$SUPERSET_ROOT_PATH/$f" "$f"
        fi
    done
fi

if command -v mise > /dev/null 2>&1; then
    log "mise install"
    mise install --yes
fi

if [[ -f go.mod ]]; then
    log "go mod download"
    go mod download
fi

if [[ -f Cargo.toml ]]; then
    log "cargo fetch"
    cargo fetch
fi

if [[ -f package.json ]]; then
    if [[ -f pnpm-lock.yaml ]]; then
        log "pnpm install"
        pnpm install --frozen-lockfile
    elif [[ -f bun.lock || -f bun.lockb ]]; then
        log "bun install"
        bun install
    elif [[ -f yarn.lock ]]; then
        log "yarn install"
        yarn install --frozen-lockfile
    else
        log "npm install"
        npm install
    fi
fi

log "workspace ready"
