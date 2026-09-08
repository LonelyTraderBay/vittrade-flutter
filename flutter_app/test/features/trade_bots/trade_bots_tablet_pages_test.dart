import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/tablet/pages/trade_bots_tablet_pages.dart';

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

  testWidgets('SC-124 hub + SC-128 risk + SC-129 emergency render real pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/trade/bots');
    expect(find.byType(TradingBotsTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);

    await pumpTablet(tester, initialLocation: '/trade/bots/risk-dashboard');
    expect(find.byType(BotRiskDashboardTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/emergency-stop');
    expect(find.byType(BotEmergencyStopTabletPage), findsOneWidget);
  });

  testWidgets('SC-125/126/127/130/131/132 render real bot lifecycle pages', (
    tester,
  ) async {
    await pumpTablet(tester, initialLocation: '/trade/bots/terms-of-service');
    expect(find.byType(BotTermsOfServiceTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/risk-disclosure');
    expect(find.byType(BotRiskDisclosureTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/bots/suitability-assessment',
    );
    expect(find.byType(BotSuitabilityAssessmentTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/security-settings');
    expect(find.byType(BotSecuritySettingsTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/history');
    expect(find.byType(BotHistoryTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/bots/performance-analytics',
    );
    expect(find.byType(BotPerformanceAnalyticsTabletPage), findsOneWidget);
  });

  testWidgets('SC-133→137 render real bot analytics pages', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/bots/backtesting');
    expect(find.byType(BotBacktestingTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/strategy-compare');
    expect(find.byType(BotStrategyCompareTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/optimization');
    expect(find.byType(BotOptimizationTabletPage), findsOneWidget);

    await pumpTablet(
      tester,
      initialLocation: '/trade/bots/portfolio-dashboard',
    );
    expect(find.byType(BotPortfolioDashboardTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/drawdown-analyzer');
    expect(find.byType(BotDrawdownAnalyzerTabletPage), findsOneWidget);
  });

  testWidgets('SC-138→142 render real bot docs pages', (tester) async {
    await pumpTablet(tester, initialLocation: '/trade/bots/equity-curve');
    expect(find.byType(BotEquityCurveTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/guide');
    expect(find.byType(BotGuideTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/faq');
    expect(find.byType(BotFaqTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/tax-reporting');
    expect(find.byType(BotTaxReportingTabletPage), findsOneWidget);

    await pumpTablet(tester, initialLocation: '/trade/bots/api-documentation');
    expect(find.byType(BotApiDocumentationTabletPage), findsOneWidget);
  });
}
