# Tablet-Adaptive Standard (mandatory for any screen with a dedicated tablet layout)

**Authority:** [DESIGN.md](../../../DESIGN.md) Layout · `AGENTS.md` UI Rules · Reference screen: Home (SC-007)
**Scope:** every Dart file on the tablet surface — see [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Enforcement:** R1's sharpest teeth are now static: `tool/tablet_route_surface_audit.dart` + `test/quality/tablet_route_surface_guardrail_test.dart` lock tablet presentation against re-dispatching the surface (`AppBreakpoints.` queries, compat `ResponsiveSurfacePage` references, and — R1c, 2026-08-24 — `OrientationBuilder`/`MediaQuery.orientationOf` orientation dispatch; all absolute, zero baseline; router/theme layers exempt as the sanctioned homes, including the router's compat `null` arm). The orientation policy's behavioral half (rotation relayout) is locked by `test/quality/tablet_rotation_guardrail_test.dart`. R4-R8's scaffold is implemented once in `VitTwoColumnTabletDashboard` (`lib/shared/layout/vit_two_column_tablet_dashboard.dart`), so a page using it satisfies those rules by construction rather than by manual review. `page_rhythm_audit.dart`'s `_hasTradeRhythmScaffold` allowlist recognizes the shared widget so structural page-rhythm coverage isn't lost. What's still manually verified per page: R2 (phone reference untouched) and R3 (threshold choice) and R9 (header promotion) — plus (a) the page's own widget test at/above its two-column threshold, (b) the existing whole-repo structural audits (page rhythm, card tile, page content width), which already scan every file under `lib/features/**/presentation` regardless of phone/tablet.
**Reference screens:** all 5 app root tabs now have a dedicated tablet page, all delegating their two-column body to `VitTwoColumnTabletDashboard`: `home_tablet_page.dart` (first, R1-R9 originally established here); `wallet_tablet_page.dart` (confirmed R9's header-promotion pattern generalizes); `markets_tablet_page.dart` (was the third dashboard reference until 2026-08-24, when Markets moved to the Analysis-terminal master-detail shell below — before the move it had confirmed a phone-only content gate like `showMarketSummary` can be safely dropped in a tablet column when the gated widgets' own data doesn't depend on the filter state; see R7); `trade_tablet_page.dart` (confirmed a financial-safety column-placement invariant — the risk panel staying in the primary column — survives being expressed as plain child-list ordering, no special-casing needed in the shared widget); `profile_tablet_page.dart` (confirmed a nested inner screen-state switch upstream of the two-column body doesn't need to interact with the shared widget at all). After all 5 confirmed the identical scaffold, it was extracted into `VitTwoColumnTabletDashboard` (own test: `test/shared/layout/vit_two_column_tablet_dashboard_test.dart`) and all 5 pages migrated onto it — see "Upgrade path" below.

## Scope

This standard governs screens that build a **dedicated tablet-specific layout**
— not just inheriting the shell. The shell-level adaptation (bottom nav vs
`VitNavigationRail` via `VitAppShell` / `AppBreakpoints.tablet` = 600px) is
already app-wide and out of scope here; every screen gets that for free.

## When to build a dedicated tablet page

