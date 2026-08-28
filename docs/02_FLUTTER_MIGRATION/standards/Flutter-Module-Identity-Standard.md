# Flutter Module Identity Standard

**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
This document defines how VitTrade Flutter screens can keep module-specific character without breaking the Home-native foundation.

`SC-007 HomePage` remains the global source of truth for background, card treatment, spacing, typography, radii, bottom navigation, and primary brand behavior. Module identity is an accent layer only.

## Three-Layer Model

1. **Global foundation** is mandatory across the app: `AppColors.bg`, `surface`, `surface2`, `surface3`, `cardBorder`, `borderSolid`, `divider`, `AppSpacing`, `AppRadii`, `AppTextStyles`, and `DeviceMetrics`.
2. **Semantic tokens** express meaning across modules: `buy`, `sell`, `warn`, `warningBg`, `warningBorder`, `accent`, and primary brand tokens.
3. **Module identity** is allowed only through controlled accents: icons, badges, chart markers, hero-card border/glow, pills, tab indicators, and empty-state illustration accents.

## Allowed Module Identity

| Module | Role | Accent intent |
| --- | --- | --- |
| Home | Overview, discovery, routing | Strongest use of `AppModuleAccents.home` / primary brand |
| Markets | Scan, compare, discover data | Charts, analytics badges, trend markers via `markets` / semantic buy-sell |
| Trade | Action, precision, risk | Primary action/focus plus buy-sell and warning disclosures |
| Wallet | Assets, trust, security | Balance hero border/glow, deposit/withdraw statuses, security markers |
| Profile | Account, identity, settings | Neutral status, verified/security badges, restrained warnings |
| Predictions | Value-based probability markets | `predictions` accent for domain separation; no casino styling |
| Arena | Points-only social challenge area | `arena` accent for points-only boundary; no wallet/PnL styling |

## Non-Negotiable Rules

- Do not use module-specific card, page, input, or bottom-nav background colors.
- Do not make bottom navigation active state module-specific; it always uses `AppColors.navActive`.
- Do not use emojis as primary UI icons in service/action grids.
- Do not introduce repeated local `Color(0x...)` palettes for backgrounds, surfaces, borders, brands, controls, or hero gradients.
- Do not create new repeated sizes or radii inside screens; promote them to shared tokens first.

## Shared Implementation Path

- Use `AppModuleAccents` for module accent tokens.
- Use `VitServiceTile` for Home/service grids and primary shortcut grids.
- Corner badges (`badgeLabel`, `riskBadgeLabel`) follow [Service-Tile-Badge-Standard.md](./Service-Tile-Badge-Standard.md).
- Use `VitModuleHeroCard`, `VitMetricCard`, `VitStatusPill`, `VitModuleSectionHeader`, and `VitAccentIconBox` for repeated module patterns before creating local equivalents.
- Keep card backgrounds neutral; apply module character through `VitAccentIconBox` color, pill color, chart series, or copy.

## Shared Widgets Extracted From Home

These widgets were extracted directly from `lib/features/home/presentation/**`
so other modules reuse the exact same implementation instead of forking a
local copy:

- `VitServiceTile.fromAction` (`lib/shared/widgets/vit_module_components.dart`)
  — factory taking primitive fields (`icon`, `label`, `accentColor`,
  `badgeLabel`, `riskBadgeLabel`, `onTap`), used by Home's product grid and
  "more products" sheet.
- `VitBalanceBreakdownRow` / `VitBalanceBreakdownItem`
  (`lib/shared/widgets/vit_balance_breakdown_row.dart`) — the tappable
  Spot/Earn/Funding-style balance breakdown row used by
  `HomePortfolioBreakdown`.
- `VitRiskDisclaimerNote` (`lib/shared/widgets/vit_risk_disclaimer_note.dart`)
  — centered muted compliance note with an optional distinct Semantics label,
  used for the Predictions/Arena product-boundary disclaimer.

## Token Growth Policy

