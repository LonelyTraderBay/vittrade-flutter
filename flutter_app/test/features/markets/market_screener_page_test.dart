import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_screener_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpScreener(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsScreener,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-015 mock repository exposes the BE draft query model', () async {
    final repository = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repository.getMarketScreener();

    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.marketPairs.first.id, 'btcusdt');
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.presets.map((preset) => preset.id), [
      'large-cap',
      'high-volume',
      'gainers',
      'bargains',
      'defi-gems',
      'l2-watch',
    ]);
    expect(snapshot.screenFilters.defaultSort, 'marketCap');
    expect(snapshot.chartSeries['btcusdt'], isNotEmpty);
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

    final gainers = await repository.getMarketScreener(
      query: const MarketScreenerQuery(
        minChange24h: 3,
        sortBy: MarketScreenerSort.change24h,
        sortDirection: MarketSortDirection.desc,
      ),
    );
    expect(gainers.marketPairs.first.id, 'solusdt');
    expect(
      gainers.marketPairs.map((pair) => pair.id),
      isNot(contains('btcusdt')),
    );
  });

  testWidgets('SC-015 renders inside the Markets shell', (tester) async {
    await pumpScreener(tester);

    expect(find.byType(MarketScreenerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Bộ lọc thị trường'), findsOneWidget);
    expect(find.text('Tìm kiếm token...'), findsOneWidget);
    expect(
      find.byKey(MarketScreenerPage.presetKey('large-cap')),
      findsOneWidget,
    );
    expect(
      find.byKey(MarketScreenerPage.sortKey(MarketScreenerSort.marketCap)),
      findsOneWidget,
    );
    expect(find.text('10 kết quả'), findsOneWidget);
    expect(find.byKey(MarketScreenerPage.rowKey('btcusdt')), findsOneWidget);
    expect(find.byKey(MarketScreenerPage.rowKey('ethusdt')), findsOneWidget);
  });

  testWidgets('SC-015 first viewport reaches first screener result row', (
    tester,
  ) async {
    await pumpScreener(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-015 MarketScreenerPage',
      semanticLabel: 'Bộ lọc thị trường',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(MarketScreenerPage.rowKey('btcusdt')),
      targetLabel: 'the first screener result row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-015 filters by search and presets', (tester) async {
    await pumpScreener(tester);

    await tester.enterText(find.byType(TextField), 'link');
    await tester.pumpAndSettle();

    expect(find.byKey(MarketScreenerPage.rowKey('linkusdt')), findsOneWidget);
    expect(find.byKey(MarketScreenerPage.rowKey('btcusdt')), findsNothing);
    expect(find.text('1 kết quả'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(MarketScreenerPage.presetKey('gainers')));
    await tester.pumpAndSettle();

    expect(find.byKey(MarketScreenerPage.rowKey('solusdt')), findsOneWidget);
    expect(find.byKey(MarketScreenerPage.rowKey('btcusdt')), findsNothing);
    expect(find.text('5 kết quả'), findsOneWidget);
  });

  testWidgets('SC-015 supports advanced category filters and reset', (
    tester,
  ) async {
    await pumpScreener(tester);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();

    expect(find.byKey(MarketScreenerPage.advancedFiltersKey), findsOneWidget);

    await tester.tap(find.byKey(MarketScreenerPage.categoryKey('DeFi')));
    await tester.pumpAndSettle();

    expect(find.byKey(MarketScreenerPage.rowKey('dotusdt')), findsOneWidget);
    expect(find.byKey(MarketScreenerPage.rowKey('btcusdt')), findsNothing);
    expect(find.text('2 kết quả'), findsOneWidget);

    await tester.tap(find.byKey(MarketScreenerPage.resetFiltersKey));
    await tester.pumpAndSettle();

    expect(find.byKey(MarketScreenerPage.rowKey('btcusdt')), findsOneWidget);
    expect(find.text('10 kết quả'), findsOneWidget);
  });

  testWidgets('SC-015 supports sort toggles and pair navigation', (
    tester,
  ) async {
    await pumpScreener(tester);

    await tester.tap(
      find.byKey(MarketScreenerPage.sortKey(MarketScreenerSort.price)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(MarketScreenerPage.sortKey(MarketScreenerSort.price)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(MarketScreenerPage.rowKey('adausdt')), findsOneWidget);

    await tester.tap(find.byKey(MarketScreenerPage.rowKey('adausdt')));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-015 back button returns to SC-008 Markets', (tester) async {
    await pumpScreener(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
