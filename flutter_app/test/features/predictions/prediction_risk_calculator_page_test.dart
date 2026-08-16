import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/prediction_risk_calculator_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskCalculator(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsRiskCalculator,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-036 mock repository exposes the risk calculator BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getRiskCalculator();

    expect(snapshot.defaultEventName, 'BTC > \$100K by Dec 2026?');
    expect(snapshot.defaultOutcome, 'yes');
    expect(snapshot.defaultShares, 100);
    expect(snapshot.defaultEntryPrice, .65);
    expect(snapshot.defaultCurrentPrice, .68);
    expect(snapshot.defaultBankroll, 10000);
    expect(snapshot.events, isNotEmpty);
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

  testWidgets('SC-036 renders calculator inside the Markets shell', (
    tester,
  ) async {
    await pumpRiskCalculator(tester);

    expect(find.byType(PredictionRiskCalculatorPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Risk Calculator'), findsOneWidget);
    expect(find.text('Rủi ro · Prediction'), findsOneWidget);
    expect(find.text('May tinh'), findsOneWidget);
    expect(find.text('Kich ban'), findsOneWidget);
    expect(find.text('Huong dan'), findsOneWidget);
    expect(find.text('Thong tin vi the'), findsOneWidget);
    expect(find.text('BTC > \$100K by Dec 2026?'), findsOneWidget);
    expect(find.text('Risk Budget (\$)'), findsOneWidget);
    expect(find.text('Total Bankroll (\$)'), findsNothing);
    expect(find.text('Position Summary'), findsOneWidget);
    expect(find.text('\$65.00'), findsWidgets);
    expect(find.text('\$68.00'), findsOneWidget);
    expect(find.text('+\$3.00'), findsWidgets);
    expect(find.text('+4.62%'), findsOneWidget);
    expect(find.text('Risk Analysis'), findsOneWidget);
    expect(find.text('Kelly Criterion Position Sizing'), findsOneWidget);
    expect(
      find.text('Suggested exposure based on risk budget and edge'),
      findsOneWidget,
    );
    expect(find.text('Max Loss'), findsOneWidget);
    expect(find.text('Max Gain'), findsOneWidget);
    expect(find.text('68.0%'), findsOneWidget);
    expect(find.text('1:0.54'), findsOneWidget);
    expect(find.text('\$857.14'), findsOneWidget);
  });

  testWidgets('SC-036 first viewport reaches position input fields', (
    tester,
  ) async {
    await pumpRiskCalculator(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-036 PredictionRiskCalculatorPage',
      semanticLabel: 'Máy tính rủi ro dự đoán',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Shares'),
      targetLabel: 'the shares input label',
      minVisibleHeight: 8,
    );
  });

  testWidgets('SC-036 inputs recalculate local metrics', (tester) async {
    await pumpRiskCalculator(tester);

    await tester.enterText(
      find.byKey(PredictionRiskCalculatorPage.sharesFieldKey),
      '200',
    );
    await tester.pumpAndSettle();

    expect(find.text('\$130.00'), findsWidgets);
    expect(find.text('\$136.00'), findsOneWidget);
    expect(find.text('+\$6.00'), findsWidgets);
  });

  testWidgets('SC-036 tabs switch scenarios and guide locally', (tester) async {
    await pumpRiskCalculator(tester);

    await tester.tap(find.byKey(PredictionRiskCalculatorPage.scenariosTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Scenarios Analysis'), findsOneWidget);
    expect(find.text('Win (YES resolves)'), findsOneWidget);
    expect(find.text('Loss (NO resolves)'), findsOneWidget);

    await tester.tap(find.byKey(PredictionRiskCalculatorPage.guideTabKey));
    await tester.pumpAndSettle();
    expect(find.text('How to Use'), findsOneWidget);
    expect(find.text('1. Input Position Details'), findsOneWidget);
    expect(find.text('Expected Value'), findsOneWidget);
  });

  testWidgets('SC-036 back button returns to Predictions home', (tester) async {
    await pumpRiskCalculator(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
