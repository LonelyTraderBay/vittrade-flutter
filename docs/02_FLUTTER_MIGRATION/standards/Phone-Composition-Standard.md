# Phone Composition Standard (Mandatory)

**Authority:** [DESIGN.md](../../../DESIGN.md) · [AGENTS.md](../../../AGENTS.md) UI rules · [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md) (Home = the phone anchor) · [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md) (tabbed-detail / wizard) · tablet counterpart: [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md) ("Module composition archetypes")
**Enforcement:** the **hard foundation is already machine-enforced** by the existing whole-repo audits (page rhythm, design-token consistency, card tile, segment pill, top header ×4, back navigation, bottom sheet, notice acknowledgement, scroll physics/auto-hide, high-risk panel, spacing duplication, content width, duplicate private widget, Home reference consistency). The **composition layer** is prose + the Home-reference diff — the same split as the tablet standard's R2/R3/R9. Input states and motion tokens ship through the shared widgets on every surface; their *static phone locks* are Motion-Standard phase 2 (see its "Enforcement & phases").
**Scope:** every screen on the **phone surface** — the 360px baseline composition (`lib/features/**/presentation/phone|pages/`, resolved once at bootstrap as `AppSurface.phone`).
**Born:** 2026-08-24 — the phone twin of the tablet archetype table, so the two surfaces share ONE two-layer model: an absolute foundation nobody may vary, plus composition grammars picked by the module's *job*.

## Why this standard exists

Phone is the baseline surface and the best-audited one — but "which composition grammar does a phone screen use, and why do modules legitimately differ?" existed only implicitly (Home as anchor, two secondary archetypes in `Flutter-Page-Archetype-Standard.md`). This doc writes the decision layer down: same foundation for everyone, **difference only by the module's job** — never cookie-cutter, never per-module drift.

## The phone composition grammar (shared by every archetype)

What "a phone screen" means structurally — the phone equivalent of the tablet's two-column/master-detail decision:

- **One scroll column** at the 360px baseline inside `VitAppShell` (bottom nav). No side-by-side columns, no master-detail on phone.
- **Root tabs** use `VitAutoHidePageScaffold`/`VitAutoHideHeaderScaffold` + `VitPageRhythm.compact`; scroll lists `.standard`; wizards/KYC/forms `.form`; hero/onboarding `.relaxed`; charts/terminals `.flush`.
- **Detail interaction is the bottom sheet** — `showVitBottomSheet` (never raw `showModalBottomSheet`); post-action ack via `showVitNoticeSheet`; sticky footers only for form CTAs.
- **Header/back** follow the Top-Header and Back-Navigation contracts — no module-private header grammar.
- **High-risk mutations** (withdraw/escrow/security/address/payment-method) go through `VitHighRiskStatePanel` + preview/confirm — on every surface.

## Module composition archetypes — same foundation, different by *job*

Pick the row that matches the screen's work **before writing code**. Every row obeys the same absolute foundation (tokens, S-tier spacing/rhythm rules, card/segment/header/sheet contracts listed above); modules differ only in the right-hand column.

