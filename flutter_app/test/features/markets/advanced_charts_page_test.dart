import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/portfolio/advanced_charts_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAdvancedCharts(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsAdvancedCharts,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-023 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getAdvancedCharts();

    expect(snapshot.indicators, hasLength(10));
    expect(snapshot.indicators.map((indicator) => indicator.shortName), [
      'SMA',
      'EMA',
      'BOLL',
      'RSI',
      'MACD',
      'STOCH',
      'ATR',
      'VWAP',
      'OBV',
      'ICHI',
    ]);
    expect(snapshot.drawingTools, hasLength(12));
    expect(snapshot.signalSummaries.map((signal) => signal.pair), [
      'BTC/USDT',
      'ETH/USDT',
      'SOL/USDT',
    ]);
    expect(snapshot.activeIndicatorIds, containsAll(['sma', 'rsi']));
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(
      snapshot.screenFilters.categories,
      containsAll(['Tất cả', 'Xu hướng', 'Động lượng']),
    );
    expect(snapshot.chartSeries['BTC/USDT'], [9, 1, 2]);
    expect(snapshot.chartSeries['sma'], [20]);
    expect(snapshot.lastUpdatedLabel, 'read-only');
    expect(
      snapshot.supportedStates,
      containsAll([
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      ]),
    );

    final trend = await repo.getAdvancedCharts(indicatorCategory: 'trend');
    expect(trend.indicators.map((indicator) => indicator.shortName), [
      'SMA',
      'EMA',
      'ICHI',
    ]);

    final lines = await repo.getAdvancedCharts(drawingCategory: 'line');
    expect(lines.drawingTools.map((tool) => tool.id), [
      'trendline',
      'hline',
      'channel',
      'ray',
    ]);
  });

  testWidgets('SC-023 renders indicator library inside the Markets shell', (
    tester,
  ) async {
    await pumpAdvancedCharts(tester);

    expect(find.byType(AdvancedChartsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Phân tích kỹ thuật'), findsOneWidget);
    expect(find.text('Chỉ báo'), findsOneWidget);
    expect(find.text('Công cụ vẽ'), findsOneWidget);
    expect(find.text('Tín hiệu kỹ thuật'), findsOneWidget);
    expect(find.text('Đang sử dụng: 2 chỉ báo'), findsOneWidget);
    expect(find.text('SMA'), findsWidgets);
    expect(find.text('RSI'), findsWidgets);
    expect(find.text('OBV'), findsWidgets);
    expect(find.text('ICHI'), findsWidgets);
  });

  testWidgets('SC-023 first viewport reaches first indicator card', (
    tester,
  ) async {
    await pumpAdvancedCharts(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'AdvancedChartsPage',
      semanticLabel: 'Phân tích kỹ thuật',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(AdvancedChartsPage.indicatorKey('sma')),
      targetLabel: 'first indicator card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-023 toggles indicators and clears active chips', (
    tester,
  ) async {
    await pumpAdvancedCharts(tester);

    await tester.tap(find.byKey(AdvancedChartsPage.indicatorToggleKey('sma')));
    await tester.pumpAndSettle();
    expect(find.text('Đang sử dụng: 1 chỉ báo'), findsOneWidget);

    await tester.tap(find.byKey(AdvancedChartsPage.indicatorToggleKey('ema')));
    await tester.pumpAndSettle();
    expect(find.text('Đang sử dụng: 2 chỉ báo'), findsOneWidget);

    await tester.tap(find.byKey(AdvancedChartsPage.clearAllKey));
    await tester.pumpAndSettle();
    expect(find.text('Đang sử dụng: 0 chỉ báo'), findsOneWidget);
    expect(find.byKey(AdvancedChartsPage.clearAllKey), findsNothing);
  });

  testWidgets('SC-023 filters indicators by trend category', (tester) async {
    await pumpAdvancedCharts(tester);

    await tester.tap(find.byKey(AdvancedChartsPage.categoryTrendKey));
    await tester.pumpAndSettle();

    expect(find.byKey(AdvancedChartsPage.indicatorKey('sma')), findsOneWidget);
    expect(find.byKey(AdvancedChartsPage.indicatorKey('ema')), findsOneWidget);
    expect(
      find.byKey(AdvancedChartsPage.indicatorKey('ichimoku')),
      findsOneWidget,
    );
    expect(find.byKey(AdvancedChartsPage.indicatorKey('rsi')), findsNothing);
  });

  testWidgets('SC-023 drawing tools tab renders tool categories', (
    tester,
  ) async {
    await pumpAdvancedCharts(tester);

    await tester.tap(find.byKey(AdvancedChartsPage.drawingTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Bộ công cụ vẽ chuyên nghiệp'), findsOneWidget);
    expect(
      find.byKey(AdvancedChartsPage.drawingToolKey('trendline')),
      findsOneWidget,
    );
    expect(
      find.byKey(AdvancedChartsPage.drawingToolKey('fib_ret')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(AdvancedChartsPage.drawingLineKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(AdvancedChartsPage.drawingToolKey('trendline')),
      findsOneWidget,
    );
    expect(
      find.byKey(AdvancedChartsPage.drawingToolKey('fib_ret')),
      findsNothing,
    );
  });

  testWidgets('SC-023 technical signals tab renders disclaimer and summaries', (
    tester,
  ) async {
    await pumpAdvancedCharts(tester);

    await tester.tap(find.byKey(AdvancedChartsPage.signalsTabKey));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Tín hiệu kỹ thuật chỉ mang tính tham khảo. Không phải khuyến nghị đầu tư.',
      ),
      findsOneWidget,
    );
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('SOL/USDT'), findsOneWidget);
    expect(find.text('Pivot Points'), findsWidgets);
  });

  testWidgets('SC-023 back button returns to SC-008 Markets', (tester) async {
    await pumpAdvancedCharts(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
