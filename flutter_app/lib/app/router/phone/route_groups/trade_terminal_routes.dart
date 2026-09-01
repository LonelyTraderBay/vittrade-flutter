// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_analytics_page.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_chart_page.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_tools_demo_page.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_trading_demo_page.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/execution_quality_demo_page.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/risk_management_demo_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_route_helpers.dart';

List<RouteBase> tradeTerminalRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(
      path: '/trade/advanced-chart/:pairId',
      name: AppRouteNames.sc055AdvancedChart,
      builder: (context, state) => _phoneTradeTerminalRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc055AdvancedChart,
        fallback: AdvancedChartPage(
          // SEC-S45: default hợp lý UX (chợ/tài sản mặc định, không phải thực thể riêng tư) — giữ.
          pairId: state.pathParameters['pairId'] ?? 'btcusdt',
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeRiskManagement,
      name: AppRouteNames.sc060RiskManagement,
      builder: (context, _) => _phoneTradeTerminalRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc060RiskManagement,
        fallback: RiskManagementDemoPage(shellRenderMode: shellRenderMode),
        requiresConfirmation: true,
        actionLabel: 'Rà soát rủi ro',
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeExecutionQuality,
      name: AppRouteNames.sc061ExecutionQuality,
      builder: (context, _) => _phoneTradeTerminalRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc061ExecutionQuality,
        fallback: ExecutionQualityDemoPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeAdvancedTools,
      name: AppRouteNames.sc062AdvancedTools,
      builder: (context, _) => _phoneTradeTerminalRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc062AdvancedTools,
        fallback: AdvancedToolsDemoPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginAdvancedDemo,
      name: AppRouteNames.sc088AdvancedTradingDemo,
      builder: (context, _) => _phoneTradeTerminalRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc088AdvancedTradingDemo,
        fallback: AdvancedTradingDemoPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginAdvancedAnalytics,
      name: AppRouteNames.sc092AdvancedAnalytics,
      builder: (context, _) => _phoneTradeTerminalRoute(
        context: context,
        semanticIdentifier: AppRouteNames.sc092AdvancedAnalytics,
        fallback: AdvancedAnalyticsPage(shellRenderMode: shellRenderMode),
      ),
    ),
  ];
}

Widget _phoneTradeTerminalRoute({
  required BuildContext context,

  required String semanticIdentifier,
  required Widget fallback,
  bool requiresConfirmation = false,
  String? actionLabel,
}) {
  return buildPhoneRoute(
    context: context,
    semanticIdentifier: semanticIdentifier,
    title: 'Terminal giao dịch',
    subtitle: 'Công cụ nâng cao trên Phone',
    description:
        'Bảng điều khiển Phone dành cho phân tích, thực thi và kiểm soát rủi ro giao dịch.',
    backPath: AppRoutePaths.trade,
    fallback: fallback,
    requiresConfirmation: requiresConfirmation,
    actionLabel: actionLabel,
    icon: Icons.candlestick_chart_outlined,
  );
}
