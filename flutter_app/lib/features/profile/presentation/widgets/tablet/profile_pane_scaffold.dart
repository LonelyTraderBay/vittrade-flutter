import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';

/// Scroll scaffold shared by the Profile tablet master-detail detail panes:
/// an optional [VitHeader] (with the back action shown only below the
/// two-column threshold, where the master menu is no longer permanently
/// visible beside the pane), one `SingleChildScrollView` owning the pane's
/// scroll (never nested inside another scrollable), and an optional
/// pull-to-refresh wrapping it — same refresh contract as
/// `VitTwoColumnTabletDashboard`'s `onRefresh`.
///
/// Top-level [children] must stay FLAT: the inner `VitPageContent(rhythm:)`
/// already inserts the rhythm's section gap between every pair of
/// children, so a manual `SizedBox(height:)` standing as an element of
/// `children` stacks onto those gaps (e.g. 16+8+16=40dp instead of 16dp)
/// and breaks the pane's vertical rhythm. Inner gaps belong inside child
/// widgets, never between them — locked by `tablet_spacing_audit` rule S4.
class ProfilePaneScaffold extends StatelessWidget {
  const ProfilePaneScaffold({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
    this.onBack,
    this.onRefresh,
    this.headerActions,
    this.rhythm = VitPageRhythm.standard,
    this.padding = VitContentPadding.relaxed,
    this.scrollKey,
  });

  final List<Widget> children;

  /// Pane header title. Null renders no header — the base overview pane
  /// already sits under the shell's own `VitTopChrome`.
  final String? title;
  final String? subtitle;
  final VoidCallback? onBack;
  final RefreshCallback? onRefresh;

  /// Header action buttons rendered beside the title (e.g. the API pane's
  /// "create key" action). Only shown when [title] renders a header.
  final List<VitHeaderActionItem>? headerActions;
  final VitPageRhythm rhythm;
  final VitContentPadding padding;
  final Key? scrollKey;

  @override
  Widget build(BuildContext context) {
    // The shell's gutter already separates the pane from the master menu,
    // so the pane bleeds horizontally to sit flush with the gutter —
    // otherwise the pane's own content pad stacks onto the 24dp gutter and
    // the detail side reads twice as far from the menu as the menu does
    // from the navigation rail.
    Widget body = SingleChildScrollView(
      key: scrollKey,
      physics: onRefresh == null ? null : const AlwaysScrollableScrollPhysics(),
      child: VitPageContent(
        rhythm: rhythm,
        padding: padding,
        density: VitDensity.compact,
        fullBleed: true,
        children: children,
      ),
    );
    if (onRefresh != null) {
      body = RefreshIndicator(onRefresh: onRefresh!, child: body);
    }

    final headerTitle = title;
    return Column(
      children: [
        if (headerTitle != null)
          Builder(
            builder: (context) {
              // The back action is needed only where the framed master
              // menu is no longer beside the pane — that is decided by the
              // SHELL's width (screen minus the nav rail) against the
              // master-detail SPLIT threshold, not the pane's own column
              // width. Both split tiers (wide ≥900 centered, portrait
              // 680–899 with the narrow 320 master) keep the menu beside
              // the pane, so a back arrow there would duplicate the
              // always-visible menu (§Master-detail #3); only the stacked
              // fallback below the split threshold renders full-width
              // panes that need their own way back.
              final narrow =
                  MediaQuery.sizeOf(context).width - VitNavigationRail.width <
                  TabletDashboardWidths.masterDetailSplitMinWidth;
              return VitHeader(
                title: headerTitle,
                subtitle: subtitle,
                showBack: narrow && onBack != null,
                onBack: onBack,
                actions: headerActions ?? const [],
                horizontalPadding: AppSpacing.zero,
              );
            },
          ),
        Expanded(child: body),
      ],
    );
  }
}
