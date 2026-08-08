# Changelog

Notable changes to the Befall MCP server and the hosted room behind it. The
CLI and MCP server ship on npm as [`befall`](https://www.npmjs.com/package/befall).

## 2026-08-08

- Corrected the documented tool surface in this README. It listed
  `vs_lock_list` and `vs_conflict_list`, which the server does not expose, and
  omitted `vs_task_claim` and `vs_handoff`, which it does. Verified against a
  live introspection of the published package: 14 tools.
- Added the refusal example from the room this project was built in, so the
  claim-time behaviour is visible without installing anything.
- Free plan is now the funnel: 1 room, 2 concurrent agents, 7-day activity
  history, no card. Paid plans run unlimited rooms and full history.
- Published a category map of the parallel-agent tooling space at
  [/compare/isolation-vs-coordination](https://befall.net/compare/isolation-vs-coordination),
  and the metadata-only privacy model field by field at
  [/security](https://befall.net/security).

## 2026-08-01

- Public home for the MCP server: install instructions, tool surface, and the
  container image MCP directories use to start the server and answer an
  introspection request.

## Earlier

Befall launched on 2026-07-22. The CLI has been on npm since then; the room,
the advisory path locks, the task board, and the GitHub App predate this
repository.