Build one when a screen is a **dashboard/hub with 2+ independent content
groupings** that benefit from side-by-side layout — content users scan or
compare at once (portfolio + market data + quick actions, in Home's case).

Skip it for linear detail pages, single-purpose forms/wizards, and
confirmation/receipt screens — these already render correctly as-is inside
the tablet shell (nav rail + full-width single column), and a bespoke tablet
layout would be extra surface with no real information-density gain. When in
doubt, ship without one: adding it later is cheap, removing a shipped one
that turned out unnecessary is not.

## Module composition archetypes — same foundation, different by *job*

Every module obeys the **same absolute foundation** (tokens, spacing S1–S4,
card frames R1–R3, input states I1–I5, motion M1–M5, header/nav rules) —
modules never differ in those. What *legitimately* differs is the
**composition grammar**, and it is chosen by the module's actual job, not by
taste. Pick the row that matches the screen's work before writing any code.
(The phone surface carries the same two-layer model with its own one-column
grammar — see `Phone-Composition-Standard.md`, including a phone↔tablet
mapping per job.)

| Archetype (module's job) | Composition grammar | Reference | What differs between modules |
| --- | --- | --- | --- |
| **Monitor dashboard** — watch state and act fast (Home, Trade) | `VitTwoColumnTabletDashboard` (R4–R8) + thin banner strip + fixed header sibling (R9) | `home_tablet_page.dart`, `trade_tablet_page.dart` | *What goes in the columns* (portfolio vs order form + risk panel) and the banner's metric grammar |
| **Settings master-detail** — many flat sibling sub-screens (Profile) | `StatefulShellRoute.indexedStack` + framed 308dp master menu (both split tiers) + per-pane scroll (`ProfileTabletMasterShell`) | `profile_tablet_page.dart` | Menu grouping by account-domain; each pane's content ports the phone page (R2) |
| **Analysis terminal** — browse a live list while inspecting the selection side-by-side (Markets) | Same `StatefulShellRoute` shell idiom, but the master is a *working list* (search + watchlist-first category chips + sort row + compact rows), not a settings menu (`MarketsTabletMasterShell`) | `markets_tablet_master_shell.dart` | What the master list filters/sorts by, and which analysis panes the detail column renders (`/markets` overview, `/pair/...`) |
| **Money-movement detail** — high-risk flows needing focus + context (Wallet deposit/withdraw/transfer/address) | `WalletTabletDetailSurface`: own header + back, single scroll, primary:flex7 / secondary:flex5 — not a two-column dashboard | `wallet_tablet_detail_surface.dart` | The flow's preview/confirm content and safety copy (financial-safety rules are non-negotiable here) |
| **Linear detail / content page** — one thing to read or confirm (pair detail, order receipt, prediction event) | **No dedicated tablet page** — renders in the shared nav-rail shell; the module's tablet dashboard links into it | receipt/event pages under `presentation/tablet/pages/` | Content only; the layout is the shell's |
| **Wizard / form flow** — step-by-step entry (KYC, create API key) | Form rhythm inside a master-detail pane or a single-column page; sticky footer CTA; never a two-column dashboard | `profile_kyc_pane.dart`, API-key create flow | Steps, fields, and per-step validation of the domain |

**What may never vary between modules:** spacing/radius/border/motion/input
tokens and their audits (S/R/I/M rules), the shared widget ladder, header
and back-navigation contracts, masking and financial-safety rules, skeleton-
mirrors-page discipline.

**Where legitimate difference comes from — and only from:**
1. the module's **archetype row above** (composition grammar),
2. the module's **accent identity** (`Flutter-Module-Identity-Standard.md`),
3. the module's **own data and workflow** (what the columns/panes contain).

If a proposed difference doesn't trace to one of those three, it is drift —
cut it. This is the rule that keeps "mỗi module một kiểu" impossible while
keeping "mọi module giống hệt nhau" (cookie-cutter) equally impossible.

## Invariant

```text
Same route contract, same data provider, same SC-NNN identifier as the phone
page. The explicit Tablet router builds the Tablet widget directly — never a
second route/path and never a Phone/Tablet conditional inside either page.
The legacy `createAppRouter()` facade may use the composition-root
`ResponsiveSurfacePage` for old responsive callers; new surface routers never
use that compatibility dispatcher.
```

## Mandatory rules

| # | Rule |
| --- | --- |
| R1 | **Explicit surface route, not a new path.** `AppSurface.tablet` in the existing route group builds `<Feature>TabletPage` directly; `AppSurface.phone` builds the phone page directly. Keep any legacy width dispatcher only in `app/bootstrap/responsive_surface_page.dart` for the compatibility `createAppRouter()` facade. |
| R2 | **Never touch the phone reference.** Don't edit the phone page or its `part` family to build a tablet variant. Reuse its already-public presentation widgets directly. For a section that's `private` inside another page's part family, write a new public tablet-specific widget instead — naming `<feature>_<section>_panel.dart` (see `home_market_watchlist_panel.dart`, `home_discovery_panel.dart`). |
| R3 | **Verify the threshold empirically, don't invent a new global breakpoint tier.** Below some min-width, fall back to a single column (still tablet shell, still nav rail). Start from `TabletDashboardWidths.twoColumnMinWidth` (`lib/app/theme/tablet_dashboard_widths.dart`) — all 5 existing dashboards confirmed 900 by pumping real widgets at candidate widths, not guessing — but re-verify against your own page's content rather than assuming it holds; if it doesn't, keep a page-local `static const` override instead of editing the shared value (see that file's own doc comment). Never invent a second `AppBreakpoints` tier for one screen. |
| R4 | **Independent-scroll columns**: primary is `Expanded`, secondary is a fixed-width `SizedBox` (not `Expanded` — see R5), each wrapping its own `SingleChildScrollView` — never one `SingleChildScrollView` wrapping the whole `Row`. A `Row` of unbounded natural height inside a single outer scrollview breaks once any child needs a bounded height; two independently height-bounded scrolling columns is the supported shape. |
| R5 | **Width-cap on the two-column block as a whole**, via an outer `Center` + `ConstrainedBox(maxWidth: primaryColumnMaxWidth + secondaryColumnMaxWidth)` wrapping the entire `Row` — never a per-column cap on the `Row`'s own children. Two per-column caps were tried first and confirmed wrong on-device: each column absorbed its own leftover width independently, so slack piled up entirely on one edge instead of distributing symmetrically (first the outer/right edge, once secondary's cap left it under-claiming its `Expanded` flex share; then the nav-rail/left edge, once secondary was pinned to a fixed width and *all* leftover shifted to primary's side instead). Inside the capped, centered block: primary is a plain `Expanded` (the outer cap already bounds the pair's total, so no per-column `ConstrainedBox` is needed there); secondary is a fixed `SizedBox(width: secondaryColumnMaxWidth)` — a flex share would let it over-claim width its own content never uses. `SingleChildScrollView` per column is still what loosens *only* the height axis while keeping width bounded; that's why the cap sits on the outer `Center` (which hands the `Row` genuinely loose constraints up to the cap) rather than wrapped directly around the `Row` or an `Expanded` child — a `ConstrainedBox` placed directly on a tightly-constrained ancestor is a no-op, since tight incoming constraints always win over a descendant's tighter bound. |
| R6 | **Two-column path uses `VitContentPadding.relaxed` + `VitPageRhythm.relaxed`** — `.compact` is the phone/space-constrained tier. The single-column fallback below the page's own threshold (R3) keeps `.compact`. |
| R7 | **Frame the secondary/sidebar column as a distinct panel** — `VitCard(variant: VitCardVariant.inner, padding: EdgeInsets.zero)` wrapping that column's `VitPageContent` — so the independent-scroll seam (R4) reads as an intentional sidebar boundary, not an accidental gap between two loose stacks. The primary/main column stays flush against the page background (its own sections already carry their own card framing). |
| R8 | **Preserve the proven safety margin.** `TabletDashboardWidths.primaryColumnMaxWidth`/`secondaryColumnMaxWidth` (800/400) are the per-column pixel widths confirmed not to overflow at the shared threshold (R3) across all 5 reference screens — `primaryColumnMaxWidth` raised from an original 640 once a wide (1280dp-logical) tablet showed 640 left a visible unused margin rather than acting as a deliberate content-width ceiling (R5), then 760 → 800 (2026-08-21) after a side-by-side variant preview so wide screens hand slack to the main column; `secondaryColumnMaxWidth` lowered 440 → 400 in the same pass to shift 40px into the main column (the 3-column tile grid stays comfortable at 400). Adding a gutter, changing the flex ratio, or lowering the threshold all eat into that margin — re-verify with your page's real content before trusting the shared numbers, don't just eyeball it. |
| R9 | **Promote the header to a fixed sibling, not a scrolling child.** The phone page's header (`VitTopChrome`, or whatever it wraps inside `VitAutoHidePageScaffold`/a leading widget in its `SingleChildScrollView`) has no single scroll offset to auto-hide against once R4 splits the body into two independently-scrolling columns. Reuse the exact same header widget/call — don't rebuild it — just move it to be a `Column` sibling above `Expanded(dashboard)`, outside any scaffold that ties it to one scrollable's offset. This is still "reusing the public widget" (R2), only its position changes. |

