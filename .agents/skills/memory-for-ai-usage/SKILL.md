---
name: memory-for-ai-usage
description: >
  Decision rules for the memory-for-ai MCP knowledge graph on this repo
  (measured 2026-09-05). Use it for multi-hop caller/blast-radius tracing,
  architecture summaries, and fuzzy discovery. Do NOT use it for exact-name
  usage search or as the source of truth for edits — grep + Read win there.
  Apply automatically before touching shared widgets, spacing tokens,
  scaffolds, or the router; no need to wait for the user to ask.
---

Project name for every MCP call:
`C-Users-Joker-PC-Documents-Projects-vittrade-flutter` (do not call
`list_projects` first just to look it up).

## When to use the graph (token-cheap, high signal)

1. **Before editing shared / high-fan-in code** — `TabletSpacingTokens`,
   `AppSpacing`, `Vit*` shared widgets, pane scaffolds, anything under
   `lib/shared/`, `lib/app/theme/`, `lib/app/router/`, or a widget used by 3+
   features: `trace_path` (direction: inbound) for callers, or
   `detect_changes` on the working diff for blast radius. Shared tokens have
   1,000+ refs across 100+ files; grep cannot answer multi-hop impact in one
   call. Report impacted callers in the plan before editing.
2. **Architecture / hotspot summaries** — `get_architecture` (scope with
   `path`), `query_graph` with complexity columns (`cyclomatic`, `cognitive`,
   `transitive_loop_depth`) for hot-path candidates.
3. **Discovery without an exact name** — `search_graph` with `query=` (BM25)
   or `semantic_query` when vocabulary may differ from the code.

## When NOT to use it (grep/Read win — measured)

1. **Exact-name usage search**: `grep -rn "Name"` is cheaper and more
   precise. `search_code` enriches by structural importance and returns false
   positives (measured 2/5 wrong rows on a real query — `TradeTerminalMetaStrip`).
2. **Source of truth for edits**: always Read the real file before Edit.
   `get_code_snippet` is best-effort (textual Dart resolution, `parse_partial`
   gaps). The graph tells you where to look; the file is the truth.
3. **Freshness/schema checks**: never call `list_projects` with
   `include_details=true` or `get_graph_schema` — they dump the full node/edge
   schema (very expensive). `list_projects` with defaults is lean enough to
   read `indexed_at`.

## Accuracy rules

- Dart resolution is **textual** (name matching). CALLS/USAGE edges are
  trustworthy for unique class/widget names; noisy for common method names
  (`build`, `dispose`). Verify any surprising edge by reading the file.
- **Freshness**: check `indexed_at` via lean `list_projects` against
  `git log -1`. If the index is older than the last few commits (or you just
  changed many files), re-index via `index_repository` before trusting
  relationship answers, or fall back to grep.
- **`Connection closed` / query error**: do not retry the identical call.
  Retry once with a simpler Cypher form — known-stable pattern:
  `MATCH (c:Class) WHERE c.name CONTAINS 'X' RETURN c.name LIMIT n`.
  Avoid exotic predicates (`ENDS WITH` on unverified properties) — measured
  to kill the connection. Still failing → grep.

## Boundaries

The graph complements, never replaces, `tool/preflight_check.dart`, guardrail
tests, and focused test runs. It informs *where* to edit and *what* a change
impacts; correctness gates remain the repo's own commands (AGENTS.md
Commands section wins).
