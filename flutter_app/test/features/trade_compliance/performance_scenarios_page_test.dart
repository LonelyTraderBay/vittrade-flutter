import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/performance_scenarios_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPerformanceScenarios(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyPerformanceScenarios,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-109 mock repository exposes performance scenarios BE draft',
    () async {
      final snapshot = await const MockTradeRegulatoryRepository(
        loadDelay: Duration.zero,
      ).getPerformanceScenarios();

      expect(snapshot.investment, 10000);
      expect(snapshot.holdingPeriods, [1, 3, 5]);
      expect(snapshot.defaultHoldingPeriod, 3);
      expect(snapshot.scenarios.map((scenario) => scenario.label), [
        'Stress',
        'Unfavorable',
        'Moderate',
        'Favorable',
      ]);
      expect(
        snapshot.scenarios.first.outcomeFor(snapshot.investment, 3).round(),
        4219,
      );
      expect(
        snapshot.endpoint,
        '/api/mobile/trade/trade-copy-trading-performance-scenarios',
      );
      expect(snapshot.actionDraft, contains('POST /copy-trading/follow'));
      expect(
        snapshot.supportedStates,
        containsAll([
          TradeScreenState.loading,
          TradeScreenState.empty,
          TradeScreenState.error,
          TradeScreenState.offline,
          TradeScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-109 renders performance scenarios in Trade shell', (
    tester,
  ) async {
    await pumpPerformanceScenarios(tester);

    expect(find.byType(PerformanceScenariosPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Performance Scenarios'), findsOneWidget);
    expect(find.text('Potential Outcomes'), findsWidgets);
    expect(find.text('Not a Guarantee'), findsOneWidget);
    expect(find.text('\u20AC10,000'), findsOneWidget);
    expect(find.text('3 Years'), findsOneWidget);
    expect(find.text('Stress Scenario'), findsOneWidget);
    expect(find.text('-25% p.a.'), findsOneWidget);
    expect(find.text('Favorable Scenario'), findsOneWidget);
    expect(find.text('+22% p.a.'), findsOneWidget);
  });

  testWidgets('SC-109 first viewport reaches first scenario card', (
    tester,
  ) async {
    await pumpPerformanceScenarios(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-109 PerformanceScenariosPage',
      semanticLabel: 'Các kịch bản hiệu suất đầu tư có thể xảy ra',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PerformanceScenariosPage.scenarioKey('Stress')),
      targetLabel: 'the first performance scenario card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-109 holding period selector recalculates outcomes', (
    tester,
  ) async {
    await pumpPerformanceScenarios(tester);

    await tester.tap(find.byKey(PerformanceScenariosPage.periodKey(1)));
    await tester.pumpAndSettle();

    expect(find.text('Value After 1Y'), findsWidgets);
    expect(find.text('\u20AC7,500'), findsOneWidget);
    expect(find.text('-\u20AC2,500'), findsOneWidget);
  });
}
