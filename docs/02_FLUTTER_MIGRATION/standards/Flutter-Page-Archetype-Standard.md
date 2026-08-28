# Flutter Page Archetype Standard

**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
This document defines two secondary structural patterns beyond the Home-native
foundation ([Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)):
**tabbed detail pages** and **form/wizard pages**. Unlike Home — which is the
single, load-bearing reference every module is diffed against — these
archetypes cover a narrow, currently small set of pages. Treat them as
guidance and a review checklist, not a hard structural gate.

## Why not a full automated audit (yet)

Before writing this doc, automatic page classification was attempted and
rejected — none of the following heuristics reliably separate "is this
archetype" from "merely touches a related widget":

- Counting `VitTabBar(` usage — 122 files across the app call it, most for a
  minor embedded tab strip, not because the whole page is tab-organized. The
  canonical tabbed-detail reference itself doesn't call `VitTabBar(` directly
  (it's one indirection removed, inside a dedicated tabs widget).
- `VitPageRhythm.form` at the page level — 33 pages use it, including OTP,
  2FA setup, and KYC pages that aren't wizards.
- A `_canSave()`/`_canProceed()`-style gate method name — not a consistent
  naming convention across the codebase.

Any of these would need per-page human verification anyway, which collapses
back into a curated list — so a curated list is what this doc is, backed by a
lightweight tripwire test (see **Enforcement**) instead of a new `tool/*_audit.dart`
+ CI step. See **Upgrade path** below for when that changes.

## Archetype A — Tabbed detail page

A single (non-root) page presenting 2+ genuinely distinct content panels,
switched by a tab strip — not a bottom-nav root, and not a single list merely
filtered by a pill row.

**Canonical reference**: `wallet_token_approval_page.dart` (SC-150) and its
widget bundle — 9 files, 0 design-token divergence, zero exceptions anywhere
in the bundle:

- `lib/features/wallet/presentation/pages/wallet_token_approval_page.dart`
- `lib/features/wallet/presentation/widgets/wallet_token_approval_tabs.dart`
- `lib/features/wallet/presentation/widgets/wallet_token_approval_badges.dart`
- `lib/features/wallet/presentation/widgets/wallet_token_approval_cards.dart`
- `lib/features/wallet/presentation/widgets/wallet_token_approval_common.dart`
- `lib/features/wallet/presentation/widgets/wallet_token_active_approvals_tab.dart`
- `lib/features/wallet/presentation/widgets/wallet_token_approval_history_tab.dart`
- `lib/features/wallet/presentation/widgets/wallet_token_approval_settings_tab.dart`
- `lib/features/wallet/presentation/widgets/wallet_token_revoke_sheet.dart`

**Rules**:

- Tab selection is a plain `String`/enum field driving `setState` — never a
  raw `TabController`/`DefaultTabController` (neither appears anywhere in
  `lib/features/`; tabs are always rendered through the shared `VitTabBar`).
- Each tab's content lives in its own dedicated widget file (one file per
  tab), not inlined as a giant `switch` in the page body.
- Page shell: `VitAutoHideHeaderScaffold` + `VitPageContent`. Use
  `VitPageRhythm.form` when tab panels are data-entry heavy (as in the
  canonical reference); `VitPageRhythm.standard` is acceptable for lighter,
  list-style tab panels.

**Secondary example**: `wallet_multi_manager_page.dart` — same shape, `VitTabBar(variant: .segment)`,
`VitPageRhythm.standard`. Its bundle needs one `CustomPainter` exception
(a chart widget), which is why it's a secondary rather than the primary
reference.

## Archetype B — Form/wizard page

A page whose job is collecting structured input and committing it — a single
screen or a multi-step flow — ending in an explicit save/submit gate, usually
with a confirm-preview step before the final commit.

**Canonical reference**: `address_add_page.dart` (SC-143) and its widget
bundle — 7 files, 0 design-token divergence, zero exceptions, page-level
`VitPageRhythm.form` (exact match to its QA-checklist tier tag):

- `lib/features/wallet/presentation/pages/address_add_page.dart`
- `lib/features/wallet/presentation/widgets/wallet_address_add_form.dart`
- `lib/features/wallet/presentation/widgets/wallet_address_add_sections.dart`
- `lib/features/wallet/presentation/widgets/wallet_address_add_common.dart`
- `lib/features/wallet/presentation/widgets/wallet_address_add_selectors.dart`
- `lib/features/wallet/presentation/widgets/wallet_address_add_agreement.dart`
- `lib/features/wallet/presentation/widgets/wallet_address_add_preview.dart`

**Rules**:

- Compose the form body via a `sections()` factory (see
  `AddressAddForm.sections(...)`) rather than one monolithic build method —
  keeps each field group independently testable and reusable.
- Gate the primary action behind an explicit, named validity check (e.g.
  `_canSave()`) — never enable submit unconditionally.
- Show a confirm-preview step (bottom sheet or dedicated screen) before the
  final commit for anything that mutates account/security state.
- Give the post-submit success state its own distinct widget — don't reuse
  the form widget with fields disabled.
- Page-level rhythm: `VitPageRhythm.form`.

**Secondary example**: `provider_application_page.dart` — the more
architecturally complete multi-step wizard (real step machine, progress bar,
per-step validation gating). Two caveats before templating from it: its own
page-level rhythm is `VitPageRhythm.standard`, not `form` (only the inner step
widgets use form-tier tokens), and its intro hero block is on the explicit
`pageRhythmRelaxedSectionGap` allowlist in
[Page-Rhythm-Visual-QA-Checklist.md](../checklists/Page-Rhythm-Visual-QA-Checklist.md) — copy
the step-progress pattern, not the rhythm-tier choice.

## Enforcement

`test/quality/home_reference_consistency_guardrail_test.dart` — the sub-test
`'archetype reference pages (tabbed detail, form wizard) stay divergence-free
and keep their defining structure'` re-uses the exact same 4 regex checks as
the Home-reference divergence scan (raw `Container(`/`BoxDecoration(`/
`BorderRadius.circular(`/`Radius.circular(`), scoped only to the two bundles
above, plus a structural-marker check (`WalletTokenApprovalTabs(` still
present in the tabbed-detail reference, `AddressAddForm.sections(` still
present in the form-wizard reference). No new `tool/*_audit.dart` file, no new
CI step — folded into the already-CI-wired `home_reference_consistency_guardrail_test.dart`.

Run locally:

```bash
cd flutter_app
flutter test test/quality/home_reference_consistency_guardrail_test.dart --reporter=compact
```

## Upgrade path

This stays a lightweight tripwire, not a full audit tool, until one of these
happens:

- The curated archetype membership grows past ~4–5 pages per archetype.
- Code review starts repeatedly catching new pages reinventing these patterns
  badly.

At that point, graduate to a proper `tool/page_archetype_consistency_audit.dart`
+ dedicated guardrail test, reusing `home_reference_consistency_audit.dart`'s
file-collection/regex-scoring/CSV-rendering plumbing with a curated
`ArchetypeSpec` membership list (not automatic classification — see **Why not
a full automated audit** above) and its own ratcheted per-archetype baseline.

## Review checklist

- Tabbed detail: tab state is a plain field + `VitTabBar`, not `TabController`; each tab is its own widget file.
- Form/wizard: fields composed via a `sections()`-style factory; explicit save gate; confirm step before commit; distinct success state.
- Page shell matches Home foundation rules ([Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md)) — no raw `Container`/`BoxDecoration`/`EdgeInsets.*(` literals.
- `flutter test test/quality/home_reference_consistency_guardrail_test.dart` passes before opening a PR that touches either canonical reference page.
