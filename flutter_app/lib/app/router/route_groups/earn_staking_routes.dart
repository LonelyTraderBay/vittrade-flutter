import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_community_governance_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_contingency_plan_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_emergency_actions_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_forum_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_analytics_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_advanced_orders_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_auto_compound_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earnings_calendar_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_history_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_insurance_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_institutional_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_guide_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_faq_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_notifications_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_recommendations_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_regulatory_framework_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_audit_reports_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_custody_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_data_export_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_developer_console_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_api_documentation_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_insurance_fund_transparency_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_proof_of_reserves_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_proposals_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_score_calculator_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_slashing_history_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_social_feed_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_suitability_assessment_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_transaction_reporting_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_third_party_integrations_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_voting_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_webhooks_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_liquid_staking_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_multi_chain_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_disclosure_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_assessment_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_tax_guide_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_terms_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_validator_health_monitor_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_validator_selection_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_withdrawal_policy_page.dart';

List<RouteBase> earnStakingRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.earn,
      name: AppRouteNames.sc327StakingEarn,
      builder: (_, _) => StakingEarnPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnStaking,
      name: AppRouteNames.sc328StakingEarnStaking,
      builder: (_, _) => StakingEarnPage(
        shellRenderMode: shellRenderMode,
        route: StakingEarnRoute.staking,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingTerms,
      name: AppRouteNames.sc353StakingTerms,
      builder: (_, _) => StakingTermsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingRiskDisclosure,
      name: AppRouteNames.sc354StakingRiskDisclosure,
      builder: (_, _) =>
          StakingRiskDisclosurePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingWithdrawalPolicy,
      name: AppRouteNames.sc355StakingWithdrawalPolicy,
      builder: (_, _) =>
          StakingWithdrawalPolicyPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingTaxGuide,
      name: AppRouteNames.sc356StakingTaxGuide,
      builder: (_, _) => StakingTaxGuidePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnHistory,
      name: AppRouteNames.sc360StakingHistory,
      builder: (_, _) => StakingHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingRiskAssessment,
      name: AppRouteNames.sc357StakingRiskAssessment,
      builder: (_, _) =>
          StakingRiskAssessmentPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnDashboard,
      name: AppRouteNames.sc358StakingDashboard,
      builder: (_, _) => StakingDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnAnalytics,
      name: AppRouteNames.sc359StakingAnalytics,
      builder: (_, _) => StakingAnalyticsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnCalendar,
      name: AppRouteNames.sc361StakingEarningsCalendar,
      builder: (_, _) =>
          StakingEarningsCalendarPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnValidatorSelection,
      name: AppRouteNames.sc362StakingValidatorSelection,
      builder: (_, _) =>
          StakingValidatorSelectionPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnAutoCompound,
      name: AppRouteNames.sc363StakingAutoCompound,
      builder: (_, _) =>
          StakingAutoCompoundPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnLiquidStaking,
      name: AppRouteNames.sc364StakingLiquidStaking,
      builder: (_, _) =>
          StakingLiquidStakingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnInsurance,
      name: AppRouteNames.sc365StakingInsurance,
      builder: (_, _) => StakingInsurancePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnAdvancedOrders,
      name: AppRouteNames.sc366StakingAdvancedOrders,
      builder: (_, _) =>
          StakingAdvancedOrdersPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnMultiChain,
      name: AppRouteNames.sc367StakingMultiChain,
      builder: (_, _) =>
          StakingMultiChainPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnInstitutional,
      name: AppRouteNames.sc368StakingInstitutional,
      builder: (_, _) =>
          StakingInstitutionalPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnGuide,
      name: AppRouteNames.sc369StakingGuide,
      builder: (_, _) => StakingGuidePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnFAQ,
      name: AppRouteNames.sc370StakingFAQ,
      builder: (_, _) => StakingFAQPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnNotifications,
      name: AppRouteNames.sc371StakingNotifications,
      builder: (_, _) =>
          StakingNotificationsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnRecommendations,
      name: AppRouteNames.sc372StakingRecommendations,
      builder: (_, _) =>
          StakingRecommendationsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnRegulatoryFramework,
      name: AppRouteNames.sc373StakingRegulatoryFramework,
      builder: (_, _) =>
          StakingRegulatoryFrameworkPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnAuditReports,
      name: AppRouteNames.sc374StakingAuditReports,
      builder: (_, _) =>
          StakingAuditReportsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnCustody,
      name: AppRouteNames.sc375StakingCustody,
      builder: (_, _) => StakingCustodyPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSuitabilityAssessment,
      name: AppRouteNames.sc376StakingSuitabilityAssessment,
      builder: (_, _) =>
          StakingSuitabilityAssessmentPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnInsuranceFundTransparency,
      name: AppRouteNames.sc377StakingInsuranceFundTransparency,
      builder: (_, _) => StakingInsuranceFundTransparencyPage(
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.earnTransactionReporting,
      name: AppRouteNames.sc378StakingTransactionReporting,
      builder: (_, _) =>
          StakingTransactionReportingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnApiDocumentation,
      name: AppRouteNames.sc379StakingApiDocumentation,
      builder: (_, _) =>
          StakingApiDocumentationPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnProofOfReserves,
      name: AppRouteNames.sc380StakingProofOfReserves,
      builder: (_, _) =>
          StakingProofOfReservesPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnRiskDashboard,
      name: AppRouteNames.sc381StakingRiskDashboard,
      builder: (_, _) =>
          StakingRiskDashboardPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSlashingHistory,
      name: AppRouteNames.sc382StakingSlashingHistory,
      builder: (_, _) =>
          StakingSlashingHistoryPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnValidatorHealthMonitor,
      name: AppRouteNames.sc383StakingValidatorHealthMonitor,
      builder: (_, _) =>
          StakingValidatorHealthMonitorPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnRiskScoreCalculator,
      name: AppRouteNames.sc384StakingRiskScoreCalculator,
      builder: (_, _) =>
          StakingRiskScoreCalculatorPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnEmergencyActions,
      name: AppRouteNames.sc385StakingEmergencyActions,
      builder: (_, _) =>
          StakingEmergencyActionsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnContingencyPlan,
      name: AppRouteNames.sc386StakingContingencyPlan,
      builder: (_, _) =>
          StakingContingencyPlanPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnSocialFeed,
      name: AppRouteNames.sc387StakingSocialFeed,
      builder: (_, _) =>
          StakingSocialFeedPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnCommunityGovernance,
      name: AppRouteNames.sc388StakingCommunityGovernance,
      builder: (_, _) =>
          StakingCommunityGovernancePage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnProposals,
      name: AppRouteNames.sc389StakingProposals,
      builder: (_, _) => StakingProposalsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnVotingProposalRoute,
      name: AppRouteNames.sc390StakingVotingDetail,
      builder: (_, state) => StakingVotingPage(
        proposalId: requireRouteParam(state, 'proposalId'),
        shellRenderMode: shellRenderMode,
      ),
    ),
    GoRoute(
      path: AppRoutePaths.earnVoting,
      name: AppRouteNames.sc391StakingVoting,
      builder: (_, _) => StakingVotingPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnForum,
      name: AppRouteNames.sc392StakingForum,
      builder: (_, _) => StakingForumPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnWebhooks,
      name: AppRouteNames.sc393StakingWebhooks,
      builder: (_, _) => StakingWebhooksPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnDataExport,
      name: AppRouteNames.sc394StakingDataExport,
      builder: (_, _) =>
          StakingDataExportPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnThirdPartyIntegrations,
      name: AppRouteNames.sc395StakingThirdPartyIntegrations,
      builder: (_, _) =>
          StakingThirdPartyIntegrationsPage(shellRenderMode: shellRenderMode),
    ),
    GoRoute(
      path: AppRoutePaths.earnDeveloperConsole,
      name: AppRouteNames.sc396StakingDeveloperConsole,
      builder: (_, _) =>
          StakingDeveloperConsolePage(shellRenderMode: shellRenderMode),
    ),
    ...earnRiskOutgoingPlaceholders,
  ];
  if (surface != AppSurface.tablet && surface != AppSurface.web) return routes;
  return buildTabletUtilityRouteFamily(
    routes: routes,
    surface: surface!,
    title: 'Earn Staking',
    subtitle: 'Staking, validator và quản trị rủi ro trên Tablet',
    description:
        'Không gian Tablet để theo dõi lợi suất staking, validator, bảo chứng và các chính sách liên quan.',
    backPath: AppRoutePaths.earn,
    icon: Icons.account_balance_outlined,
  );
}
