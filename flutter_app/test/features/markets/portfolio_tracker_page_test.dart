import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/portfolio/portfolio_tracker_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPortfolio(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPortfolioTracker,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-021 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getPortfolioTracker();

    expect(snapshot.stats.totalValue, 56279.10);
    expect(snapshot.stats.totalPnlPct, 14.53);
    expect(snapshot.stats.best24hSymbol, 'SOL');
    expect(snapshot.stats.stableAllocation, 22.2);
    expect(snapshot.holdings, hasLength(6));
    expect(snapshot.holdings.first.symbol, 'BTC');
    expect(snapshot.performance, hasLength(10));
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Tổng quan',
      'Tài sản',
      'Hiệu suất',
    ]);
    expect(snapshot.chartSeries['portfolioPerformance'], hasLength(10));
    expect(snapshot.chartSeries['portfolioAllocation'], [
      28.2,
      22.1,
      22.2,
      14.5,
      9.2,
      4.0,
    ]);
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

    final pnlSorted = await repo.getPortfolioTracker(
      sortBy: MarketPortfolioSort.pnl,
    );
    expect(pnlSorted.holdings.first.symbol, 'SOL');
  });

  testWidgets('SC-021 renders overview inside the Markets shell', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.byType(PortfolioTrackerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.text('Tổng giá trị'), findsOneWidget);
    expect(find.text(r'$56,279.10'), findsOneWidget);
    expect(find.text('Phân bổ tài sản'), findsOneWidget);
    expect(find.text('Tài sản chính'), findsOneWidget);
    expect(find.text('Đánh giá rủi ro'), findsOneWidget);
  });

  testWidgets('SC-021 first viewport reaches first holding row', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'PortfolioTrackerPage',
      semanticLabel: 'Theo dõi danh mục',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PortfolioTrackerPage.holdingKey('btc')),
      targetLabel: 'first holding row',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-021 hide balance toggles masked values', (tester) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byKey(PortfolioTrackerPage.hideBalanceKey));
    await tester.pumpAndSettle();

    expect(find.text(r'$56,279.10'), findsNothing);
    expect(find.text('••••••'), findsWidgets);
  });

  testWidgets('SC-021 assets tab can sort holdings by PnL', (tester) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byKey(PortfolioTrackerPage.assetsTabKey));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(PortfolioTrackerPage.sortKey(MarketPortfolioSort.pnl)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lãi/Lỗ'), findsWidgets);
    expect(find.byKey(PortfolioTrackerPage.holdingKey('sol')), findsOneWidget);
  });

  testWidgets('SC-021 performance tab renders chart and breakdown', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byKey(PortfolioTrackerPage.performanceTabKey));
    await tester.pumpAndSettle();

    expect(find.text('30d'), findsOneWidget);
    expect(find.text('Giá trị danh mục'), findsOneWidget);
    expect(find.text('Lãi/Lỗ theo tài sản'), findsOneWidget);
    expect(find.text('ROI tổng'), findsOneWidget);
  });

  testWidgets('SC-021 holding tap uses pair detail route', (tester) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byKey(PortfolioTrackerPage.holdingKey('btc')));
    await tester.pumpAndSettle();

    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-021 back button returns to SC-008 Markets', (tester) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
