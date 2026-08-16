import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/derivatives_overview_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDerivatives(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsDerivatives,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-018 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getMarketDerivatives();

    expect(snapshot.globalStats.totalOpenInterest, 45678901000);
    expect(snapshot.globalStats.totalLiquidations24h, 234567000);
    expect(snapshot.pairs, hasLength(8));
    expect(snapshot.pairs.first.symbol, 'BTC/USDT');
    expect(snapshot.liquidationHistory, hasLength(7));
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Tổng quan',
      'Perpetual',
      'Thanh lý',
    ]);
    expect(snapshot.chartSeries['liquidationLong'], hasLength(7));
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

    final funding = await repo.getMarketDerivatives(
      sortBy: MarketDerivativesSort.funding,
    );
    expect(funding.pairs.first.symbol, 'DOGE/USDT');
  });

  testWidgets('SC-018 renders overview inside the Markets shell', (
    tester,
  ) async {
    await pumpDerivatives(tester);

    expect(find.byType(DerivativesOverviewPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Phái sinh'), findsOneWidget);
    expect(find.text('Tổng Open Interest'), findsOneWidget);
    expect(find.text(r'$45.68B'), findsOneWidget);
    expect(find.text('Thanh lý theo thời gian (24h)'), findsOneWidget);
    expect(find.text('Top Open Interest'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
  });

  testWidgets('SC-018 first viewport reaches derivatives tabs', (tester) async {
    await pumpDerivatives(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-018 DerivativesOverviewPage',
      semanticLabel: 'Phái sinh',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DerivativesOverviewPage.overviewTabKey),
      routeName: 'SC-018 DerivativesOverviewPage',
      actionLabel: 'the overview derivatives tab',
    );
  });

  testWidgets('SC-018 switches to Perpetual tab and sorts by funding', (
    tester,
  ) async {
    await pumpDerivatives(tester);

    await tester.tap(find.byKey(DerivativesOverviewPage.perpetualTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Perpetual'), findsWidgets);
    expect(
      find.byKey(
        DerivativesOverviewPage.sortKey(MarketDerivativesSort.funding),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(
        DerivativesOverviewPage.sortKey(MarketDerivativesSort.funding),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('DOGE/USDT'), findsOneWidget);
    expect(find.text('50x'), findsWidgets);
  });

  testWidgets('SC-018 liquidation tab shows split and warning copy', (
    tester,
  ) async {
    await pumpDerivatives(tester);

    await tester.tap(find.byKey(DerivativesOverviewPage.liquidationTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Tổng thanh lý 24h'), findsOneWidget);
    expect(find.text('Thanh lý theo cặp'), findsOneWidget);
    expect(find.text('Cảnh báo rủi ro'), findsOneWidget);
  });

  testWidgets('SC-018 back button returns to SC-008 Markets', (tester) async {
    await pumpDerivatives(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
