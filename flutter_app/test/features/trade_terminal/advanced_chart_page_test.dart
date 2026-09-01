import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/portfolio/price_alerts_page.dart';
import 'package:vit_trade_flutter/features/trade_terminal/data/trade_terminal_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_chart_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpAdvancedChart(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeAdvancedChart('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-055 mock repository exposes advanced chart BE draft', () async {
    final repo = const MockTradeTerminalRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getAdvancedChart(pairId: 'btcusdt');

    expect(snapshot.trade.pairs, hasLength(3));
    expect(snapshot.pair.symbol, 'BTC/USDT');
    expect(snapshot.candles, hasLength(25));
    expect(snapshot.indicators.map((item) => item.id), [
      'ma7',
      'ma25',
      'ma99',
      'ema',
      'bb',
      'rsi',
      'macd',
      'vol',
    ]);
    expect(snapshot.timeframes, ['1m', '5m', '15m', '1h', '4h', '1D', '1W']);
    expect(snapshot.chartTypes, ['candle', 'line', 'area']);
    expect(snapshot.ohlcv.volumeLabel, '8.0K');
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

  testWidgets('SC-055 renders advanced chart inside the Trade shell', (
    tester,
  ) async {
    await pumpAdvancedChart(tester);

    expect(find.byType(AdvancedChartPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('67,543.21'), findsOneWidget);
    expect(find.text('+2.34%'), findsOneWidget);
    expect(find.text('Mới nhất'), findsOneWidget);
    expect(find.text('1h'), findsOneWidget);
    expect(find.text('MA(7)'), findsOneWidget);
    expect(find.text('MA(25)'), findsOneWidget);
    expect(find.text('MUA'), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);
  });

  testWidgets('SC-320 uses full-width chart workspace at 360x800', (
    tester,
  ) async {
    await pumpAdvancedChart(tester, viewport: const Size(360, 800));

    expect(find.byType(AdvancedChartPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(AdvancedChartPage.buyKey), findsOneWidget);
    expect(find.byKey(AdvancedChartPage.sellKey), findsOneWidget);
    expect(find.byKey(AdvancedChartPage.alertKey), findsOneWidget);

    final chartFinder = find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_AdvancedTradeChartPainter',
    );
    expect(chartFinder, findsOneWidget);

    final chartRect = tester.getRect(chartFinder);
    final buyRect = tester.getRect(find.byKey(AdvancedChartPage.buyKey));
    final sellRect = tester.getRect(find.byKey(AdvancedChartPage.sellKey));
    final alertRect = tester.getRect(find.byKey(AdvancedChartPage.alertKey));

    expect(chartRect.left, closeTo(0, 0.5));
    expect(chartRect.right, closeTo(360, 0.5));
    expect(chartRect.height, greaterThan(140));
    expect(buyRect.bottom, lessThanOrEqualTo(800));
    expect(sellRect.bottom, lessThanOrEqualTo(800));
    expect(alertRect.bottom, lessThanOrEqualTo(800));
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-055 timeframe, chart type, and indicator sheet are local', (
    tester,
  ) async {
    await pumpAdvancedChart(tester);

    final timeframeButton = find.byKey(AdvancedChartPage.timeframeKey('4h'));
    await tester.ensureVisible(timeframeButton);
    await tester.tap(timeframeButton);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedChartPage.chartTypeKey('line')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AdvancedChartPage.indicatorButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Chỉ báo kỹ thuật'), findsOneWidget);
    await tester.tap(find.byKey(AdvancedChartPage.indicatorKey('ma7')));
    await tester.pumpAndSettle();
    expect(find.text('MA(7)'), findsOneWidget);

    await tester.tap(find.byKey(AdvancedChartPage.closeIndicatorsKey));
    await tester.pumpAndSettle();
    expect(find.text('Chỉ báo kỹ thuật'), findsNothing);
  });

  testWidgets('SC-055 buy action returns to SC-049 trade pair', (tester) async {
    await pumpAdvancedChart(tester);

    await tester.tap(find.byKey(AdvancedChartPage.buyKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(2));
  });

  testWidgets('SC-055 alert action opens SC-014 price alerts', (tester) async {
    await pumpAdvancedChart(tester);

    await tester.tap(find.byKey(AdvancedChartPage.alertKey));
    await tester.pumpAndSettle();

    expect(find.byType(PriceAlertsPage), findsOneWidget);
  });

  testWidgets('SC-055 pair selector opens SC-008 markets', (tester) async {
    await pumpAdvancedChart(tester);

    await tester.tap(find.byKey(AdvancedChartPage.pairSelectorKey));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
