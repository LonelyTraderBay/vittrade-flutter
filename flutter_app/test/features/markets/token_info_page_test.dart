import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/token_info_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTokenInfo(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.pairInfo('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-045 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getTokenInfo('btcusdt');

    expect(snapshot.pair.id, 'btcusdt');
    expect(snapshot.fundamentals.symbol, 'BTC');
    expect(snapshot.fundamentals.name, 'Bitcoin');
    expect(snapshot.fundamentals.supplyDistribution, hasLength(2));
    expect(snapshot.fundamentals.contractAddresses, isEmpty);
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Tong quan',
      'On-chain',
      'Du an',
    ]);
    expect(snapshot.chartSeries['btcusdt'], isNotEmpty);
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

  testWidgets('SC-045 renders overview inside the trade shell', (tester) async {
    await pumpTokenInfo(tester);

    expect(find.byType(TokenInfoPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC - Thông tin'), findsOneWidget);
    expect(find.text('Tổng quan'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('Thống kê thị trường'), findsOneWidget);
    expect(find.text('Cung token'), findsOneWidget);
  });

  testWidgets('SC-045 first viewport reaches market statistics card', (
    tester,
  ) async {
    await pumpTokenInfo(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'TokenInfoPage',
      semanticLabel: 'Thông tin token',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(TokenInfoPage.marketStatsCardKey),
      targetLabel: 'market statistics card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-045 switches on-chain and project tabs locally', (
    tester,
  ) async {
    await pumpTokenInfo(tester);

    await tester.tap(find.byKey(TokenInfoPage.onchainTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Hoạt động mạng lưới (24h)'), findsOneWidget);
    expect(find.text('Thông tin mạng lưới'), findsOneWidget);

    await tester.tap(find.byKey(TokenInfoPage.projectTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Giới thiệu'), findsOneWidget);
    expect(find.text('Liên kết'), findsOneWidget);
  });

  testWidgets('SC-045 back button returns to SC-044 PairDetailPage', (
    tester,
  ) async {
    await pumpTokenInfo(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-045 chart CTA returns to SC-044 PairDetailPage', (
    tester,
  ) async {
    await pumpTokenInfo(tester);

    await tester.ensureVisible(find.byKey(TokenInfoPage.chartButtonKey));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(TokenInfoPage.chartButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });
}