R4-R8 are implemented once in `VitTwoColumnTabletDashboard` (`lib/shared/layout/vit_two_column_tablet_dashboard.dart`) — a new tablet page calls it (`primaryChildren`/`secondaryChildren` in, the whole threshold/Row/Align/ConstrainedBox/VitCard tree handled internally) rather than re-implementing these rules by hand. They stay documented here as the contract that widget's own doc comment carries in full, and as the standard R1-R3/R9 still hold a page to directly.

## Dashboard composition playbook (established by the Home tablet redesign, 2026-08)

Beyond the scaffold rules, all root-tab tablet dashboards follow the same
monitor-first composition, established on `home_tablet_page.dart` and rolled
out to Markets/Profile/Trade in the same pass:

1. **Banner slot is for thin strips only; tall heroes scroll with the primary column.** The scaffold's fixed `banner:` slot suits a flat KPI strip (~90–110px): *monitor* surfaces (Home/Markets/Trade) use one `VitCard(radius: standard)` of metric blocks separated by hairline dividers that reflows to two rows below ~760px. A tall identity hero (~230px) must NOT go in the banner slot — on an 800dp-tall landscape screen a locked banner that size eats a third of the viewport and starves the working columns (Profile learned this from user feedback, 2026-08-22). Instead, identity surfaces put their hero vocabulary card (`VitCardVariant.hero` gradient + `VitHeroGlow` + `VitCardRadius.large` — `ProfileAccountHero`) as the primary column's first *scrolling* card, the same pattern Home tablet uses for `HomePortfolioCard`. Pick the banner grammar that matches what the page *is*; either way the fixed banner never scrolls with either column.
2. **Dense primary workspace** — the main column carries the surface's working table/form at tablet density (e.g. Markets' 6-column sortable pair table), not a copy of the phone feed. Phone-only clipping (row caps like `visiblePairs`' 8-row take, `showMarketSummary` gates) stays phone-side; the tablet reads the un-clipped data through a surface-appropriate accessor.
3. **Pull-to-refresh** — pass `onRefresh` (invalidate + await the page's snapshot provider) so every scrollable path — both columns and the single-column fallback — refreshes.
4. **Skeleton mirrors the dashboard** — the loading state renders through the same `VitTwoColumnTabletDashboard` (banner + column skeletons mirroring the loaded blocks), so resolving data never reflows the page shape. Generic one-column `VitSkeletonList` loading is the phone idiom.
5. **Sensitive data masked in the banner** — emails/phones go through `VitFormat` masking helpers even in summary strips.

## Master-detail shell pattern (route-based split view — Profile 2026-08-22, Markets 2026-08-24)

Two modules share this shell idiom for different jobs: Profile
(settings-style — many flat sibling sub-routes: KYC, security, VIP, devices,
API, activity, settings, sub-accounts…) and Markets (analysis terminal — a
live, searchable pair list beside the pair being inspected; decided
2026-08-24, Binance-iPad job). The dashboard shape gives way to a split
view: a persistent framed master column beside a detail pane that renders
the active sub-route in place. Reference implementations:
`ProfileTabletMasterShell` + `profileRoutes()`'s tablet arm (settings),
`MarketsTabletMasterShell` + `marketsRoutes()`'s tablet arm (terminal — note
it folds the separate `marketPairRoutes()` group into the shell's single
branch, and root_routes mounts that group only for phone/web).

1. **Route via `StatefulShellRoute.indexedStack`, one branch.** The tablet
   arm returns `[StatefulShellRoute.indexedStack(branches:
   [StatefulShellBranch(routes: <the feature's existing flat GoRoutes>])]`;
   phone/web keep the flat list untouched. Keep every `GoRoute`'s
   `path`/`name` byte-identical — the static route audits
   (`route_coverage_audit`, `navigation_edge_audit`) parse those blocks from
   source and stay green through the wrap.
2. **Back-stack semantics, not `go`.** With flat sibling routes, plain
   `context.go` builds a one-page stack, so the system back button would
   exit the tab. Menu rows/CTAs that open a pane use the
   push-first-then-replace helper (`profile_pane_navigation.dart`):
   overview → pane is a `push`, pane → other pane is a `pushReplacement` —
   back always lands on the overview.
3. **Shell owns header and framing; panes own their scroll.** The shell
   renders the fixed `VitTopChrome` (R9) and the R4–R8 width idioms
   (`TabletDashboardWidths` 900/800/400/20/24: outer cap + centered pair,
   master framed `VitCard(inner)` at 400, detail `Expanded`), reusing the
   standard's proven numbers rather than `VitTwoColumnTabletDashboard`
   itself (whose static children lists don't fit a routing outlet). Each
   pane is a content-only widget on `ProfilePaneScaffold` (optional header,
   back shown only below `masterDetailSplitMinWidth` (680) — every tier
   that keeps the menu beside the pane needs no duplicate way back — own
   `SingleChildScrollView` + optional `onRefresh`).
4. **Content ports per R2.** A pane = a public tablet port of the phone
   page's part-family content (see `ProfileKycPane`, `ProfileSecurityPane`,
   `ProfileVipPane`), watching the same screen provider; not-yet-ported
   sub-routes keep building their old placeholder page inside the pane —
   migration is incremental and the architecture never re-opens.
5. **Portrait keeps the split; the stacked fallback is resize-only
   (2026-08-27; master slimmed same day).** Between
   `masterDetailSplitMinWidth` (680) and `twoColumnMinWidth` (900) —
   real-tablet portrait — the shell KEEPS the split: iPad-Settings
   portrait semantics, so rotation relayouts sizes without ever changing
   the composition or swapping to full-page pushes (which the 2026-08-27
   emulator acceptance had flagged as unprofessional). The master column
   is ONE width for both split tiers — `masterDetailMasterWidth` = 308
   (was 400 wide / 320 portrait): the menu reads the same whichever way
   the tablet is held, and on the wide tier the 1224 pair cap hands every
   dp taken off the menu straight to the detail pane (800 → 892) instead
   of adding dead margins. 300 fits the longest menu label un-ellipsized
   at the current row tokens — verified by the label-zone measurement
   test in `profile_tablet_page_test.dart`; don't lower the token without
   re-running that test. Pane content already renders at phone width by
   design (R2), so the detail pane (~372dp portrait on an 800dp-logical
   tablet) is within proven bounds. Below 680 (window-resize territory,
   not real tablets) the old stacked fallback applies: hub route stacks
   menu above the overview pane (independent scrolls, `Expanded` shares);
   a sub-route pane takes the full width with its own back header.
6. **Selection is route-derived, never a parallel local state.** The menu's
   selected row comes from the routing outlet itself
   (`ProfileMasterMenu.selectedRoute`, matched against the sub-route
   currently rendered in the detail pane) — never a local index/enum/tab
   controller duplicated beside the router. Selection *is* the location,
   which is what makes rule 2's back-stack semantics and the orientation
   policy's rotation survival true for free (there is no second state to
   sync or lose). A non-routed split view (none exists today) must still own
   selection in exactly one place above the split, reset it when the
   selected id leaves the source list, and render a real empty state
   (`VitEmptyState`) when nothing is selected — never a blank detail pane,
   and never a selection derived from scroll position.

