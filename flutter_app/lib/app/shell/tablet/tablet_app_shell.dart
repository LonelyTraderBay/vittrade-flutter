import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

/// Tablet shell độc lập: navigation rail cố định bên trái, không dùng
/// bottom-nav auto-hide của Phone.
class TabletAppShell extends StatelessWidget {
  const TabletAppShell({
    super.key,
    required this.child,
    this.activeDestination = VitBottomNavDestination.home,
    this.onDestinationSelected,
    this.showNavigation = true,
    this.statusBarTime,
    this.notificationBadgeCount,
    this.homeBadgeCount = 0,
    this.renderMode = ShellRenderMode.native,
  });

  final Widget child;
  final VitBottomNavDestination activeDestination;
  final ValueChanged<VitBottomNavDestination>? onDestinationSelected;
  final bool showNavigation;
  final String? statusBarTime;
  final int? notificationBadgeCount;
  final int homeBadgeCount;
  final ShellRenderMode renderMode;

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      top: true,
      bottom: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showNavigation)
            SafeArea(
              top: false,
              right: false,
              bottom: false,
              child: VitNavigationRail(
                activeDestination: activeDestination,
                onDestinationSelected: onDestinationSelected,
                homeNotificationBadgeCount:
                    notificationBadgeCount ?? homeBadgeCount,
              ),
            ),
          Expanded(child: child),
        ],
      ),
    );

    if (!renderMode.usesVisualQaFrame) return body;
    return Column(
      children: [
        VitStatusBar(time: statusBarTime),
        Expanded(child: body),
      ],
    );
  }
}
