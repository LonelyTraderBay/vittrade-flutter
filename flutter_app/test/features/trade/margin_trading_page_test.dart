import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/margin/margin_trading_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpMarginTrading(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.tradeMargin,
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-085 mock repository exposes margin trading BE draft', () async {
    const repo = MockTradeRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getMarginTrading();

    expect(snapshot.pair.symbol, 'BTC/USDT');
    expect(snapshot.account.totalEquity, 12450.80);
    expect(snapshot.defaultMode, 'cross');
    expect(snapshot.defaultTab, 'trade');
    expect(snapshot.defaultLeverage, 5);
    expect(
      snapshot.positions.where((position) => position.mode == 'cross'),
      hasLength(2),
    );
    expect(snapshot.referencePrices.markPrice, 67543.21);
    expect(snapshot.referencePrices.lastPrice, 67572.63);
    final routeVariant = await repo.getMarginTrading(pairRouteVariant: true);
    expect(routeVariant.referencePrices.lastPrice, 67516.13);
    expect(snapshot.riskWarning.title, 'Rủi ro đòn bẩy 5x');
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
  });

  testWidgets('SC-085 renders trade baseline inside the Trade shell', (
    tester,
  ) async {
    await pumpMarginTrading(tester);

    expect(find.byType(MarginTradingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chế độ Pro'), findsNothing);
    expect(find.text('Tổng vốn'), findsOneWidget);
    expect(find.text('Giá tăng'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(1));
  });

  testWidgets('SC-085 first viewport reaches the order side controls', (
    tester,
  ) async {
    await pumpMarginTrading(tester);

    expect(find.byKey(MarginTradingPage.sideKey('long')), findsOneWidget);
  });

  testWidgets('SC-085 simple form controls update locally', (tester) async {
    await pumpMarginTrading(tester);

    await tester.tap(MarginTradingPage.sideKey('short').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Giá giảm'), findsWidgets);

    await tester.tap(MarginTradingPage.maxAmountKey.asFinder());
    await tester.pumpAndSettle();
    expect(find.textContaining('0.'), findsWidgets);
  });

  testWidgets('SC-086 pair route renders the BTC/USDT margin variant', (
    tester,
  ) async {
    await pumpMarginTrading(
      tester,
      initialLocation: AppRoutePaths.tradeMarginBtcusdt,
    );

    expect(find.byType(MarginTradingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(1));
    expect(find.text('67,516.13'), findsAtLeastNWidgets(1));
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
