/// Shared starting-point width tokens for two-column tablet dashboard pages
/// (see `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`
/// R3/R8). `HomeTabletPage` and `WalletTabletPage` both use these values
/// unchanged as of writing — extracted here once a second screen confirmed
/// the same numbers, per each page's own original doc comment.
///
/// These are defaults, not a hard global rule: a future tablet dashboard
/// with denser or sparser content may empirically need a different
/// threshold or cap. In that case, keep a page-local `static const`
/// override instead of changing these shared values — changing them here
/// would silently shift the proven safety margin (R8) for every page that
/// currently relies on them unchanged.
final class TabletDashboardWidths {
  const TabletDashboardWidths._();

  /// Below this content width, a two-column dashboard doesn't have enough
  /// room per column for widgets sized for phone content without
  /// overflowing — pages fall back to a single column (still tablet shell,
  /// still nav rail, just not side-by-side) down to `AppBreakpoints.tablet`.
  static const double twoColumnMinWidth = 900;

  /// Caps the primary (main-content) column's own width on wide
  /// tablets/landscape so rows and cards built for phone-width content
  /// don't stretch into sparse, oversized layouts. Paired with
  /// [secondaryColumnMaxWidth] as the two-column block's total width cap in
  /// [VitTwoColumnTabletDashboard] — raised from an original 640 once a
  /// wide (1280dp-logical) tablet showed that value left a visible unused
  /// margin rather than actually being a deliberate content-width ceiling;
  /// raised again 760 → 800 (2026-08-21, user-approved after a side-by-side
  /// variant preview) so screens ≥ ~1310dp of content width hand the slack
  /// to the main column instead of centering it away. Re-verify on-device
  /// before raising further, don't just keep bumping the number.
  static const double primaryColumnMaxWidth = 800;

  /// Caps the secondary (sidebar-panel) column's own width — see
  /// [primaryColumnMaxWidth]. Lowered 440 → 400 (2026-08-21) to shift 40px
  /// into the main column at every two-column width: the 3-column tile grid
  /// and row lists stay comfortable at 400px, and the main workspace gains
  /// density where it matters more.
  static const double secondaryColumnMaxWidth = 400;

  /// Outer breathing room reserved on each side of the dashboard block.
  /// Matches `AppSpacing.contentPad` (20) so the dashboard's content plane
  /// aligns exactly with the header's content inset — one shared edge line
  /// — while still keeping content off the screen bezel. Reserved inside
  /// the pair cap in [VitTwoColumnTabletDashboard], so the column caps
  /// themselves stay at their proven values (R8).
  static const double outerHorizontalMargin = 20;

  /// Explicit gutter between the two dashboard columns — both columns sit
  /// on the same content plane (cards and the sidebar frame inset by
  /// [outerHorizontalMargin]), so the block needs a deliberate separator
  /// wider than the outer margin to read as two panels, not one slab.
  static const double columnGutter = 24;

  /// Vertical breathing room above and below the two-column block: the top
  /// gap drops both columns below the fixed header on one shared line, and
  /// the bottom gap keeps scrolled content from pressing against the
  /// viewport's bottom edge.
  static const double blockVerticalGap = 16;
}
