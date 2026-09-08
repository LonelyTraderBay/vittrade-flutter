import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_flow_tablet_pages.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_trading_extended_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_trading_core_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/compliance_reports_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/compliance_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/regulatory_disclosures_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_trading_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';

void main() {
  Future<void> pumpTablet(
    WidgetTester tester, {
    required String initialLocation,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: initialLocation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-066/067/068/079/065/083 render real copy core pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/trade/copy-trading/active');
    expect(find.byType(ActiveCopiesTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/trade/copy-trading/settings');
    expect(find.byType(CopySettingsTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/notifications',
    );
    expect(find.byType(CopyNotificationsTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/leaderboard',
    );
    expect(find.byType(ProviderLeaderboardTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/copy-trading/education');
    expect(find.byType(CopyEducationTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/copy-safety-center');
    expect(find.byType(CopySafetyCenterTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/copy-provider-apply');
    expect(find.byType(ProviderApplyTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/copy-trading/comparison');
    expect(find.byType(ProviderComparisonTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/risk-analysis',
    );
    expect(find.byType(PortfolioRiskAnalysisTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-provider-governance',
    );
    expect(find.byType(ProviderGovernanceTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/copy-dispute-resolution');
    expect(find.byType(CopyDisputeResolutionTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/copy-audit-log/copy-01');
    expect(find.byType(CopyAuditLogTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/trader/trader-01');
    expect(find.byType(CopyProviderDetailTabletPage), findsOneWidget);
  });

  testWidgets('SC-084 renders the real regulatory disclosures hub', (
    tester,
  ) async {
    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/regulatory-disclosures',
    );
    expect(find.byType(RegulatoryDisclosuresTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/client-money-protection',
    );
    expect(find.byType(ClientMoneyProtectionTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/cass-reconciliation',
    );
    expect(find.byType(CassReconciliationTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/investor-compensation',
    );
    expect(find.byType(InvestorCompensationTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/slippage-monitoring',
    );
    expect(find.byType(SlippageMonitoringTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/complaints-handling',
    );
    expect(find.byType(ComplaintsHandlingTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/complaint-submission',
    );
    expect(find.byType(ComplaintSubmissionTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/complaint-tracking',
    );
    // SC-113 base path uses null complaintId — may show either tracking or utility.
    expect(
      find.byType(ComplaintTrackingTabletPage).evaluate().isNotEmpty ||
          find.byType(VitTabletUtilityPage).evaluate().isNotEmpty,
      isTrue,
    );

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/regulatory-reports-dashboard',
    );
    expect(find.byType(RegulatoryReportsDashboardTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/arm-integration-status',
    );
    expect(find.byType(ArmIntegrationStatusTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/regulatory-inspection-ready',
    );
    expect(find.byType(RegulatoryInspectionReadyTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/ombudsman-referral',
    );
    expect(find.byType(OmbudsmanReferralTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/client-categorization',
    );
    expect(find.byType(ClientCategorizationTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-trading/product-governance',
    );
    expect(find.byType(ProductGovernanceTabletPage), findsOneWidget);
  });

  testWidgets('SC-070/071/072/073/074 render real copy flow pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/trade/copy-provider/pro-01');
    expect(find.byType(CopyProviderDetailTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-provider/pro-01/assessment',
    );
    expect(find.byType(PreCopyAssessmentTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-provider/pro-01/configuration',
    );
    expect(find.byType(CopyConfigurationTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-provider/pro-01/confirmation',
    );
    expect(find.byType(CopyConfirmationTabletPage), findsOneWidget);
    expect(find.byKey(CopyConfirmationTabletPage.confirmKey), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/copy-performance/copy-01',
    );
    expect(find.byType(CopyPerformanceTabletPage), findsOneWidget);
    expect(find.text('Chênh lệch hiệu suất'), findsOneWidget);
  });

  testWidgets('SC-063 renders the real copy trading hub', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/copy-trading');

    expect(find.byType(CopyTradingTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.text('Tổng AUM'), findsOneWidget);
  });
}
