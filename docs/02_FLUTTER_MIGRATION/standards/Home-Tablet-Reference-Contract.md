# Home Tablet Reference Contract

**Screen:** Home / SC-007  
**Reference implementation:** `HomeTabletPage` + `VitTwoColumnTabletDashboard`  
**Authority:** `AGENTS.md`, `DESIGN.md`, and `Tablet-Adaptive-Standard.md`
**Scope:** every Dart file on the tablet surface — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  

This contract extracts reusable tablet rules from Home. It does not make Home
copy, product content, or business data a template for other screens.

## 1. App chrome and navigation rail

- Keep the shared dark `VitAppShell` chrome.
- Use the persistent `VitNavigationRail` at the tablet shell breakpoint.
- Keep the Home header as a fixed sibling above the body scroll region; it is
  not part of either independently scrolling dashboard column.
- Do not add a Home-specific route or a second navigation model.

## 2. Content width and gutter

- The page body owns horizontal insets through `VitPageContent`.
- At the two-column tier, center the complete dashboard block with the shared
  `VitTwoColumnTabletDashboard` width cap.
- The dashboard frame uses `outerHorizontalMargin = 12px` and
  `columnGutter = 12px`; normal page content keeps `contentPad = 20px`.
- Default caps are `800px` primary plus `400px` secondary. Do not add local
  width caps or a new breakpoint tier without empirical evidence.

## 3. Grid, columns, and scroll ownership

- Below the two-column threshold (`900px` content width), render one compact
  scrollable column with primary content followed by secondary content.
- At or above the threshold, use two independently height-bounded
  `SingleChildScrollView` columns.
- The primary column is the information-dense workspace: portfolio, market
  ticker, and watchlist.
- The secondary column is a framed sidebar: notices, next action, quick
  actions, recent products, and discovery.
- Never wrap the whole two-column `Row` in one outer scroll view.

## 4. Page rhythm

- The fallback uses `VitContentPadding.compact` and
  `VitPageRhythm.compact`.
- The primary column uses the standard 12px block rhythm. The shared
  secondary wrapper may use the relaxed density only for its intentional
  24px card padding; it must not create a 24px inter-block gap.
- Parent layout owns section rhythm; child sections own only their internal
  gaps from the Tablet role scale (4/8/12).

## 5. Card and section archetypes

- Reuse `VitCard`, `VitMarketTickerStrip`, `VitMarketPairRow`,
  `VitDiscoveryActionCard`, `VitNextActionCard`, and `VitEmptyState` before
  introducing a local surface.
- Tablet-specific panels are allowed only when the phone section is private to
  the phone page's `part` family. Home's watchlist and discovery panels are
  examples of that exception.
- Segment controls use `VitTabBar`; do not wrap them in another bordered card.
- The sidebar seam is provided by the shared `VitCardVariant.inner` frame.

## 6. Header and tab behavior

- Use the canonical Home `HomeHeader` / `VitTopChrome` archetype.
- Keep global search, notifications, and news actions accessible at the
  header level.
- Market tabs stay local to the Home Tablet state and use the same provider
  data and route contracts as phone Home.

## 7. Loading, empty, error, offline, and refresh states

| State | Home Tablet behavior |
| --- | --- |
| Loading | `HomeLoadingContent` in a bounded scroll region; preserve the main block order. |
| Empty | Shared `VitEmptyState` inside the affected market/recent section; keep the rest of the dashboard usable. |
| Error | Shared `HomeErrorContent` / `VitErrorState` with an explicit retry action. |
| Offline | Fail closed to the retryable error surface until the repository exposes a typed connectivity error; never fabricate balances or market data. |
| Refresh | Pull-to-refresh on any dashboard column (the single-column fallback included), wired through `VitTwoColumnTabletDashboard.onRefresh`. Re-invalidate `homeSnapshotProvider`, await its future, and preserve the current tab/balance-visibility UI state. |

## 8. Typography hierarchy

- Page/header chrome follows the canonical `VitTopChrome` styles.
- Hero portfolio values use existing numeric/hero styles.
- Section headings use `VitSectionHeader`; market rows use shared tabular
  figures and existing text tokens.
- No page-local font sizes or one-off text styles.

## 9. Color usage

- Dark canvas and surfaces come from `AppColors` and shared Vit* widgets.
- Amber is the brand/action accent.
- Green/red communicate market or trade semantics only.
- Prediction Markets and Open Arena keep their existing accent/copy
  separation; Arena remains points-only.
- No neon, glass, gradient, or decorative glow is added by the tablet page.

## 10. Accessibility and touch targets

- Shared controls provide the semantic role and visible labels where possible.
- Icon-only actions must retain a tooltip and semantic label.
- Interactive controls keep the shared minimum tap target; do not encode state
  using color alone.
- Wide-tablet tests assert no render exception at the two-column tier; golden
  frames provide visual review evidence.

## 11. Responsive rules

| Available content width | Rule |
| --- | --- |
| `< 600px` | Phone reference remains in the shell. At a 600px physical viewport, the 96px rail leaves 504px of content, so this is expected. |
| `600–899px` | Home Tablet page uses a single compact scroll column once the dispatcher receives at least 600px of content. |
| `>= 900px` | Home Tablet page uses the shared two-column dashboard with independent scroll ownership. |
| `>= 1200px` | Keep the centered 800/400 block; do not stretch cards to fill the shell. |

## 12. Reusable patterns

Allowed to reuse on future tablet dashboards:

- `VitTwoColumnTabletDashboard` for the two-column mechanics.
- Fixed header sibling + bounded dashboard body.
- Primary workspace / framed secondary sidebar composition.
- Shared state primitives and token-based page rhythm.
- Public tablet-specific panels for phone-private sections.

## 13. Home-only patterns

These are not general-purpose design-system contracts:

- Home's portfolio balance and asset breakdown content.
- Home's market tabs and current mover selection.
- Home's announcement ordering and next-action dismissal state.
- Home's Prediction Markets / Open Arena discovery copy and routes.
