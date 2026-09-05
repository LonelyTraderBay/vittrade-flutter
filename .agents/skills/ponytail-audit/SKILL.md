---
name: ponytail-audit
description: >
  Whole-module over-engineering audit for VitTrade. Ranks delete/yagni/shrink/reuse-vit
  findings in a scope directory. Output is a ledger only — no auto-fix in the audit turn.
  Use ~1× per sprint on trade module or when user says "ponytail audit".
---

# Ponytail Audit (VitTrade)

Scan a scope for unnecessary complexity. **Ledger only** — schedule fixes in later
batches; do not refactor during the audit turn.

## Default scope

```
flutter_app/lib/features/trade/presentation/pages/
flutter_app/lib/features/trade/presentation/widgets/
```

Override when the user names a different module path.

## Output

Write to:

```
flutter_app/run-artifacts/ponytail-audit-<scope>-YYYY-MM-DD.md
```

Example: `ponytail-audit-trade-2026-07-02.md`

## Format

One line per finding, ranked by impact (highest token/debt savings first):

```
# Ponytail audit — <scope> — <date>

## Top findings

1. <file>:L<line>: <tag> <what>. <replacement>.
...

## Summary

- delete: N
- yagni: N
- shrink: N
- reuse-vit: N
- net: ~-<lines> lines possible across top items
```

Tags (same as [vittrade-minimal-review](../vittrade-minimal-review/SKILL.md)):

- `delete:` dead code, unused wrapper
- `yagni:` one-caller abstraction
- `shrink:` same behavior, fewer lines
- `reuse-vit:` local widget duplicating shared `Vit*`

## Scan patterns

1. **reuse-vit** — local scaffolds duplicating `VitCard`, `VitHeader`, `VitTabBar`,
   `VitSegmentedChoice`, `VitPresetChipRow`, layout shells.
2. **yagni** — private classes/helpers used once (`_Foo` with single reference).
3. **delete** — unused top-level constants (`unused_element` analyze warnings).
4. **shrink** — `_SectionLabel` duplicates across widget files; inline or shared.
5. **token drift** — `BorderRadius.circular(` outside `app_radii.dart`; raw hex
   colors outside `AppColors`.

## Do not flag

- Financial preview/confirm, masked data, required flow states (AGENTS.md).
- Required migration from local → `Vit*` (even if diff grows briefly).
- Guardrail tests under `flutter_app/test/quality/`.

## Cadence

~1× per sprint on active module. Trade module first; home/wallet on rotation.
