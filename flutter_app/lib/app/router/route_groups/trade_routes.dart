import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/orders_history_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/trade_settings_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/position_dashboard_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/trade_history_export_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/convert/convert_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/futures/futures_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/futures/leverage_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/margin/margin_trading_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/margin/margin_trading_hub_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> tradeRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.trade,
      name: AppRouteNames.sc048Trade,
      builder: (_, state) {
        final initialSide = _tradeSideFromQuery(
          state.uri.queryParameters['side'],
        );
        return switch (surface) {
          // Web surface composition is migrated in P7.
          AppSurface.phone ||
          AppSurface.tablet ||
          AppSurface.web ||
          null => TradePage(
            initialSide: initialSide,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeConvert,
      name: AppRouteNames.sc056Convert,
      builder: (_, _) => ConvertPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
      name: AppRouteNames.sc412TradeCopyRegulatoryDisclosuresAlias,
      redirect: (_, _) => AppRoutePaths.tradeCopyRegulatoryDisclosures,
    ),
    GoRoute(
      path: AppRoutePaths.tradeMargin,
      name: AppRouteNames.sc085MarginTrading,
      builder: (_, _) => MarginTradingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginBtcusdt,
      name: AppRouteNames.sc086MarginTradingPair,
      builder: (_, _) => switch (surface) {
        AppSurface.phone ||
        AppSurface.tablet ||
        AppSurface.web ||
        null => MarginTradingPage(
          pairId: 'btcusdt',
          pairRouteVariant: true,
          shellRenderMode: shellRenderMode,
        ),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginHub,
      name: AppRouteNames.sc090MarginTradingHub,
      builder: (_, _) => MarginTradingHubPage(shellRenderMode: shellRenderMode),
    ),
    ...tradeMarginOutgoingPlaceholders,
    ...tradeBotsOutgoingPlaceholders,
    GoRoute(
      path: AppRoutePaths.tradeOrderReceipt,
      name: AppRouteNames.sc051OrderReceipt,
      builder: (context, _) => switch (surface) {
        AppSurface.phone => OrderReceiptPage(shellRenderMode: shellRenderMode),
        // Web surface composition is migrated in P7.
        AppSurface.web => OrderReceiptPage(shellRenderMode: shellRenderMode),
        AppSurface.tablet || null =>
          AppBreakpoints.isTablet(MediaQuery.sizeOf(context).width)
              ? TradeTabletOrderReceiptPage(shellRenderMode: shellRenderMode)
              : OrderReceiptPage(shellRenderMode: shellRenderMode),
      },
    ),
    GoRoute(
      path: AppRoutePaths.tradeOrdersHistory,
      name: AppRouteNames.sc050OrdersHistory,
      builder: (_, _) => OrdersHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradePositions,
      name: AppRouteNames.sc053PositionDashboard,
      builder: (_, _) =>
          PositionDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeSettings,
      name: AppRouteNames.sc052TradeSettings,
      builder: (_, _) => TradeSettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeExport,
      name: AppRouteNames.sc054TradeHistoryExport,
      builder: (_, _) =>
          TradeHistoryExportPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/trade/:pairId/futures/leverage',
      name: AppRouteNames.sc058Leverage,
      builder: (_, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        return switch (surface) {
          AppSurface.phone || AppSurface.tablet || AppSurface.web || null =>
            LeveragePage(pairId: pairId, shellRenderMode: shellRenderMode),
        };
      },
    ),
    GoRoute(
      path: '/trade/:pairId/futures',
      name: AppRouteNames.sc057Futures,
      builder: (_, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        return FuturesPage(pairId: pairId, shellRenderMode: shellRenderMode);
      },
    ),
    GoRoute(
      path: '/trade/:pairId',
      name: AppRouteNames.sc049TradePair,
      builder: (_, state) {
        final pairId = state.pathParameters['pairId'] ?? 'btcusdt';
        final side = _tradeSideFromQuery(state.uri.queryParameters['side']);
        return switch (surface) {
          AppSurface.phone ||
          AppSurface.tablet ||
          AppSurface.web ||
          null => TradePage(
            pairId: pairId,
            chartVariant: TradeChartVariant.pairRoute,
            initialSide: side,
            shellRenderMode: shellRenderMode,
          ),
        };
      },
    ),
  ];

  if (surface == AppSurface.web) {
    return buildWebUtilityRouteFamily(
      routes: routes,
      title: 'Giao dịch',
      subtitle: 'Thị trường · lệnh · quản trị rủi ro',
      description:
          'Không gian Web riêng cho giao dịch, vị thế, lịch sử lệnh và cấu hình. Thông tin giá, phí, hạn mức và rủi ro phải được rà soát trước khi thực thi.',
      backPath: AppRoutePaths.home,
      icon: Icons.candlestick_chart_outlined,
    );
  }
  return routes;
}

TradeOrderSide _tradeSideFromQuery(String? value) {
  return value == 'sell' ? TradeOrderSide.sell : TradeOrderSide.buy;
}
