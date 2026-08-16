import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_correlations_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCorrelations(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsCorrelations,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-026 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getMarketCorrelations();

    expect(snapshot.assets.map((asset) => asset.symbol), [
      'BTC',
      'ETH',
      'SOL',
      'BNB',
      'XRP',
      'ADA',
      'AVAX',
      'LINK',
    ]);
    expect(snapshot.matrix, hasLength(8));
    expect(snapshot.matrix.first[1], 0.92);
    expect(snapshot.pairs, hasLength(28));
    expect(snapshot.pairs.first.assetA, 'BTC');
    expect(snapshot.pairs.first.assetB, 'ETH');
    expect(snapshot.diversificationScore.score, 27);
    expect(snapshot.diversificationScore.label, 'Thấp');
    expect(snapshot.diversificationScore.highestCorr.pair, 'BTC/ETH');
    expect(snapshot.diversificationScore.lowestCorr.pair, 'XRP/LINK');
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Ma trận',
      'Cặp tương quan',
      'Đa dạng hóa',
    ]);
    expect(snapshot.chartSeries['matrix'], hasLength(64));
    expect(snapshot.chartSeries['pairCorrelations'], hasLength(28));
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

    final lowSorted = await repo.getMarketCorrelations(
      sortOrder: CorrelationSortOrder.low,
    );
    expect(lowSorted.pairs.first.assetA, 'XRP');
    expect(lowSorted.pairs.first.assetB, 'LINK');

    final d30 = await repo.getMarketCorrelations(
      timeframe: MarketCorrelationTimeframe.d30,
    );
    expect(d30.matrix.first[1], 0.89);
  });

  testWidgets('SC-026 renders the matrix inside the Markets shell', (
    tester,
  ) async {
    await pumpCorrelations(tester);

    expect(find.byType(MarketCorrelationsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Tương quan thị trường'), findsOneWidget);
    expect(find.text('Ma trận'), findsOneWidget);
    expect(find.text('Cặp tương quan'), findsOneWidget);
    expect(find.text('Đa dạng hóa'), findsOneWidget);
    expect(find.text('Ma trận tương quan (7d)'), findsOneWidget);
    expect(find.text('Cách đọc ma trận'), findsOneWidget);
    expect(find.text('Khuyến nghị'), findsOneWidget);
    expect(find.text('BTC/ETH'), findsOneWidget);
    expect(find.text('XRP/LINK'), findsOneWidget);
  });

  testWidgets('SC-026 first viewport reaches correlation matrix card', (
    tester,
  ) async {
    await pumpCorrelations(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'MarketCorrelationsPage',
      semanticLabel: 'Tương quan thị trường',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(MarketCorrelationsPage.matrixCardKey),
      targetLabel: 'correlation matrix card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-026 timeframe selector updates matrix labels', (
    tester,
  ) async {
    await pumpCorrelations(tester);

    await tester.tap(find.byKey(MarketCorrelationsPage.timeframe30dKey));
    await tester.pumpAndSettle();

    expect(find.text('Ma trận tương quan (30d)'), findsOneWidget);
    expect(find.text('0.89'), findsWidgets);
  });

  testWidgets('SC-026 pair tab supports high and low sorting', (tester) async {
    await pumpCorrelations(tester);

    await tester.tap(find.byKey(MarketCorrelationsPage.pairsTabKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(MarketCorrelationsPage.pairKey('BTC-ETH')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(MarketCorrelationsPage.sortLowKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(MarketCorrelationsPage.pairKey('XRP-LINK')),
      findsOneWidget,
    );
    expect(find.text('Rất thấp'), findsNothing);
    expect(find.text('Trung bình'), findsWidgets);
  });

  testWidgets('SC-026 diversification tab renders risk insights', (
    tester,
  ) async {
    await pumpCorrelations(tester);

    await tester.tap(find.byKey(MarketCorrelationsPage.diversifyTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Chỉ số đa dạng hóa'), findsOneWidget);
    expect(find.text('/ 100'), findsOneWidget);
    expect(find.text('Tương quan TB'), findsOneWidget);
    expect(find.text('So sánh theo thời gian'), findsOneWidget);
    expect(find.textContaining('Tương quan quá khứ'), findsOneWidget);
  });

  testWidgets('SC-026 back button returns to SC-008 Markets', (tester) async {
    await pumpCorrelations(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
