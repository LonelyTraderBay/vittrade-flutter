import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_backtest_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_recommendations_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpBacktest(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsBacktest,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-349 mock repository exposes savings backtest BE draft', () async {
    final snapshot = await const MockSavingsBacktestRepository().getBacktest();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-backtest');
    expect(snapshot.actionDraft, contains('backtest/run'));
    expect(snapshot.title, 'Mô phỏng đầu tư');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(
      snapshot.recommendationsRoute,
      AppRoutePaths.earnSavingsRecommendations,
    );
    expect(snapshot.tabs.map((tab) => tab.label), [
      'Thiết lập',
      'Kết quả',
      'So sánh',
    ]);
    expect(snapshot.defaultAmountUsd, 10000);
    expect(snapshot.defaultPeriod, SavingsBacktestPeriod.oneYear);
    expect(snapshot.defaultPreset, SavingsBacktestPreset.balanced);
    expect(snapshot.periods, hasLength(4));
    expect(snapshot.presets, hasLength(4));
    expect(snapshot.result.points, hasLength(12));
    expect(snapshot.contractNotes, contains('allocation presets'));
    expect(snapshot.supportedStates, contains(EarnScreenState.success));
  });

  testWidgets('SC-349 renders backtest setup baseline', (tester) async {
    await pumpBacktest(tester);

    expect(find.byType(SavingsBacktestPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Mô phỏng đầu tư'), findsOneWidget);
    expect(find.byKey(SavingsBacktestPage.summaryKey), findsOneWidget);
    expect(find.text('Backtest Simulator'), findsOneWidget);
    expect(find.text('\$10,000.00'), findsOneWidget);
    expect(find.text('Thiết lập'), findsOneWidget);
    expect(find.text('Vốn ban đầu (USD)'), findsOneWidget);
    expect(
      find.byKey(SavingsBacktestPage.presetKey(SavingsBacktestPreset.balanced)),
      findsOneWidget,
    );
    expect(find.byKey(SavingsBacktestPage.allocationKey), findsOneWidget);
  });

  testWidgets('SC-349 can change setup and run to results', (tester) async {
    await pumpBacktest(tester);

    await tester.tap(find.byKey(SavingsBacktestPage.amountKey(25000)));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(SavingsBacktestPage.periodKey(SavingsBacktestPeriod.twoYears)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(
        SavingsBacktestPage.presetKey(SavingsBacktestPreset.aggressive),
      ),
    );
    await tester.pumpAndSettle();

    final run = find.byKey(SavingsBacktestPage.runKey);
    await Scrollable.ensureVisible(tester.element(run), alignment: 0.82);
    await tester.pumpAndSettle();
    await tester.tap(run);
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsBacktestPage.resultsKey), findsOneWidget);
    expect(find.text('Hiệu suất tổng quan'), findsOneWidget);
    expect(find.text('Tăng trưởng tài sản'), findsOneWidget);

    await tester.tap(find.byKey(SavingsBacktestPage.applyKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsRecommendationsPage), findsOneWidget);
  });

  testWidgets('SC-349 compare tab shows preset comparison', (tester) async {
    await pumpBacktest(tester);

    await tester.tap(find.text('So sánh'));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsBacktestPage.compareKey), findsOneWidget);
    expect(find.text('So sánh tăng trưởng'), findsOneWidget);
    expect(find.text('An toàn'), findsWidgets);
    expect(find.text('Tăng trưởng'), findsWidgets);
  });

  testWidgets('SC-349 savings insight edge opens backtest page', (
    tester,
  ) async {
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

    await tester.scrollUntilVisible(
      find.byKey(SavingsPage.backtestInsightKey),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(SavingsPage.backtestInsightKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsBacktestPage), findsOneWidget);
  });
}
