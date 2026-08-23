# Typography Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) Typography · [AGENTS.md](../../../AGENTS.md) UI rules · [Flutter-Design-Tokens.md](../Flutter-Design-Tokens.md)
**Enforcement:** `test/quality/typography_scale_guardrail_test.dart` (locks the scale's load-bearing invariants) · the `design_token_consistency_audit` already bans raw `fontSize` literals in presentation code (P0 hard-baselined, ratcheted repo-wide). Role choice itself stays review-enforced, like the tablet standard's R2/R3/R9.
**Scope:** every presentation file on every surface — typography is surface-agnostic.
**Born:** 2026-08-24 — the scale existed and was tokenized (`app_text_styles.dart`, ~42 roles) but was never written down as a *role map*: pages picked styles by eye, and nothing stated that financial tables must render through the tabular-figure numeric styles.

## Why this standard exists

Typography drift in a trading app is expensive in a way color drift isn't: a price column laid out in proportional figures jitters sideways on every tick, and a page that grows its own heading sizes fragments the hierarchy screen-to-screen. The scale already encodes the answer — numeric/amount styles carry `FontFeature.tabularFigures` (23 declarations) — this doc makes picking by *role* the rule and locks the tabular invariant with a test.

## Rule 1 — Pick by role, never by eye

The scale in `lib/app/theme/app_text_styles.dart`, grouped by job:

| Role group | Styles | Use for |
| --- | --- | --- |
| Micro / caption | `microTiny`, `micro`, `caption`, `captionSm` | timestamps, footnotes, helper text, badges |
| Body | `body`, `base`, `baseMedium` | running text, list titles, control labels |
| Section titles | `sectionTitleXs/Sm/Md`, `sectionTitle` | section headers (with `VitSectionHeader`) |
| Page titles | `pageTitle`, `display`, `jumbo` | page header, hero display moments |
| Hero numbers | `heroNumber` | portfolio/hero balances (one per screen) |
| **Money / figures** | `amountXs/Sm/Base/Md/Lg`, `numericMicro`, `numericCode`, `numericDisplaySm/Md/Lg/Xl`, `numericDisplay`, `numericDisplayHeroXs/Sm` | **any financial figure, price, quantity, PnL, table cell** |
| Chart labels | `chartLabelNano/Tiny/Xs` | axis labels, sparkline annotations |
| Mono / code | `monoCode` | addresses, API keys, order ids |
| Identity | `avatarSm/Md/Lg`, `navLabel`, `badge`, `control` | avatar initials, nav, badges, control text |

A new style is added to `app_text_styles.dart` **with a role comment** when a recurring job has no slot — never a page-local `TextStyle(...)` or `copyWith(fontSize:)` to "nudge" a size.

## Rule 2 — Financial figures always render tabular

Every money/quantity figure uses a style from the Money/figures group — they carry `tabularFigures`, so columns of tick-updating numbers stay still. Never `copyWith` away the `fontFeatures`; never render a price in `body`/`base` because it "looks close". (Invariant locked by the guardrail test: every `amount*`/`numeric*` style in the token file must contain `FontFeature.tabularFigures`.)

## Rule 3 — One hierarchy per screen

At most one `pageTitle`/`heroNumber` per screen; section titles come from `VitSectionHeader` (which owns its tier), not from hand-rolled `Text` with bumped sizes. Deeper nesting means restructure, not a smaller heading font.

## Rule 4 — Color/weight override only, never size

`copyWith(color:, fontWeight:)` on a scale style is fine (semantic coloring). `copyWith(fontSize:)` in presentation code is a violation — it re-opens the drift the token layer closed.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| Price column in `body` | Proportional figures jitter on tick; use `numeric*` |
| `copyWith(fontSize: 15)` "just here" | A 43rd unnamed role invents itself (Rule 1/4) |
| Two `heroNumber` on one screen | Hierarchy collapses (Rule 3) |
| New style without a role comment | Next reader can't tell job from accident |

## Verify

```bash
cd flutter_app
flutter test test/quality/typography_scale_guardrail_test.dart --reporter=compact
dart run tool/design_token_consistency_audit.dart --check
```

## Migration pointers

- Token source: `lib/app/theme/app_text_styles.dart`
- Numeric tables layout rules: [Data-Table-Standard.md](./Data-Table-Standard.md)
- Phone composition context: [Phone-Composition-Standard.md](./Phone-Composition-Standard.md)