## Orientation policy (both orientations, zero orientation dispatch — locked 2026-08-24)

The tablet surface supports **both orientations** — nothing in the app locks
or favors one. The whole layout contract is **width-driven**: the
`TabletDashboardWidths` tiers (single-column <900, two-column ≥900,
centered 800/400 ≥1200 — plus the master-detail shells' own portrait split
tier 680–899 with the same 308 master both tiers, rule 5 of the shell
pattern above) already answer every question orientation could.

1. **Presentation never queries orientation (R1c, absolute).** No
   `OrientationBuilder`, no `MediaQuery.orientationOf` in any tablet
   presentation file — locked at zero since 2026-08-24 by
   `tool/tablet_route_surface_audit.dart` (rule R1c, the same scanner as
   R1a/R1b). If a layout "needs to know orientation", it actually needs a
   width tier — add or override a `TabletDashboardWidths` value instead.
   Dispatching on both width and orientation creates four quadrant states
   (narrow/wide × portrait/landscape) of which only two are ever tested;
   width-only keeps every state reachable by a fixed viewport size.
2. **Rotation is a relayout, not a rebuild.** Rotating must not lose state:
   route-derived state (master-detail selection, shell pattern rule 6)
   survives because the router owns it; column scroll positions are widget
   state and survive the relayout. Locked behaviorally by
   `test/quality/tablet_rotation_guardrail_test.dart`: every
   tablet-composed root rotates portrait↔landscape and back with zero
   layout errors, exactly one navigation rail, and its own semantic content
   intact at every stop.
