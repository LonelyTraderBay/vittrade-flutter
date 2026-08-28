# Trade Header & Navigation Conventions

**Scope:** Trade-module screens on both surfaces — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Status:** Policy for the trade product surface. As of the Phase 5 module split, `trade` is no longer one Dart feature module — it is 5 sibling feature modules: `trade_core` (shared shells/heroes/union repository; no routed pages of its own), `trade_terminal` (spot/futures/margin/convert/analytics, ~26 pages), `trade_copy` (copy-trading, ~22 pages), `trade_bots` (trading bots, ~19 routed pages), and `trade_compliance` (regulatory/MiFID, ~27 pages) — together still the same 87 routed screens this doc has always covered. Route URL paths are unchanged (still `/trade/...` everywhere); this was a pure internal code-organization refactor, and every rule below applies identically across all 5 modules. The three shared shells (`VitTradeHubScaffold`/`VitTradeDetailScaffold`/`VitTradeSimpleShell`) themselves now live in `trade_core`, consumed by the other 4 modules.

Not backed by a dedicated automated guardrail — unlike [Top-Header-Standard.md](./Top-Header-Standard.md) and [Back-Navigation-Standard.md](./Back-Navigation-Standard.md), which document existing enforced behavior. This doc exists because those two were historically silent (header-scroll choice) or blind (back-nav wiring, see below) for the trade module specifically. The three tool gaps below (§1 x2, §2) are now fixed (2026-07-12) and their `--strict`/guardrail output can be trusted again for trade; this doc remains the source of truth for the *rules themselves* (which shell for which screen shape, `push()` vs `go()`).

**Rollout complete (2026-07-12, pre-split):** §2 (back navigation) and §3 (push/go) are now at 100% compliance across all 87 screens — see each section for the verification count. Those counts were taken before the module split; the split moved files without changing their contents, so the compliance figures are unchanged, only the directory layout referenced in each section's example paths is different now. This doc remains the reference for any *new* trade screen (in any of the 5 modules) and for the record of the three tool gaps that blocked verifying that compliance, all now fixed.

## 1. Header shell: auto-hide vs fixed

`lib/features/trade_core/presentation/widgets/trade_module_layout.dart` defines two top-level shells, shared by all 5 trade_* modules:

- `VitTradeHubScaffold` — wraps `VitHeader` in `VitAutoHideHeaderScaffold` (header hides on scroll).
- `VitTradeDetailScaffold` — renders `VitHeader` as a plain pinned `Column` child (header stays fixed).

[Top-Header-Standard.md](./Top-Header-Standard.md)'s screen-level → archetype contract governs *visual archetype* (`instrument`/`rootModule`/`detail`/`fullscreenTool`) only — it does not choose between these two scroll behaviors, and both are valid under the `detail` archetype. The rule below is the actual convention already followed by the 8 pages using `VitTradeDetailScaffold` today (verified by direct grep, 2026-07-12; also now correctly reported by `dart run tool/top_header_visual_archetype_audit.dart` for 7 of the 8 — see "Known tool gaps, fixed" below for the one documented residual):

| Rule | Shell | Screens today |
| --- | --- | --- |
| Root/hub of a flow — the screen a user lands on and may scroll through at length (product hub, list, dashboard) | `VitTradeHubScaffold` | `trade_page`, `futures_page`, `margin_trading_page`, `trade_settings_page` (all `trade_terminal`), `trading_bots_page` (`trade_bots`), `copy_trading_page` (`trade_copy`), `transaction_reporting_page` (`trade_compliance`), and the rest of the 5 modules not listed on the right |
| Entity detail / transaction step inside an already-rooted flow — assessment, confirmation, configuration, audit log, performance, settings tied to one entity | `VitTradeDetailScaffold` | `client_categorization_opt_up_page.dart` (`trade_compliance`); `copy_audit_log_page.dart`, `copy_notifications_page.dart`, `copy_performance_page.dart`, `copy_provider_detail_page.dart`, `copy_settings_page.dart`, `performance_attribution_page.dart`, `pre_copy_assessment_page.dart` (all `trade_copy`) |

When adding a new `trade` screen: if it's an entry point users can scroll for a while and return to, use `VitTradeHubScaffold`. If it's a step inside a flow that already has a root (a detail, a confirmation, a log), use `VitTradeDetailScaffold` so the title/context never scrolls away mid-flow.

## 1.1 Title / subtitle archetypes

Header chrome must stay consistent across the L1 product-tab strip (`Giao ngay` … `Bot`). Differences come from **title / subtitle / actions inputs**, not from a different shell.

| Archetype | Pages | Title | Subtitle | Actions | Product tabs |
| --- | --- | --- | --- | --- | --- |
| **L1 Instrument** | Spot, Futures, Margin | `{pair.symbol}` | Product name VI (Spot / Futures / Margin) | **Lệnh + Vị thế** (D5) on all three | on |
| **L1 Product hub** | Convert, Bot hub | Product name VI | One-line purpose VI | Convert: settings; Bot hub: none | on |
| **L2 Trade utility** | Orders, Positions, Settings, leverage, export… (`showProductTabs: true`) | Screen name VI | Short context VI; **no** EN crumbs like `· Trade` | Keep existing | keep on |
| **L2 Copy** | Copy cluster | Title VI | Hub/detail context VI | Keep existing | **off** (ARCH-A2) |
| **L2 Bot sub-pages** | Bot settings / dashboard / backtest children | Keep VI | Keep VI | Keep existing | **off**; do not pass dead `activeProductId: 'bots'` when tabs are off |

