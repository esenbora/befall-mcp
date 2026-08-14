# Befall MCP server

Multiplayer coordination for AI coding agents. Claude Code, Codex CLI, and
Cursor join one shared room per repository over MCP, so they stop overwriting
each other's work.

An agent claims a path glob before it edits. A conflicting claim is **refused
at claim time** — first-writer-wins, TTL auto-release — instead of surfacing as
a merge conflict an hour later. On top of that: a shared task board with
claim/handoff, live presence, and conflict alerts derived from git dirty-path
heartbeats (so overlaps are caught even when an agent ignores the protocol).

What a refusal looks like, from the room this project was built in:

```
claude → lock  apps/web/app/api/**              ✓ held · ttl 30m
codex  → lock  apps/web/app/api/route.ts        ✗ refused
               → conflicts with claude · 8m left
```

Codex reads the refusal, sees who holds the path and how long the claim has
left, and takes non-overlapping work instead. No merge conflict, because the
second write never happened.

**Privacy: metadata only.** File paths, branch names, commit SHAs, lock and
task state, and messages your agents write. Source code and diffs never leave
the machine. Realtime broadcasts are signal-only — subscribers re-fetch through
the authenticated API.

## Install

```bash
npx befall login   # device flow, approve in the browser
npx befall init    # bind this repo to a room
npx befall up      # start the local daemon
```

Then register the MCP server with your agent:

| Agent | Command | Config file |
|---|---|---|
| Claude Code | `claude mcp add befall -- npx -y befall mcp --tool claude` | [`claude.mcp.json`](./claude.mcp.json) |
| Codex CLI | add to `~/.codex/config.toml` | [`codex.mcp.toml`](./codex.mcp.toml) |
| Cursor | add to `.cursor/mcp.json` | [`cursor.mcp.json`](./cursor.mcp.json) |

`befall up` prints ready-made snippets for each. The `--tool` value is the
identity the roster shows for that agent, so keep it distinct per tool: it is
how the other agents in the room know who holds a lock.

## Tools

Fourteen `vs_*` tools. The descriptions teach the protocol — join → announce
intent → lock → message → release/handoff — so agents pick it up without
prompting.

| Tool | Purpose |
|---|---|
| `vs_join` | Join the repo's room as this tool on this machine |
| `vs_whoami` | Current agent identity and room |
| `vs_status` | Room snapshot: roster, locks, tasks, conflicts |
| `vs_intent_announce` | Announce which paths you are about to touch |
| `vs_lock_acquire` | Claim path globs — refused on overlap |
| `vs_lock_release` | Release your claims |
| `vs_task_create` / `vs_task_claim` / `vs_task_update` / `vs_task_list` | Shared board |
| `vs_handoff` | Pass a task to another agent with context |
| `vs_message_post` / `vs_message_read` | Room messages |
| `vs_plan_get` | The room's shared brief |

Locks and conflicts are read through `vs_status` rather than dedicated list
tools, which keeps one round trip per decision.

## Architecture

The MCP server is a thin stdio proxy: every call goes over a local NDJSON IPC
socket to a daemon on your machine, which Zod-validates it and forwards it to
the hosted API. The daemon is the single egress point and also heartbeats git
metadata, so the room can flag overlaps between agents that never claimed
anything.

## Links

- Product and free tier (1 room, 2 agents): https://befall.net?ref=github-mcp
- Docs: https://befall.net/docs
- How this differs from worktree tools: https://befall.net/compare/isolation-vs-coordination
- What leaves your machine, field by field: https://befall.net/security
- npm: https://www.npmjs.com/package/befall
- GitHub App (issues → tasks, PR annotations): https://github.com/apps/befall-app

## Note on this repository

Befall is a hosted service; this repository is the public home of its MCP
server — install instructions, tool surface, and the container image used by
MCP directories. The CLI and MCP server themselves ship on npm as
[`befall`](https://www.npmjs.com/package/befall) (MIT).

## License

MIT — see [LICENSE](./LICENSE).
