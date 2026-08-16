import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/market_heatmap_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpHeatmap(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsHeatmap,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-013 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getMarketHeatmap();

    expect(snapshot.coins, hasLength(20));
    expect(
      snapshot.coins.map((coin) => coin.symbol),
      containsAll(['BTC', 'ETH', 'SOL']),
    );
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.metrics, ['24h', '7d']);
    expect(
      snapshot.screenFilters.categories,
      containsAll(['Tất cả', 'Layer 1', 'Layer 2']),
    );
    expect(snapshot.chartSeries['btc'], [2.34, 5.12, 23456789000]);
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
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
  });

  testWidgets('SC-013 renders inside the Markets shell', (tester) async {
    await pumpHeatmap(tester);

    expect(find.byType(MarketHeatmapPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Bản đồ thị trường'), findsOneWidget);
    expect(find.text('Quét biến động · Markets'), findsOneWidget);
    expect(find.text(r'$2,018.43B'), findsOneWidget);
    expect(find.text('+1.28%'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.byKey(MarketHeatmapPage.tileKey('btc')), findsOneWidget);
    expect(find.byKey(MarketHeatmapPage.tileKey('eth')), findsOneWidget);
    expect(find.text('Top tăng'), findsOneWidget);
    expect(find.text('Top giảm'), findsOneWidget);
  });

  testWidgets('SC-013 toggles metric and category filters', (tester) async {
    await pumpHeatmap(tester);

    await tester.tap(find.byKey(MarketHeatmapPage.metric7dKey));
    await tester.pumpAndSettle();

    expect(find.text('+15.67%'), findsWidgets);

    await tester.tap(find.byKey(MarketHeatmapPage.categoryKey('Layer 1')));
    await tester.pumpAndSettle();

    expect(find.text('10'), findsOneWidget);
    expect(find.byKey(MarketHeatmapPage.tileKey('btc')), findsOneWidget);
    expect(find.byKey(MarketHeatmapPage.tileKey('matic')), findsNothing);
  });

  testWidgets('SC-013 first viewport reaches heatmap controls', (tester) async {
    await pumpHeatmap(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-013 MarketHeatmapPage',
      semanticLabel: 'Bản đồ thị trường',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(MarketHeatmapPage.metric24hKey),
      routeName: 'SC-013 MarketHeatmapPage',
      actionLabel: '24h metric control',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(MarketHeatmapPage.tileKey('btc')),
      routeName: 'SC-013 MarketHeatmapPage',
      actionLabel: 'BTC heatmap tile',
    );
  });

  testWidgets('SC-013 opens selected coin detail and routes to pair detail', (
    tester,
  ) async {
    await pumpHeatmap(tester);

    await tester.tap(find.byKey(MarketHeatmapPage.tileKey('btc')));
    await tester.pumpAndSettle();

    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('BTC/USDT · Layer 1'), findsOneWidget);

    await tester.tap(find.byKey(MarketHeatmapPage.detailButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-013 back button returns to SC-008 Markets', (tester) async {
    await pumpHeatmap(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
