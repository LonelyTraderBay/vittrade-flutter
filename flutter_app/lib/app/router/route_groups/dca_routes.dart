import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/hub/dca_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_rebalance_dashboard_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_rebalance_config_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/research/dca_backtester_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/research/dca_dynamic_amount_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_multi_asset_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_performance_compare_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_portfolio_optimizer_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/schedule/dca_schedule_analytics_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/schedule/dca_schedule_config_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/schedule/dca_smart_rules_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> dcaRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  return [
    GoRoute(
      path: AppRoutePaths.dca,
      name: AppRouteNames.sc169Dca,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc169Dca,
        fallback: DCAPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaPortfolioOptimizer,
      name: AppRouteNames.sc174DcaPortfolioOptimizer,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc174DcaPortfolioOptimizer,
        fallback: DCAPortfolioOptimizerPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaDynamicAmount,
      name: AppRouteNames.sc175DcaDynamicAmount,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc175DcaDynamicAmount,
        fallback: DCADynamicAmountPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaBacktester,
      name: AppRouteNames.sc176DcaBacktester,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc176DcaBacktester,
        fallback: DCABacktesterPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaMultiAsset,
      name: AppRouteNames.sc177DcaMultiAsset,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc177DcaMultiAsset,
        fallback: DCAMultiAssetPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaPerformanceCompare,
      name: AppRouteNames.sc178DcaPerformanceCompare,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc178DcaPerformanceCompare,
        fallback: DCAPerformanceComparePage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaSmartRules,
      name: AppRouteNames.sc179DcaSmartRules,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc179DcaSmartRules,
        fallback: DCASmartRulesPage(shellRenderMode: shellRenderMode),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaRebalanceConfig,
      name: AppRouteNames.sc170DcaRebalanceConfig,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc170DcaRebalanceConfig,
        fallback: DCARebalanceConfigPage(shellRenderMode: shellRenderMode),
        requiresConfirmation: true,
        actionLabel: 'Rà soát cấu hình',
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaRebalanceDashboard,
      name: AppRouteNames.sc171DcaRebalanceDashboard,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc171DcaRebalanceDashboard,
        fallback: DCARebalanceDashboardPage(
          configId: 'config001',
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaScheduleConfig,
      name: AppRouteNames.sc172DcaScheduleConfig,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc172DcaScheduleConfig,
        fallback: DCAScheduleConfigPage(shellRenderMode: shellRenderMode),
        requiresConfirmation: true,
        actionLabel: 'Rà soát lịch',
      ),
    ),
    GoRoute(
      path: AppRoutePaths.dcaScheduleAnalytics,
      name: AppRouteNames.sc173DcaScheduleAnalytics,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc173DcaScheduleAnalytics,
        fallback: DCAScheduleAnalyticsPage(
          configId: 'config001',
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
    GoRoute(
      path: '/dca/rebalance/:configId/edit',
      name: AppRouteNames.sc408DcaRebalanceEdit,
      builder: (context, _) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc408DcaRebalanceEdit,
        fallback: DCARebalanceConfigPage(shellRenderMode: shellRenderMode),
        requiresConfirmation: true,
        actionLabel: 'Rà soát chỉnh sửa',
      ),
    ),
    GoRoute(
      path: '/dca/rebalance/:configId/history',
      name: AppRouteNames.sc409DcaRebalanceHistory,
      builder: (context, state) => _tabletDcaRoute(
        context: context,
        surface: surface,
        semanticIdentifier: AppRouteNames.sc409DcaRebalanceHistory,
        fallback: DCARebalanceDashboardPage(
          configId: requireRouteParam(state, 'configId'),
          shellRenderMode: shellRenderMode,
        ),
      ),
    ),
  ];
}

Widget _tabletDcaRoute({
  required BuildContext context,
  required AppSurface? surface,
  required String semanticIdentifier,
  required Widget fallback,
  bool requiresConfirmation = false,
  String? actionLabel,
}) {
  return buildSurfaceAwareTabletRoute(
    context: context,
    surface: surface,
    semanticIdentifier: semanticIdentifier,
    title: 'DCA',
    subtitle: 'Chiến lược phân bổ định kỳ trên Tablet',
    description:
        'Không gian Tablet để theo dõi cấu hình, lịch thực hiện và hiệu suất DCA.',
    backPath: AppRoutePaths.dca,
    fallback: fallback,
    requiresConfirmation: requiresConfirmation,
    actionLabel: actionLabel,
    icon: Icons.autorenew_rounded,
  );
}
