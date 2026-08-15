import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/client_money/arm_integration_status_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/governance/audit_trail_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/execution/best_execution_reports_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/client_money/cass_reconciliation_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/governance/client_categorization_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/client_money/client_money_protection_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/complaints/complaint_submission_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/complaints/complaint_tracking_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/complaints/complaints_handling_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/disclosures/ex_ante_costs_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/disclosures/ex_post_costs_report_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/execution/execution_venue_analysis_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/client_money/investor_compensation_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/disclosures/kid_generator_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/execution/live_market_data_analytics_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/execution/market_data_analytics_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/complaints/ombudsman_referral_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/disclosures/performance_scenarios_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/governance/product_governance_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/disclosures/regulatory_disclosures_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/governance/regulatory_inspection_ready_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/hub/regulatory_reports_dashboard_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/disclosures/risk_indicator_explainer_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/disclosures/riy_calculator_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/execution/slippage_monitoring_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/governance/target_market_definition_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/pages/governance/transaction_reporting_page.dart';
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
      builder: (_, _) =>
          RegulatoryDisclosuresPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyTransactionReporting,
      name: AppRouteNames.sc093TransactionReporting,
      builder: (_, _) =>
          TransactionReportingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
      name: AppRouteNames.sc094RegulatoryReportsDashboard,
      builder: (_, _) =>
          RegulatoryReportsDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyArmIntegrationStatus,
      name: AppRouteNames.sc095ArmIntegrationStatus,
      builder: (_, _) =>
          ArmIntegrationStatusPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyBestExecutionReports,
      name: AppRouteNames.sc096BestExecutionReports,
      builder: (_, _) =>
          BestExecutionReportsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyExecutionVenueAnalysis,
      name: AppRouteNames.sc097ExecutionVenueAnalysis,
      builder: (_, _) =>
          ExecutionVenueAnalysisPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopySlippageMonitoring,
      name: AppRouteNames.sc098SlippageMonitoring,
      builder: (_, _) =>
          SlippageMonitoringPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyClientCategorization,
      name: AppRouteNames.sc099ClientCategorization,
      builder: (_, _) =>
          ClientCategorizationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyProductGovernance,
      name: AppRouteNames.sc100ProductGovernance,
      builder: (_, _) =>
          ProductGovernancePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyTargetMarketDefinition,
      name: AppRouteNames.sc101TargetMarketDefinition,
      builder: (_, _) =>
          TargetMarketDefinitionPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) =>
          ClientMoneyProtectionPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyCassReconciliation,
      name: AppRouteNames.sc103CassReconciliation,
      builder: (_, _) =>
          CassReconciliationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyInvestorCompensation,
      name: AppRouteNames.sc104InvestorCompensation,
      builder: (_, _) =>
          InvestorCompensationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyExAnteCosts,
      name: AppRouteNames.sc105ExAnteCosts,
      builder: (_, _) => ExAnteCostsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRiyCalculator,
      name: AppRouteNames.sc106RiyCalculator,
      builder: (_, _) => RIYCalculatorPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyExPostCostsReport,
      name: AppRouteNames.sc107ExPostCostsReport,
      builder: (_, _) =>
          ExPostCostsReportPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyKidGenerator,
      name: AppRouteNames.sc108KidGenerator,
      builder: (_, _) => KIDGeneratorPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyPerformanceScenarios,
      name: AppRouteNames.sc109PerformanceScenarios,
      builder: (_, _) =>
          PerformanceScenariosPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRiskIndicatorExplainer,
      name: AppRouteNames.sc110RiskIndicatorExplainer,
      builder: (_, _) =>
          RiskIndicatorExplainerPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyComplaintsHandling,
      name: AppRouteNames.sc111ComplaintsHandling,
      builder: (_, _) =>
          ComplaintsHandlingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyComplaintSubmission,
      name: AppRouteNames.sc112ComplaintSubmission,
      builder: (_, _) =>
          ComplaintSubmissionPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyComplaintTrackingBase,
      name: AppRouteNames.sc113ComplaintTracking,
      builder: (_, _) =>
          ComplaintTrackingPage(shellRenderMode: shellRenderMode),
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
      builder: (_, _) =>
          OmbudsmanReferralPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyAuditTrail,
      name: AppRouteNames.sc115AuditTrail,
      builder: (_, _) => AuditTrailPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyRegulatoryInspectionReady,
      name: AppRouteNames.sc116RegulatoryInspectionReady,
      builder: (_, _) =>
          RegulatoryInspectionReadyPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeCopyClientOptUpRequest,
      name: AppRouteNames.sc411ClientOptUpRequest,
      builder: (_, _) =>
          ClientOptUpRequestPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginMarketDataAnalytics,
      name: AppRouteNames.sc089MarketDataAnalytics,
      builder: (_, _) =>
          MarketDataAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.tradeMarginLiveMarketDataAnalytics,
      name: AppRouteNames.sc091LiveMarketDataAnalytics,
      builder: (_, _) =>
          LiveMarketDataAnalyticsPage(shellRenderMode: shellRenderMode),
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
