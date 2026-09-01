// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_ad_analytics_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_ad_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_create_ad_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_my_ads_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_order_book_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_dashboard_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_express_confirm_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_express_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_guide_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_home_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_notifications_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_trading_level_page.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

List<RouteBase> p2pMarketplaceRoutes(ShellRenderMode shellRenderMode) {
  final routes = <RouteBase>[
    GoRoute(
      path: AppRoutePaths.p2pExpress,
      name: AppRouteNames.sc211P2PExpress,
      builder: (_, _) => P2PExpressPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pExpressConfirm,
      name: AppRouteNames.sc210P2PExpressConfirm,
      builder: (_, state) => P2PExpressConfirmPage(
        shellRenderMode: shellRenderMode,
        tradeType: parseP2PTradeType(state.uri.queryParameters['type']),
        asset: state.uri.queryParameters['asset'] ?? 'USDT',
        fiatAmount: parseP2PAmount(state.uri.queryParameters['fiat']),
        cryptoAmount: parseP2PAmount(state.uri.queryParameters['crypto']),
        adId: state.uri.queryParameters['adId'],
        paymentMethod: state.uri.queryParameters['payment'],
      ),
    ),
    GoRoute(
      path: '/p2p/ad-analytics/:adId',
      name: AppRouteNames.sc223P2PAdAnalytics,
      builder: (_, state) => P2PAdAnalyticsPage(
        adId: requireRouteParam(state, 'adId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/p2p/ad/:adId',
      name: AppRouteNames.sc224P2PAdDetail,
      builder: (_, state) => P2PAdDetailPage(
        adId: requireRouteParam(state, 'adId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.p2pMyAds,
      name: AppRouteNames.sc225P2PMyAds,
      builder: (_, _) => P2PMyAdsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pCreate,
      name: AppRouteNames.sc226P2PCreateAd,
      builder: (_, _) => P2PCreateAdPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pTradingLevel,
      name: AppRouteNames.sc230P2PTradingLevel,
      builder: (_, _) => P2PTradingLevelPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pGuide,
      name: AppRouteNames.sc280P2PGuide,
      builder: (_, _) => P2PGuidePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSettings,
      name: AppRouteNames.sc279P2PSettings,
      builder: (_, _) => P2PSettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pSettingsNotifications,
      name: AppRouteNames.sc278P2PNotificationsSettings,
      builder: (_, _) =>
          P2PNotificationsSettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pOrderBook,
      name: AppRouteNames.sc273P2POrderBook,
      builder: (_, _) => P2POrderBookPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2pDashboard,
      name: AppRouteNames.sc274P2PDashboard,
      builder: (_, _) => P2PDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.p2p,
      name: AppRouteNames.sc282P2PHome,
      builder: (_, _) => P2PHomePage(shellRenderMode: shellRenderMode),
    ),
  ];

  return routes;
}
