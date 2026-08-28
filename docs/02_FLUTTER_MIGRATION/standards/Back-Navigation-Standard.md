# Back Navigation Standard (Mandatory)

**Authority:** Derived from the classification logic in `tool/back_navigation_behavior_audit.dart` and the required/forbidden snippet rules in `tool/home_entry_back_navigation_audit.dart` — this documents existing enforced behavior, it does not introduce new policy.
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement (header back-control audit):** `dart run tool/back_navigation_behavior_audit.dart --check --strict` · `test/quality/back_navigation_behavior_guardrail_test.dart` — Named CI step + artifact upload.
**Enforcement (Home-entry contract audit):** `dart run tool/home_entry_back_navigation_audit.dart --check` (checks artifact freshness AND that every rule passes) · `test/quality/home_entry_back_navigation_guardrail_test.dart` — Named CI step + artifact upload.
**Reference screen(s):** `flutter_app/lib/features/home/presentation/pages/home_page_part_01.dart` / `home_page_part_02.dart` — every `HEB-C0*` rule in Domain 2 is anchored to a page Home can push a user into; see [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md), whose own Verification section runs the Domain 2 audit.

Two independent audits cover back navigation. **Domain 1** scans every visible header back control app-wide for a safe resolution pattern (no stranding the user with no way back). **Domain 2** is Home-anchored: it pins the literal outbound-navigation snippets Home uses to reach other screens, and the literal back-navigation contract those destination screens must keep so a user who arrived from Home is never stranded either.

## Domain 1 — Header back-control behavior (`back_navigation_behavior_audit.dart`)

Scans every `.dart` file under `lib/` for `VitHeader(` / `VitTopChrome(` construction call sites whose top-level `showBack` argument contains `true` (balanced paren/brace/bracket + quote-aware parsing, not a naive substring match), plus the `_PairHeader` class body in files ending `pair_detail_header_widgets.dart` (matched via its `onPressed:` handler). Each match becomes one row of the back-navigation inventory (`VitTrade-Header-Back-Navigation-Behavior-Audit.md` / `.csv`).

For every match, the tool resolves the `onBack` callback plus the source of any local (`_`-prefixed) method it calls, then classifies it:

| Classification | Mode | Trigger | Strict issue |
| --- | --- | --- | --- |
| `missing_on_back` | `none` | Visible back control has no `onBack` (or `_PairHeader` `onPressed`) at all | `visible_back_without_onBack` |
| `unsafe_back_path` | `dynamic_unvalidated` | Callback reads `backPath` / `widget.backPath` but never routes it through `resolveSafeBackPath(...)` | `backPath_used_without_resolveSafeBackPath` |
| `dynamic_back_path` | `history_then_fallback` / `parent_route_only` | Same `backPath` usage, validated via `resolveSafeBackPath(...)` | — |
| `history_then_fallback` | `history_then_fallback` | Uses `goBackOrFallback(..., mode: BackNavigationMode.historyThenFallback)`, or manually pairs `context.canPop()` + `context.pop()` + `context.go(...)` | — |
| `parent_route_only` | `parent_route_only` / `delegated_by_owner` | Uses `goBackOrFallback(...)` with the default mode, calls `context.go(...)` with no pop, or delegates straight to the widget's own `onBack` / `widget.onBack` parameter | — |
| `unknown` | `history_only` | Calls `context.pop()` with no paired `context.go(...)` anywhere in the resolved source | `history_pop_without_fallback` (or `high_risk_...` variant) |
| `unknown` | `unknown` | Callback matches none of the above patterns | `unable_to_classify_back_behavior` |

`resolveSafeBackPath` and `goBackOrFallback` live in `lib/core/navigation/back_navigation.dart`; `BackNavigationMode` has exactly two values, `parentRouteOnly` and `historyThenFallback`. A row is a **strict violation** whenever its `issue` is not `-`; `--strict` (only meaningful combined with `--check`) fails the run when one or more exist.

### Anti-patterns (Domain 1 quick reference)

| Anti-pattern | Why it fails | Fix |
| --- | --- | --- |
| `showBack: true` with no `onBack` wired | `missing_on_back` → `visible_back_without_onBack` | Wire `onBack`, or delegate to the widget's own `onBack` parameter |
| Raw, unvalidated `backPath` fed into navigation | `unsafe_back_path` → `backPath_used_without_resolveSafeBackPath` | Route it through `resolveSafeBackPath(candidate: backPath, fallbackPath: ...)` first |
| Bare `onBack: () => context.pop()` and nothing else | `unknown` / `history_only` → `history_pop_without_fallback` | Pair with `context.go(fallbackPath)` when `!context.canPop()`, or call `goBackOrFallback(...)` |
| Hand-rolled pop/go combo that doesn't match the three literal calls the audit looks for | `unknown` / `unknown` → `unable_to_classify_back_behavior` | Prefer the shared `goBackOrFallback(...)` helper over reimplementing the triad |

