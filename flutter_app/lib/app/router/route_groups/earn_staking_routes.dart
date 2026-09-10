import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/router/route_error_page.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/entities/earn_entities.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/route_groups/placeholder_routes.dart';
import 'package:vit_trade_flutter/app/router/route_groups/surface_route_helpers.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_insurance_fund_transparency_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_voting_page.dart';

List<RouteBase> earnStakingRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  final routes = <GoRoute>[
    GoRoute(
      path: AppRoutePaths.earn,
      name: AppRouteNames.sc327StakingEarn,
      builder: legacyPhoneRouteStub,
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
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingRiskDisclosure,
      name: AppRouteNames.sc354StakingRiskDisclosure,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingWithdrawalPolicy,
      name: AppRouteNames.sc355StakingWithdrawalPolicy,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingTaxGuide,
      name: AppRouteNames.sc356StakingTaxGuide,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnHistory,
      name: AppRouteNames.sc360StakingHistory,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnStakingRiskAssessment,
      name: AppRouteNames.sc357StakingRiskAssessment,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnDashboard,
      name: AppRouteNames.sc358StakingDashboard,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnAnalytics,
      name: AppRouteNames.sc359StakingAnalytics,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnCalendar,
      name: AppRouteNames.sc361StakingEarningsCalendar,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnValidatorSelection,
      name: AppRouteNames.sc362StakingValidatorSelection,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnAutoCompound,
      name: AppRouteNames.sc363StakingAutoCompound,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnLiquidStaking,
      name: AppRouteNames.sc364StakingLiquidStaking,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnInsurance,
      name: AppRouteNames.sc365StakingInsurance,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnAdvancedOrders,
      name: AppRouteNames.sc366StakingAdvancedOrders,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnMultiChain,
      name: AppRouteNames.sc367StakingMultiChain,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnInstitutional,
      name: AppRouteNames.sc368StakingInstitutional,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnGuide,
      name: AppRouteNames.sc369StakingGuide,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnFAQ,
      name: AppRouteNames.sc370StakingFAQ,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnNotifications,
      name: AppRouteNames.sc371StakingNotifications,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnRecommendations,
      name: AppRouteNames.sc372StakingRecommendations,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnRegulatoryFramework,
      name: AppRouteNames.sc373StakingRegulatoryFramework,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnAuditReports,
      name: AppRouteNames.sc374StakingAuditReports,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnCustody,
      name: AppRouteNames.sc375StakingCustody,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSuitabilityAssessment,
      name: AppRouteNames.sc376StakingSuitabilityAssessment,
      builder: legacyPhoneRouteStub,
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
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnApiDocumentation,
      name: AppRouteNames.sc379StakingApiDocumentation,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnProofOfReserves,
      name: AppRouteNames.sc380StakingProofOfReserves,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnRiskDashboard,
      name: AppRouteNames.sc381StakingRiskDashboard,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSlashingHistory,
      name: AppRouteNames.sc382StakingSlashingHistory,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnValidatorHealthMonitor,
      name: AppRouteNames.sc383StakingValidatorHealthMonitor,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnRiskScoreCalculator,
      name: AppRouteNames.sc384StakingRiskScoreCalculator,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnEmergencyActions,
      name: AppRouteNames.sc385StakingEmergencyActions,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnContingencyPlan,
      name: AppRouteNames.sc386StakingContingencyPlan,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnSocialFeed,
      name: AppRouteNames.sc387StakingSocialFeed,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnCommunityGovernance,
      name: AppRouteNames.sc388StakingCommunityGovernance,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnProposals,
      name: AppRouteNames.sc389StakingProposals,
      builder: legacyPhoneRouteStub,
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
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnForum,
      name: AppRouteNames.sc392StakingForum,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnWebhooks,
      name: AppRouteNames.sc393StakingWebhooks,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnDataExport,
      name: AppRouteNames.sc394StakingDataExport,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnThirdPartyIntegrations,
      name: AppRouteNames.sc395StakingThirdPartyIntegrations,
      builder: legacyPhoneRouteStub,
    ),
    GoRoute(
      path: AppRoutePaths.earnDeveloperConsole,
      name: AppRouteNames.sc396StakingDeveloperConsole,
      builder: legacyPhoneRouteStub,
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
