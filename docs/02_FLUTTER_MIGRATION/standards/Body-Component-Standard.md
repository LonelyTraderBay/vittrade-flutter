# Body Component Standard

**Authority:** Derived from existing tool logic in `flutter_app/tool/body_component_consistency_audit.dart` — no new policy invented; this doc writes down what the tool already grades.
**Enforcement:** `dart run tool/body_component_consistency_audit.dart` (regenerate) · `dart run tool/body_component_consistency_audit.dart --check` (artifact-freshness check only) — **audit-only, not CI-enforced.** No `test/quality/body_component*` guardrail test exists today.
**Reference report:** [VitTrade-Body-Component-Consistency-Audit.md](../audits/VitTrade-Body-Component-Consistency-Audit.md) / [.csv](../audits/VitTrade-Body-Component-Consistency-Audit.csv) — generated 2026-07-09 baseline, `total_routed_screens=414`.

Every routed screen's **body** (everything below the top header, which is governed separately by the top-header audits) is graded on **7 axes**, rolled into a letter grade (A–D, or `Tool`) and an issue priority (P0–P3). This doc explains what each axis actually checks and what a route must do to earn each grade — read it before touching a screen's body layout, surfaces, controls, state handling, or copy.

## The 7 grading axes

| Axis | What it checks | Pass | Warn | Fail |
| --- | --- | --- | --- | --- |
| **Layout** | Shared scaffold + content wiring | Non-tool: `VitPageLayout`/`VitAutoHideHeaderScaffold`/`RewardsArenaPointsBridge` **and** `VitPageContent`/`VitPageSection` both present. Tool: any of `SafeArea`, `MediaQuery.paddingOf`, `DeviceMetrics`, `VitHeader`, `VitTopChrome` | Only one of the two shared-layout groups present (non-tool) | Neither present, or source unresolved |
| **Surface** | Shared surface widgets vs raw `Container(` | ≥3 of `VitCard`/`VitCardStat`/`VitServiceTile`/`VitModuleHeroCard`/`VitMetricCard`/canonical Trade surfaces (`VitNextActionCard`, `VitTradeSimpleHero`, `VitTradeSimpleOrderForm`) **and** custom-token count ≤45 (tool: ≥1 shared surface) | 1–2 shared surfaces present; **or** ≥3 shared surfaces but `customBodyCount` >45; **or** zero shared surfaces with <6 raw `Container(` | Zero shared surfaces **and** ≥6 raw `Container(` |
| **Controls** | Raw inputs/buttons vs shared primitives | No raw `TextField(` without `VitInput`/`VitSearchBar`; <4 raw buttons or `VitCtaButton`/`VitHeaderActionButton`/`VitHeaderActionItem` present; <12 `GestureDetector(` or `InkWell(`/`onTap:` present | ≥4 raw buttons without a shared action widget, or ≥12 `GestureDetector(` without `InkWell(`/`onTap:` | Any raw `TextField(` with no shared input widget |
| **State** | Loading/empty/error/offline/submitting/success coverage | Uses `VitEmptyState`/`VitErrorState`/`VitOfflineBanner`/`VitBanner`/`VitSkeleton`/`VitHighRiskStatePanel` | Financial-safety candidate route with state-keyword hints (`loading`, `empty`, `error`, `offline`, `submitting`, `success`, `failure`, `AsyncValue`, `.when(`) but no shared widget; **or** a high-impact feature (`wallet`/`trade`/`profile`/`p2p`/`predictions`/`markets`/`rewards`) route with no keyword hints and no shared widget | Financial-safety candidate route with no shared state widget and no keyword hints |
| **Financial safety** | Preview → confirm → result semantics on money/security flows | `VitHighRiskStatePanel` present, or preview/confirm score ≥2 **and** fee/risk/disclosure score ≥2 | Preview/confirm or fee/risk/disclosure signal present (score >0) but the ≥2-each pass threshold isn't met — this includes the case where **both** groups are present but one scores below 2 | Financial-safety candidate with neither signal group |
| **Responsive** | Fixed sizing and bottom-chrome safety | No `width:` >360px; no `Positioned(...bottom:...)` without a safe-area/shared-layout signal; <30 oversized fixed dimensions or a responsive escape hatch (`LayoutBuilder`/`Flexible(`/`Expanded(`) present | ≥30 oversized fixed dimensions (`height:` >56 or `width:` >320) with no responsive escape hatch | Any `width:` >360px, or unsafe `Positioned(bottom:)` |
| **Copy boundary** | Domain-specific forbidden vocabulary | No forbidden terms for the route's feature | Arena: `wallet`/`profit` mentioned. Other features: `casino`/`gamble`/`gambling`/`fomo` mentioned | Arena: `payout`/`stake return`/`casino`/`gamble`/`gambling`. Predictions: `casino`/`gamble`/`gambling`/`fomo` |

