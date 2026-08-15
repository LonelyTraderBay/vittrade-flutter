import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_api_documentation_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/backtest/bot_backtesting_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/dashboard/bot_drawdown_analyzer_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/dashboard/bot_equity_curve_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_faq_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_guide_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/dashboard/bot_history_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/backtest/bot_optimization_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/dashboard/bot_performance_analytics_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/dashboard/bot_portfolio_dashboard_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/backtest/bot_strategy_compare_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_tax_reporting_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_emergency_stop_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/dashboard/bot_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_risk_disclosure_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_security_settings_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_suitability_assessment_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/settings/bot_terms_of_service_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/pages/hub/trading_bots_page.dart';
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
      builder: (_, _) => TradingBotsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotTermsOfService,
      name: AppRouteNames.sc117BotTermsOfService,
      builder: (_, _) =>
          BotTermsOfServicePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotRiskDisclosure,
      name: AppRouteNames.sc118BotRiskDisclosure,
      builder: (_, _) =>
          BotRiskDisclosurePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotSuitabilityAssessment,
      name: AppRouteNames.sc119BotSuitabilityAssessment,
      builder: (_, _) =>
          BotSuitabilityAssessmentPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotRiskDashboard,
      name: AppRouteNames.sc120BotRiskDashboard,
      builder: (_, _) => BotRiskDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotEmergencyStop,
      name: AppRouteNames.sc121BotEmergencyStop,
      builder: (_, _) => BotEmergencyStopPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotSecuritySettings,
      name: AppRouteNames.sc122BotSecuritySettings,
      builder: (_, _) =>
          BotSecuritySettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotHistory,
      name: AppRouteNames.sc123BotHistory,
      builder: (_, _) => BotHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotPerformanceAnalytics,
      name: AppRouteNames.sc124BotPerformanceAnalytics,
      builder: (_, _) =>
          BotPerformanceAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotBacktesting,
      name: AppRouteNames.sc125BotBacktesting,
      builder: (_, _) => BotBacktestingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotStrategyCompare,
      name: AppRouteNames.sc126BotStrategyCompare,
      builder: (_, _) =>
          BotStrategyComparePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotOptimization,
      name: AppRouteNames.sc127BotOptimization,
      builder: (_, _) => BotOptimizationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotPortfolioDashboard,
      name: AppRouteNames.sc128BotPortfolioDashboard,
      builder: (_, _) =>
          BotPortfolioDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotDrawdownAnalyzer,
      name: AppRouteNames.sc129BotDrawdownAnalyzer,
      builder: (_, _) =>
          BotDrawdownAnalyzerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotEquityCurve,
      name: AppRouteNames.sc130BotEquityCurve,
      builder: (_, _) => BotEquityCurvePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotGuide,
      name: AppRouteNames.sc131BotGuide,
      builder: (_, _) => BotGuidePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotFaq,
      name: AppRouteNames.sc132BotFaq,
      builder: (_, _) => BotFaqPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotTaxReporting,
      name: AppRouteNames.sc133BotTaxReporting,
      builder: (_, _) => BotTaxReportingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeBotApiDocumentation,
      name: AppRouteNames.sc134BotApiDocumentation,
      builder: (_, _) =>
          BotApiDocumentationPage(shellRenderMode: shellRenderMode),
    ),
  ];
  if (surface != AppSurface.tablet) return routes;
  return buildTabletUtilityRouteFamily(
    routes: routes,
    title: 'Trading Bots',
    subtitle: 'Tự động hóa giao dịch và kiểm soát rủi ro trên Tablet',
    description:
        'Không gian Tablet để theo dõi bot, hiệu suất, cấu hình và các điều kiện an toàn.',
    backPath: AppRoutePaths.tradeBots,
    icon: Icons.smart_toy_outlined,
  );
}
