# Enterprise PR Review Checklist

Use this checklist for every VitTrade Flutter pull request. It converts the
enterprise architecture rules into review gates that can be verified from the
diff, tests, and CI output.

This checklist itemizes the most common gates. For anything not explicitly
listed below (or to see which domains are audit-only and not yet CI-enforced),
check the full domain map in
[Flutter-Design-System-Reference.md](./Flutter-Design-System-Reference.md).

## Required PR Evidence

- [ ] Scope summary explains the user-facing or engineering outcome.
- [ ] Changed files are grouped by feature, router, shared UI, test, or docs.
- [ ] Verification commands and results are listed in the PR description.
- [ ] Screenshots or emulator evidence are attached for visible UI changes.
- [ ] Any exception to line-count or layer rules is documented with a reason.

## Architecture Review

- [ ] Feature code stays inside `flutter_app/lib/features/<feature>/`.
- [ ] New feature modules include `domain`, `data`, and `presentation`.
- [ ] Domain contracts are introduced before presentation code depends on data.
- [ ] `presentation/pages` and `presentation/widgets` avoid direct
      `features/*/data` imports.
- [ ] Controllers own flow state, validation, submit intent, and high-risk
      orchestration.
- [ ] Pages focus on provider reads, route arguments, shell layout, navigation,
      and top-level composition.
- [ ] Shared layout and design-system primitives are reused before local
      variants are created.
- [ ] No new direct runtime `Colors.*` usage is introduced outside established
      theme or token boundaries.
- [ ] No new hardcoded numeric typography/spacing/radius/container patterns are
      added in feature or shared code without documented exception.
- [ ] Changed files do not increase design-token debt; `dart run
      tool/design_token_consistency_audit.dart --check` passes.
- [ ] UI changes follow the Home reference standard ("SC-007 HomePage", see
      [Flutter-Module-Identity-Standard.md](./standards/Flutter-Module-Identity-Standard.md));
      `dart run tool/home_reference_consistency_audit.dart --check` passes and
      `flutter test test/quality/home_reference_consistency_guardrail_test.dart`
      passes. This gate is hard-enforced for every module, not just P0.
- [ ] Home page visuals are pinned by golden tests; run `flutter test
      test/features/home/golden/` and, for deliberate UI changes, regenerate
      with `flutter test --update-goldens test/features/home/golden/` and
      review the diffed PNGs before committing.
- [ ] Changed presentation pages follow page rhythm standard; `dart run
      tool/page_rhythm_audit.dart --check` passes and
      `flutter test test/quality/page_rhythm_audit_sync_guardrail_test.dart` passes.
- [ ] Phone-first layout @ 360×800 has no overflow/constraint violations;
      `flutter test test/quality/page_rhythm_phone_visual_qa_test.dart` passes.
- [ ] Scroll/detail pages use Recipe A or B from
      [Page-Content-Width-Standard.md](./standards/Page-Content-Width-Standard.md) — no
      double horizontal `contentPad`; `dart run
      tool/page_content_width_audit.dart --check` passes and
      `flutter test test/quality/page_content_width_guardrail_test.dart` passes.
- [ ] Scroll-to-hide headers use `VitAutoHideHeaderScaffold` only (no page-local
      `_headerVisible` / `heightFactor` collapse); collapse-budget gate stays
      intact — `flutter test test/quality/scroll_auto_hide_guardrail_test.dart`
      passes (see [Scroll-Auto-Hide-Standard.md](./standards/Scroll-Auto-Hide-Standard.md)).
- [ ] Tab-root pages use `VitPageRhythm.compact` with major sections as direct
      `VitPageContent` children (see
      [Page-Rhythm-Standard.md](./standards/Page-Rhythm-Standard.md)).
- [ ] Tier A strip tiles follow card tile standard; `dart run
      tool/card_tile_audit.dart --check --strict-full` passes,
      `dart run tool/card_tile_manifest.dart --check` passes, and
      `flutter test test/quality/card_tile_guardrail_test.dart` passes (see
      [Card-Tile-Standard.md](./standards/Card-Tile-Standard.md)).
- [ ] Tier B service tiles with corner badges follow safe inset standard;
      `flutter test test/quality/service_tile_badge_guardrail_test.dart` passes
      (see [Service-Tile-Badge-Standard.md](./standards/Service-Tile-Badge-Standard.md)).
- [ ] Tier E task cards use `VitTaskCard` intrinsic height;
      `flutter test test/quality/task_card_guardrail_test.dart` passes (see
      [Task-Card-Standard.md](./standards/Task-Card-Standard.md)).
- [ ] Module accent icon boxes use `VitAccentIconBox` — no local `_AccentIcon`;
      `flutter test test/quality/accent_icon_box_guardrail_test.dart` passes (see
      [Accent-Icon-Box-Standard.md](./standards/Accent-Icon-Box-Standard.md)).
- [ ] Segment/tab/filter pills follow segment-pill standard; `dart run
      tool/segment_pill_audit.dart --check --strict-full` passes,
      `dart run tool/segment_pill_manifest.dart --check` passes, and
      `flutter test test/quality/segment_pill_guardrail_test.dart` passes (see
      [Segment-Pill-Standard.md](./standards/Segment-Pill-Standard.md)).
- [ ] P0 financial modules stay at or below the current design-token baseline
      enforced by `tool/design_token_consistency_audit.dart --check`.
- [ ] The CI design-token report artifact is reviewed when UI, theme, shared
      layout, or feature presentation files change.

## Router Review

- [ ] Public router facade remains `flutter_app/lib/app/router/app_router.dart`.
- [ ] New paths and names are covered by route contract tests.
- [ ] New pages are reachable through the correct route group.
- [ ] Back behavior is covered for high-risk or nested routes.
- [ ] `dart run tool/route_coverage_audit.dart --check` passes.
- [ ] `dart run tool/navigation_edge_audit.dart --check` passes when
      navigation calls, route builders, or screen links change.