**Financial safety is conditional**: it only applies to a route when `_isFinancialSafetyCandidate` matches — feature in `{wallet, trade, p2p, earn, launchpad, dca, profile, predictions}` **and** (route/page text hits a safety keyword — `withdraw`, `deposit`, `address`, `escrow`, `paymentmethod`, `leverage`, `margin`, `copy`, `apikey`, `security`, `2fa`, `kyc`, `confirm`, `confirmation`, `receipt`, `transfer`, `redeem`, `claim`, `rebalance`, `automation`, `approval`, `device`, `verification`, `release`, `emergency` — **or** mentions `order` for trade/p2p/predictions outside history/report/analytics, **or** `screenLevel == L3_transactionFlow` outside history/guide/faq, **or** body text hits `VitHighRiskStatePanel`/`preview`/`confirm`/`confirmation`/`release escrow`/`disable 2fa`). Routes that don't match are `not_applicable` and excluded from the grade/priority math entirely.

**Fullscreen tools** (`screenLevel == L3_fullscreenTool`, `archetype == fullscreenTool`, or one of `AdvancedChartPage`/`FuturesPage`/`P2PChatPage`/`TradingBotsPage`/`EnterpriseStatesPage`) skip the letter grade entirely — see Exceptions below.

## How the letter grade is computed

Given the 7 (or 6, if financial safety is `not_applicable`) axis statuses, plus `sharedComponentCount` (occurrences of the 24 shared primitive tokens: `VitPageLayout`, `VitAutoHideHeaderScaffold`, `VitTopChrome`, `VitHeader`, `VitPageContent`, `VitPageSection`, `VitCard`, `VitCardStat`, `VitCtaButton`, `VitTabBar`, `VitSearchBar`, `VitInput`, `VitEmptyState`, `VitErrorState`, `VitOfflineBanner`, `VitBanner`, `VitSkeleton`, `VitHighRiskStatePanel`, `VitStickyFooter`, `VitServiceTile`, `VitModuleHeroCard`, `VitMetricCard`, `VitStatusPill`, `VitModuleSectionHeader`) and `customBodyCount` (occurrences of 10 risk tokens: `Container(`, `GestureDetector(`, `TextField(`, `CustomPaint(`, `Positioned(`, `Stack(`, `SizedBox(height:`, `fontSize:`, `fontFamily:`, `BorderRadius.circular(`):

| Grade | Requires |
| --- | --- |
| **Tool** | Route is a fullscreen tool (see Exceptions) — no letter grade math applied |
| **D** | Page source unresolved, or zero shared **and** zero custom tokens, or ≥2 failing axes, or both layout **and** surface fail |
| **C** | Exactly 1 failing axis, or ≥3 warning axes, or `customBodyCount ≥ 50` **without** being "custom-pressure stabilized" (see below) |
| **A** | Zero warning axes **and** `sharedComponentCount ≥ 5` **and** `customBodyCount ≤ 35` |
| **B** | Everything that doesn't hit A, C, D, or Tool — the default "acceptable, not yet exemplary" grade |

**Custom-pressure stabilization**: a route with `customBodyCount ≥ 50` is *not* auto-downgraded to C if it also has `sharedComponentCount ≥ 8` **and** layout/controls/state all pass, surface doesn't fail, financial safety is pass-or-not-applicable, responsive passes, and copy boundary passes — i.e. heavy custom body markup is tolerated only when every other axis is clean.

## How issue priority (P0–P3) is computed

Independent of the letter grade, checked in this order:

1. **P0** — copy boundary fails, or responsive fails, or financial safety fails, or controls fails (any of these four is an immediate top-priority issue regardless of grade).
2. **P1** — grade is D; or grade is C **and** the feature is high-impact (`wallet`, `trade`, `profile`, `p2p`, `predictions`, `markets`, `rewards`).
3. **P2** — grade is C (non-high-impact), or layout/surface/state/financial-safety/copy-boundary is `warn`.
4. **P3** — everything else (typically grade A/B with no warnings).

## Primary issue and recommended action

The tool also assigns one `primary_issue` string per route (first match wins, in this order): `page_source_unresolved` → `domain_copy_boundary_violation` → `missing_financial_safety_preview_confirm` → `responsive_or_bottom_chrome_risk` → `raw_controls_need_shared_primitives` → `missing_shared_body_layout` → `local_surfaces_need_vitcard` → `missing_required_state_coverage` → `fullscreen_tool_manual_visual_qa_required` → `financial_safety_needs_manual_review` → `domain_copy_boundary_needs_review` → `partial_shared_body_layout` → `surface_consistency_needs_review` → `state_coverage_needs_review` → `fixed_size_pressure_needs_mobile_qa` → `custom_body_pressure_high` → `none`. Each maps 1:1 to a `recommended_action` sentence in the CSV/MD report — use that column directly instead of re-deriving intent from the raw axis statuses.

## Do / Don't