`lib/app/theme/app_spacing.dart` now holds only the true generic scale
(`x1..x7`, `contentPad`, `rowPy`, page-rhythm tokens, icon sizes, etc). The
historical "module-prefixed screen tokens" block (finding #15) has been fully
migrated into per-feature files under `lib/app/theme/spacing/`
(`<module>_spacing_tokens.dart`, e.g. `TradeSpacingTokens`,
`MarketsSpacingTokens`) — one file per `lib/features/*` module. New one-off
tokens for a feature must go into that feature's own
`<module>_spacing_tokens.dart`, never appended back into `app_spacing.dart`.

**Resolved (2026-07-09):** this policy names `shared_spacing_tokens.dart` as
the intended home for tokens that are genuinely generic (consumed by
`lib/shared/widgets/**` and/or by feature modules other than the one that
defined them) but don't belong in the core scale — **that file now exists**
(`SharedSpacingTokens`). `lib/app/theme/spacing/cross_module_spacing_tokens.dart`
remains a false cognate: it holds tokens for the `cross_module` *feature*
(`lib/features/cross_module/`), not tokens shared *across* modules — do not
confuse the two.

61 constants that were reached into from outside their origin module were
moved into `SharedSpacingTokens`, and every call site was repointed
(verified via `flutter analyze` + the full test suite): 4 from
`WalletSpacingTokens` (consumed by `vit_toggle_pill.dart` and 2 other
cross-module sites), 3 from `TradeSpacingTokens` (consumed by
`vit_trade_instrument_hero.dart`/`vit_trade_order_list.dart` and 1 other
site), 3 from `ArenaSpacingTokens` (consumed by `vit_community_rules_link.dart`),
and 55 from `HomeSpacingTokens` (consumed by 13 `lib/shared/widgets/` files
plus several other feature modules and `trade_spacing_tokens.dart` itself).
This closes the specific 17-shared-widgets-file dependency-direction problem
this note originally documented.

**Residual (not exhaustive, smaller, separate follow-up if pursued):** a
handful of *other* inter-module spacing-token cross-references exist beyond
the 61 moved — confirmed still present: `p2p_spacing_tokens.dart` reads
`TradeSpacingTokens.complaintSubmissionLineHeightReadable`;
`wallet_spacing_tokens.dart` reads `TradeSpacingTokens.tradeBotLineHeightTight`/
`tradeBotLineHeightCaption`/`tradeBotLineHeightReadable`. These were out of
scope for this pass (they weren't part of the originally-reported
shared/widgets dependency problem) and were left untouched.

## Enforcement

- `tool/design_token_consistency_audit.dart` — local literal-token debt
  (fontSize, EdgeInsets, BorderRadius.circular, etc.) with a hard baseline
  gate on the 5 P0 financial modules.
- `tool/home_reference_consistency_audit.dart` — structural divergence from
  Home's own patterns (raw `Container`/`BoxDecoration` instead of `VitCard`,
  `BorderRadius.circular(`/`Radius.circular(` instead of `AppRadii.*`),
  **hard-gated for every module**, not just P0. Home itself is locked at a
  divergence baseline of `0` — if that regresses, Home is no longer clean
  enough to serve as the reference. Paired with
  `test/quality/home_reference_consistency_guardrail_test.dart` (also spot-
  checks that Home still consumes the three shared widgets above instead of
  re-forking a local copy).
- `test/features/home/golden/` — pixel baselines for Home's loading/error/data
  states and the three shared widgets above, pinned to Flutter 3.41.9 stable
  (matches CI) at 360×800. No `golden_toolkit` dependency; uses `flutter_test`'s
  native `matchesGoldenFile`, so custom fonts render as their test-environment
  fallback rather than the real typeface — goldens catch structural/layout
  regressions, not font-rendering differences.
- All of the above run in `.github/workflows/flutter-ci.yml` alongside the
  existing design-token/page-rhythm/card-tile/segment-pill gates.

## Out of Scope

The following were explicitly identified as out of scope while making Home
the enforced standard, and remain separate future initiatives:

- App-wide `AppColors.warn`/`warn08`/`warn10`/`warn15`/`warningText` sweep
  (697+119 call sites across ~450 files) — unrelated in scope and size to the
  Home-reference work; only Home's own 2 usages were migrated to
  `riskWarning`/`riskWarning10` as an isolated pilot.
- Branch protection / required status checks for the new CI gates — a GitHub
  repository admin-settings action (web UI or API), not achievable by any
  code change in this repo.

## Review Checklist

- Foundation matches Home: background, surfaces, card radii, spacing, typography, CTA/input heights, bottom chrome.
- Module character is visible but restrained.
- Accent use is semantic or module-token based.
- No local dark/blue surface palette is reintroduced.
- Static audit passes before visual QA.
- Visual QA verifies representative Home, Markets, Trade, Wallet, and Profile screens.