3. **Landscape-specific hazards are width-tier hazards.** A 1112×834
   landscape tablet is only ~834dp tall — the composition playbook's banner
   rule already encodes the surviving constraint (fixed banners stay thin,
   tall heroes scroll with the primary column). A portrait tablet
   (~800–834dp wide) rides the same single-column fallback a 768px tablet
   already exercises — no new tier, no portrait-only code path.
4. **QA sizes** (fixed-viewport matrix in
   `responsive_visual_qa_matrix_test.dart` + the rotation pairs above):
   portrait 768×1024 / 800×1280 / 834×1112; landscape 1024×768 / 1280×800 /
   1112×834.

## Step checklist (new tablet page)

1. Confirm the screen qualifies — see "When to build a dedicated tablet page."
2. Add `<Feature>TabletPage` + wire it directly in the existing `AppSurface.tablet` route branch (R1).
3. Build `<Feature>TabletPage`, reusing phone widgets (R2); write new public panel widgets only for sections that are private to the phone page's part family.
4. Pick the two-column threshold empirically (R3, R8) — re-verify `VitTwoColumnTabletDashboard`'s `TabletDashboardWidths` defaults hold for this page's content; pass constructor overrides if they don't rather than editing the shared constants.
5. Build `primaryChildren`/`secondaryChildren` lists from the page's own content, then `return VitTwoColumnTabletDashboard(primaryChildren: ..., secondaryChildren: ...)` — R4-R8 satisfied automatically. Header promoted to a fixed `Column` sibling above it (R9, still page-specific — the shared widget has no opinion on headers).
6. Register any route/page override needed by the structural audits; do not add a feature-specific responsive dispatcher (R1).
7. Add a widget test that pumps at the page's own two-column width and asserts `tester.takeException()` is `null` (the overflow guard) plus both columns' key content is present — the phone-width tests in the same file do **not** exercise this path. The shared widget's own generic mechanics (fallback threshold, `Row` shape, `VitCard` framing) already have dedicated coverage in `test/shared/layout/vit_two_column_tablet_dashboard_test.dart` — the page-level test only needs to prove *this page's* content lands in the right column, not re-verify the scaffold itself.
8. Run the check suite (§5 of `Flutter-Design-System-Reference.md`) — the tablet-specific audits below are part of it; a new tablet file is scanned by the same page-rhythm/card-tile/content-width audits as any phone file **plus** the six tablet locks (spacing, card border, input, motion, route-surface incl. R1c orientation, rotation relayout).

