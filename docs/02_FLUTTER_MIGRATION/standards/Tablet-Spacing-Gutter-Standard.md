# Tablet Spacing & Gutter Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · [AGENTS.md](../../../AGENTS.md) UI rules · [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md) (vertical page rhythm) · [Tablet-Card-Border-Standard.md](./Tablet-Card-Border-Standard.md)
**Enforcement:** `dart run tool/tablet_spacing_audit.dart --check` · `test/quality/tablet_spacing_guardrail_test.dart` (**absolute lock — zero baseline**)
**Scope:** every Dart file under `lib/` on the **tablet surface** (path contains `/tablet/`, or the file name mentions `tablet`).
**Born:** 2026-08-22 — companion to the Tablet Card & Border Standard; locks the "which gap, which token" decision so tablet screens stop drifting optically page-to-page.

## Why this standard exists

The tablet surface is already fully tokenized — a 2026-08-22 sweep found **zero** numeric literals in `SizedBox` gaps, `EdgeInsets` insets, or stroke thicknesses (the only three stragglers, `Divider(height: 1)`, were migrated on the spot). What was *not* written down is **which token each spacing role must use**: pages picked `x4` vs `x5` vs `columnGutter` by feel, so identical roles rendered at different gaps on different panes (the master-detail gutter-stacking bug of commit `4a171046` was exactly this class of drift). This standard fixes the role→token map and locks the zero-literal state so drift cannot creep back.

## Rule 1 — The spacing scale is role-based

Base scale (`AppSpacing`): `x1=3 · x2=5 · x3=8 · x4=13 · x5=21 · x6=34 · x7=55` (plus `contentPad=20`, `rowGap=8`, `sectionGap=20`, `dividerHairline=1`).

| Role on the tablet surface | Token | Value |
| --- | --- | --- |
| Micro gap (pill↔pill in a Wrap, icon↔label) | `AppSpacing.x1`–`x2` | 3–5 |
| Item gap (rows/chips/cards inside a section) | `AppSpacing.rowGap` | 8 |
| Section inner gap (header→body, compact tier) | `AppSpacing.pageRhythmCompactInnerGap` | 5 |
| Section inner gap (standard tier) | `AppSpacing.pageRhythmStandardInnerGap` | 8 |
| Section gap (between blocks in a scroll) | `pageRhythm*SectionGap` via `VitPageContent(rhythm:)` | 8–24 by tier |
| Icon→text inside a tile/card row | `AppSpacing.x3` | 8 |
| Between sibling cards in a column | `AppSpacing.cardGap` | 13 |
| Inside-card padding | `VitCard` variant/density defaults (`density.cardPadding`) | — |
| Tile strip padding (Tier A) | `AppSpacing.cardTilePadding` | 12×5 |

**Never** re-derive a gap from another scale step "because it looks close" — pick by role, not by eye. When two roles genuinely need a new number, add a named token to `AppSpacing`/module spacing (with a role comment), never a literal at the call site.

## Rule 2 — Horizontal gutters of the tablet frame

All tablet frame geometry comes from `TabletDashboardWidths` (`lib/app/theme/tablet_dashboard_widths.dart`) — do **not** re-declare these numbers anywhere else:

| Geometry | Token | Value |
| --- | --- | --- |
| Nav rail width | `VitNavigationRail.width` | 96 |
| Screen edge → dashboard block (each side) | `outerHorizontalMargin` (= `AppSpacing.contentPad`) | 20 |
| Gutter between the two dashboard columns | `columnGutter` | 24 |
| Two-column threshold (below → single column) | `twoColumnMinWidth` | 900 |
| Primary/secondary column caps | `primaryColumnMaxWidth` / `secondaryColumnMaxWidth` | 800 / 400 |
| Vertical breathing above/below the block | `blockVerticalGap` | 16 |

Consequences (learned the hard way — commit `4a171046`):

- Pane content inside a master-detail/two-column layout is **gutter-flush**: `VitPageContent(fullBleed: true)` + `VitHeader(horizontalPadding: AppSpacing.zero)`. Stacking the default `contentPad` on top of `columnGutter` yields a 44px gap — double the rail→menu margin — and reads as broken alignment.
- A page needing different frame numbers keeps a **page-local override** in its own widget call — never edits the shared tokens (R8 safety margin, see the doc comment in `tablet_dashboard_widths.dart`).

## Rule 3 — Lines: hairline only, token-locked

- Every divider/separator stroke is a **1px hairline**: `Divider(height: AppSpacing.dividerHairline)` (plus its color token). `thickness:` literals are forbidden; card border strokes stay at VitCard's default 1px side (see the Card & Border standard).
- Accent bars that accompany section labels use `AppSpacing.pageSectionAccentWidth` — never a hand-rolled `width: 3/4`.

## Rule 4 — Absolute lock: no numeric spacing literals

In tablet files, every dimension must be a token reference:

- `SizedBox(height: 12)` → `SizedBox(height: AppSpacing.…)` (S1)
- `EdgeInsets.all(16)` / `EdgeInsets.only(top: 24)` → token-based insets (S2)
- `thickness: 2`, `Divider(height: 1)` → `AppSpacing.dividerHairline` (S3)

The guardrail is **zero-tolerance with no baseline** — the surface is clean today and any new literal fails CI outright. (Token references like `AppSpacing.x5` never trip the scanner: the digit is glued to a word character.)

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `SizedBox(height: 10)` "just this once" | 10 is on no scale; next page picks 12 |
| `contentPad` stacked on `columnGutter` | Double gutter (44px) — the master-detail bug |
| Editing `TabletDashboardWidths` for one page | Shifts the proven R8 margin for every page |
| New gap = nearest scale step by eye | Role decides the token (Rule 1), not eyeballing |
| `Divider(height: 1)` literal | Should be `AppSpacing.dividerHairline` |
| Adding a one-caller spacing token | Tokens document a *role*; one-caller literals belong in review, not the scale |

## Recipe for new tablet UI

1. Vertical page rhythm → `VitPageContent(rhythm: …)` by navigation role (see [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md)).
2. Every gap inside a section → Rule 1 table by role.
3. Frame layout (rail/margins/gutters/columns) → `VitTwoColumnTabletDashboard` / master-detail shell with `TabletDashboardWidths` untouched; pane content gutter-flush.
4. Any line/divider → hairline token (Rule 3).
5. Before commit: `dart run tool/tablet_spacing_audit.dart --check` + `flutter test test/quality/tablet_spacing_guardrail_test.dart`.

## Verify

```bash
cd flutter_app
dart run tool/tablet_spacing_audit.dart            # regenerate audit CSV
dart run tool/tablet_spacing_audit.dart --check    # CI: artifact current
flutter test test/quality/tablet_spacing_guardrail_test.dart --reporter=compact
```

## Migration pointers

- Audit: [VitTrade-Tablet-Spacing-Audit.csv](../audits/VitTrade-Tablet-Spacing-Audit.csv) (empty — locked at zero)
- Vertical rhythm tiers: [Page-Rhythm-Standard.md](./Page-Rhythm-Standard.md)
- Frame widths & master-detail shells: [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md)
- Card frames & borders: [Tablet-Card-Border-Standard.md](./Tablet-Card-Border-Standard.md)
