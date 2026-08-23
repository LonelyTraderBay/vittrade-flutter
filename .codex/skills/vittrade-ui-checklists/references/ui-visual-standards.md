# VitTrade UI visual standards

Use this reference for Flutter presentation, shared-widget, and theme work.
`AGENTS.md`, the design-system reference, and the standards under
`docs/02_FLUTTER_MIGRATION/standards/` remain authoritative.

## Reuse ladder

Prefer shared primitives before local widgets: `VitAppShell`,
`VitPageLayout`, `VitPageContent`, `VitHeader`, `VitBottomNav`,
`VitNavigationRail`, `VitCard`, `VitCtaButton`, `VitInput`, `VitTabBar`,
`VitSegmentedChoice`, `VitPresetChipRow`, `VitSectionHeader`, `VitTaskCard`,
`VitServiceTile`, `VitAccentIconBox`, `VitCommunityRulesLink`, and
`VitStatusPill`.

Use theme tokens only: `AppColors`, `AppSpacing`, `AppRadii`,
`AppTextStyles`, `AppInputStates` (hover/focus), and `AppMotion`
(durations/easing). Dark theme is the baseline; phone-first starts at 360 px
and the tablet-adaptive shell starts at `AppBreakpoints.tablet` (600 px).

## Domain contracts and verification

Read `docs/02_FLUTTER_MIGRATION/Flutter-Design-System-Reference.md` for the
complete domain map and exact command flags. Common checks are:

| Domain | Standard | Verify from `flutter_app/` |
| --- | --- | --- |
| Page rhythm | `standards/Page-Rhythm-Standard.md` | `dart run tool/page_rhythm_audit.dart --check` + the page-rhythm guardrails |
| Content width | `standards/Page-Content-Width-Standard.md` | `dart run tool/page_content_width_audit.dart --check` |
| Card tiles | `standards/Card-Tile-Standard.md` | `dart run tool/card_tile_audit.dart --check --strict-full` |
| Card & border (tablet) | `standards/Tablet-Card-Border-Standard.md` | `dart run tool/tablet_card_border_audit.dart --check` |
| Spacing & gutters (tablet) | `standards/Tablet-Spacing-Gutter-Standard.md` | `dart run tool/tablet_spacing_audit.dart --check` |
| Input states (tablet) | `standards/Tablet-Input-Standard.md` | `dart run tool/tablet_input_audit.dart --check` |
| Motion (tablet absolute + phone ratchet) | `standards/Motion-Standard.md` | `dart run tool/motion_audit.dart --check` |
| Typography roles + tabular figures | `standards/Typography-Standard.md` | `flutter test test/quality/typography_scale_guardrail_test.dart` |
| Financial data tables | `standards/Data-Table-Standard.md` | See the standard's Verify block |
| Contrast floor (WCAG pairs) | `standards/Flutter-Native-Design-Standard.md` (Contrast floor section) | `flutter test test/quality/contrast_floor_guardrail_test.dart` |
| Surface dispatch (tablet) | `standards/Tablet-Adaptive-Standard.md` (R1) | `dart run tool/tablet_route_surface_audit.dart --check` |
| Orientation (tablet) | `standards/Tablet-Adaptive-Standard.md` (R1c + orientation policy) | `dart run tool/tablet_route_surface_audit.dart --check` + `flutter test test/quality/tablet_rotation_guardrail_test.dart` |
| Segment pills | `standards/Segment-Pill-Standard.md` | `dart run tool/segment_pill_audit.dart --check --strict-full` |
| Phone composition | `standards/Phone-Composition-Standard.md` | `dart run tool/home_reference_consistency_audit.dart --check` + page-rhythm audits |
| Scroll auto-hide | `standards/Scroll-Auto-Hide-Standard.md` | `flutter test test/quality/scroll_auto_hide_guardrail_test.dart` |
| Notice acknowledgement | `standards/Notice-Acknowledgement-Standard.md` | `flutter test test/quality/notice_acknowledgement_guardrail_test.dart` |
| Tablet-adaptive layout | `standards/Tablet-Adaptive-Standard.md` | The page's two-column widget test |

`standards/` means `docs/02_FLUTTER_MIGRATION/standards/`. The design-system
reference wins when this compact table and a standard disagree.

## Hard rules

- Tab roots use `VitPageRhythm.compact`; major sections are direct
  `VitPageContent` children. Do not create rhythm with arbitrary
  `SizedBox(height: AppSpacing.x*)` gaps.
- Apply horizontal content padding once on the scroll → `VitPageContent`
  chain; use the documented inset/full-bleed recipes.
- Never wrap `VitTabBar` or `VitSegmentedTabBar` in a bordered `VitCard` or
  `DecoratedBox`. Binary/2–4-option toggles use `VitSegmentedChoice` and
  preset rows use `VitPresetChipRow`.
- Do not create local `_SegmentButton`, `_FilterButton`, `_AccentIcon`, or
  `_CommunityRules*` duplicates when a shared `Vit*` primitive exists.
- Scroll-to-hide headers use `VitAutoHideHeaderScaffold` or
  `VitAutoHidePageScaffold`; do not hand-roll header visibility and collapse.
- Include loading, empty, error, offline, submitting, and success states when
  the flow requires them.
- Post-action acknowledgement uses `showVitNoticeSheet`; sticky footers are
  only for in-progress form or wizard CTAs.
- Hover/focus come from shared widgets + `AppInputStates` tokens — no
  page-local `MouseRegion`/`onHover`, no off-token `hoverColor:`/
  `focusColor:`, no `skipTraversal`. Fills never shift layout.
- Animation durations/easings are `AppMotion.*` tokens — no inline
  `Duration(`/`Curves.` in tablet presentation; resolve reduced motion via
  `AppMotion.respect(context, …)`.
- Tablet presentation never queries device orientation — no
  `OrientationBuilder`, no `MediaQuery.orientationOf`; layout decisions are
  width-tier only (`TabletDashboardWidths` via `LayoutBuilder`).
- New text/bg token pairings must meet WCAG 4.5:1 or enter the locked
  deviation list in `contrast_floor_guardrail_test.dart` with a reason —
  never ship silently below the floor.
- Never use `BorderRadius.circular()` outside `app_radii.dart`.

## Radius and tile guidance

| Role | Token |
| --- | --- |
| Interactive controls | `AppRadii.inputRadius` |
| Standard cards | `AppRadii.cardRadius` / `VitCardRadius.standard` |
| Large or hero cards | `AppRadii.cardLargeRadius` / `VitCardRadius.large` |
| Micro surfaces | `AppRadii.smRadius` |
| Status pills | `AppRadii.pillRadius` |

Fixed-height tile cards should use `VitCard.height` or a minimum constraint,
`VitCardContentAlign.center`, `AppSpacing.cardTilePadding`, and
`AppSpacing.cardTileInnerGap` rather than page-specific centering math.