**L1 product-tab copy (Phase 1 / T1):**

| Page | Title | Subtitle |
| --- | --- | --- |
| Convert SC-056 | `Chuyển đổi` | `Đổi tài sản nhanh` |
| Orders SC-050 | `Lịch sử lệnh` | `Lịch sử lệnh · Spot` |
| Copy hub SC-063 | `Sao chép giao dịch` | `Sao chép chiến lược có kiểm soát` |
| Bot SC-059 | `Bot giao dịch` | `Tự động hóa giao dịch theo chiến lược` |
| Spot / Futures / Margin | `{pair.symbol}` | existing product subtitle |

Chart terminals (`VitTradeTerminalHeader`) stay on their own L1 visual variant — document only; do not force them onto `VitTradeSimpleShell` inputs.

**Known tool gaps, fixed (2026-07-12):**

- `tool/top_header_visual_archetype_audit.dart`'s `_extraSourceForPageGroup` used to pull in the *entire* `trade_module_layout.dart` file as extra classification source for any page matching `'VitTradeDetailScaffold('` — but that file also defines `VitTradeHubScaffold`, whose body contains `VitAutoHideHeaderScaffold(`, so the classifier true-positived on borrowed text from the *other* class. Fixed by extracting only the matched shell class's own body (brace-matched) instead of the whole file. 7 of the 8 `VitTradeDetailScaffold` pages above now correctly show `fixed_vit_header`; `total_routed_screens=414`, `strict_visual_issues=0`, `screen_level_mismatches=0` unchanged. One residual gap remains and is intentionally left as-is: `ClientOptUpRequestPage` (grouped via `client_categorization_page.dart`, which also defines a routed class delegating header rendering through a third helper) still shows `auto_hide_header` — a per-routed-class fix for it was tried and reverted because it regressed an unrelated `markets` page (`PairDetailPage`) that delegates to a differently-named helper class; documented as a code comment in the tool.
- `tool/top_header_behavior_audit.dart` used to group source purely by Dart `part of` directives and never read `trade_module_layout.dart` at all, so it had zero visibility into any of the three shared shells (`VitTradeHubScaffold`/`VitTradeDetailScaffold`/`VitTradeSimpleShell`) — misclassifying every screen routed through them as `no_top_header`. Fixed by porting the same per-shell-class source resolution from the tool above. Regenerated result: `no_top_header` dropped from 111 to 3 app-wide (the 3 remaining are sanctioned exceptions: `LoginPage`, `P2PChatPage`, `AdvancedChartPage`), and `HomePage` now correctly reports `auto_hide_header`. This domain's guardrail only checks artifact freshness (no archetype-correctness gate), so it never blocked CI, but the per-page classification for `trade` can now be trusted.

## 2. Back navigation: `goBackOrFallback` only, `mode:` always explicit

100% of `trade` back actions must call:

```dart
goBackOrFallback(
  context,
  fallbackPath: AppRoutePaths.X,
  mode: BackNavigationMode.historyThenFallback,
)
```

**Status: 100% compliant (verified 2026-07-12, pre-split).** `grep -rc "goBackOrFallback(" lib/features/trade_terminal/presentation/pages lib/features/trade_copy/presentation/pages lib/features/trade_bots/presentation/pages lib/features/trade_compliance/presentation/pages` and `grep -rc "mode: BackNavigationMode.historyThenFallback"` (same 4 directories — `trade_core` has no `presentation/pages` of its own) both return **88 matches across 87 files** (`copy_provider_detail_page.dart`, now in `trade_copy`, has 2 call sites, one per shell branch) — every back action across the 5 modules now resolves through `goBackOrFallback(..., mode: BackNavigationMode.historyThenFallback)`, and zero raw `context.go(...)` remain wired to `onBack:` anywhere under those 4 modules' `presentation/pages` directories. The split moved files, not contents, so these counts still hold; only the directory list changed from the single pre-split `lib/features/trade/presentation/pages`.

This was a full rewrite, not a spot-fix: an earlier partial sample of this doc found only 4 non-compliant files, but the full 87-screen sweep found **82/87 (94%) were actually violating** — the 4 were a floor from limited sampling. Two failure shapes accounted for all 82, both now fixed everywhere: missing `mode:` on an existing `goBackOrFallback` call (defaults to `parentRouteOnly`), and raw `context.go(AppRoutePaths.X)` used directly as the back action. Reference pattern for any new screen: `convert_page.dart`, `margin_trading_page.dart`, `trading_bots_page.dart`, or `copy_trading_page.dart`.

**Known tool gap, fixed (2026-07-12):** [Back-Navigation-Standard.md](./Back-Navigation-Standard.md) Domain 1 (`tool/back_navigation_behavior_audit.dart`) used to only audit a `VitHeader(`/`VitTopChrome(` call site whose `showBack:` argument text contained the literal substring `true`. Both `VitTradeHubScaffold` and `VitTradeDetailScaffold` pass `showBack: showBack` (a variable, not a literal) in `trade_module_layout.dart`, so the extracted argument text was `"showBack"`, `.contains('true')` was false, and every one of the ~65+ pages routed through these two shared shells was silently skipped (`continue`), never actually checked. Fixed by only skipping a call site when the `showBack:` argument is a literal `false`; any other value (a literal `true`, a bare-identifier passthrough, or a conditional expression) is now audited. This surfaced 9 previously-invisible call sites app-wide (not just `trade` — the same passthrough pattern also existed in `wallet`, `p2p`, and `profile`), all of which resolve to the safe `delegated_by_owner`/`history_then_fallback` classifications with zero new strict issues (`strict_back_issues=0` app-wide, unchanged). The `--strict` exit code for `trade` back-nav routes can now be trusted; manual grep is no longer required.

## 3. `push()` vs `go()` for forward navigation

Convention, mirrored from the one case the app already enforces via a real guardrail — `HEB-C01` in [Back-Navigation-Standard.md](./Back-Navigation-Standard.md) Domain 2, which requires Home's own outbound navigation to use `context.push(path)` and forbids `context.go(path)` so pushed screens pop back to Home. `trade` has no equivalent guardrail yet; apply the same reasoning module-wide:

- **`push()`** — opening a screen the user should be able to pop back out of into the same list/flow: hub → entity detail (e.g. copy-trading list → provider detail), list → order/position detail, any "drill in" action.
- **`go()`** — replacing the current flow's root: bottom-nav tab switches, and `goBackOrFallback`'s own `fallbackPath` argument. Do not use `go()` to open a detail screen.

**Status: applied across all 87 screens (2026-07-12, pre-split).** Every confirmed "open an entity detail" / "drill into a sibling report" / "advance a wizard step" call site was converted from `context.go(...)` to `context.push(...)`: `trade_page_part_01.dart`'s original pattern (open orders/positions, now `trade_terminal`) was already correct and used as the reference; `copy_trading_page.dart`, `copy_provider_detail_page.dart`, `active_copies_page.dart`, `copy_configuration_page.dart`, `copy_education_page.dart`, `copy_notifications_page.dart`, `provider_leaderboard_page.dart`, `pre_copy_assessment_page.dart`, `provider_comparison_page.dart` (all now `trade_copy`), `transaction_reporting_page.dart`, `arm_integration_status_page.dart`, `regulatory_reports_dashboard_page.dart`, `best_execution_reports_page.dart`, and `complaint_tracking_page.dart` (all now `trade_compliance`) were fixed. (`copy_trading_v2_page.dart` was also fixed at the time but has since been deleted entirely in later cleanup — it no longer exists anywhere in the codebase, so it is dropped from this list rather than given a stale path.)

Two call sites were deliberately **kept as `go()`** because they are genuine flow-completion actions (submit → land on a new root, not a step the user should pop back into): `copy_confirmation_page.dart` (post-submit → active copies) and `provider_application_page.dart` (post-submit → copy trading hub) — both in `trade_copy`; line numbers cited in the original 2026-07-12 audit are no longer reliable after the split and are omitted here. Use this same test for any new call site: if pressing back after arriving should return the user to a *form they just submitted*, keep `go()`; if it should return them to a *list or hub they were browsing*, use `push()`.

## Verify

No dedicated `trade`-specific guardrail exists yet for the shell-choice rule (§1) or `push()`/`go()` rule (§3) — the underlying tools now classify `trade` pages correctly (all three known gaps above are fixed), but nothing gates CI on the *rule* in this doc, only on artifact freshness. Back navigation (§2) is covered by `test/quality/back_navigation_behavior_guardrail_test.dart` with `--strict`. For a touched file, either trust a fresh regen of the relevant tool or spot-check directly — substitute `<module>` with whichever of `trade_terminal`/`trade_copy`/`trade_bots`/`trade_compliance` owns the touched page (`trade_core` holds only the shared shells/widgets, not routed pages):

```bash
cd flutter_app
dart run tool/top_header_visual_archetype_audit.dart --check --strict
dart run tool/top_header_behavior_audit.dart --check
dart run tool/back_navigation_behavior_audit.dart --check --strict
grep -n "VitTradeHubScaffold(\|VitTradeDetailScaffold(" lib/features/<module>/presentation/pages/<file>.dart
grep -n "onBack:\|goBackOrFallback\|context.go(\|context.push(" lib/features/<module>/presentation/pages/<file>.dart
```

## Related

- [Top-Header-Standard.md](./Top-Header-Standard.md) — screen-level → visual archetype contract this doc supplements (§D)
- [Back-Navigation-Standard.md](./Back-Navigation-Standard.md) — Domain 1/2 audits this doc supplements
- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — §2 audit-domain map