| Do | Don't |
| --- | --- |
| Wrap the body in `VitPageLayout`/`VitAutoHideHeaderScaffold` + `VitPageContent`/`VitPageSection` | Hand-roll a raw `Scaffold` + `Column` body |
| Use `VitCard`/`VitCardStat`/`VitServiceTile`/`VitModuleHeroCard`/`VitMetricCard` for repeated surfaces | Stack 6+ raw `Container(` panels for the same role |
| Use `VitInput`/`VitSearchBar` for any text entry | Drop a bare `TextField(` with no shared wrapper |
| Add `VitEmptyState`/`VitErrorState`/`VitOfflineBanner`/`VitSkeleton` for high-impact and financial-safety routes | Ship a withdraw/escrow/security screen with only a local warning `Text` and no shared state widget |
| Give money/security flows a preview → fee/risk disclosure → confirm → receipt path (or `VitHighRiskStatePanel`) | Let a withdraw/deposit/KYC/2FA screen skip straight from input to success |
| Keep Arena copy points-only; keep Predictions copy value-based | Use `payout`, `casino`, `gamble`, `fomo` in Arena/Predictions body copy |

## Exceptions

Fullscreen tools are graded `Tool` instead of A–D: `AdvancedChartPage`, `FuturesPage`, `P2PChatPage`, `TradingBotsPage`, `EnterpriseStatesPage`, plus any route whose `screenLevel` is `L3_fullscreenTool` or `archetype` is `fullscreenTool`. These still get a layout/surface status (tool-specific thresholds — see the axis table) but no letter grade; the primary issue defaults to `fullscreen_tool_manual_visual_qa_required` unless a harder failure (copy/financial/responsive/controls/state) fires first — note layout/surface can never be `fail` for a tool route (the tool-specific thresholds only produce `pass`/`warn`), so those two axes are excluded from this pre-emption list even though they're checked earlier in `_primaryIssue`'s match order. `needsManualReview` (used to group the "manual review" report sections) is `true` for grade C, grade D, grade Tool, or any financial-safety/copy-boundary `warn`/`fail` — that is the tool's own definition of "look at this by hand," not a separate rule.

## Limitations (state plainly, not papered over)

- This is a **static text-matching heuristic** over concatenated page + part + directly-imported feature-widget source — it does not parse the widget tree, so it can be fooled by comments, string literals, or indirection through helper functions.
- Route inventory is parsed from `VitTrade-Top-Header-Visual-Archetype-Audit.md`'s `## Route Visual Inventory` table; if that table is stale, this audit's `page_file`/`archetype`/`screenLevel` inputs are stale too.
- `test_scope` in the CSV (e.g. `flutter test test/features/wallet --reporter=compact`) is a suggested manual verification command per feature — it is not itself run by any CI step for this domain.
- There is currently **no guardrail test** and **no CI gate** for this domain. `--check` only compares the regenerated markdown/CSV against what's committed (artifact freshness) — it does not fail on grade regressions, and nothing in CI invokes it today. Promoting this domain to a CI-enforced guardrail (mirroring `card_tile_guardrail_test.dart` / `segment_pill_guardrail_test.dart`) is a tracked follow-up, not yet built.

## Current baseline (2026-07-09 generation)

```text
total_routed_screens=414
grade_A=353
grade_B=51
grade_C=5
grade_D=0
grade_Tool=5
priority_P0=4
priority_P1=1
priority_P2=49
priority_P3=360
```

The 2026-06-04 baseline above (grade_A=238/grade_C=57/grade_D=1) was mostly an
audit false-positive, not real debt: `_directFeatureWidgetImports` (the
function that merges a page's directly-imported feature-widget source into
the scanned bundle) resolved `package:vit_trade_flutter/...` imports without
the `lib/` prefix, so it silently failed to find the target file and never
merged it in — for every page that reaches its shared layout only through a
facade widget (e.g. `VitTradeHubScaffold`, `VitP2PFlowScaffold`) imported via
the app's own preferred `package:vit_trade_flutter/...` style. Once the path
resolution was fixed, ~52 of the 58 `grade_C`/`grade_D` routes moved to
`grade_A`/`grade_B` with no code changes to the pages themselves. The
remaining 5 `grade_C` routes (all `raw_controls_need_shared_primitives`, in
`earn`/`markets`) are real, unrelated findings on the Controls axis.

## Verify

```bash
cd flutter_app
dart run tool/body_component_consistency_audit.dart          # regenerate MD + CSV report
dart run tool/body_component_consistency_audit.dart --check   # local artifact-freshness check (not run in CI)
dart run tool/top_header_visual_archetype_audit.dart --check --strict   # route inventory this audit depends on
flutter analyze
flutter test --reporter=compact
```

## Related

- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — §2 audit-domain map lists this as "Audit-only — not CI-enforced"; §3 now links here as its dedicated standard doc
- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md) — Home reference consistency (the sibling hard-gated structural audit)
- [Card-Tile-Standard.md](./Card-Tile-Standard.md) — surface-tier rules for the "Surface" axis's `VitCard` usage
- [Segment-Pill-Standard.md](./Segment-Pill-Standard.md) — control-tier rules feeding the "Controls" axis
- [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md) — layout archetypes feeding the "Layout" axis
