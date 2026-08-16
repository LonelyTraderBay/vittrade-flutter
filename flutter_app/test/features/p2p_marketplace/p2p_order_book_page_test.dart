import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_order_book_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpOrderBook(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pOrderBook,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-273 mock repository exposes order book BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getOrderBook();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-order-book');
    expect(
      snapshot.actionDraft,
      'POST /orders/:id/action where applicable; POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Sổ lệnh P2P');
    expect(snapshot.subtitle, 'Giao dịch · P2P');
    expect(snapshot.selectedAsset.asset, 'USDT');
    expect(snapshot.markets, hasLength(5));
    expect(snapshot.bids, hasLength(10));
    expect(snapshot.asks, hasLength(10));
    expect(snapshot.bestBid.priceVnd, 25224.1);
    expect(snapshot.bestAsk.priceVnd, 25375.9);
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
        P2PScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-273 renders order book baseline', (tester) async {
    await pumpOrderBook(tester);

    expect(find.byType(P2POrderBookPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Sổ lệnh P2P'), findsOneWidget);
    expect(find.text('Giao dịch · P2P'), findsOneWidget);
    expect(find.byKey(P2POrderBookPage.assetRailKey), findsOneWidget);
    expect(find.byKey(P2POrderBookPage.assetKey('USDT')), findsOneWidget);
    expect(find.byKey(P2POrderBookPage.assetKey('BTC')), findsOneWidget);
    expect(find.textContaining('+0.80%'), findsNWidgets(2));
    expect(find.byKey(P2POrderBookPage.tickerKey), findsOneWidget);
    expect(find.text('Giá hiện tại'), findsOneWidget);
    expect(find.text('25.300'), findsOneWidget);
    expect(find.text('24h High'), findsOneWidget);
    expect(find.text('25.450'), findsOneWidget);
    expect(find.text('24h Low'), findsOneWidget);
    expect(find.text('25.180'), findsOneWidget);
    expect(find.text('Volume 24h'), findsOneWidget);
    expect(find.text('2.45B'), findsOneWidget);
    expect(find.text('Spread'), findsOneWidget);
    expect(find.byKey(P2POrderBookPage.depthChartKey), findsOneWidget);
    expect(find.text('Biểu đồ độ sâu'), findsOneWidget);
    expect(find.byKey(P2POrderBookPage.bestPricesKey), findsOneWidget);
    expect(find.text('Bid cao nhất'), findsOneWidget);
    expect(find.text('Ask thấp nhất'), findsOneWidget);
    expect(find.byKey(P2POrderBookPage.orderListsKey), findsOneWidget);
    expect(find.text('Mua (Bid)'), findsOneWidget);
    expect(find.text('Bán (Ask)'), findsOneWidget);
  });

  testWidgets('SC-273 first viewport reaches ticker and best prices', (
    tester,
  ) async {
    await pumpOrderBook(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-273 P2POrderBookPage',
      semanticLabel: 'Sổ lệnh P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderBookPage.assetKey('USDT')),
      routeName: 'SC-273 P2POrderBookPage',
      actionLabel: 'selected asset chip',
      minVisibleHeight: 44,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderBookPage.refreshKey),
      routeName: 'SC-273 P2POrderBookPage',
      actionLabel: 'market refresh action',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2POrderBookPage.bestPricesKey),
      routeName: 'SC-273 P2POrderBookPage',
      actionLabel: 'best bid and ask cards',
      minVisibleHeight: 56,
    );
  });

  testWidgets('SC-273 supports asset state and refresh action', (tester) async {
    await pumpOrderBook(tester);

    await tester.tap(P2POrderBookPage.assetKey('BTC').finder);
    await tester.pumpAndSettle();

    expect(find.text('1.715B'), findsOneWidget);
    expect(find.textContaining('-2.30%'), findsNWidgets(2));

    await tester.tap(find.byKey(P2POrderBookPage.refreshKey));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(P2POrderBookPage), findsOneWidget);
  });

  testWidgets('SC-273 back navigation uses safe P2P parent route', (
    tester,
  ) async {
    await pumpOrderBook(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2POrderBookPage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
