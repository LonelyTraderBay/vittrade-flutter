import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_advanced_chart_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAdvancedChart(WidgetTester tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsAdvancedChart(
              'btcusdt',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-041 mock repository exposes the advanced chart BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getAdvancedChart('btcusdt');

    expect(snapshot.eventId, 'btcusdt');
    expect(snapshot.priceHistory, hasLength(10));
    expect(snapshot.orderFlow, hasLength(6));
    expect(snapshot.indicators, hasLength(4));
    expect(snapshot.patterns.map((pattern) => pattern.name), [
      'Ascending Triangle',
      'Higher Lows',
      'Volume Breakout',
    ]);
    expect(snapshot.currentProbability, closeTo(.69, .001));
    expect(snapshot.priceChangePercent, closeTo(18.97, .01));
    expect(snapshot.currentRsi, 66);
    expect(snapshot.predictionEvents, isNotEmpty);
    expect(snapshot.orders, hasLength(3));
    expect(snapshot.receipts, hasLength(6));
    expect(snapshot.rewards, isNotEmpty);
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
    expect(
      snapshot.supportedStates,
      containsAll([
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-041 renders chart tab inside the Markets shell', (
    tester,
  ) async {
    await pumpAdvancedChart(tester);

    expect(find.byType(PredictionAdvancedChartPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Advanced Chart'), findsOneWidget);
    expect(find.text('Biểu đồ · Prediction'), findsOneWidget);
    expect(find.text('Bieu do'), findsOneWidget);
    expect(find.text('Chi bao'), findsOneWidget);
    expect(find.text('Phan tich'), findsOneWidget);
    expect(find.text('Current Probability'), findsOneWidget);
    expect(find.text('69.0%'), findsOneWidget);
    expect(find.text('+18.97%'), findsOneWidget);
    expect(find.text('Probability Chart'), findsOneWidget);
    expect(find.text('Trading Volume'), findsOneWidget);
  });

  testWidgets('SC-041 first viewport reaches the chart work area', (
    tester,
  ) async {
    await pumpAdvancedChart(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-041 PredictionAdvancedChartPage',
      semanticLabel:
          'Biểu đồ nâng cao của sự kiện dự đoán: nến giá, chỉ báo kỹ thuật và phân tích',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Probability Chart'),
      targetLabel: 'the primary probability chart title',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-041 timeframe and layer controls update locally', (
    tester,
  ) async {
    await pumpAdvancedChart(tester);

    await tester.tap(PredictionAdvancedChartPage.timeframe4hKey.finder);
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(PredictionAdvancedChartPage.contentKey),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lop hien thi'), findsOneWidget);

    await tester.tap(find.byKey(PredictionAdvancedChartPage.volumeToggleKey));
    await tester.pumpAndSettle();
    expect(find.text('Trading Volume'), findsNothing);
  });

  testWidgets('SC-041 tabs switch indicators and analysis locally', (
    tester,
  ) async {
    await pumpAdvancedChart(tester);

    await tester.tap(find.byKey(PredictionAdvancedChartPage.indicatorsTabKey));
    await tester.pumpAndSettle();
    expect(find.text('RSI (Relative Strength Index)'), findsOneWidget);
    expect(find.text('Technical Indicators'), findsOneWidget);
    expect(find.text('Overall Signal'), findsOneWidget);
    expect(find.text('BULLISH'), findsOneWidget);

    await tester.tap(find.byKey(PredictionAdvancedChartPage.analysisTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Order Flow (Buy vs Sell Pressure)'), findsOneWidget);
    expect(find.text('Support & Resistance'), findsOneWidget);
    expect(find.text('Pattern Recognition'), findsOneWidget);
    expect(find.text('Ascending Triangle'), findsOneWidget);
  });

  testWidgets('SC-041 back button returns to Predictions home', (tester) async {
    await pumpAdvancedChart(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
