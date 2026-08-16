import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/research/dca_backtester_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpBacktester(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaBacktester,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-176 mock repository exposes backtester BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getBacktester();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-backtester');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.assets, ['BTC', 'ETH', 'BNB', 'SOL']);
    expect(snapshot.activeFrequency, DcaBacktestFrequency.monthly);
    expect(snapshot.activeStrategy, DcaBacktestStrategy.fixed);
    expect(snapshot.result.returnPercent, 1108.33);
    expect(snapshot.historicalData.length, 12);
    expect(snapshot.drawdowns.length, 12);
    expect(snapshot.dcaPlans, isEmpty);
    expect(snapshot.schedules, isEmpty);
    expect(snapshot.rules, isEmpty);
    expect(snapshot.portfolioTargets, isEmpty);
    expect(snapshot.backtests, isEmpty);
    expect(
      snapshot.supportedStates,
      containsAll([
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-176 renders setup baseline', (tester) async {
    await pumpBacktester(tester);

    expect(find.byType(DCABacktesterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('DCA Backtester'), findsOneWidget);
    expect(find.text('Cài đặt'), findsOneWidget);
    expect(find.text('Chọn tài sản'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('Khung thời gian'), findsOneWidget);
    expect(find.text('Fixed Amount'), findsOneWidget);
    expect(find.byKey(DCABacktesterPage.runKey), findsOneWidget);
  });

  testWidgets('SC-176 run backtest opens results and analysis tabs', (
    tester,
  ) async {
    await pumpBacktester(tester);

    await tester.ensureVisible(find.byKey(DCABacktesterPage.runKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCABacktesterPage.runKey));
    await tester.pumpAndSettle();

    expect(find.text('Total Invested'), findsOneWidget);
    expect(find.text('Portfolio Growth (DCA vs Lump Sum)'), findsOneWidget);

    await tester.tap(find.byKey(DCABacktesterPage.tabKey('analysis')));
    await tester.pumpAndSettle();
    expect(find.text('Drawdown Analysis'), findsOneWidget);
    expect(find.text('Risk Analysis'), findsOneWidget);
  });
}
