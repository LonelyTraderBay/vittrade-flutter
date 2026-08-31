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

  /// Minimum content width for a master-detail shell to keep its SPLIT
  /// (framed master menu beside the detail pane) below the two-column
  /// dashboard tier — the portrait tier. Between this width and
  /// [twoColumnMinWidth] the shell splits with the master column
  /// ([masterDetailMasterWidth]) instead of stacking menu above pane:
  /// iPad-Settings portrait semantics, where rotation relayouts sizes but
  /// never changes the composition or swaps to full-page pushes. Below this
  /// width the shell falls back to the stacked single column down to
  /// `AppBreakpoints.tablet` (window-resize territory only — real tablets
  /// in portrait still sit above it).
  ///
  /// Chosen so an 800dp-logical portrait tablet (shell = 800 − 96 rail =
  /// 704dp) still splits: 308 master + 24 gutter + 372 detail ≈ phone-width
  /// content, which every pane already renders by design (R3 threshold
  /// choice — verified per page, see the Adaptive standard).
  static const double masterDetailSplitMinWidth = 680;

  /// The master (menu) column width for master-detail shells — ONE width
  /// for both split tiers (wide/centered and portrait), like the iPad
  /// Settings sidebar: the menu reads the same whichever way the tablet is
  /// held, and every dp taken off it is handed straight to the detail pane
  /// (the wide tier's pair cap stays 1224, so narrowing the master widens
  /// the pane instead of adding dead margins). 300 fits the longest menu
  /// label ("Xác minh danh tính (KYC)") un-ellipsized at the current row
  /// tokens (verified by a TextPainter measurement test — don't lower
  /// without re-running it); the wide tier previously borrowed
  /// [secondaryColumnMaxWidth] (400) and portrait used 320 (2026-08-27
  /// user request to slim the menu and maximize the pane on both
  /// orientations).
  static const double masterDetailMasterWidth = 308;

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
  /// LUẬT 13dp (user chốt 2026-08-31): mọi khoảng trống dọc + ngang trên
  /// tablet = 13 — lề ngang khung đổi 20 → 13, tách khỏi `contentPad` của
  /// phone (một quyết định khung tablet, không phải fork token module).
  /// Reserved inside the pair cap in [VitTwoColumnTabletDashboard], so the
  /// column caps themselves stay at their proven values (R8).
  static const double outerHorizontalMargin = 12;

  /// Explicit gutter between the two dashboard columns — LUẬT 13dp
  /// (2026-08-31): 24 → 13, cùng một khoảng trắng với mọi khe khác trên
  /// tablet để khung và nội dung đọc cùng một nhịp.
  static const double columnGutter = 12;

  /// Vertical breathing room above and below the two-column block: the top
  /// gap drops both columns below the fixed header on one shared line, and
  /// the bottom gap keeps scrolled content from pressing against the
  /// viewport's bottom edge. LUẬT 13dp (2026-08-31): 16 → 13.
  static const double blockVerticalGap = 12;
}
