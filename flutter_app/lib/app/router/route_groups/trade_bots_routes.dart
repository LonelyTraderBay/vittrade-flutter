import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> tradeBotsRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.tradeBots,
      name: AppRouteNames.sc059TradingBots,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotTermsOfService,
      name: AppRouteNames.sc117BotTermsOfService,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotRiskDisclosure,
      name: AppRouteNames.sc118BotRiskDisclosure,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotSuitabilityAssessment,
      name: AppRouteNames.sc119BotSuitabilityAssessment,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotRiskDashboard,
      name: AppRouteNames.sc120BotRiskDashboard,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotEmergencyStop,
      name: AppRouteNames.sc121BotEmergencyStop,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotSecuritySettings,
      name: AppRouteNames.sc122BotSecuritySettings,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotHistory,
      name: AppRouteNames.sc123BotHistory,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotPerformanceAnalytics,
      name: AppRouteNames.sc124BotPerformanceAnalytics,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotBacktesting,
      name: AppRouteNames.sc125BotBacktesting,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotStrategyCompare,
      name: AppRouteNames.sc126BotStrategyCompare,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotOptimization,
      name: AppRouteNames.sc127BotOptimization,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotPortfolioDashboard,
      name: AppRouteNames.sc128BotPortfolioDashboard,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotDrawdownAnalyzer,
      name: AppRouteNames.sc129BotDrawdownAnalyzer,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotEquityCurve,
      name: AppRouteNames.sc130BotEquityCurve,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotGuide,
      name: AppRouteNames.sc131BotGuide,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotFaq,
      name: AppRouteNames.sc132BotFaq,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotTaxReporting,
      name: AppRouteNames.sc133BotTaxReporting,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotApiDocumentation,
      name: AppRouteNames.sc134BotApiDocumentation,
      builder: legacyPhoneRouteStub,
    ),
  ];
  if (surface != AppSurface.tablet && surface != AppSurface.web) return routes;
  return buildTabletUtilityRouteFamily(
    routes: routes,
    surface: surface!,
    title: 'Trading Bots',
    subtitle: 'Tự động hóa giao dịch và kiểm soát rủi ro trên Tablet',
    description:
        'Không gian Tablet để theo dõi bot, hiệu suất, cấu hình và các điều kiện an toàn.',
    backPath: AppRoutePaths.tradeBots,
    icon: Icons.smart_toy_outlined,
  );
}
