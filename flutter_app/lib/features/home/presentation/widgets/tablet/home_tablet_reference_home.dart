import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_discovery_panel.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_market_watchlist_panel.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_next_action_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_notice_line.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_products_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_recent_products_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_kpi_strip.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';

/// Dedicated tablet Home composition — monitor-first command center
/// (SC-007): a full-width KPI strip banner compresses the portfolio facts,
/// the primary column is the dense market watchlist, and the framed sidebar
/// carries the acting/discovery surface in three clear groups.
class HomeTabletReferenceHome extends StatelessWidget {
  const HomeTabletReferenceHome({
    super.key,
    required this.snapshot,
    required this.notice,
    required this.visibleNextAction,
    required this.marketPairs,
    required this.marketTab,
    required this.balanceHidden,
    required this.onToggleBalance,
    required this.onNavigate,
    required this.onDismissNotice,
    required this.onDismissNextAction,
    required this.onMarketTabChanged,
    this.onRefresh,
    this.moreActionCount = 0,
    this.onMore,
  });

  final HomeSnapshot snapshot;

  /// Top-priority visible announcement, or null when nothing surfaces —
  /// see the page's priority sort and session dismissals.
  final HomeAnnouncement? notice;
  final HomeNextAction? visibleNextAction;
  final List<HomeCryptoPair> marketPairs;
  final String marketTab;
  final bool balanceHidden;
  final VoidCallback onToggleBalance;
  final ValueChanged<String> onNavigate;
  final ValueChanged<HomeAnnouncement> onDismissNotice;
  final VoidCallback? onDismissNextAction;
  final ValueChanged<String> onMarketTabChanged;

  /// Pull-to-refresh for both dashboard columns and the single-column
  /// fallback (see [VitTwoColumnTabletDashboard.onRefresh]).
  final RefreshCallback? onRefresh;

  /// «Xem thêm (+N)» overflow count for the quick-actions header; zero
  /// hides the action.
  final int moreActionCount;

  /// Opens the flat product catalog dialog (Margin, Copy Trade, Bot, …)
  /// beyond the sidebar grid's capacity.
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    final gridActions = snapshot.quickActions.take(
      HomeProductsSection.gridCapacity,
    );

    final secondaryChildren = [
      if (notice != null)
        HomeNoticeLine(
          announcement: notice!,
          onDismiss: onDismissNotice,
          onNavigate: onNavigate,
        ),
      if (visibleNextAction != null)
        HomeNextActionSection(
          nextAction: visibleNextAction!,
          onNavigate: onNavigate,
          // The page pairs a non-null dismiss with every non-null next
          // action it passes in.
          onDismiss: onDismissNextAction!,
        ),
      HomeProductsSection(
        quickActions: gridActions.toList(growable: false),
        maxVisibleQuickActions: HomeProductsSection.gridCapacity,
        moreActionCount: moreActionCount,
        onNavigate: onNavigate,
        onMore: onMore,
        density: VitDensity.standard,
      ),
      HomeRecentProductsSection(
        recentProducts: snapshot.recentProducts,
        onNavigate: onNavigate,
        density: VitDensity.standard,
      ),
      HomeDiscoveryPanel(onNavigate: onNavigate),
    ];

    return VitTwoColumnTabletDashboard(
      key: const Key('sc007_home_tablet_dashboard'),
      banner: HomeTabletKpiStrip(
        snapshot: snapshot,
        balanceHidden: balanceHidden,
        onToggleBalance: onToggleBalance,
        onNavigate: onNavigate,
      ),
      primaryChildren: [
        HomeMarketWatchlistPanel(
          activeTab: marketTab,
          pairs: marketPairs,
          onTabChanged: onMarketTabChanged,
          onNavigate: onNavigate,
        ),
      ],
      secondaryChildren: secondaryChildren,
      onRefresh: onRefresh,
      primaryContentGap: AppSpacing.x4,
      secondaryContentGap: AppSpacing.x4,
    );
  }
}