### High-risk flagging

`_isHighRisk` lower-cases the file path plus the resolved callback source and checks it for any of 17 literal needles: `withdraw`, `address_add`, `address-book/add`, `token_approval`, `p2p_order`, `proof`, `cancel`, `dispute`, `escrow`, `leverage`, `order_receipt`, `copy_configuration`, `confirmation`, `claim`, `security`, `api_key`, `kyc`. This is a coarse keyword heuristic over money-movement / account-security flows — it is **not** an independent CI gate and does not fail the build by itself. Its only effects are: (a) it renames the `history_pop_without_fallback` issue to `high_risk_history_pop_without_fallback` for matching flows, and (b) it is surfaced via the audit's `highRisk` column and the `high_risk_entries` summary counter, so reviewers can prioritize which strict violations to fix first.

### Audit columns (CSV) and generated report

`VitTrade-Header-Back-Navigation-Behavior-Audit.csv` columns: `file`, `line`, `owner`, `sourceWidget`, `classification`, `mode`, `fallback`, `highRisk`, `issue`, `notes`. The companion markdown also folds in a **Modal And Sheet Baseline** table read from the sibling `VitTrade-Back-Modal-Behavior-Audit.csv` (modal/sheet dismissal is a separate, non-header audit not covered by this doc) so the report shows header back controls, modal closes, and sheet-result returns side by side.

## Domain 2 — Home-entry back-navigation contract (`home_entry_back_navigation_audit.dart`)

A curated list of `HomeEntryBackRule` entries (currently 42: 28 traceability rules + 14 contract rules). Each declares a `file`, a list of literal `requiredSnippets` (every one must be found via `String.contains`), and an optional list of literal `forbiddenSnippets` (none may be present). A rule fails — reported `FAIL` with an `evidence` string naming the exact missing/forbidden snippet — when its file doesn't exist, any required snippet is absent, or any forbidden snippet is present. `VitTrade-Home-Entry-Back-Navigation-Audit.csv` columns: `id`, `area`, `file`, `status`, `evidence`, `notes`.

### Matrix source rules (`HEB-001`–`HEB-027`, `HEB-030`)

28 traceability rules. Each asserts that the literal snippet documenting one specific Home entry point — header Search/Notifications, next-action Withdraw, a Recent-products card (BTC/USDT, P2P, Copy Trade, Staking), a Product quick action (Mua nhanh, Convert, Margin, Bot, Copy Trade, DCA, Wallet, P2P, Staking, Savings, Launchpad, Predictions, Arena, Rewards, Support, Topics, Referral), the Discovery bridge (Prediction Markets, Open Arena), the Markets root, or a Market-tab pair row — still exists verbatim in the Home file that is supposed to contain it (`home_page_part_01.dart`, `home_page_part_02.dart`, or `home_mock_data.dart`). None of these carry `forbiddenSnippets`; they only guard against a documented entry point silently disappearing or being renamed out from under the Home surface matrix.

### Home-entry contract rules (`HEB-C01`–`HEB-C03`)

14 rules asserting the actual back-navigation contract, not just traceability:

| ID | Area | Anchor file | Fallback route required | Notes |
| --- | --- | --- | --- | --- |
| `HEB-C01` | Home outbound | `home_page_part_01.dart` | — | Requires `context.push(path);`; forbids `context.go(path);` — Home's shared navigate helper must preserve history so pushed screens can pop back to Home |
| `HEB-C02A` | Trade pair entry | `trade_page_part_01.dart` | `AppRoutePaths.trade` | Also requires `widget.chartVariant == TradeChartVariant.pairRoute \|\| context.canPop()` |
| `HEB-C02B` | Convert entry | `convert_page.dart` | `AppRoutePaths.trade` | |
| `HEB-C02C` | Margin entry | `margin_trading_page.dart` | `AppRoutePaths.trade` | |
| `HEB-C02D` | Bot entry | `trading_bots_page.dart` | `AppRoutePaths.trade` | |
| `HEB-C02E` | Copy Trade entry | `copy_trading_page.dart` | `AppRoutePaths.trade` | |
| `HEB-C02F` | DCA entry | `dca_page_part_01.dart` | `AppRoutePaths.trade` | |
| `HEB-C02G` | Savings entry | `savings_page.dart` | `snapshot.backRoute` | Fallback is a computed expression, not a route constant |
| `HEB-C02H` | Prediction Markets entry | `predictions_home_page.dart` | `AppRoutePaths.markets` | |
| `HEB-C02I` | Wallet entry | `wallet_page.dart` | `AppRoutePaths.home` | Also requires `final showBack = context.canPop();` — the back arrow itself is conditional |
| `HEB-C02J` | Withdraw next action | `withdraw_page.dart` | `AppRoutePaths.wallet` | |
| `HEB-C02K` | Pair detail entry | `pair_detail_page.dart` | `AppRoutePaths.markets` | |
| `HEB-C02L` | Instrument chrome | `vit_top_chrome.dart` | — | Requires both `if (showBack) ...[` and `if (leading != null) ...[` — back arrow and instrument leading slot must render together |
| `HEB-C03` | Home source coverage | `home_page_part_03.dart` | — | Requires `part of 'home_page.dart';`; forbids `onNavigate(` — documents this part currently has zero Home outbound entries |

