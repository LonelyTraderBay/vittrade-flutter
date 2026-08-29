import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/market_depth_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/token_info_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPairDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.pairDetail('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-044 mock repository exposes the pair detail BE draft', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getPairDetail('btcusdt');

    expect(snapshot.pair.symbol, 'BTC/USDT');
    expect(snapshot.marketPairs, isNotEmpty);
    expect(snapshot.watchlist, contains('btcusdt'));
    expect(snapshot.alerts, isNotEmpty);
    expect(snapshot.screenFilters.categories, isNotEmpty);
    expect(snapshot.chartSeries['btcusdt'], isNotEmpty);
    expect(snapshot.depth.bids, isNotEmpty);
    // Terminal desk (2026-08-30): fixture sinh 24 giao dịch deterministic.
    expect(snapshot.recentTrades, hasLength(24));
    expect(snapshot.lastUpdatedLabel, 'read-only');
    expect(
      snapshot.supportedStates,
      containsAll([
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-044 renders pair detail inside the Trade shell', (
    tester,
  ) async {
    await pumpPairDetail(tester);

    expect(find.byType(PairDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('67,543.21'), findsOneWidget);
    expect(find.byKey(PairDetailPage.chartTabKey), findsOneWidget);
    expect(find.byKey(PairDetailPage.orderBookTabKey), findsOneWidget);
    expect(find.byKey(PairDetailPage.tradesTabKey), findsOneWidget);
    expect(find.text('Mua định kỳ BTC'), findsOneWidget);
    expect(find.text('Thông tin BTC'), findsOneWidget);
    expect(find.text('Độ sâu thị trường'), findsOneWidget);
  });

  testWidgets('SC-044 first viewport reaches the pair chart', (tester) async {
    await pumpPairDetail(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'PairDetailPage',
      semanticLabel: 'Chi tiết cặp giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PairDetailPage.chartContentKey),
      minVisibleHeight: 48,
      targetLabel: 'pair detail chart',
      reason:
          'Pair detail should expose the live market chart above bottom '
          'navigation after the compact price and tab controls.',
    );
  });

  testWidgets('SC-044 switches order book and trades tabs', (tester) async {
    await pumpPairDetail(tester);

    await tester.tap(find.byKey(PairDetailPage.orderBookTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Sổ lệnh BTC/USDT'), findsOneWidget);
    expect(find.textContaining('Mid'), findsOneWidget);

    await tester.tap(find.byKey(PairDetailPage.tradesTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Giá'), findsOneWidget);
    expect(find.text('Khối lượng'), findsOneWidget);
    expect(find.text('12:09:59'), findsOneWidget);
  });

  testWidgets('SC-044 detail cards navigate to token info and depth target', (
    tester,
  ) async {
    await pumpPairDetail(tester);

    await tester.ensureVisible(find.byKey(PairDetailPage.infoButtonKey));
    await tester.tap(find.byKey(PairDetailPage.infoButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(TokenInfoPage), findsOneWidget);

    await pumpPairDetail(tester);
    await tester.ensureVisible(find.byKey(PairDetailPage.depthButtonKey));
    await tester.tap(find.byKey(PairDetailPage.depthButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(MarketDepthPage), findsOneWidget);
  });

  testWidgets('SC-044 header actions use canonical catalog controls', (
    tester,
  ) async {
    await pumpPairDetail(tester);

    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            (widget.properties.label?.startsWith('Chọn') ?? false) &&
            (widget.properties.label?.contains('BTC/USDT') ?? false) &&
            widget.properties.button == true,
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.star_rounded));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.star_border_rounded), findsOneWidget);
  });

  testWidgets('SC-044 back button returns to Markets parent', (tester) async {
    await pumpPairDetail(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();
    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
