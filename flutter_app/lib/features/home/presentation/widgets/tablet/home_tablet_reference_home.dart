import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_announcement_banner.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_discovery_panel.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_market_ticker_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_market_watchlist_panel.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_next_action_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_portfolio_card.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_products_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_recent_products_section.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';

/// Dedicated tablet Home composition. It keeps Home's domain data and
/// navigation contracts, while replacing the phone-shaped single stack with
/// the shared independent-scroll tablet dashboard.
class HomeTabletReferenceHome extends StatelessWidget {
  const HomeTabletReferenceHome({
    super.key,
    required this.snapshot,
    required this.visibleAnnouncements,
    required this.visibleNextAction,
    required this.marketTickerPairs,
    required this.marketPairs,
    required this.marketTab,
    required this.balanceHidden,
    required this.onToggleBalance,
    required this.onNavigate,
    required this.onDismissAnnouncement,
    required this.onDismissNextAction,
    required this.onMarketTabChanged,
  });

  final HomeSnapshot snapshot;
  final List<HomeAnnouncement> visibleAnnouncements;
  final HomeNextAction? visibleNextAction;
  final List<HomeCryptoPair> marketTickerPairs;
  final List<HomeCryptoPair> marketPairs;
  final String marketTab;
  final bool balanceHidden;
  final VoidCallback onToggleBalance;
  final ValueChanged<String> onNavigate;
  final ValueChanged<HomeAnnouncement> onDismissAnnouncement;
  final VoidCallback? onDismissNextAction;
  final ValueChanged<String> onMarketTabChanged;

  @override
  Widget build(BuildContext context) {
    final primaryChildren = [
      HomePortfolioCard(
        snapshot: snapshot,
        balanceHidden: balanceHidden,
        onToggleBalance: onToggleBalance,
        onNavigate: onNavigate,
      ),
      if (marketTickerPairs.isNotEmpty)
        HomeMarketTickerSection(
          pairs: marketTickerPairs,
          onNavigate: onNavigate,
          itemGap: AppSpacing.x2,
        ),
      HomeMarketWatchlistPanel(
        activeTab: marketTab,
        pairs: marketPairs,
        onTabChanged: onMarketTabChanged,
        onNavigate: onNavigate,
      ),
    ];

    final secondaryChildren = [
      if (visibleAnnouncements.isNotEmpty)
        HomeAnnouncementBanner(
          announcements: visibleAnnouncements,
          onDismiss: onDismissAnnouncement,
          onNavigate: onNavigate,
        ),
      if (visibleNextAction != null)
        HomeNextActionSection(
          nextAction: visibleNextAction!,
          onNavigate: onNavigate,
          onDismiss: onDismissNextAction ?? () {},
        ),
      HomeProductsSection(
        quickActions: snapshot.quickActions,
        maxVisibleQuickActions: snapshot.quickActions.length,
        moreActionCount: 0,
        onNavigate: onNavigate,
        onMore: null,
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
      primaryChildren: primaryChildren,
      secondaryChildren: secondaryChildren,
      primaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
      secondaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
    );
  }
}
