# Top Header Standard (Mandatory)

**Authority:** Derived entirely from the four `tool/top_header_*_audit.dart` scripts and their `test/quality/top_header_*_guardrail_test.dart` counterparts — this doc introduces no new policy, it documents what those tools already classify and gate.
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement — behavior:** `dart run tool/top_header_behavior_audit.dart --check` · `test/quality/top_header_behavior_guardrail_test.dart`
**Enforcement — actions:** `dart run tool/top_header_action_audit.dart --check --strict` · `test/quality/top_header_action_guardrail_test.dart`
**Enforcement — global access:** `dart run tool/top_header_global_access_policy_audit.dart --check` · `test/quality/top_header_global_access_policy_guardrail_test.dart`
**Enforcement — visual archetype:** `dart run tool/top_header_visual_archetype_audit.dart --check --strict` · `test/quality/top_header_visual_guardrail_test.dart`
**Reference screen:** `flutter_app/lib/features/home/presentation/widgets/home_header.dart` — `HomeHeader` wraps `VitTopChrome(type: VitTopChromeType.rootBrand, …)`, the only `rootBrand` archetype in the app (`VitTrade-Top-Header-Visual-Archetype-Audit.md` reports `rootBrand=1`, zero mismatch). This is a visual-archetype fact only — section A's behavior audit still misclassifies `HomePage` as `no_top_header`; see the gap note there.

Four independent audits share one concern — the top chrome — but classify different axes of it: how the header pins/scrolls, which icons it shows, who may reach global search/notifications from it, and which visual archetype it must render as for its route's screen level. All four walk `lib/app/router/route_groups/*.dart` to resolve `GoRoute` → page class → page source, the same way `Flutter-Page-Archetype-Standard.md`'s tripwire test does.

## A. Header behavior

`tool/top_header_behavior_audit.dart` classifies every routed page into exactly one `classification` (regenerates `VitTrade-Top-Header-Behavior-Audit.md`; `--check` only verifies the artifact is byte-identical to a fresh run — there is no `--strict` flag and no violation threshold, it is a pure inventory/freshness gate):

| Classification | Detected when |
| --- | --- |
| `auto_hide_header` | Source contains `VitAutoHideHeaderScaffold(`, `RewardsArenaPointsBridge(`, `_CollapsibleHomeHeader`, or a `_headerVisible` field paired with `UserScrollNotification`/`ScrollUpdateNotification` |
| `fixed_vit_header` | Source contains `VitHeader(` and no scroll container (`SingleChildScrollView`/`ListView`/`CustomScrollView`/`NestedScrollView`) appears before it |
| `custom_scroll_header` | `VitHeader(` appears *after* a scroll container opens, or the page uses `_TradeHeader`/`MarketListHeader` |
| `no_top_header` | None of the above patterns are found |
| `unresolved` | The route's page class could not be resolved to a `lib/features/**` class at all |

A second `variant` field refines the same source further:

| Variant | Meaning |
| --- | --- |
| `shared_auto_hide_scaffold` | `VitAutoHideHeaderScaffold(` or `RewardsArenaPointsBridge(` |
| `home_collapsible_custom` | `_CollapsibleHomeHeader` — a name the classifier still checks for, but it has zero matches anywhere in `lib/` today; Home's real header does not trigger this variant |
| `trade_custom_in_scroll` | `_TradeHeader` |
| `market_custom_in_scroll` | `MarketListHeader` |
| `vit_header_custom` | `VitHeader(variant: VitHeaderVariant.custom)` |
| `vit_header_default_with_actions` | `VitHeader(` with a `trailing:` or `action:` argument |
| `vit_header_default_title_subtitle` | `VitHeader(` with a `subtitle:` argument |
| `vit_header_default_title_only` | Plain `VitHeader(` with neither |
| `no_top_header` | No `VitHeader(` at all |

**Rules**

1. A route's page class must resolve from its `GoRoute` builder (`return X(`, `child: X(`, or `=> X(`) — obscuring the returned widget behind further indirection makes the route `unresolved`, which is always wrong for a shipped screen.
2. New screens must land in `auto_hide_header` (via `VitAutoHideHeaderScaffold(`/`RewardsArenaPointsBridge(`) or `fixed_vit_header` (via `VitHeader(` with no enclosing scroll view) — the only bespoke scroll-coupled header names the classifier still recognizes outside the shared scaffold are Trade's `_TradeHeader` and Markets' `MarketListHeader` (`_CollapsibleHomeHeader` is a third name it checks for, but nothing in `lib/` matches it today); any other hand-rolled show/hide logic reads as `no_top_header`.
3. Scroll-to-hide via layout collapse (`heightFactor` / removing a `Column` child above an `Expanded` body) must only happen inside `VitAutoHideHeaderScaffold`, which keeps a `_canHideHeader` / `_collapseBudget` gate so short lists do not snap scroll offset back to the top — see [Scroll-Auto-Hide-Standard.md](./Scroll-Auto-Hide-Standard.md). Do not hand-roll `_headerVisible` on pages.
4. `no_top_header` is only acceptable for the curated cases enumerated in section D's `_noHeaderDecisions` map — this tool itself does not gate that, the visual archetype audit does.

