import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/portfolio/advanced_charts_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/derivatives_overview_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/comparison_tool_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/market_calendar_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/market_correlations_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/pair/market_depth_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/pair/market_heatmap_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/responsive/markets_responsive_entry.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/market_movers_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/research/market_news_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/hub/market_overview_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/portfolio/portfolio_tracker_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/market_screener_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/tools/market_sectors_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/portfolio/price_alerts_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/research/social_signals_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/research/social_sentiment_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/research/token_info_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/research/token_unlocks_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/pages/hub/watchlist_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> marketsRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.markets,
      name: AppRouteNames.sc008MarketList,
      builder: (_, _) => switch (surface) {
        AppSurface.phone => MarketListPage(shellRenderMode: shellRenderMode),
        AppSurface.tablet => const MarketsTabletPage(),
        // Web surface composition is migrated in P7.
        AppSurface.web => MarketListPage(shellRenderMode: shellRenderMode),
        null => MarketsResponsiveEntry(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.marketsOverview,
      name: AppRouteNames.sc009MarketOverview,
      builder: (_, _) => MarketOverviewPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsMovers,
      name: AppRouteNames.sc010MarketMovers,
      builder: (_, _) => MarketMoversPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsSectors,
      name: AppRouteNames.sc011MarketSectors,
      builder: (_, state) => MarketSectorsPage(
        shellRenderMode: shellRenderMode,
        selectedSectorId: state.uri.queryParameters['id'],
      ),
    ),
    GoRoute(
      path: AppRoutePaths.marketsWatchlist,
      name: AppRouteNames.sc012Watchlist,
      builder: (_, _) => WatchlistPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsHeatmap,
      name: AppRouteNames.sc013MarketHeatmap,
      builder: (_, _) => MarketHeatmapPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsAlerts,
      name: AppRouteNames.sc014PriceAlerts,
      builder: (_, _) => PriceAlertsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsScreener,
      name: AppRouteNames.sc015MarketScreener,
      builder: (_, _) => MarketScreenerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsCompare,
      name: AppRouteNames.sc016ComparisonTool,
      builder: (_, _) => ComparisonToolPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsCalendar,
      name: AppRouteNames.sc017MarketCalendar,
      builder: (_, _) => MarketCalendarPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsDerivatives,
      name: AppRouteNames.sc018DerivativesOverview,
      builder: (_, _) =>
          DerivativesOverviewPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsDepth,
      name: AppRouteNames.sc019MarketDepth,
      builder: (_, _) => MarketDepthPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsSocialSentiment,
      name: AppRouteNames.sc020SocialSentiment,
      builder: (_, _) => SocialSentimentPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsPortfolioTracker,
      name: AppRouteNames.sc021PortfolioTracker,
      builder: (_, _) => PortfolioTrackerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsNews,
      name: AppRouteNames.sc022MarketNews,
      builder: (_, _) => MarketNewsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsAdvancedCharts,
      name: AppRouteNames.sc023AdvancedCharts,
      builder: (_, _) => AdvancedChartsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsUnlocks,
      name: AppRouteNames.sc024TokenUnlocks,
      builder: (_, _) => TokenUnlocksPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsSignals,
      name: AppRouteNames.sc025SocialSignals,
      builder: (_, _) => SocialSignalsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsCorrelations,
      name: AppRouteNames.sc026MarketCorrelations,
      builder: (_, _) =>
          MarketCorrelationsPage(shellRenderMode: shellRenderMode),
    ),
  ];
}

List<RouteBase> marketPairRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: '/pair/:pairId',
      name: AppRouteNames.sc044PairDetail,
      builder: (_, state) => PairDetailPage(
        // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
        pairId: state.pathParameters['pairId'] ?? 'btcusdt',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/pair/:pairId/info',
      name: AppRouteNames.sc045TokenInfo,
      builder: (_, state) => TokenInfoPage(
        // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
        pairId: state.pathParameters['pairId'] ?? 'btcusdt',
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/pair/:pairId/depth',
      name: AppRouteNames.sc046PairDepth,
      builder: (_, state) {
        // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        final returnTo = state.uri.queryParameters['returnTo'];
        return MarketDepthPage(
          pairId: pairId,
          backPath: returnTo ?? AppRoutePaths.pairDetail(pairId),
          shellRenderMode: shellRenderMode,
        );
      },
    ),
  ];
}