## Anti-patterns

| Anti-pattern | Result |
| --- | --- |
| `ConstrainedBox(maxWidth: …)` wrapped directly around the `Row`/`Expanded` with no `Center` (or other constraint-loosening ancestor) first | No-op — the tight incoming constraint from the parent `Expanded`/shell wins; width never actually caps |
| Per-column width caps (each column separately capped to its own max) instead of one cap on the combined two-column block | Leftover width piles up entirely on one edge instead of distributing symmetrically — reads as a layout bug even though each column's own cap is individually correct |
| One `SingleChildScrollView` wrapping the whole two-column `Row` | Unbounded-height layout errors once any column's content needs a bounded height |
| Editing the phone reference page "to share more code" with the tablet variant | Violates R2 — breaks that page's own locked reference-consistency audit/golden |
| A second global breakpoint constant for one screen's own fallback width | Should be a local, documented, page-scoped constant instead (R3) |
| Skipping the ≥threshold widget test because the phone-width tests already pass | Leaves the actual two-column layout completely unverified |
| Keeping the phone page's `VitAutoHidePageScaffold`/scroll-leading header as-is in the tablet page | Header has no single scroll offset to hide/show against once R4 splits the body — either breaks or silently no-ops |

## Limitations

- R1's runtime-dispatch half has a static audit (`tablet_route_surface_audit.dart`, 2026-08-23; R1c orientation-dispatch added 2026-08-24, still zero usages); the orientation policy's behavioral half (rotation relayout keeps state and composition) is locked by `tablet_rotation_guardrail_test.dart`, not a scanner. R1's route-wiring half plus R2/R3/R9 stay prose plus a required widget-test pattern, not a `tool/*_audit.dart` script. Master-detail selection (shell pattern rule 6) stays prose — it is route-derived by construction in the one reference shell, and a static scanner can't classify "is a split view" reliably (same verdict as Flutter-Page-Archetype-Standard's curated-list approach). R4-R8 no longer need one: they're enforced by construction now that every tablet page delegates its two-column body to `VitTwoColumnTabletDashboard` rather than hand-rolling it, so they can't independently drift per page.
- Five reference implementations (`HomeTabletPage`, `WalletTabletPage`, `MarketsTabletPage`, `TradeTabletPage`, `ProfileTabletPage`) as of writing — all five app root tabs. R8's 900 threshold and 440 secondary cap held unchanged for all five, across genuinely varied content shapes (a financial order-entry form, a nested inner screen-state switch, a search-filterable list); the 640 primary cap held structurally (no overflow) but was later found too conservative on a wide physical tablet — raised to 760 (R5/R8) after on-device verification, not just a desk-check. Re-validate before assuming any of these numbers hold for a screen with meaningfully different content density than these five, and pass constructor overrides on `VitTwoColumnTabletDashboard` rather than editing the shared defaults if they don't.

## Upgrade path

Markets left the dashboard-reference set on 2026-08-24 for the Analysis-terminal master-detail shell — `VitTwoColumnTabletDashboard` retains four reference consumers (Home, Wallet, Trade, Profile).
1. ~~When a second dedicated tablet screen ships, extract its width constants into a shared file if they match the first screen's.~~ Done — `lib/app/theme/tablet_dashboard_widths.dart`, after `WalletTabletPage` confirmed `HomeTabletPage`'s numbers unchanged. ~~When a third screen ships, evaluate whether a dedicated audit tool is worth building.~~ Resolved differently once a third, fourth, and fifth screen (Trade, Profile) all confirmed the identical scaffold: extracted it into `VitTwoColumnTabletDashboard` (`lib/shared/layout/`) instead of building a separate audit tool to check five hand-rolled copies stayed in sync — a shared widget makes the copies impossible rather than merely checked. All 5 existing pages migrated onto it in the same rollout.
2. If a screen needs a width tier beyond `AppBreakpoints.tablet`, promote it to a real global breakpoint only once ≥2 screens independently need the same cutoff.
3. A 6th tablet page (or beyond) is now a pure consumer of `VitTwoColumnTabletDashboard` — no new scaffold code, no new audit-registry entries beyond R1's existing two (`page_rhythm_layout_registry.dart`, `top_header_visual_archetype_audit.dart`). If a future page's content genuinely can't fit the two-column shape (e.g. needs three columns, or an asymmetric split that isn't primary/secondary), that's a signal for a second shared widget alongside this one, not for hand-rolling around it.

## Verify

```bash
cd flutter_app
flutter analyze <touched tablet page file>
flutter test <touched tablet page test file> --reporter=compact
# The six tablet locks (all absolute-zero as of 2026-08-24):
dart run tool/tablet_spacing_audit.dart --check
dart run tool/tablet_card_border_audit.dart --check
dart run tool/tablet_input_audit.dart --check
dart run tool/motion_audit.dart --check
dart run tool/tablet_route_surface_audit.dart --check # incl. R1c orientation
flutter test test/quality/tablet_rotation_guardrail_test.dart --reporter=compact
# Whole-repo structural audits (scan every presentation file):
dart run tool/page_rhythm_audit.dart --check --strict-full
dart run tool/card_tile_audit.dart --check --strict-full
dart run tool/page_content_width_audit.dart --check
```