| Archetype (module's job) | Composition grammar | Reference | What differs between modules |
| --- | --- | --- | --- |
| **Tab-root feed hub** — one mixed overview the user scans daily (Home) | `VitAutoHidePageScaffold` + `.compact` + mixed feed sections + embedded market tabs (`VitTabBar`) | `home_page.dart` + part family (the anchor every module is diffed against) | The feed's section mix and module accent |
| **Scannable list + filters** — find one item among many (Markets) | Single scroll: search/filter tier (`Segment-Pill-Standard`) above result rows; phone-only clipping gates (row caps, `showMarketSummary`) are legal *here* — they keep one shared scroll short | `market_list_page.dart` | Filter tiers, row columns, per-domain rows |
| **Trading terminal** — act on live state with risk in view (Trade) | Dense `.compact`/`.flush` body, order form + tabs, confirm flows via bottom sheets; `VitHighRiskStatePanel` for the risky mutations | `trade_page.dart` + part family | Order-entry shape, instrument data, per-flow risk copy |
| **Account / settings hub** — many entries, few at once (Profile) | Grouped menu list (`.compact`) → **push** to plain sub-pages; groups own their accent headers | `profile_page.dart` | Menu grouping by account-domain; sub-page content |
| **Money-movement flow** — move value safely (Wallet deposit/withdraw/transfer) | Wizard grammar (below) + preview/confirm sheet + `VitHighRiskStatePanel`; masking on account/address data | `address_add_page.dart` (canonical), wallet flows | Steps, fields, fee/risk copy of the flow |
| **Tabbed detail page** / **Form-wizard page** | Already standardized separately — follow those rules, not this table's rows | [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md) (A: tabbed detail, B: form/wizard) | — |

## What may never vary between modules

Tokens and their audits (spacing/rhythm, radius, border, color, type), the shared `Vit*` ladder, header and back-navigation contracts, bottom-sheet/notice idioms, scroll physics and auto-hide rules, high-risk panel + preview/confirm gating, masking rules, skeleton/empty/error/offline state discipline. These are the phone hard foundation — identical for every module, CI-enforced.

## Where legitimate difference comes from — and only from

1. the module's **archetype row above** (composition grammar),
2. the module's **accent identity** (`Flutter-Module-Identity-Standard.md`),
3. the module's **own data and workflow** (what the feed/list/form/panes contain).

If a proposed difference doesn't trace to one of those three, it is drift — cut it. Same rule as the tablet table: "mỗi module một kiểu" is impossible, and so is "mọi module giống hệt nhau".

## Phone ↔ tablet mapping (when porting a module)

The *job* is constant across surfaces; only the grammar changes:

| Job | Phone grammar | Tablet grammar |
| --- | --- | --- |
| Monitor/act (Home, Markets, Trade) | Tab-root feed / list+filters / terminal (this table) | Two-column dashboard (`VitTwoColumnTabletDashboard`) |
| Settings (Profile) | Hub list → push sub-pages | Master-detail (`ProfileTabletMasterShell`) |
| Money movement (Wallet) | Wizard + sheets + high-risk panel | `WalletTabletDetailSurface` + the same gating |
| Detail/receipt | Linear scroll page (no special grammar) | Nav-rail shell, no dedicated page |

Port content per the tablet standard's R2; never translate the grammar literally (a phone wizard is sheets + sticky CTA, not a shrunken two-column dashboard).

## Anti-patterns

| Anti-pattern | Result |
| --- | --- |
| Squeezing a two-column/master-detail layout onto phone | Violates the one-column grammar — that's what the tablet surface is for |
| A module inventing its own header/back/ack idioms | Breaks the Top-Header/Back-Navigation/Notice contracts — CI or review catches it |
| Using a full page where a sheet suffices (or a sheet for a multi-step flow) | respectively: nav noise; a wizard trapped in a sheet without sticky-CTA grammar |
| Copying another module's feed/terminal shape "because it looks good" | Only the job picks the archetype — a wallet flow styled as a market terminal reads wrong |
| Phone page dispatching on width for tablet behavior | Surface is resolved at bootstrap (R1's rule, both surfaces) |

## Recipe for a new phone screen

1. Identify the job → pick the archetype row above (or Page-Archetype A/B).
2. Pick the rhythm tier by the row's grammar; scaffold via `VitPageLayout` + `VitPageContent`.
3. Interactions: sheets for detail, notice-sheet for acks, `VitHighRiskStatePanel` + preview/confirm for risky commits.
4. Run §5 of [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) before the PR; if the screen also has a tablet composition, follow [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md) step checklist.

## Verify

```bash
cd flutter_app
flutter analyze <touched phone page file>
flutter test <touched phone page test file> --reporter=compact
dart run tool/home_reference_consistency_audit.dart --check
dart run tool/page_rhythm_audit.dart --check --strict-full
dart run tool/page_rhythm_screen_rollup.dart --check --strict-layout
flutter test test/quality/page_rhythm_phone_visual_qa_test.dart --reporter=compact
```

## Migration pointers

- Phone anchor + divergence rules: [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)
- Page-level archetypes (tab detail / wizard): [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md)
- The same model on tablet: [Tablet-Adaptive-Standard.md](./Tablet-Adaptive-Standard.md) → "Module composition archetypes"
- Interaction/motion tokens (shared widgets): [Tablet-Input-Standard.md](./Tablet-Input-Standard.md) · [Motion-Standard.md](./Motion-Standard.md)