**Current gap:** `HomePage` renders through the shared `VitAutoHidePageScaffold(` wrapper (`lib/shared/layout/vit_auto_hide_page_scaffold.dart`), which itself opens `VitAutoHideHeaderScaffold(` — but this tool only scans the routed page's own `part of` file group, never the widgets a wrapper indirects into, so it never sees that literal string. `VitTrade-Top-Header-Behavior-Audit.md` therefore lists `HomePage` as `no_top_header`/`no_top_header` today. That is a tool blind spot, not a missing header: the visual archetype audit (section D) resolves the same indirection via its own extra-source lookup and correctly reports `HomePage` as `rootBrand` with zero screen-level mismatch.

The same blind spot is much larger for `trade`: all 87 routed screens indirect through one of three shells in `lib/features/trade/presentation/widgets/trade_module_layout.dart` (`VitTradeHubScaffold`/`VitTradeDetailScaffold`/`VitTradeSimpleShell`), none of which this tool's `part of` grouping ever reads — so **69 of 87** trade screens are misclassified `no_top_header` (ground truth: 61 `auto_hide_header` + 8 `fixed_vit_header`). No CI impact (this domain only gates artifact freshness), but do not trust this artifact's per-page classification for `trade`. See [Trade-Header-Navigation-Conventions.md](./Trade-Header-Navigation-Conventions.md).

## B. Trailing actions

`tool/top_header_action_audit.dart` (regenerates `VitTrade-Top-Header-Action-Audit.md` + `.csv`) walks every `VitHeader(` call plus a curated `_customHeaderTargets` allowlist of 5 files / 6 classes (`_HomeHeader` in `home_page_part_01.dart`, `MarketListHeader`, `_PairHeader`, `_TradeHeader`, and `LaunchpadHomeHeaderActions`/`_HeaderActions` together in `launchpad_home_header_widgets.dart`) and classifies every icon/action it finds. `--check` verifies both artifacts are current; `--strict` additionally fails when the sum of `vit_header_with_custom_trailing` + `vit_header_with_legacy_action` + `migration_candidates` + `banned_icon_usages` + `custom_button_usages` + `action_groups_over_limit` is greater than zero.

**Canonical action catalog** (`VitHeaderActionType` → icon) — the only 20 actions the tool accepts as `canonical_action_type`:

| Action | Icon | Action | Icon |
| --- | --- | --- | --- |
| `back` | `chevron_left_rounded` | `history` | `history_rounded` |
| `close` | `close_rounded` | `analytics` | `bar_chart_rounded` |
| `search` | `search_rounded` | `portfolio` | `business_center_outlined` |
| `notifications` | `notifications_none_rounded` | `overview` | `monitor_heart_outlined` |
| `filter` | `tune_rounded` | `sectors` | `layers_rounded` |
| `settings` | `settings_outlined` | `refresh` | `refresh_rounded` |
| `export` | `download_rounded` | `help` | `help_outline_rounded` |
| `share` | `share_outlined` | `emergency` | `error_outline_rounded` |
| `favoriteOn` / `favoriteOff` | `star_rounded` / `star_border_rounded` | `more` | `more_vert_rounded` |
| `add` | `add_rounded` | | |

**Banned icons** — a raw `Icons.*` reference matching one of these is flagged `banned_icon` with its required replacement:

| Banned `Icons.*` | Canonical replacement |
| --- | --- |
| `ios_share_rounded` | `share` |
| `file_download_outlined` | `export` |
| `filter_alt_outlined` | `filter` |
| `favorite_rounded` / `favorite_border_rounded` | `favoriteOn` / `favoriteOff` |
| `add` (raw Material icon) | `add_rounded` |
| `person_add_alt_1_rounded` | `add` |
| `chevron_right_rounded` | `VitHeaderActionType.more` |

`keyboard_arrow_down_rounded` and `arrow_drop_down_rounded` are the only icons explicitly allowed *outside* the action catalog — they're `selector_or_content_icon`s, permitted only as selector/body content, never as a header action.

