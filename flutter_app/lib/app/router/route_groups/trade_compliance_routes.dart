import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/complaints/complaint_tracking_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/governance/target_market_definition_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';

List<RouteBase> tradeComplianceRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.tradeCopyRegulatoryDisclosures,
      name: AppRouteNames.sc084RegulatoryDisclosures,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyTransactionReporting,
      name: AppRouteNames.sc093TransactionReporting,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
      name: AppRouteNames.sc094RegulatoryReportsDashboard,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyArmIntegrationStatus,
      name: AppRouteNames.sc095ArmIntegrationStatus,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyBestExecutionReports,
      name: AppRouteNames.sc096BestExecutionReports,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyExecutionVenueAnalysis,
      name: AppRouteNames.sc097ExecutionVenueAnalysis,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopySlippageMonitoring,
      name: AppRouteNames.sc098SlippageMonitoring,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyClientCategorization,
      name: AppRouteNames.sc099ClientCategorization,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyProductGovernance,
      name: AppRouteNames.sc100ProductGovernance,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyTargetMarketDefinition,
      name: AppRouteNames.sc101TargetMarketDefinition,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: '${AppRoutePaths.tradeCopyTargetMarketDefinition}/:productId',
      name: AppRouteNames.sc415TargetMarketDefinitionDetail,
      builder: (_, state) => TargetMarketDefinitionPage(
        productId: requireRouteParam(state, 'productId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyClientMoneyProtection,
      name: AppRouteNames.sc102ClientMoneyProtection,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyCassReconciliation,
      name: AppRouteNames.sc103CassReconciliation,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyInvestorCompensation,
      name: AppRouteNames.sc104InvestorCompensation,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyExAnteCosts,
      name: AppRouteNames.sc105ExAnteCosts,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRiyCalculator,
      name: AppRouteNames.sc106RiyCalculator,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyExPostCostsReport,
      name: AppRouteNames.sc107ExPostCostsReport,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyKidGenerator,
      name: AppRouteNames.sc108KidGenerator,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyPerformanceScenarios,
      name: AppRouteNames.sc109PerformanceScenarios,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRiskIndicatorExplainer,
      name: AppRouteNames.sc110RiskIndicatorExplainer,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyComplaintsHandling,
      name: AppRouteNames.sc111ComplaintsHandling,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyComplaintSubmission,
      name: AppRouteNames.sc112ComplaintSubmission,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyComplaintTrackingBase,
      name: AppRouteNames.sc113ComplaintTracking,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: '/trade/copy-trading/complaint-tracking/:complaintId',
      name: AppRouteNames.sc416ComplaintTrackingDetail,
      builder: (_, state) => ComplaintTrackingPage(
        complaintId: state.pathParameters['complaintId'],
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyOmbudsmanReferral,
      name: AppRouteNames.sc114OmbudsmanReferral,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyAuditTrail,
      name: AppRouteNames.sc115AuditTrail,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRegulatoryInspectionReady,
      name: AppRouteNames.sc116RegulatoryInspectionReady,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyClientOptUpRequest,
      name: AppRouteNames.sc411ClientOptUpRequest,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginMarketDataAnalytics,
      name: AppRouteNames.sc089MarketDataAnalytics,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
      name: AppRouteNames.sc091LiveMarketDataAnalytics,
      builder: legacyPhoneRouteStub,
    ),
  ];
  if (surface != AppSurface.tablet && surface != AppSurface.web) return routes;
  return buildTabletUtilityRouteFamily(
    routes: routes,
    surface: surface!,
    title: 'Tuân thủ giao dịch',
    subtitle: 'Báo cáo, công bố và kiểm soát tuân thủ trên Tablet',
    description:
        'Không gian Tablet để theo dõi báo cáo thực thi, chi phí, khiếu nại và nghĩa vụ tuân thủ.',
    backPath: AppRoutePaths.trade,
    icon: Icons.gavel_outlined,
  );
}
