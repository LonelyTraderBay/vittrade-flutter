import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/market_depth_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_sectors_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/token_info_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/widgets/markets_tablet_master_shell.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> marketsRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.markets,
      name: AppRouteNames.sc008MarketList,
      // Web surface composition is migrated in P7.
      builder: (_, _) => MarketListPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.marketsOverview,
      name: AppRouteNames.sc009MarketOverview,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsMovers,
      name: AppRouteNames.sc010MarketMovers,
      builder: legacyPhoneRouteStub,
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
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsHeatmap,
      name: AppRouteNames.sc013MarketHeatmap,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsAlerts,
      name: AppRouteNames.sc014PriceAlerts,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsScreener,
      name: AppRouteNames.sc015MarketScreener,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsCompare,
      name: AppRouteNames.sc016ComparisonTool,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsCalendar,
      name: AppRouteNames.sc017MarketCalendar,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsDerivatives,
      name: AppRouteNames.sc018DerivativesOverview,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsDepth,
      name: AppRouteNames.sc019MarketDepth,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsSocialSentiment,
      name: AppRouteNames.sc020SocialSentiment,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsPortfolioTracker,
      name: AppRouteNames.sc021PortfolioTracker,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsNews,
      name: AppRouteNames.sc022MarketNews,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsAdvancedCharts,
      name: AppRouteNames.sc023AdvancedCharts,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsUnlocks,
      name: AppRouteNames.sc024TokenUnlocks,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsSignals,
      name: AppRouteNames.sc025SocialSignals,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.marketsCorrelations,
      name: AppRouteNames.sc026MarketCorrelations,
      builder: legacyPhoneRouteStub,
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
          AppSurface.phone ||
          AppSurface.tablet ||
          AppSurface.web ||
          null => PairDetailPage(
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
          AppSurface.phone ||
          AppSurface.tablet ||
          AppSurface.web ||
          null => TokenInfoPage(
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
          AppSurface.phone ||
          AppSurface.tablet ||
          AppSurface.web ||
          null => MarketDepthPage(
            pairId: pairId,
            backPath: returnTo ?? AppRoutePaths.pairDetail(pairId),
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
  ];
}
