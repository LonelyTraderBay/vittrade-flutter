import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/tablet/pages/earn_savings_tablet_pages.dart';

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

  testWidgets('SC-296→300 render real savings core pages', (tester) async {
    await pumpTablet(tester, initialLocation: '/earn/savings');
    expect(find.byType(SavingsHubTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/earn/savings/portfolio');
    expect(find.byType(SavingsPortfolioTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/history');
    expect(find.byType(SavingsHistoryTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/guide');
    expect(find.byType(SavingsGuideTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/faq');
    expect(find.byType(SavingsFaqTabletPage), findsOneWidget);
  });

  testWidgets('SC-302→317 render real savings tool pages', (tester) async {
    await pumpTablet(tester, initialLocation: '/earn/savings/goals');
    expect(find.byType(SavingsGoalsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/analytics');
    expect(find.byType(SavingsAnalyticsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/rebalance');
    expect(find.byType(SavingsRebalanceTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/earn/savings/notification-preferences',
    );
    expect(
      find.byType(SavingsNotificationPreferencesTabletPage),
      findsOneWidget,
    );

    await pumpTablet(tester, initialLocation: '/earn/savings/dca');
    expect(find.byType(SavingsDcaTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/earn/savings/smart-suggestions',
    );
    expect(find.byType(SavingsSmartSuggestionsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/export');
    expect(find.byType(SavingsExportTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/backtest');
    expect(find.byType(SavingsBacktestTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/autopilot');
    expect(find.byType(SavingsAutoPilotTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/ladder');
    expect(find.byType(SavingsLadderTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/whatif');
    expect(find.byType(SavingsWhatIfTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/notifications');
    expect(find.byType(SavingsNotificationsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/recommendations');
    expect(find.byType(SavingsRecommendationsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/risk-assessment');
    expect(find.byType(SavingsRiskAssessmentTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/comparison');
    expect(find.byType(SavingsComparisonTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/auto-compound');
    expect(find.byType(AutoCompoundSettingsTabletPage), findsOneWidget);
  });

  testWidgets('SC-330/331/332 render real sample product flow', (tester) async {
    await pumpTablet(tester, initialLocation: '/earn/savings/product/sample');
    expect(find.byType(SavingsProductSampleTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/earn/savings/redeem/pos001');
    expect(find.byType(SavingsRedeemTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/earn/savings/receipt');
    expect(find.byType(SavingsReceiptTabletPage), findsOneWidget);
  });
}