**Rules**

1. `VitHeaderAction.bell` / `.search` / `.more` (the old built-in enum) are `legacy_built_in` and `needsMigration: true` — replace with `VitHeader.actions` / `VitHeaderActionItem(type: VitHeaderActionType.…)`.
2. A raw `trailing:` widget on `VitHeader(` is always `needsMigration: true` under `--strict` (either `custom_trailing_widget` when it has no catalog icon inside it, or `custom_action_button` when a canonical icon is reachable only through a hand-rolled button) — strict mode requires zero `trailing:` usage app-wide.
3. Icons that don't match the canonical catalog at all are `non_catalog_icon` — map them to the catalog or move them into page content, they are not a header action.
4. An action group (any of `VitHeaderActionButton(`, `VitIconButton(`, `IconButton(`, the eight `_Header*Button(` legacy widgets — `_HeaderActionButton`, `_HeaderButton`, `_HeaderSettingsButton`, `_HeaderCreateButton`, `_HeaderExportButton`, `_HeaderDownloadButton`, `_HeaderHistoryButton`, `_HeaderChartButton` — plus `_HeaderSmallIcon(` and `_AddAddressButton(`) with more than 3 buttons in one trailing/custom-header block is `action_groups_over_limit` — collapse the rest behind `more`.
5. Any bespoke header widget not in the `_customHeaderTargets` allowlist above is invisible to this audit — a new custom header class needs its file+class added there before this tool can review its icons.

## C. Global access policy

`tool/top_header_global_access_policy_audit.dart` (regenerates `VitTrade-Top-Header-Global-Access-Policy-Audit.md` + `.csv`) governs only the `search` and `notifications` `VitHeaderActionType` values — it does not gate any other action type. There is no `--strict` flag; `--check` fails on stale artifacts *and* on any policy violation unconditionally.

| Scope | Who may use it | Rule |
| --- | --- | --- |
| `global_search` | `home_page_part_01.dart` only | Must route to `/search` / `AppRoutePaths.search`, else `global_search_missing_search_route` |
| `module_search` | `topic_hub_page.dart`, `predictions_home_page.dart` only | Allowed as a scoped, in-module search |
| *(any other file)* | — | `search_action_not_allowlisted` |
| `global_notification` | `home_page_part_01.dart` only | Must route to `/notifications` / `AppRoutePaths.notifications`, else `global_notification_missing_inbox_route` |
| `context_notification` | `convert_page_header_widgets.dart`, `launchpad_claim_receipt_page.dart`, `p2p_claim_detail_page_part_01.dart` only | Must **not** deep-link to the global inbox (`context_notification_opens_global_inbox`) and must carry a `tooltip:` scoping it (`context_notification_missing_scope_tooltip`) |
| *(any other file)* | — | `notification_action_not_allowlisted` |

Three additional hard-coded source checks feed `sourceIssues` (not allowlist-based): `root_routes.dart` must not read `HomeMockData.homeBadge` for the shell badge (must read `notificationUnreadCountProvider`); Home's header wiring must not read `notifications: snapshot.notifications` (must read global notification state); `notifications_page.dart` must not hold a local `_notifications` list (must mutate the global notification store).

`lib/shared/**` files are exempt from the action-type scan entirely. Plain `Icons.search_rounded` / `Icons.notifications_none_rounded` / `notifications_rounded` references elsewhere are only tallied (`contentSearchControls`, `contentNotificationIcons`) — those are body-content search bars or badge glyphs, out of scope for this policy.

**Known limitation:** the allowlists key on the file that *textually contains* the `VitHeaderActionItem(...)` call, not the routed page file. If a page's header is extracted into a companion widget (e.g. a `*_header.dart` file wrapping `VitTopChrome`), that widget's file must be added to the relevant allowlist too, or the audit reports `search_action_not_allowlisted` / `notification_action_not_allowlisted` even though the action itself is legitimate — check the current CSV before assuming a flagged row is a real regression.

## D. Visual archetype

`tool/top_header_visual_archetype_audit.dart` (regenerates `VitTrade-Top-Header-Visual-Archetype-Audit.md` + `.csv`) assigns every route a `screenLevel` and an `archetype`, then fails `--strict` when a route's archetype doesn't match its screen level's `expectedArchetype`, or when any other strict issue fires.

**Screen-level → expected archetype contract:**

