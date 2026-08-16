import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_movers_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpMovers(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsMovers,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-010 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getMarketMovers();
    final gainers = snapshot.movers
        .where((mover) => mover.change24h > 0)
        .toList();

    expect(gainers, hasLength(13));
    expect(snapshot.movers.map((mover) => mover.symbol), contains('ZRO'));
    expect(snapshot.movers.map((mover) => mover.symbol), contains('BTC'));
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, contains('Layer 2'));
    expect(snapshot.screenFilters.sortOptions.map((option) => option.id), [
      'change',
      'volume',
      'market_cap',
    ]);
    expect(snapshot.chartSeries['zro'], isNotEmpty);
    expect(snapshot.tabs, containsAll(['Tăng mạnh', 'Giảm mạnh']));
    expect(snapshot.timeframes, containsAll(['1h', '24h', '7d']));
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

  testWidgets('SC-010 renders inside the Markets shell', (tester) async {
    await pumpMovers(tester);

    expect(find.byType(MarketMoversPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Biến động thị trường'), findsOneWidget);
    expect(find.text('Tăng mạnh'), findsOneWidget);
    expect(find.text('Khung thời gian:'), findsOneWidget);
    expect(find.text('Danh mục: Tất cả'), findsOneWidget);
    expect(find.text('13 kết quả'), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.byKey(const Key('sc010_mover_zro')), findsOneWidget);
    expect(find.text('ZRO'), findsWidgets);
    expect(find.text('LayerZero'), findsOneWidget);
  });

  testWidgets('SC-010 first viewport reaches first mover row', (tester) async {
    await pumpMovers(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-010 MarketMoversPage',
      semanticLabel: 'Biến động thị trường',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(const Key('sc010_mover_zro')),
      targetLabel: 'the first market mover row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-010 supports tab, timeframe, category, and sort controls', (
    tester,
  ) async {
    await pumpMovers(tester);

    await tester.tap(find.byKey(MarketMoversPage.losersTabKey));
    await tester.pumpAndSettle();

    expect(find.text('WLD'), findsWidgets);
    expect(find.text('-6.78%'), findsOneWidget);

    await tester.ensureVisible(find.byKey(MarketMoversPage.unusualTabKey));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(MarketMoversPage.unusualTabKey));
    await tester.pumpAndSettle();

    expect(find.text('KL +78.90%'), findsOneWidget);

    await tester.tap(find.byKey(MarketMoversPage.categoryDropdownKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sc010_category_Layer 2')));
    await tester.pumpAndSettle();

    expect(find.text('Danh mục: Layer 2'), findsOneWidget);

    await tester.tap(find.byKey(MarketMoversPage.sortMarketCapKey));
    await tester.pumpAndSettle();

    expect(find.text('Sắp xếp theo Market Cap 24h'), findsOneWidget);
  });

  testWidgets('SC-010 back button returns to SC-008 Markets', (tester) async {
    await pumpMovers(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
    expect(find.text('Tìm kiếm BTC, ETH...'), findsOneWidget);
  });

  testWidgets('SC-010 wires market rows to pair detail route', (tester) async {
    await pumpMovers(tester);

    await tester.ensureVisible(find.byKey(const Key('sc010_mover_btc')));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(const Key('sc010_mover_btc')));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-010 full content reaches the refresh footer', (tester) async {
    await pumpMovers(tester);

    await tester.ensureVisible(find.text('Dữ liệu cập nhật mỗi 30 giây'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Dữ liệu cập nhật mỗi 30 giây'), findsOneWidget);
    expect(find.byKey(const Key('sc010_mover_btc')), findsOneWidget);
  });
}