- [ ] UI navigation uses `AppRoutePaths`, `AppRouteNames`, or
      `NavigationIntent`; new direct raw route strings are not introduced.
- [ ] Route-bearing mock/domain data resolves to declared router paths.

## Product Safety Review

- [ ] Withdraw, escrow, security, address, and P2P payment-method flows preview
      risk and require confirmation.
- [ ] Fees, limits, risk, and next steps are visible before confirmation.
- [ ] Sensitive data is masked in UI and tests.
- [ ] Arena remains points-only.
- [ ] Prediction Markets remains separate from Arena.
- [ ] Trade, margin, futures, and copy-trading copy avoids hype, casino, FOMO,
      and hidden-risk language.

## Test Review

- [ ] Focused tests cover the changed feature or controller behavior.
- [ ] Router tests run when routes change.
- [ ] Product copy guardrails run when Trade, Wallet, P2P, Prediction, Arena,
      or rewards copy changes.
- [ ] Accessibility or semantics tests run for high-risk controls.
- [ ] Full `flutter test --reporter=compact` passes before merge.
- [ ] Test files remain below `400` lines or are split by behavior group.

## Required Commands

Note: `architecture_baseline_guardrails_test.dart` was split into the three
`architecture_*_debt_guardrails_test.dart` files below (2026-07); the product
copy guardrail set is 5 files, not 1 — `product_copy_guardrails_test.dart`
plus the per-module `money_copy_guardrail_test.dart`,
`p2p_wallet_product_copy_guardrails_test.dart`,
`prediction_product_copy_guardrails_test.dart`, and
`trade_product_copy_guardrails_test.dart`. Both corrected below
(2026-07-27 QA audit); code/tests remain the source of truth per
`docs/01_AI_RULES/DOCUMENT_PRECEDENCE.md`.

Run from `flutter_app/` before merge:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed .
dart run tool/route_coverage_audit.dart --check
dart run tool/navigation_edge_audit.dart --check
flutter analyze
flutter test test/app/router --reporter=compact
flutter test test/quality/navigation_route_guardrails_test.dart --reporter=compact
flutter test test/quality/architecture_import_debt_guardrails_test.dart test/quality/architecture_layer_boundary_guardrails_test.dart test/quality/architecture_size_style_debt_guardrails_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart test/quality/money_copy_guardrail_test.dart test/quality/p2p_wallet_product_copy_guardrails_test.dart test/quality/prediction_product_copy_guardrails_test.dart test/quality/trade_product_copy_guardrails_test.dart --reporter=compact
flutter test --reporter=compact
``` 

Design-token checks (required for every PR with UI changes):

```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart --check
flutter test test/quality/design_token_consistency_guardrail_test.dart --reporter=compact
```

Home-reference checks (required for every PR with UI changes):

```bash
cd flutter_app
dart run tool/home_reference_consistency_audit.dart --check
flutter test test/quality/home_reference_consistency_guardrail_test.dart --reporter=compact
flutter test test/features/home/golden/ --reporter=compact
```

To update the Home reference baseline after a deliberate, reviewed UI change:

```bash
cd flutter_app
dart run tool/home_reference_consistency_audit.dart   # regenerate the audit artifact
flutter test --update-goldens test/features/home/golden/  # regenerate goldens; review the PNG diff
```

Page-rhythm checks (required for every PR with layout / presentation changes):

```bash
cd flutter_app
dart run tool/page_rhythm_audit.dart --check --strict-full
dart run tool/page_rhythm_screen_rollup.dart --check --strict-layout
dart run tool/page_rhythm_coverage_matrix.dart --check
flutter test test/quality/page_rhythm_audit_sync_guardrail_test.dart --reporter=compact
flutter test test/quality/page_rhythm_phone_visual_qa_test.dart --reporter=compact
```

Card-tile checks (required for PRs touching strip tiles / Home cards):

```bash
cd flutter_app
dart run tool/card_tile_audit.dart --check --strict-full
dart run tool/card_tile_manifest.dart --check
flutter test test/quality/card_tile_guardrail_test.dart --reporter=compact
```

Service-tile badge checks (required for PRs touching `VitServiceTile` / product grids):

```bash
cd flutter_app
flutter test test/quality/service_tile_badge_guardrail_test.dart --reporter=compact
flutter test test/shared/widgets/vit_shared_widgets_test.dart --name "VitServiceTile corner badges"
```

Task-card checks (required for PRs touching Rewards / Arena mission lists):

```bash
cd flutter_app
flutter test test/quality/task_card_guardrail_test.dart --reporter=compact
flutter test test/quality/accent_icon_box_guardrail_test.dart --reporter=compact
flutter test test/shared/widgets/vit_shared_widgets_test.dart --name "VitTaskCard"
```

Segment-pill checks (required for PRs touching tabs / filters / pill rows):

```bash
cd flutter_app
dart run tool/segment_pill_audit.dart --check --strict-full
dart run tool/segment_pill_manifest.dart --check
flutter test test/quality/segment_pill_guardrail_test.dart --reporter=compact
```

CI uploads the design-token audit `.csv` (and regenerated markdown when the
tool emits it) as the `design-token-consistency-audit` artifact, and the
home-reference audit `.csv`/`.md` as the `home-reference-consistency-audit`
artifact, so reviewers can compare debt/divergence trends.

## Merge Criteria

- [ ] CI is green.
- [ ] No unresolved blocker comments remain.
- [ ] All required docs, manifest rows, route contracts, and tests are updated.
- [ ] Worktree output artifacts are not committed.
- [ ] The PR leaves the codebase at least as clean as it found it.