| Level | Screen type | Expected archetype |
| --- | --- | --- |
| L0 | Home root / Auth entry | `rootBrand` / `authOnboarding` |
| L1 | Primary tab roots (Markets, Wallet, Profile) and product module hubs (P2P, DCA, Launchpad, Staking/Earn, Arena, Arena Points, Predictions, Rewards) | `rootModule` |
| L1 | Trade instrument workspace (Trade, Margin Trading, and Futures — Futures qualifies via `VitTradeSimpleShell(`) | `instrument` |
| L1 | Utility hubs (search, news, notifications, support, referral, cross-module) | `detail` |
| L2 | Section hub, utility detail, entity detail | `detail` |
| L2 | Instrument detail (Pair Detail) | `instrument` |
| L3 | Transaction flows (confirm, receipt, withdraw, deposit, add/create/edit, KYC, 2FA) | `detail` |
| L3 | Fullscreen tools (advanced chart, P2P chat) | `fullscreenTool` |

Archetype is detected in priority order: an explicit `type: VitTopChromeType.X` always wins; else `HomePage`/`_HomeHeader` → `rootBrand`; `TradePage`/`MarginTradingPage`/Futures-via-`VitTradeSimpleShell(` → `instrument`; membership in the curated `_rootModulePages` set or `MarketListHeader` → `rootModule`; `_TradeHeader`/`_PairHeader` → `instrument`; `fixed_vit_header` behavior → `detail`; `auto_hide_header` + `VitHeader(` → `detail`; a custom-scroll header with a custom variant → `instrument`; otherwise `unclassified`.

`no_top_header` routes only escape `unclassified` via the curated `_noHeaderDecisions` map (e.g. `LoginPage`→`authOnboarding`, `AdvancedChartPage`/`P2PChatPage`/`TradingBotsPage`→`fullscreenTool`, `FuturesPage`→`instrument`, `EnterpriseStatesPage`→`fullscreenTool` as a dev-showcase exception). Two entries in that map, `DCARebalanceDashboard` and `DCAScheduleAnalytics`, are explicitly flagged `no_header_needs_migration_decision`; `WalletPage`/`ProfilePage` are explicitly flagged `root_title_in_content` (root module pages must move page identity into `VitTopChrome`, not leave it in page content). Any `no_top_header` route missing from this map is `no_header_without_exception_reason` — that is the only real escape hatch for a header-less screen.

**Other `--strict` issues:**

| Issue | Fires when |
| --- | --- |
| `root_module_missing_vit_top_chrome` | Wallet/Profile/MarketList/P2PHome page source has no `VitTopChrome(` |
| `offline_banner_hard_coded_in_header` | `VitOfflineBanner(` sits inside a `header: Column(...)` block |
| `offline_banner_hard_coded_without_state_gate` | `VitOfflineBanner(` isn't preceded (within ~480 chars) by an `if`/`switch`/`showOfflineBanner`/`currentState` or an offline/stale/reconnecting keyword — exempt only for `EnterpriseStatesPage` |
| `root_header_uses_nonstandard_font_size_30` | Literal `fontSize: 30` on a `rootModule`/`MarketListPage` header |
| `top_header_uses_local_padding_tokens` | `_HomeHeader`/`MarketListHeader`/`_PairHeader`/`_TradeHeader` uses `EdgeInsets.fromLTRB(20,` or `EdgeInsets.symmetric(horizontal: 20)` instead of the shared token |
| `screen_level_archetype_mismatch(expected_X)` | Archetype disagrees with the screen-level contract above |

The guardrail test also asserts a static token contract independent of the audit: `lib/app/theme/app_top_header_tokens.dart` must define `detailMinHeight`, `rootMinHeight`, `instrumentMinHeight`, `horizontalPadding`, `actionGap`, `buttonSize`, `badgeMinSize`, `surfaceColor`, `dividerColor`; and `vit_top_chrome.dart`, `vit_header.dart`, `vit_header_action_button.dart` must each import `app_top_header_tokens.dart` and reference `AppTopHeaderTokens.` — no local re-declaration of header metrics/colors in those three files — this is the guardrail's first test, alongside a second test that just re-runs the `--check --strict` audit above. A third test locks `ArenaHomePage`, `DCAPage`, `StakingEarnPage`, `PredictionsHomePage` to `rootModule`/`L1_productModuleHub` with zero screen-level mismatch, so those four product hubs cannot silently regress to a detail-style header.

**Module identity inside the header stays accent-only** — icon, pill, border, tab indicator, chart marker, or restrained accent color; no per-module header background or local header palette (see [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)).

