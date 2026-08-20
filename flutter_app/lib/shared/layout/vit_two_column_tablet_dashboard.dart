import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Shared two-column tablet-dashboard scaffold for screens with a dedicated
/// tablet layout (Home, Wallet, Markets, Trade, Profile) — see
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`.
///
/// Below [twoColumnMinWidth], falls back to a single scrolling column
/// (still tablet shell, still nav rail, just not side-by-side) holding
/// [primaryChildren] followed by [secondaryChildren] (R3). At/above that
/// width, renders the true two-column dashboard: [primaryChildren] as the
/// main column, flush against the page background (its own sections already
/// carry their own card framing), and [secondaryChildren] as a sidebar
/// column framed as a distinct panel (R7) — `VitCardVariant.inner` plus an
/// explicit `AppColors.borderSolid` outline, since the inner variant's own
/// default (no border, fill color only) reads too close in value to the
/// page background to register as a panel on its own.
///
/// This is the canonical explanation of the constraint-safety shape
/// mandated by R4/R5 of the Standard above:
///
/// * **R4 — independent-scroll columns.** Each column wraps its own
///   `SingleChildScrollView` — never one `SingleChildScrollView` wrapping
///   the whole `Row`. A `Row` of unbounded natural height inside a single
///   outer scrollview breaks once any child needs a bounded height; two
///   independently height-bounded scrolling columns is the supported shape.
/// * **R5 — width cap on the two-column block as a whole**, via an outer
///   `Center` + `ConstrainedBox(maxWidth: primaryColumnMaxWidth +
///   secondaryColumnMaxWidth)` wrapping the entire `Row` — not a per-column
///   cap on the `Row`'s own children. Two per-column caps (tried first,
///   confirmed wrong on-device) put each column in charge of absorbing its
///   *own* slack independently: primary (the wider cap) hid its slack
///   gracefully near the nav rail, but secondary (the narrower cap) leaked
///   its slack as dead space at the *outer* screen edge — and once that was
///   fixed by sizing secondary exactly to its cap, ALL the shell's leftover
///   width piled onto primary's side instead, showing up as an equally
///   lopsided gap between the nav rail and primary's content. Capping the
///   *pair* and centering it distributes any leftover symmetrically on
///   both outer edges instead of dumping it entirely on one side — the
///   difference between a page that looks intentionally margined and one
///   that looks like content stopped short by mistake. Inside that capped,
///   centered block: primary is a plain `Expanded` (no per-column
///   `ConstrainedBox` needed — the outer cap already bounds the pair's
///   total, so `Expanded` naturally receives exactly
///   `primaryColumnMaxWidth` once secondary's fixed width is subtracted);
///   secondary is a fixed `SizedBox(width: secondaryColumnMaxWidth)`, not
///   `Expanded` — giving it a flex share instead would let it over-claim
///   width its own content never uses. `SingleChildScrollView` per column
///   is what loosens *only* the height axis while keeping width bounded;
///   that's the one place a width cap can actually narrow a column without
///   also loosening the `Row`'s own tight-height stretch, which independent
///   scrolling depends on. A `ConstrainedBox` placed directly on a
///   tightly-constrained ancestor (e.g. `Expanded` itself) is a no-op —
///   tight incoming constraints always win over a descendant's tighter
///   bound; that's why the width cap sits on the outer `Center` (which
///   hands the `Row` genuinely loose constraints up to the cap), not
///   wrapped around the `Row` or an `Expanded` child directly.
///
/// R6: the two-column path uses `VitContentPadding.relaxed` +
/// `VitPageRhythm.relaxed`; the single-column fallback keeps `.compact`.
/// Screen-specific [primaryContentGap] and [secondaryContentGap] overrides may
/// tighten the major-section rhythm when the dashboard has a denser scan path;
/// they only affect the two-column path and keep the fallback contract intact.
/// Both paths reserve [bottomContentInset] after the final content item so
/// tablet columns never end flush against the viewport edge.
/// R8: [primaryColumnMaxWidth]/[secondaryColumnMaxWidth] default to the
/// per-column pixel widths confirmed not to overflow at the shared
/// threshold on multiple independent content sets — override these
/// constructor params locally on a page that empirically needs a different
/// number instead of editing [TabletDashboardWidths] (its own doc comment:
/// overridable defaults, not hard-shared state).
class VitTwoColumnTabletDashboard extends StatelessWidget {
  const VitTwoColumnTabletDashboard({
    super.key,
    required this.primaryChildren,
    required this.secondaryChildren,
    this.onRefresh,
    this.twoColumnMinWidth = TabletDashboardWidths.twoColumnMinWidth,
    this.primaryColumnMaxWidth = TabletDashboardWidths.primaryColumnMaxWidth,
    this.secondaryColumnMaxWidth =
        TabletDashboardWidths.secondaryColumnMaxWidth,
    this.primaryContentGap,
    this.secondaryContentGap,
    this.bottomContentInset = AppSpacing.contentPad,
  });

  /// Main-column content. Flush against the page background at the
  /// two-column width; rendered first in the single-column fallback.
  final List<Widget> primaryChildren;

  /// Sidebar-panel content. Framed in a `VitCard` at the two-column width
  /// (R7); appended after [primaryChildren] in the single-column fallback.
  final List<Widget> secondaryChildren;

  /// Optional pull-to-refresh callback (the tablet equivalent of the phone
  /// scroll-shell's `RefreshIndicator`). When non-null, every scrollable
  /// path — both two-column columns and the single-column fallback — wraps
  /// in a `RefreshIndicator` and scrolls always-scrollable so the overscroll
  /// gesture works even when a column's content is shorter than the
  /// viewport. Null (the default) keeps the historical non-refreshable
  /// behavior for pages that have no refresh semantics.
  final RefreshCallback? onRefresh;

  /// Below this content width, falls back to a single scrolling column
  /// (R3). Defaults to [TabletDashboardWidths.twoColumnMinWidth] — only
  /// override after empirically re-verifying against the page's own
  /// content (R3, R8), not by guessing.
  final double twoColumnMinWidth;

  /// Caps the primary column's own width at/above [twoColumnMinWidth]
  /// (R8).
  final double primaryColumnMaxWidth;

  /// Caps the secondary column's own width at/above [twoColumnMinWidth]
  /// (R8).
  final double secondaryColumnMaxWidth;

  /// Optional vertical gap between primary-column sections. When null, the
  /// column keeps the rhythm selected below for backward compatibility.
  final double? primaryContentGap;

  /// Optional vertical gap between secondary-column sections. When null, the
  /// sidebar keeps the relaxed rhythm selected below for backward
  /// compatibility.
  final double? secondaryContentGap;

  /// Bottom breathing room after the final content item in each scrollable
  /// column. The same inset is used by the single-column fallback so all
  /// tablet root screens share one end-of-content standard.
  final double bottomContentInset;

  /// Null keeps each column's default physics; a refreshable column must
  /// always allow overscroll so the pull gesture works even when its content
  /// is shorter than the viewport.
  ScrollPhysics? get _physics =>
      onRefresh == null ? null : const AlwaysScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < twoColumnMinWidth) {
          return _wrapRefresh(
            SingleChildScrollView(
              physics: _physics,
              padding: EdgeInsets.only(bottom: bottomContentInset),
              child: VitPageContent(
                padding: VitContentPadding.compact,
                rhythm: VitPageRhythm.compact,
                children: [...primaryChildren, ...secondaryChildren],
              ),
            ),
          );
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: primaryColumnMaxWidth + secondaryColumnMaxWidth,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _wrapRefresh(
                    SingleChildScrollView(
                      physics: _physics,
                      padding: EdgeInsets.only(bottom: bottomContentInset),
                      child: VitPageContent(
                        padding: VitContentPadding.relaxed,
                        rhythm: VitPageRhythm.relaxed,
                        customGap: primaryContentGap,
                        children: primaryChildren,
                      ),
                    ),
                  ),
                ),
                // Fixed width, not Expanded — see R5 above: a flex share
                // would let this column over-claim width beyond what its
                // own capped content ever uses.
                SizedBox(
                  width: secondaryColumnMaxWidth,
                  child: _wrapRefresh(
                    SingleChildScrollView(
                      physics: _physics,
                      child: VitCard(
                        variant: VitCardVariant.inner,
                        radius: VitCardRadius.standard,
                        padding: EdgeInsets.zero,
                        // Inner-variant cards default to a borderless fill
                        // (see VitCard._decoration) — fine for a card nested
                        // inside another surface, but on its own against the
                        // page background that fill alone reads too close in
                        // value to register as a distinct sidebar panel (R7).
                        // Confirmed on-device: the standard card border token
                        // (AppColors.cardBorder, ~7% white) was tried first and
                        // was imperceptible at this size against surface2, so
                        // this uses the stronger, still-existing borderSolid
                        // token (already used for the same "give this surface
                        // a visible edge" purpose elsewhere, e.g.
                        // two_fa_setup_backup.dart) — a call-site override, not
                        // a change to any of the ~250 other inner-variant call
                        // sites app-wide.
                        borderColor: AppColors.borderSolid,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottomContentInset),
                          child: VitPageContent(
                            padding: VitContentPadding.relaxed,
                            rhythm: VitPageRhythm.relaxed,
                            customGap: secondaryContentGap,
                            children: secondaryChildren,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _wrapRefresh(Widget scroll) {
    final onRefresh = this.onRefresh;
    if (onRefresh == null) return scroll;
    return RefreshIndicator(onRefresh: onRefresh, child: scroll);
  }
}
