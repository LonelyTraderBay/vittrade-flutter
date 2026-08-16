import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/prediction_market_maker_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpMarketMaker(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsMarketMaker,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-037 mock repository exposes the market maker BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getMarketMaker();

    expect(snapshot.defaultEventName, 'BTC > \$100K by Dec 2026?');
    expect(snapshot.defaultSpreadBps, 50);
    expect(snapshot.defaultMinDepth, 1000);
    expect(snapshot.positions, hasLength(2));
    expect(snapshot.earningsHistory, hasLength(6));
    expect(snapshot.totalLiquidity, 8000);
    expect(snapshot.totalValue, 8390);
    expect(snapshot.totalFees, 500);
    expect(snapshot.totalImpermanentLoss, -110);
    expect(snapshot.netReturn, 780);
    expect(snapshot.averageApr, closeTo(21.35, .01));
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

  testWidgets('SC-037 renders provide tab inside the Markets shell', (
    tester,
  ) async {
    await pumpMarketMaker(tester);

    expect(find.byType(PredictionMarketMakerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Market Maker'), findsOneWidget);
    expect(find.text('Thanh khoản · Prediction'), findsOneWidget);
    expect(find.text('Cung cap'), findsOneWidget);
    expect(find.text('Vi the'), findsOneWidget);
    expect(find.text('Thu nhap'), findsOneWidget);
    expect(find.text('Liquidity Provider'), findsOneWidget);
    expect(find.text('Total Provided'), findsOneWidget);
    expect(find.text('\$8000.00'), findsOneWidget);
    expect(find.text('21.4%'), findsOneWidget);
    expect(find.text('Them thanh khoan'), findsWidgets);
    expect(find.text('Select Event'), findsOneWidget);
    expect(find.text('Spread (basis points)'), findsOneWidget);
    expect(find.text('Hieu gia bid/ask: 0.50%'), findsOneWidget);
  });

  testWidgets('SC-037 first viewport reaches liquidity amount input', (
    tester,
  ) async {
    await pumpMarketMaker(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-037 PredictionMarketMakerPage',
      semanticLabel: 'Tạo lập thị trường dự đoán: cung cấp thanh khoản',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Liquidity Amount (USD)'),
      targetLabel: 'the liquidity amount input label',
      minVisibleHeight: 8,
    );
  });

  testWidgets('SC-037 spread and amount controls update locally', (
    tester,
  ) async {
    await pumpMarketMaker(tester);

    await tester.tap(find.byKey(PredictionMarketMakerPage.spread100Key));
    await tester.pumpAndSettle();
    expect(find.text('Hieu gia bid/ask: 1.00%'), findsOneWidget);

    await tester.enterText(
      find.byKey(PredictionMarketMakerPage.amountFieldKey),
      '5000',
    );
    await tester.pumpAndSettle();
    expect(find.text('Daily Fees'), findsOneWidget);
    expect(find.text('\$6.00'), findsOneWidget);
    expect(find.text('~22.5%'), findsOneWidget);
  });

  testWidgets('SC-037 tabs switch positions and earnings locally', (
    tester,
  ) async {
    await pumpMarketMaker(tester);

    await tester.tap(find.byKey(PredictionMarketMakerPage.positionsTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Cac vi the'), findsOneWidget);
    expect(find.text('Current Value'), findsOneWidget);
    expect(find.text('\$8390.00'), findsOneWidget);
    expect(find.text('BTC > \$100K by Dec 2026?'), findsWidgets);
    expect(find.text('24.5% APR'), findsOneWidget);

    await tester.tap(find.byKey(PredictionMarketMakerPage.earningsTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Phan tich thu nhap'), findsOneWidget);
    expect(find.text('Fee Earnings Over Time'), findsOneWidget);
    expect(find.text('Total Fees'), findsOneWidget);
  });

  testWidgets('SC-037 back button returns to Predictions home', (tester) async {
    await pumpMarketMaker(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
