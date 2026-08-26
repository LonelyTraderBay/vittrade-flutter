import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/portfolio/advanced_charts_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/derivatives_overview_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/comparison_tool_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_calendar_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_correlations_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/market_depth_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/market_heatmap_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_movers_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/market_news_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/hub/market_overview_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/portfolio/portfolio_tracker_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_screener_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_sectors_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/portfolio/price_alerts_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/social_signals_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/social_sentiment_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/token_info_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/token_unlocks_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/hub/watchlist_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/widgets/markets_tablet_master_shell.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_depth_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_detail_pane.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_token_info_pane.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> marketsRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.markets,
      name: AppRouteNames.sc008MarketList,
      builder: (_, _) => switch (surface) {
        // Web surface composition is migrated in P7.
        AppSurface.phone ||
        AppSurface.web ||
        null => MarketListPage(shellRenderMode: shellRenderMode),
        AppSurface.tablet => const MarketsTabletPage(),
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
  if (surface == AppSurface.web) {
    return buildTabletUtilityRouteFamily(
      routes: routes,
      surface: surface!,
      title: 'Công cụ thị trường',
      subtitle: 'Phân tích, nghiên cứu và cảnh báo trên Tablet',
      description:
          'Không gian Tablet để theo dõi xu hướng, dữ liệu chuyên sâu, nghiên cứu và công cụ quản trị thị trường.',
      backPath: AppRoutePaths.markets,
      icon: Icons.query_stats_outlined,
    );
  }
  if (surface != AppSurface.tablet) return routes;
  // Tablet terminal master-detail (Binance-iPad style): một shell route giữ
  // danh sách cặp khung trái (search + «Yêu thích» + sort), detail pane bên
  // phải render `/markets` (tổng quan) hay `/pair/...` đang hoạt động qua
  // StatefulNavigationShell. Cùng paths/names như danh sách flat — GoRoute
  // blocks giữ byte-compatible cho static route audits; phone giữ
  // navigation full-page như cũ. Pair routes gia nhập branch của shell
  // (root mount bỏ qua chúng trên tablet để không đăng ký trùng path).
  return [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MarketsTabletMasterShell(
        navigationShell: navigationShell,
        currentPath: state.uri.path,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            routes.first,
            ...buildTabletUtilityRouteFamily(
              routes: routes.skip(1),
              surface: surface!,
              title: 'Công cụ thị trường',
              subtitle: 'Phân tích, nghiên cứu và cảnh báo trên Tablet',
              description:
                  'Không gian Tablet để theo dõi xu hướng, dữ liệu chuyên sâu, nghiên cứu và công cụ quản trị thị trường.',
              backPath: AppRoutePaths.markets,
              icon: Icons.query_stats_outlined,
            ),
            ...marketPairRoutes(shellRenderMode, surface: surface),
          ],
        ),
      ],
    ),
  ];
}

List<RouteBase> marketPairRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: '/pair/:pairId',
      name: AppRouteNames.sc044PairDetail,
      builder: (context, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        return switch (surface) {
          // Terminal master-detail: pane phân tích thật trong detail column
          // bên cạnh master list.
          AppSurface.tablet => MarketsPairDetailPane(pairId: pairId),
          AppSurface.phone || AppSurface.web || null => PairDetailPage(
            // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
            pairId: pairId,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
    GoRoute(
      path: '/pair/:pairId/info',
      name: AppRouteNames.sc045TokenInfo,
      builder: (context, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        return switch (surface) {
          // Terminal master-detail: pane thông tin token thật trong detail
          // column.
          AppSurface.tablet => MarketsTokenInfoPane(pairId: pairId),
          AppSurface.phone || AppSurface.web || null => TokenInfoPage(
            // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
            pairId: pairId,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
    GoRoute(
      path: '/pair/:pairId/depth',
      name: AppRouteNames.sc046PairDepth,
      builder: (context, state) {
        // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        final returnTo = state.uri.queryParameters['returnTo'];
        return switch (surface) {
          // Terminal master-detail: pane độ sâu thị trường thật trong
          // detail column (back luôn về pair detail pane).
          AppSurface.tablet => MarketsPairDepthPane(pairId: pairId),
          AppSurface.phone || AppSurface.web || null => MarketDepthPage(
            pairId: pairId,
            backPath: returnTo ?? AppRoutePaths.pairDetail(pairId),
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
  ];
}
