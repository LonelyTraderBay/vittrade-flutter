import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_header.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_status_content.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_reference_home.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

/// Tablet composition of Home (SC-007). It shares route/data contracts with
/// phone Home, but renders a dedicated tablet command center and header.
class HomeTabletPage extends ConsumerStatefulWidget {
  const HomeTabletPage({super.key});

  @override
  ConsumerState<HomeTabletPage> createState() => _HomeTabletPageState();
}

class _HomeTabletPageState extends ConsumerState<HomeTabletPage> {
  String _marketTab = 'hot';
  bool _balanceHidden = false;
  final Set<String> _sessionHiddenAnnouncementIds = <String>{};
  final Set<String> _dismissedNextActionIds = <String>{};

  void _setTab(String key) => setState(() => _marketTab = key);

  void _toggleBalanceHidden() =>
      setState(() => _balanceHidden = !_balanceHidden);

  void _go(String path) => unawaited(context.push(path));

  void _dismissAnnouncement(HomeAnnouncement announcement) {
    setState(() => _sessionHiddenAnnouncementIds.add(announcement.id));
  }

  void _dismissNextAction(HomeNextAction nextAction) {
    setState(() => _dismissedNextActionIds.add(nextAction.routePath));
  }

  List<HomeAnnouncement> _visibleAnnouncements(HomeSnapshot snapshot) {
    final announcements = snapshot.announcements
        .where(
          (announcement) =>
              announcement.active &&
              announcement.type.surfacesOnHome &&
              !_sessionHiddenAnnouncementIds.contains(announcement.id),
        )
        .toList(growable: true);
    announcements.sort(
      (a, b) =>
          _announcementSortKey(a.type).compareTo(_announcementSortKey(b.type)),
    );
    return announcements;
  }

  HomeNextAction? _visibleNextAction(HomeNextAction? nextAction) {
    if (nextAction == null) return null;
    if (_dismissedNextActionIds.contains(nextAction.routePath)) return null;
    return nextAction;
  }

  int _announcementSortKey(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.info => 0,
      HomeAnnouncementType.campaign => 1,
      HomeAnnouncementType.security => 2,
      HomeAnnouncementType.risk => 3,
    };
  }

  Future<void> _refreshHome() async {
    ref.invalidate(homeSnapshotProvider);
    await ref.read(homeSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeSnapshotProvider);
    final notificationUnreadCount = ref.watch(notificationUnreadCountProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trang chủ',
      semanticIdentifier: 'SC-007',
      child: Column(
        children: [
          HomeHeader(notifications: notificationUnreadCount, onNavigate: _go),
          Expanded(
            child: homeAsync.when(
              loading: () =>
                  const SingleChildScrollView(child: HomeLoadingContent()),
              error: (error, stackTrace) =>
                  HomeErrorContent(onRetry: _refreshHome),
              data: _buildDashboard,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(HomeSnapshot snapshot) {
    final controller = HomeController(state: HomeViewState(snapshot: snapshot));
    final visibleAnnouncements = _visibleAnnouncements(snapshot);
    final visibleNextAction = _visibleNextAction(snapshot.nextAction);
    final marketTickerPairs = controller.gainers
        .take(3)
        .toList(growable: false);
    return HomeTabletReferenceHome(
      snapshot: snapshot,
      visibleAnnouncements: visibleAnnouncements,
      visibleNextAction: visibleNextAction,
      marketTickerPairs: marketTickerPairs,
      marketPairs: controller.tabPairs(_marketTab),
      marketTab: _marketTab,
      balanceHidden: _balanceHidden,
      onToggleBalance: _toggleBalanceHidden,
      onNavigate: _go,
      onDismissAnnouncement: _dismissAnnouncement,
      onDismissNextAction: visibleNextAction == null
          ? null
          : () => _dismissNextAction(visibleNextAction),
      onMarketTabChanged: _setTab,
    );
  }
}
