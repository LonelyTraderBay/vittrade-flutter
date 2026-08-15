import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/hub/active_copies_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/safety/copy_audit_log_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/flow/copy_confirmation_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/safety/copy_education_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/flow/copy_configuration_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/hub/copy_notifications_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/analytics/copy_performance_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/provider/copy_provider_detail_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/safety/copy_safety_center_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/hub/copy_settings_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/hub/copy_trading_card_demo.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/safety/dispute_resolution_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/analytics/performance_attribution_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/flow/pre_copy_assessment_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/analytics/portfolio_risk_analysis_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/provider/provider_comparison_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/provider/provider_governance_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/provider/provider_leaderboard_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/provider/provider_application_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/safety/safety_education_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/pages/provider/trader_profile_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> tradeCopyRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.tradeCopyTrading,
      name: AppRouteNames.sc063CopyTrading,
      builder: (_, _) => CopyTradingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyEducation,
      name: AppRouteNames.sc065CopyEducation,
      builder: (_, _) => CopyEducationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyActive,
      name: AppRouteNames.sc066ActiveCopies,
      builder: (_, _) => ActiveCopiesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopySettings,
      name: AppRouteNames.sc067CopySettings,
      builder: (_, _) => CopySettingsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyNotifications,
      name: AppRouteNames.sc068CopyNotifications,
      builder: (_, _) =>
          CopyNotificationsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyProviderApply,
      name: AppRouteNames.sc069ProviderApplication,
      builder: (_, _) =>
          ProviderApplicationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyComparison,
      name: AppRouteNames.sc076ProviderComparison,
      builder: (_, _) =>
          ProviderComparisonPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRiskAnalysis,
      name: AppRouteNames.sc078PortfolioRiskAnalysis,
      builder: (_, _) =>
          PortfolioRiskAnalysisPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyLeaderboard,
      name: AppRouteNames.sc079ProviderLeaderboard,
      builder: (_, _) =>
          ProviderLeaderboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopySafety,
      name: AppRouteNames.sc080SafetyEducation,
      builder: (_, _) => SafetyEducationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyProviderGovernance,
      name: AppRouteNames.sc081ProviderGovernance,
      builder: (_, _) =>
          ProviderGovernancePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyDisputeResolution,
      name: AppRouteNames.sc082DisputeResolution,
      builder: (_, _) =>
          DisputeResolutionPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopySafetyCenter,
      name: AppRouteNames.sc083CopySafetyCenter,
      builder: (_, _) => CopySafetyCenterPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: '/trade/trader/:traderId',
      name: AppRouteNames.sc087TraderProfile,
      builder: (_, state) => TraderProfilePage(
        traderId: requireRouteParam(state, 'traderId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: '/trade/copy-provider/:providerId/assessment',
      name: AppRouteNames.sc071PreCopyAssessment,
      builder: (_, state) {
        final providerId = requireRouteParam(state, 'providerId');
        return PreCopyAssessmentPage(
          providerId: providerId,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: '/trade/copy-provider/:providerId/configuration',
      name: AppRouteNames.sc072CopyConfiguration,
      builder: (_, state) {
        final providerId = requireRouteParam(state, 'providerId');
        final backPath = resolveSafeBackPath(
          candidate: state.uri.queryParameters['back'],
          fallbackPath: AppRoutePaths.tradeCopyProvider(providerId),
          allowedPrefixes: const [AppRoutePaths.trade],
        );
        return CopyConfigurationPage(
          providerId: providerId,
          backPath: backPath,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: '/trade/copy-provider/:providerId/confirmation',
      name: AppRouteNames.sc073CopyConfirmation,
      builder: (_, state) {
        final providerId = requireRouteParam(state, 'providerId');
        return CopyConfirmationPage(
          providerId: providerId,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: '/trade/copy-provider/:providerId',
      name: AppRouteNames.sc070CopyProviderDetail,
      builder: (_, state) {
        final backPath = resolveSafeBackPath(
          candidate: state.uri.queryParameters['back'],
          fallbackPath: AppRoutePaths.tradeCopyTrading,
          allowedPrefixes: const [AppRoutePaths.trade],
        );
        return CopyProviderDetailPage(
          providerId: requireRouteParam(state, 'providerId'),
          backPath: backPath,
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: '/trade/copy-performance/:copyId',
      name: AppRouteNames.sc074CopyPerformance,
      builder: (_, state) {
        return CopyPerformancePage(
          copyId: requireRouteParam(state, 'copyId'),
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: '/trade/copy-performance/:copyId/attribution',
      name: AppRouteNames.sc075PerformanceAttribution,
      builder: (_, state) {
        return PerformanceAttributionPage(
          copyId: requireRouteParam(state, 'copyId'),
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: '/trade/copy-audit-log/:copyId',
      name: AppRouteNames.sc077CopyAuditLog,
      builder: (_, state) {
        return CopyAuditLogPage(
          copyId: requireRouteParam(state, 'copyId'),
          shellRenderMode: shellRenderMode,
        );
      },
    ),
    GoRoute(
      path: AppRoutePaths.demoCopyCard,
      name: AppRouteNames.sc401CopyTradingCardDemo,
      builder: (_, _) => InternalSurfaceGate(
        kind: InternalSurfaceKind.qaDemo,
        routePath: AppRoutePaths.demoCopyCard,
        child: CopyTradingCardDemo(shellRenderMode: shellRenderMode),
      ),
    ),
  ];
  if (surface != AppSurface.tablet) return routes;
  return buildTabletUtilityRouteFamily(
    routes: routes,
    title: 'Copy Trading',
    subtitle: 'Theo dõi nhà giao dịch và quản trị sao chép trên Tablet',
    description:
        'Không gian Tablet để xem nhà cung cấp, đánh giá phù hợp, hiệu suất và các lớp an toàn Copy Trading.',
    backPath: AppRoutePaths.tradeCopyTrading,
    icon: Icons.copy_all_outlined,
    wrapper: (route, child) =>
        route.name == AppRouteNames.sc401CopyTradingCardDemo
        ? InternalSurfaceGate(
            kind: InternalSurfaceKind.qaDemo,
            routePath: route.path,
            child: child,
          )
        : child,
  );
}
