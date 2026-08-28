# Data-Table Standard (Mandatory for financial tables/lists)

**Authority:** [DESIGN.md](../../../DESIGN.md) · [Typography-Standard.md](./Typography-Standard.md) (Rule 2 — tabular figures) · [Card-Tile-Standard.md](./Card-Tile-Standard.md) / [Tablet-Card-Border-Standard.md](./Tablet-Card-Border-Standard.md) (framing) · [Segment-Pill-Standard.md](./Segment-Pill-Standard.md) (filter/sort tier)
**Enforcement:** prose + review today, backed by the already-CI-locked rules it composes (typography guardrail, spacing locks, hairline tokens, input-state rules). No dedicated scanner while the repo has effectively one columnar table — see "Upgrade path" for the trigger to graduate.
**Scope:** both surfaces — any screen whose primary job is comparing rows of financial/quantitative data (price pairs, positions, orders, ledger entries); phone renders them as row lists, tablet as columnar tables. See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).
**Born:** 2026-08-24 — the Markets pair table established every one of these rules in practice; this doc writes them down so the *next* table (positions, orders ledger, …) doesn't re-derive them by eye.

## Why this standard exists

A trading app's most-read surface is the table. Tables fail in specific, repeatable ways: proportional figures that jitter sideways on every tick, columns that collapse onto themselves at one breakpoint, headers that scroll away exactly when the user needs them to sort, and zebra/border decoration that fights the card system. Each rule below pins one of those failures to the shared tokens that already exist.

## Rules

1. **Figures are tabular, always.** Every price/quantity/PnL/percentage cell renders through an `amount*`/`numeric*` style (`Typography-Standard` Rule 2 — locked by `typography_scale_guardrail_test`). Never `body`/`base` "because it looks close".
2. **Column widths are tokens, not literals.** Column min-widths and cell padding come from `AppSpacing`/module spacing tokens (`SharedSpacingTokens.homeRankedValueColumnWidth` is the exemplar) — the tablet spacing lock and the phone spacing audits already fail literals.
3. **Separators are hairlines.** Row separation is the 1px `dividerHairline` + `AppColors.divider` token (see the Markets rows and menu rows) — never zebra fills, never heavier borders, never a second stroke system.
4. **The header stays reachable.** Phone: the filter/sort tier rides `Segment-Pill-Standard` (S1–S4 decision tree) above the list, inside the scroll as a sticky tier only via the sanctioned scaffolds. Tablet: column headers sort on tap and sit at the top of the table block — they never scroll away with the rows on a monitor dashboard (the banner/section owns them).
5. **Rows are shared primitives.** Build rows from the shared ladder (`VitMarketPairRow`-style rows, `VitKeyValueRow`, `VitCard`-framed dense rows) so hover/focus (input states), tap targets, and masking ride the shared mechanisms — a table never hand-rolls its own row chrome.
6. **Framing follows the card system.** Phone: the table is section content inside the page rhythm (no extra wrapper card around a list that already has one). Tablet: dense cells use `VitCardRadius.tight` framing per the Card & Border tiers.
7. **States mirror the table.** Loading = row skeletons with the same column shape (`VitSkeletonList` / the Markets `_PairTableSkeleton` pattern); empty = `VitEmptyState` *inside* the table area with the rest of the screen usable; error keeps the header/filter actionable.
8. **Sensitive cells are masked.** Account/address/id cells go through `VitFormat` masking even in dense tables.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| Price column in proportional figures | Jitters on tick (Rule 1) |
| `SizedBox(width: 72)` column width literal | Off-token — fails the spacing audits anyway (Rule 2) |
| Zebra striping "for readability" | Fights the hairline + card system (Rule 3) |
| Sort control hand-rolled beside the header | The segment-pill tier already owns filter/sort UI (Rule 4) |
| A per-table private row widget with its own ink/border | Breaks input states + duplicate-widget ratchet (Rule 5) |
| Full address rendered unmasked in a dense cell | Masking applies in tables too (Rule 8) |

## Recipe for a new table

1. Identify the figure roles → pick `numeric*`/`amount*` styles per column.
2. Layout: phone = shared rows in one scroll section; tablet = columnar block in the dashboard column (`VitTwoColumnTabletDashboard`'s primary) with sortable headers.
3. Separators/padding/widths from tokens; framing per the card tiers.
4. Sort/filter UI through the segment-pill decision tree; sticky per Rule 4.
5. Ship skeleton + empty states mirroring the column shape before the PR.

## Upgrade path

This stays composed prose while there is **one** real columnar table (Markets). The moment a **second** columnar table ships (positions/ledger), extract the shared `VitDataTable` widget (headers+rows+sort contract, both surfaces) — per the repo's no-one-caller-abstraction rule — and graduate this standard to its own `tool/data_table_audit.dart` the same way Card-Tile did.

## Verify

```bash
cd flutter_app
flutter test test/quality/typography_scale_guardrail_test.dart --reporter=compact
dart run tool/segment_pill_audit.dart --check --strict-full
dart run tool/tablet_spacing_audit.dart --check
flutter test <touched table page test> --reporter=compact
```

## Migration pointers

- Exemplar: `markets_tablet_page.dart` pair table + `vit_market_rows.dart` shared rows + `markets_status_content.dart` skeleton mirror
- Figure styles: `lib/app/theme/app_text_styles.dart` (Money/figures group)
- Tablet composition context: [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md) · phone: [Phone-Composition-Standard.md](./Phone-Composition-Standard.md)