Every `HEB-C02*` rule except `C02L` also requires the literal string `mode: BackNavigationMode.historyThenFallback` alongside its `fallbackPath:`. Read together, the contract is: **try history first** (so a Home-pushed screen pops back to Home) **and fall back to the named parent route only when there is no history** — e.g. the page was opened directly by deep link or route restoration, not by tapping through Home.

## Limitations (source has no waiver mechanism)

Both audits are literal string/regex matchers over source text, not an AST or runtime check — grep the tool files for `allow`/`exempt`/`exception` and there is none:

- Domain 1 has no per-line waiver comment (unlike, e.g., `card-tile: allow-start`). The only way to clear a strict issue is to make the callback actually match one of the recognized safe patterns above — there is no override.
- Domain 2's `requiredSnippets` / `forbiddenSnippets` are exact-substring matches tied to a specific file path and formatting. Renaming a file or extracting a widget into a new one silently breaks a rule even when the underlying behavior is unchanged — this happened for real: `HEB-001`/`HEB-002` originally pointed at `home_page_part_01.dart` for `onNavigate('/search')` / `onNavigate('/notifications')`, but a header-extraction refactor moved that code to `lib/features/home/presentation/widgets/home_header.dart` without updating the rule's `file` field, so both rules failed until the `file` field was corrected to point at the new location (both now pass; see `passed=42`/`failed=0` in the generated report). Any future widget extraction touching a rule's anchor file needs the same manual update — there is no path-independent matching.
- Domain 1's `showBack` gate is `_extractTopLevelArgument(...).contains('true')` — a literal-only check. `lib/features/trade/presentation/widgets/trade_module_layout.dart` passes `showBack: showBack` (a variable, forwarded from the shell's own parameter) at both its `VitHeader(` call sites, so the extracted text is `"showBack"`, never contains `'true'`, and the audit silently `continue`s past every one of the ~65+ `trade` pages routed through `VitTradeHubScaffold`/`VitTradeDetailScaffold` — it never evaluates their back-nav wiring at all. A `0` strict-issue count for `trade` is therefore not evidence of compliance. See [Trade-Header-Navigation-Conventions.md](./Trade-Header-Navigation-Conventions.md) for the manually-verified back-nav findings this gap hides.

## Verify (mandatory)

```bash
cd flutter_app
dart run tool/back_navigation_behavior_audit.dart                  # regenerate inventory + CSV
dart run tool/back_navigation_behavior_audit.dart --check --strict # CI: artifacts current AND zero strict issues
flutter test test/quality/back_navigation_behavior_guardrail_test.dart --reporter=compact

dart run tool/home_entry_back_navigation_audit.dart          # regenerate Home-entry contract audit
dart run tool/home_entry_back_navigation_audit.dart --check  # CI: artifacts current AND every rule passes
flutter test test/quality/home_entry_back_navigation_guardrail_test.dart --reporter=compact
```

## Related

- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — §2 audit-domain map lists both tools' exact commands and CI status
- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md) — Home-native foundation rules these entry pages must also follow
- [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md) — tabbed-detail / form-wizard shell rules for several `HEB-C02*` destination pages
- [HomePage-Flutter-Native-Standard.md](../../04_SCREEN_REFERENCES/home/HomePage-Flutter-Native-Standard.md) — Home section order and verification (runs the Domain 2 audit directly)
- [Trade-Header-Navigation-Conventions.md](./Trade-Header-Navigation-Conventions.md) — manually-verified back-nav and push/go findings for `trade`, since Domain 1 currently can't see that module's shared-shell pages
