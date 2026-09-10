// Batch test tablet sinh từ route group earn_staking (coverage 2026-09-10:
// group + các trang tablet liên quan chưa phủ). Bất biến: mọi route tablet
// render trang thật — không rơi vào VitTabletUtilityPage, không exception.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('earn_staking tablet routes render trang thật (lô 1)', (
    tester,
  ) async {
    final locations = <String>[
      AppRoutePaths.earnStaking,
      AppRoutePaths.earnStakingTerms,
      AppRoutePaths.earnStakingRiskDisclosure,
      AppRoutePaths.earnStakingWithdrawalPolicy,
      AppRoutePaths.earnStakingTaxGuide,
      AppRoutePaths.earnHistory,
      AppRoutePaths.earnStakingRiskAssessment,
      AppRoutePaths.earnDashboard,
      AppRoutePaths.earnAnalytics,
      AppRoutePaths.earnCalendar,
      AppRoutePaths.earnValidatorSelection,
      AppRoutePaths.earnAutoCompound,
      AppRoutePaths.earnLiquidStaking,
      AppRoutePaths.earnInsurance,
      AppRoutePaths.earnAdvancedOrders,
      AppRoutePaths.earnMultiChain,
      AppRoutePaths.earnInstitutional,
      AppRoutePaths.earnGuide,
      AppRoutePaths.earnFAQ,
      AppRoutePaths.earnNotifications,
      AppRoutePaths.earnRecommendations,
      AppRoutePaths.earnRegulatoryFramework,
      AppRoutePaths.earnAuditReports,
    ];
    for (final location in locations) {
      await pumpTablet(tester, location);

      expect(find.byType(VitTabletUtilityPage), findsNothing, reason: location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });

  testWidgets('earn_staking tablet routes render trang thật (lô 2)', (
    tester,
  ) async {
    final locations = <String>[
      AppRoutePaths.earnCustody,
      AppRoutePaths.earnSuitabilityAssessment,
      AppRoutePaths.earnInsuranceFundTransparency,
      AppRoutePaths.earnTransactionReporting,
      AppRoutePaths.earnApiDocumentation,
      AppRoutePaths.earnProofOfReserves,
      AppRoutePaths.earnRiskDashboard,
      AppRoutePaths.earnSlashingHistory,
      AppRoutePaths.earnValidatorHealthMonitor,
      AppRoutePaths.earnRiskScoreCalculator,
      AppRoutePaths.earnEmergencyActions,
      AppRoutePaths.earnContingencyPlan,
      AppRoutePaths.earnSocialFeed,
      AppRoutePaths.earnCommunityGovernance,
      AppRoutePaths.earnProposals,
      AppRoutePaths.earnVotingProposalRoute,
      AppRoutePaths.earnVoting,
      AppRoutePaths.earnForum,
      AppRoutePaths.earnWebhooks,
      AppRoutePaths.earnDataExport,
      AppRoutePaths.earnThirdPartyIntegrations,
      AppRoutePaths.earnDeveloperConsole,
    ];
    for (final location in locations) {
      await pumpTablet(tester, location);

      expect(find.byType(VitTabletUtilityPage), findsNothing, reason: location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}
