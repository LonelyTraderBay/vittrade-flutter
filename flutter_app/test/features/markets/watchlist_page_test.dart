import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/hub/watchlist_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<GoRouter> pumpWatchlist(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter(
      initialLocation: AppRoutePaths.marketsWatchlist,
    );
    await tester.pumpWidget(
      ProviderScope(child: VitTradeApp(routerConfig: router)),
    );
    await tester.pumpAndSettle();
    return router;
  }

  test('SC-012 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getMarketWatchlist();

    expect(snapshot.entries, hasLength(3));
    expect(snapshot.entries.map((entry) => entry.pairId), [
      'btcusdt',
      'ethusdt',
      'solusdt',
    ]);
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.defaultSort, 'manual');
    expect(snapshot.chartSeries['btcusdt'], isNotEmpty);
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

  testWidgets('SC-012 renders inside the Markets shell', (tester) async {
    await pumpWatchlist(tester);

    expect(find.byType(WatchlistPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Danh sách theo dõi'), findsOneWidget);
    expect(find.text('Theo dõi · Markets'), findsNothing);
    expect(find.textContaining('Cập nhật'), findsWidgets);
    expect(find.text('Tìm kiếm cặp giao dịch...'), findsOneWidget);
    expect(find.text('3 cặp đang theo dõi'), findsOneWidget);
    expect(find.byKey(WatchlistPage.cardKey('btcusdt')), findsOneWidget);
    expect(find.byKey(WatchlistPage.cardKey('ethusdt')), findsOneWidget);
    expect(find.byKey(WatchlistPage.cardKey('solusdt')), findsOneWidget);
    expect(find.text('Chờ mốc \$3800'), findsOneWidget);
  });

  testWidgets('SC-012 first viewport reaches first watchlist pair', (
    tester,
  ) async {
    await pumpWatchlist(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'WatchlistPage',
      semanticLabel: 'Danh sách theo dõi',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(WatchlistPage.cardKey('btcusdt')),
      minVisibleHeight: 48,
      targetLabel: 'first watchlist pair card',
      reason:
          'Watchlist should expose the first tracked pair above bottom '
          'navigation after compact toolbar controls.',
    );
  });

  testWidgets('SC-012 filters search and shows empty state', (tester) async {
    await pumpWatchlist(tester);

    await tester.enterText(find.byType(TextField), 'sol');
    await tester.pump();

    expect(find.byKey(WatchlistPage.cardKey('solusdt')), findsOneWidget);
    expect(find.byKey(WatchlistPage.cardKey('btcusdt')), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pump();

    expect(find.text('Không tìm thấy cặp nào'), findsOneWidget);
  });

  testWidgets('SC-012 removes a pair from local watchlist state', (
    tester,
  ) async {
    final router = await pumpWatchlist(tester);

    await tester.tap(find.byKey(WatchlistPage.removeKey('watch-btc')));
    await tester.pump();

    expect(find.byKey(WatchlistPage.cardKey('btcusdt')), findsNothing);
    expect(find.text('2 cặp đang theo dõi'), findsOneWidget);

    // STATE-S23 round-trip: điều hướng đi rồi quay lại — mutation giữ nguyên
    // (state sống ở Notifier, không phải late List của trang).
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(MarketListPage), findsOneWidget);

    router.go(AppRoutePaths.marketsWatchlist);
    await tester.pumpAndSettle();
    expect(find.byKey(WatchlistPage.cardKey('btcusdt')), findsNothing);
    expect(find.text('2 cặp đang theo dõi'), findsOneWidget);
  });

  testWidgets('SC-012 back and add controls return to SC-008 Markets', (
    tester,
  ) async {
    await pumpWatchlist(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);

    await pumpWatchlist(tester);
    await tester.tap(find.byKey(WatchlistPage.addPairKey));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });

  testWidgets('SC-012 wires pair and trade actions to existing targets', (
    tester,
  ) async {
    await pumpWatchlist(tester);

    await tester.tap(find.byKey(WatchlistPage.pairLinkKey('btcusdt')));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(PairDetailPage),
        matching: find.text('BTC/USDT'),
      ),
      findsOneWidget,
    );

    await pumpWatchlist(tester);
    await tester.tap(find.byKey(WatchlistPage.tradeKey('btcusdt')));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.text('Giao dịch Spot'), findsWidgets);
  });
}