**Known gap (`trade` module):** `_extraSourceForPageGroup` includes the whole `lib/features/trade/presentation/widgets/trade_module_layout.dart` file as extra source for any page matching `'VitTradeDetailScaffold('`, but that file also defines `VitTradeHubScaffold` (which does contain `VitAutoHideHeaderScaffold(`). The classifier's `source.contains('VitAutoHideHeaderScaffold(')` check then false-positives on the borrowed class body, so all 8 pages that actually use the fixed-header `VitTradeDetailScaffold` (`client_categorization_opt_up_page.dart`, `copy_audit_log_page.dart`, `copy_notifications_page.dart`, `copy_performance_page.dart`, `copy_provider_detail_page.dart`, `copy_settings_page.dart`, `performance_attribution_page.dart`, `pre_copy_assessment_page.dart`) show as `auto_hide_header`/`shared_auto_hide_scaffold` — reproducibly, not from a stale artifact. See [Trade-Header-Navigation-Conventions.md](./Trade-Header-Navigation-Conventions.md) for the manually-verified ground truth and the actual auto-hide-vs-fixed convention this module follows.

## Anti-patterns

| Anti-pattern | Why | Fix |
| --- | --- | --- |
| New page returns a widget the audits can't name-match (`return _buildScaffold();`) | Route resolves to `unresolved`/`unclassified` in three of the four audits at once | Return the page class directly from `GoRoute.builder`/`child:` |
| Hand-rolled scroll-hide header logic outside `VitAutoHideHeaderScaffold` | Not one of the two live custom-header names (`_TradeHeader`, `MarketListHeader`) — `_CollapsibleHomeHeader` is a third name the classifier checks for but nothing matches it today; reads as `no_top_header` | Use `VitAutoHideHeaderScaffold` (or `VitHeader(` for a fixed header) |
| `VitHeader(trailing: _MyActionsRow())` | `custom_trailing_widget`/`custom_action_button`, always a strict violation | `VitHeader(actions: [VitHeaderActionItem(type: VitHeaderActionType.…)])` |
| `Icon(Icons.favorite_border_rounded)` in a header action | `banned_icon` | `VitHeaderActionType.favoriteOff` → `Icons.star_border_rounded` |
| A non-Home page adding `VitHeaderActionType.search` / `.notifications` | `search_action_not_allowlisted` / `notification_action_not_allowlisted` unless it's one of the six allowlisted files in section C | Route through Home's global actions, or use a scoped module search/context notification per the allowlist |
| `WalletPage`/`ProfilePage` titling itself in page content instead of `VitTopChrome` | `root_title_in_content` under the visual archetype audit | Move the title into `VitTopChrome(type: VitTopChromeType.rootModule, title: …)` |
| `VitOfflineBanner()` rendered unconditionally | `offline_banner_hard_coded_without_state_gate` | Gate it behind connectivity/staleness state |

## Verify

```bash
cd flutter_app
dart run tool/top_header_behavior_audit.dart                        # regenerate behavior artifact
dart run tool/top_header_behavior_audit.dart --check                # CI: artifact current
dart run tool/top_header_action_audit.dart                          # regenerate action markdown + CSV
dart run tool/top_header_action_audit.dart --check --strict         # CI: current + zero violations
dart run tool/top_header_global_access_policy_audit.dart            # regenerate global access markdown + CSV
dart run tool/top_header_global_access_policy_audit.dart --check    # CI: current + zero policy violations
dart run tool/top_header_visual_archetype_audit.dart                # regenerate visual archetype markdown + CSV
dart run tool/top_header_visual_archetype_audit.dart --check --strict # CI: current + zero strict issues
flutter test test/quality/top_header_behavior_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_action_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_global_access_policy_guardrail_test.dart --reporter=compact
flutter test test/quality/top_header_visual_guardrail_test.dart --reporter=compact
```

## Related

- Module accent boundaries for header identity: [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)
- Shared design tokens backing `VitHeader`/`VitTopChrome`: [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md)
- Tabbed-detail/form-wizard page shells that sit under `auto_hide_header`: [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md)
- Trade-module auto-hide-vs-fixed convention and known classifier gap detail: [Trade-Header-Navigation-Conventions.md](./Trade-Header-Navigation-Conventions.md)
- Generated inventories: [VitTrade-Top-Header-Behavior-Audit.md](../audits/VitTrade-Top-Header-Behavior-Audit.md) · [VitTrade-Top-Header-Action-Audit.md](../audits/VitTrade-Top-Header-Action-Audit.md) · [VitTrade-Top-Header-Global-Access-Policy-Audit.md](../audits/VitTrade-Top-Header-Global-Access-Policy-Audit.md) · [VitTrade-Top-Header-Visual-Archetype-Audit.md](../audits/VitTrade-Top-Header-Visual-Archetype-Audit.md)
