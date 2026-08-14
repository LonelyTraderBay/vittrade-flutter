# Segment-Pill Migration — Execution Plan

> **Status:** Complete — `interactive locals = 0`, `compliance warn = 0` (2026-07-07)
>
> **Manifest:** [VitTrade-Segment-Pill-Migration-Manifest.csv](../audits/VitTrade-Segment-Pill-Migration-Manifest.csv)  
> **Audit:** [VitTrade-Segment-Pill-Audit.csv](../audits/VitTrade-Segment-Pill-Audit.csv)  
> **Report:** [Segment-Pill-Compliance-Report.md](../audits/Segment-Pill-Compliance-Report.md)  
> **Standard:** [Segment-Pill-Standard.md](./standards/Segment-Pill-Standard.md)

## Final metrics

| Metric | Start (Batch 0) | Final |
| --- | ---: | ---: |
| Interactive local classes | 85 | **0** |
| P0 local classes | 12 | **0** |
| P1 local classes | — | **0** |
| Compliance warn (height override) | — | **0** |
| Compliance pass audit rows | — | **226** |
| Compliance review (tier U/P) | — | **96** |
| `VitChoicePill` call sites | — | **130** |

## Batches

| Batch | Scope | Outcome |
| --- | --- | --- |
| 0 | Tooling: scan, audit, manifest, guardrails, CI | P0 ban + manifest |
| 1 | P1 markets, p2p, trade, earn, arena | P1 ban + `--strict-p1` |
| 2 | P2 core: earn, p2p, arena, wallet, trade | `batch-2-core` → 0 |
| 3 | P2 markets + dca | `batch-3-markets-dca` → 0 |
| 4 | P2 long-tail (17 classes) | `batch-4-long-tail` → 0 |
| 5 | Height warn normalization (30 files) | warn 30 → 0 |
| 6 | `--strict-full` CI + docs closeout | program complete |

## Phase 6 — CI strict gate

- [segment_pill_audit.dart](../../flutter_app/tool/segment_pill_audit.dart) — `--strict-full` fails on P0/P1 bans, warn rows, interactive locals, duplicate locals in audit
- CI + guardrail test use `--strict-full` (replaces separate `--strict-p0 --strict-p1`)
- Docs: AGENTS.md, DESIGN.md, Segment-Pill-Standard.md, Enterprise-PR-Review-Checklist.md, `.codex/skills/vittrade-ui-checklists/SKILL.md`

## Verify (regression)

```bash
cd flutter_app
dart run tool/segment_pill_audit.dart --check --strict-full
dart run tool/segment_pill_manifest.dart --check
flutter test test/quality/segment_pill_guardrail_test.dart --reporter=compact
flutter analyze
```

## New/changed presentation pages

1. Pick tier via [Segment-Pill-Standard.md](./standards/Segment-Pill-Standard.md) decision tree (S1–S4)
2. No P0/P1 local `_Filter*` / `_ChipButton` / `_SegmentedTabs` classes
3. No custom `height:` on `VitChoicePill` / `VitFilterChip` (use default 44px compact)
4. Regenerate: `dart run tool/segment_pill_audit.dart && dart run tool/segment_pill_manifest.dart`

## Checkpoint AI

| Batch | Cluster | Status |
| --- | --- | --- |
| 0 | Tooling + P0 | done |
| 1 | P1 markets/p2p/trade/earn | done |
| 2 | P2 core modules | done |
| 3 | P2 markets + dca | done |
| 4 | P2 long-tail | done |
| 5 | Height warn cleanup | done |
| 6 | `--strict-full` + docs | done |

**Next batch:** none — program complete
