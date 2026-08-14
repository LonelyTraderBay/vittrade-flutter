// Phone-specific home scroll shell.
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class HomeScrollShell extends StatelessWidget {
  const HomeScrollShell({
    super.key,
    required this.scrollEndClearance,
    required this.onRefresh,
    required this.visibleAnnouncements,
    required this.onScrollNotification,
    required this.child,
  });

  final double scrollEndClearance;
  final Future<void> Function() onRefresh;
  final List<HomeAnnouncement> visibleAnnouncements;
  final bool Function(ScrollNotification, List<HomeAnnouncement>)
  onScrollNotification;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          onScrollNotification(notification, visibleAnnouncements),
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: VitInsetScrollView(
          key: HomePage.contentKey,
          bottomInset: scrollEndClearance,
          physics: const AlwaysScrollableScrollPhysics(),
          child: child,
        ),
      ),
    );
  }
}
