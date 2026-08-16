import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/futures/futures_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/futures/leverage_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpLeverage(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // GD4 Cụm F3: previewFuturesLeverage giờ Future<T>, setLeverage
          // watch theo family key = request (đổi mỗi lần kéo slider/preset)
          // — loadDelay mặc định 300ms để lại pending timer mồ côi (xem
          // GD4-Async-Playbook.md mục 9).
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeFuturesLeverage('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-058 mock repository exposes leverage BE draft', () async {
    final repo = const MockTradeRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getFuturesLeverage(pairId: 'btcusdt');
    final preview = await repo.previewFuturesLeverage(
      const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 10),
    );
    final highRiskPreview = await repo.previewFuturesLeverage(
      const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 100),
    );
    final receipt = await repo.submitFuturesLeverage(
      const TradeFuturesLeverageRequest(pairId: 'btcusdt', leverage: 50),
    );

    expect(snapshot.futures.pair.symbol, 'BTC/USDT');
    expect(snapshot.currentLeverage, 10);
    expect(snapshot.presets, [1, 2, 3, 5, 10, 20, 25, 50, 75, 100]);
    expect(snapshot.sliderStops, [1, 10, 25, 50, 75, 100]);
    expect(preview.riskLabel, 'Trung bình thấp');
    expect(preview.riskLevel, 3);
    expect(preview.positionSize, 1000);
    expect(preview.liquidationDistancePct, 9);
    expect(preview.openFee, .2);
    expect(highRiskPreview.riskLabel, 'Rất cao');
    expect(highRiskPreview.showRiskTips, isTrue);
    expect(receipt.adjustmentId, 'LEV-DEMO-058');
    expect(receipt.preview.riskLabel, 'Cao');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-058 renders LeveragePage inside the Trade shell', (
    tester,
  ) async {
    await pumpLeverage(tester);

    expect(find.byType(LeveragePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Điều chỉnh đòn bẩy'), findsOneWidget);
    expect(find.text('Hiện tại: 10x'), findsOneWidget);
    expect(find.text('Rủi ro: Trung bình thấp'), findsOneWidget);
    expect(find.text('Mức rủi ro'), findsOneWidget);
    expect(find.text('Kéo để điều chỉnh'), findsOneWidget);
    expect(find.text('Chọn nhanh'), findsOneWidget);
    expect(find.text('Ước tính tác động'), findsOneWidget);
    expect(find.text('Xác nhận đòn bẩy 10x'), findsOneWidget);
  });

  testWidgets('SC-058 first viewport reaches leverage slider', (tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeFuturesLeverage('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-058 LeveragePage',
      semanticLabel: 'Điều chỉnh đòn bẩy giao dịch Futures',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(LeveragePage.sliderKey),
      targetLabel: 'the leverage slider',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-058 preset updates risk and impact preview', (tester) async {
    await pumpLeverage(tester);

    await tester.tap(find.byKey(LeveragePage.presetKey(50)));
    await tester.pumpAndSettle();

    expect(find.text('Rủi ro: Cao'), findsOneWidget);
    expect(find.text('Cao'), findsOneWidget);
    expect(find.text('\$5,000'), findsOneWidget);
    expect(find.text('~1.8%'), findsOneWidget);
    expect(find.text('Xác nhận đòn bẩy 50x'), findsOneWidget);
  });

  testWidgets('SC-058 very high leverage shows safety tips', (tester) async {
    await pumpLeverage(tester);

    await tester.tap(find.byKey(LeveragePage.presetKey(100)));
    await tester.pumpAndSettle();

    expect(find.text('Rủi ro: Rất cao'), findsOneWidget);
    expect(find.text('Lưu ý quan trọng'), findsOneWidget);
    expect(find.text('Luôn đặt Stop Loss để giới hạn lỗ'), findsOneWidget);
    expect(find.text('Theo dõi vị thế thường xuyên'), findsOneWidget);
  });

  testWidgets('SC-058 confirm returns to SC-057 FuturesPage', (tester) async {
    await pumpLeverage(tester);

    await tester.tap(find.byKey(LeveragePage.presetKey(25)));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(LeveragePage.confirmKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LeveragePage.confirmKey));
    await tester.pumpAndSettle();

    expect(find.byType(FuturesPage), findsOneWidget);
    expect(find.byType(LeveragePage), findsNothing);
  });

  testWidgets('SC-058 back returns to SC-057 FuturesPage', (tester) async {
    await pumpLeverage(tester);

    await tester.tap(find.byKey(LeveragePage.backKey));
    await tester.pumpAndSettle();

    expect(find.byType(FuturesPage), findsOneWidget);
    expect(find.byType(LeveragePage), findsNothing);
  });
}
