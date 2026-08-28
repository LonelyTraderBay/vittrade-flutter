import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/market_depth_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDepth(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsDepth,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpPairDepth(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.pairDepth('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-019 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getMarketDepth();

    expect(snapshot.pair.symbol, 'BTC/USDT');
    expect(snapshot.depth.spread.toStringAsFixed(2), '40.53');
    expect(snapshot.depth.spreadPct.toStringAsFixed(4), '0.0600');
    expect(snapshot.depth.totalBidQuantity.toStringAsFixed(3), '0.868');
    expect(snapshot.depth.totalAskQuantity.toStringAsFixed(3), '0.746');
    expect(snapshot.depth.bidRatioPct.toStringAsFixed(1), '53.8');
    expect(snapshot.availableLevels, [15, 25, 50]);
    expect(snapshot.whaleOrders, hasLength(5));
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Biểu đồ độ sâu',
      'Sổ lệnh',
      'Lệnh cá voi',
    ]);
    expect(snapshot.chartSeries['bidCumulative'], hasLength(25));
    expect(snapshot.chartSeries['askCumulative'], hasLength(25));
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

    final fifteenLevels = await repo.getMarketDepth(levels: 15);
    expect(fifteenLevels.depth.bids, hasLength(15));
    expect(fifteenLevels.depth.asks, hasLength(15));
  });

  testWidgets('SC-019 renders depth chart inside the Markets shell', (
    tester,
  ) async {
    await pumpDepth(tester);

    expect(find.byType(MarketDepthPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Độ sâu BTC'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text(r'$67,543.21'), findsOneWidget);
    expect(find.text('Chênh lệch giá'), findsOneWidget);
    expect(find.text(r'$40.53'), findsOneWidget);
    // 'Biểu đồ độ sâu' xuất hiện 2 nơi: tab trái + tiêu đề card chart.
    expect(find.text('Biểu đồ độ sâu'), findsNWidgets(2));
    expect(find.text('Mua 53.8%'), findsOneWidget);
    expect(find.text('Bán 46.2%'), findsOneWidget);
  });

  testWidgets('SC-019 updates depth levels from chart controls', (
    tester,
  ) async {
    await pumpDepth(tester);

    await tester.tap(find.byKey(MarketDepthPage.levelKey(15)));
    await tester.pumpAndSettle();

    expect(find.byKey(MarketDepthPage.levelKey(15)), findsOneWidget);
    expect(find.text('Mua 54.7%'), findsOneWidget);
  });

  testWidgets('SC-019 first viewport reaches depth controls', (tester) async {
    await pumpDepth(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-019 MarketDepthPage',
      semanticLabel: 'Độ sâu thị trường',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(MarketDepthPage.depthChartTabKey),
      routeName: 'SC-019 MarketDepthPage',
      actionLabel: 'depth chart tab',
    );
  });

  testWidgets('SC-019 Order Book tab renders bid and ask rows', (tester) async {
    await pumpDepth(tester);

    await tester.tap(find.byKey(MarketDepthPage.orderBookTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Lệnh bán (Ask)'), findsOneWidget);
    expect(find.text('Lệnh mua (Bid)'), findsOneWidget);
    expect(
      find.textContaining('Chênh lệch: 0.0600%', findRichText: true),
      findsOneWidget,
    );
  });

  testWidgets('SC-019 Whale Alert tab renders warning and whale summary', (
    tester,
  ) async {
    await pumpDepth(tester);

    await tester.tap(find.byKey(MarketDepthPage.whaleAlertTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Cảnh báo cá voi'), findsOneWidget);
    expect(find.text('Lệnh lớn gần đây'), findsOneWidget);
    expect(find.text('Lệnh mua lớn'), findsOneWidget);
    expect(find.text('Lệnh bán lớn'), findsOneWidget);
  });

  testWidgets('SC-019 back button returns to SC-008 Markets', (tester) async {
    await pumpDepth(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });

  testWidgets('SC-046 renders pair depth route inside the Trade shell', (
    tester,
  ) async {
    await pumpPairDepth(tester);

    expect(find.byType(MarketDepthPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Độ sâu BTC'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text(r'$67,543.21'), findsOneWidget);
    expect(find.text('Mua 53.8%'), findsOneWidget);
  });

  testWidgets('SC-046 back button returns to SC-044 PairDetailPage', (
    tester,
  ) async {
    await pumpPairDepth(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-046 invalid constructor backPath falls back to pair detail', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: '/custom-depth',
      routes: [
        GoRoute(
          path: '/custom-depth',
          builder: (_, _) => const MarketDepthPage(
            pairId: 'btcusdt',
            backPath: 'https://evil.example/depth',
          ),
        ),
        GoRoute(
          path: '/pair/:pairId',
          builder: (_, _) => const Scaffold(body: Text('Safe pair detail')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Safe pair detail'), findsOneWidget);
    expect(find.byType(MarketDepthPage), findsNothing);
  });
}
