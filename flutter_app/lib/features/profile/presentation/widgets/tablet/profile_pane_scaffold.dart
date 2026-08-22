import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';

/// Scroll scaffold shared by the Profile tablet master-detail detail panes:
/// an optional [VitHeader] (with the back action shown only below the
/// two-column threshold, where the master menu is no longer permanently
/// visible beside the pane), one `SingleChildScrollView` owning the pane's
/// scroll (never nested inside another scrollable), and an optional
/// pull-to-refresh wrapping it — same refresh contract as
/// `VitTwoColumnTabletDashboard`'s `onRefresh`.
class ProfilePaneScaffold extends StatelessWidget {
  const ProfilePaneScaffold({
    super.key,
    required this.children,
    this.title,
    this.subtitle,
    this.onBack,
    this.onRefresh,
    this.rhythm = VitPageRhythm.form,
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
          LayoutBuilder(
            builder: (context, constraints) {
              // The master menu stays visible beside the pane at/above the
              // dashboard threshold, so a back action is only needed in the
              // single-column fallback territory.
              final narrow =
                  constraints.maxWidth <
                  TabletDashboardWidths.twoColumnMinWidth;
              return VitHeader(
                title: headerTitle,
                subtitle: subtitle,
                showBack: narrow && onBack != null,
                onBack: onBack,
                horizontalPadding: AppSpacing.zero,
              );
            },
          ),
        Expanded(child: body),
      ],
    );
  }
}
