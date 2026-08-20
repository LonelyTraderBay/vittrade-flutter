import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_more_products_sheet.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_header.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_status_content.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_reference_home.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

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
      (a, b) => a.type.homePriority.compareTo(b.type.homePriority),
    );
    return announcements;
  }

  HomeNextAction? _visibleNextAction(HomeNextAction? nextAction) {
    if (nextAction == null) return null;
    if (_dismissedNextActionIds.contains(nextAction.routePath)) return null;
    return nextAction;
  }

  Future<void> _refreshHome() async {
    ref.invalidate(homeSnapshotProvider);
    await ref.read(homeSnapshotProvider.future);
  }

  void _showMoreProducts(List<HomeQuickAction> actions) {
    final rootContext = context;

    if (actions.isEmpty) return;

    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        barrierColor: AppColors.modalScrim,
        // Full-width phone sheet stretches badly at tablet widths; cap it
        // at the dashboard's main-column width so it reads as the same
        // content column.
        constraints: const BoxConstraints(
          maxWidth: TabletDashboardWidths.primaryColumnMaxWidth,
        ),
        builder: (sheetContext) {
          return HomeMoreProductsSheet(
            actions: actions,
            onNavigate: (path) {
              Navigator.of(sheetContext).pop();
              unawaited(rootContext.push(path));
            },
            density: VitDensity.standard,
          );
        },
      ),
    );
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
              loading: () => HomeLoadingContent(onRefresh: _refreshHome),
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
    // The sidebar grid renders every quick action, so the «Xem thêm» sheet
    // only carries catalog products not already visible there.
    final gridRoutes = snapshot.quickActions
        .map((action) => action.routePath)
        .toSet();
    final moreCatalogActions = _flatMoreCatalogActions(
      productGroups: snapshot.productGroups,
      excludedRoutes: gridRoutes,
    );
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
      onRefresh: _refreshHome,
      moreActionCount: moreCatalogActions.length,
      onMore: moreCatalogActions.isEmpty
          ? null
          : () => _showMoreProducts(moreCatalogActions),
    );
  }
}

/// Flat «Xem thêm» catalog: group order preserved, route duplicates skipped
/// (including quick-action routes already visible in the sidebar grid).
/// Mirrors the phone page's private helper — each surface owns its own
/// composition, the catalog shape is the shared contract.
List<HomeQuickAction> _flatMoreCatalogActions({
  required List<HomeProductGroup> productGroups,
  required Set<String> excludedRoutes,
}) {
  final seen = Set<String>.of(excludedRoutes);
  final actions = <HomeQuickAction>[];
  for (final group in productGroups) {
    for (final action in group.actions) {
      if (seen.add(action.routePath)) {
        actions.add(action);
      }
    }
  }
  return actions;
}
