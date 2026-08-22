# Tablet Card & Border Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Tokens · [AGENTS.md](../../../AGENTS.md) UI rules · [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md)
**Enforcement:** `dart run tool/tablet_card_border_audit.dart --check` · `test/quality/tablet_card_border_guardrail_test.dart` (ratchet baseline `test/quality/tablet_card_border_baseline.txt`)
**Scope:** every Dart file under `lib/` on the **tablet surface** (path contains `/tablet/`, or the file name mentions `tablet` — shared tablet scaffolds included). Phone surface keeps its current rules; a later phase may adopt this standard repo-wide.
**Born:** 2026-08-22 — after the Profile master-detail rollout exposed unregulated border drift (see "Why this standard exists").

## Why this standard exists

Before this standard the tablet surface had **three border layers tokenized well and one layer completely unregulated**:

- Radii were centralized (`BorderRadius.circular` count in lib/: **0**) ✔
- Stroke width was uniform (VitCard always draws 1px sides) ✔
- Variant defaults were centralized ✔
- **Tinted border colors were hand-rolled per page**: 46 `borderColor:` overrides across tablet files using **12 different alpha steps** (`.14 .18 .20 .22 .24 .26 .28 .32 .34 .38 .42 .45`) on ad-hoc base colors (private pane colors, module accents), plus **4 hand-rolled `BorderSide`** decorations. Same-role cards therefore glowed at different intensities screen-to-screen — the "many frames lit up, nothing matches" complaint.

## Rule 1 — One frame source: `VitCard`

Every card-shaped frame on the tablet surface is a `VitCard` (`lib/shared/widgets/vit_card.dart`). Do **not** hand-roll `Container`/`DecoratedBox` + `Border.all(`/`BorderSide(` decorations in tablet presentation code.

- Sanctioned non-`VitCard` outlines: `VitSegmentedTabBar` pills (own pill outline — never wrap in a bordered box, per AGENTS.md), input fields (`AppRadii.inputRadius`), and `VitHighRiskStatePanel` (standardized risk chrome).
- Existing debt: 4 raw `BorderSide` sites — pinned in the baseline, must shrink; new code adds none.

## Rule 2 — Radius tiers are role-based, not taste-based

| Role | `VitCardRadius` | Value | Examples |
| --- | --- | --- | --- |
| Hero / large feature card (gradient, glow) | `large` | 24px (`AppRadii.cardLargeRadius`) | account hero, portfolio card, sheet tops |
| Standard content card / framed sidebar | `standard` | 16px (`AppRadii.cardRadius`) | pane sections, master menu frame, list cards |
| Dense control surface in a trading terminal | `tight` | 8px (`AppRadii.smRadius`) | Trade Command Center v2 cells |

- Pick the tier by the card's **role in the layout**, not by how round you feel like making it.
- Never introduce a fourth tier or a numeric radius; `BorderRadius.circular()` stays at zero everywhere in lib/ (locked, no baseline).

## Rule 3 — Border color follows the variant default; tint only through the 3-step scale

Default behavior — **prefer no override at all**:

| Variant | Background | Default border |
| --- | --- | --- |
| `standard` | `cardBg` | `cardBorder` (7% white hairline) |
| `hero` | `portfolio` gradient + glow | `portfolioBorder` (15% amber) |
| `inner` | `surface2` | none (`BorderSide.none`) |
| `ghost` | transparent | none |

When a card genuinely needs a semantic/state accent (buy/sell/risk/module accent), pass `borderColor:` as either:

1. **A ready color token, untouched** — `AppColors.cardBorder`, `borderSolid`, `overlayStroke`, `buy20`, `warningBorder`, … or
2. **A tinted accent limited to the sanctioned scale**: `accent.withValues(alpha: …)` with **`.12` (subtle) / `.22` (standard) / `.34` (strong)** and a base color that is an existing semantic token (`AppColors.*`, `AppModuleAccents.*`) — not a private one-off color invented for the border.

Any other alpha step is a violation (R2). Map old drift when you touch a file: `≤.20 → .12` · `.21–.28 → .22` · `≥.32 → .34`.

`borderColor: AppColors.transparent` is allowed to keep geometry stable across states (e.g. selected/unselected rows) and never counts as a tint.

## Rule 4 — Nested frames: concentric radii + inner inset

To keep inner frames from crowding or visually "cutting" the content of their parent card:

- **Concentric radius:** an inner card's radius must be at least **8px smaller** than its parent's (`24 → 16`, `16 → 8`). Inside a `large` hero, nest `standard` cards; inside a `standard` card, nest `tight`/`inner` surfaces — never equal radii.
- **Inset:** an inner card keeps ≥ `AppSpacing.x3` (12px) breathing room from its parent's border on every side (the parent's default padding already provides this — do not shrink it to "reclaim" space).
- **Content vs border:** never let text touch a tinted border — content padding comes from `VitCard`'s variant/density defaults; only *increase* it, never below the default, on cards carrying a visible border. A border is a container's edge, not a divider through content.

## Rule 5 — Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `borderColor: c.withValues(alpha: .26)` | Off-scale tint — 4th intensity invents itself per page |
| Private color (`_paneAccent`) only used for a border | Border color must trace to a semantic token |
| `Container(decoration: BoxDecoration(border: Border.all(...)))` in tablet UI | Bypasses VitCard variant/audit surface |
| Same role, different radius per page | Radius is role-based (Rule 2) |
| Inner card radius == parent radius | Breaks concentric nesting (Rule 4) |
| Shrinking card padding to fit a border in | Border never crowds content (Rule 4) |
| Copying a pane's border recipe to a new pane | This standard is the recipe |

## Recipe for new tablet UI (decision flow)

1. Need a frame? → `VitCard`. Pick **variant** by content nature (hero gradient? plain content? nested inside another card?).
2. Pick **radius** from Rule 2 by role.
3. Border color? → **Don't override** unless semantic state demands it; if it does, use Rule 3 (token or 3-step tint).
4. Nesting? → Apply Rule 4 (radius −8, inset ≥ `x3`).
5. Run `dart run tool/tablet_card_border_audit.dart --check` and `flutter test test/quality/tablet_card_border_guardrail_test.dart` before commit.

## Enforcement & ratchet

- **R1 raw-border** and **R2 ad-hoc tint** violations are pinned in `test/quality/tablet_card_border_baseline.txt` (20 entries at birth: 4 × R1, 16 × R2). New violations fail CI; entries must be removed from the baseline as files are touched — debt only shrinks.
- **R3 literal radius** has **zero tolerance** (no baseline — lib/ is already clean and stays clean).
- The audit artifact (`VitTrade-Tablet-Card-Border-Audit.csv`) must stay current, same as the other audit tools.

## Verify

```bash
cd flutter_app
dart run tool/tablet_card_border_audit.dart          # regenerate audit CSV
dart run tool/tablet_card_border_audit.dart --check  # CI: artifact current
dart run tool/tablet_card_border_audit.dart --regen-baseline  # only when retiring debt
flutter test test/quality/tablet_card_border_guardrail_test.dart --reporter=compact
```

## Migration pointers

- Audit: [VitTrade-Tablet-Card-Border-Audit.csv](../audits/VitTrade-Tablet-Card-Border-Audit.csv)
- Baseline (debt inventory): `flutter_app/test/quality/tablet_card_border_baseline.txt`
- Height/centering tiers for strip tiles: [Card-Tile-Standard.md](./Card-Tile-Standard.md)
- Tablet layout thresholds, master-detail shells: [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md)
