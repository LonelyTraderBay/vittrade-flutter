import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_what_if_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpWhatIf(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsWhatIf,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-352 mock repository exposes savings what-if BE draft', () async {
    final snapshot = await const MockSavingsWhatIfRepository().getWhatIf();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-whatif');
    expect(snapshot.actionDraft, contains('whatif/run'));
    expect(snapshot.title, 'What-If Analysis');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs.map((tab) => tab.label), [
      'Kịch bản',
      'Kết quả',
      'Stress Test',
    ]);
    expect(snapshot.defaultScenario, SavingsWhatIfScenarioId.apyCrash);
    expect(snapshot.scenarios, hasLength(6));
    expect(snapshot.portfolio, hasLength(5));
    expect(snapshot.contractNotes, contains('scenario result'));
    expect(snapshot.supportedStates, contains(EarnScreenState.success));
  });

  testWidgets('SC-352 renders scenario planner baseline', (tester) async {
    await pumpWhatIf(tester);

    expect(find.byType(SavingsWhatIfPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('What-If Analysis'), findsOneWidget);
    expect(find.byKey(SavingsWhatIfPage.summaryKey), findsOneWidget);
    expect(find.text('Scenario Planner'), findsOneWidget);
    expect(find.text('\$10,000.00'), findsOneWidget);
    expect(find.text('Chọn kịch bản'), findsOneWidget);
    expect(
      find.byKey(
        SavingsWhatIfPage.scenarioKey(SavingsWhatIfScenarioId.apyCrash),
      ),
      findsOneWidget,
    );
    expect(find.byKey(SavingsWhatIfPage.portfolioKey), findsOneWidget);
    expect(find.text('USDT Linh hoạt'), findsOneWidget);
  });

  testWidgets('SC-352 runs selected scenario and renders results', (
    tester,
  ) async {
    await pumpWhatIf(tester);

    await tester.tap(
      find.byKey(
        SavingsWhatIfPage.scenarioKey(SavingsWhatIfScenarioId.apySpike),
      ),
    );
    await tester.pumpAndSettle();
    final runButton = find.byKey(SavingsWhatIfPage.runKey);
    await Scrollable.ensureVisible(tester.element(runButton), alignment: .82);
    await tester.pumpAndSettle();
    await tester.tap(runButton);
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsWhatIfPage.resultsKey), findsOneWidget);
    expect(find.text('Kịch bản: APY tăng vọt'), findsOneWidget);
    expect(find.text('Ảnh hưởng theo tài sản'), findsOneWidget);
    expect(find.byKey(SavingsWhatIfPage.assetImpactKey), findsOneWidget);
  });

  testWidgets('SC-352 stress tab renders ranking and resilience state', (
    tester,
  ) async {
    await pumpWhatIf(tester);

    await tester.tap(find.text('Stress Test'));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsWhatIfPage.stressKey), findsOneWidget);
    expect(find.text('Stress Test tổng hợp'), findsOneWidget);
    expect(find.text('Xếp hạng theo ảnh hưởng'), findsOneWidget);
    expect(find.text('Đánh giá chống chịu'), findsOneWidget);
  });

  testWidgets('SC-352 savings insight edge opens what-if page', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final whatIfInsight = find.byKey(SavingsPage.whatIfInsightKey);
    await Scrollable.ensureVisible(
      tester.element(whatIfInsight),
      alignment: .65,
    );
    await tester.pumpAndSettle();
    await tester.tap(whatIfInsight);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsWhatIfPage), findsOneWidget);
  });
}
