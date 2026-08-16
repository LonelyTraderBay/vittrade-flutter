import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/market_news_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/pair_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpNews(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsNews,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-022 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getMarketNews();

    expect(snapshot.news, hasLength(12));
    expect(snapshot.breakingNews, hasLength(1));
    expect(snapshot.breakingNews.first.id, 'n1');
    expect(snapshot.categories.map((category) => category.label), [
      'Tất cả',
      'Nóng',
      'Bitcoin',
      'Altcoin',
      'DeFi',
      'Vĩ mô',
      'Pháp lý',
      'Phân tích',
      'NFT',
    ]);
    expect(
      snapshot.sentimentBadges[MarketNewsSentiment.bullish]!.label,
      'Tích cực',
    );
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, containsAll(['Tất cả', 'Nóng']));
    expect(snapshot.chartSeries['sentimentCounts'], [8, 2, 2]);
    expect(snapshot.chartSeries['categoryCounts'], hasLength(8));
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

    final breaking = await repo.getMarketNews(category: 'breaking');
    expect(breaking.news.single.id, 'n1');

    final bearish = await repo.getMarketNews(
      sentiment: MarketNewsSentiment.bearish,
    );
    expect(bearish.news.map((item) => item.id), ['n5', 'n9']);
  });

  testWidgets('SC-022 renders news feed inside the Markets shell', (
    tester,
  ) async {
    await pumpNews(tester);

    expect(find.byType(MarketNewsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Tin thị trường'), findsOneWidget);
    expect(find.text('NÓNG'), findsWidgets);
    expect(
      find.text(
        'Bitcoin ETF ghi nhan dong tien vao ky luc \$1.2B trong 1 ngay',
      ),
      findsWidgets,
    );
    expect(find.text('Tích cực'), findsWidgets);
    expect(find.text('Trung lập'), findsWidgets);
    expect(find.text('Tiêu cực'), findsWidgets);
  });

  testWidgets('SC-022 first viewport reaches first news card', (tester) async {
    await pumpNews(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-022 MarketNewsPage',
      semanticLabel: 'Tin thị trường',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(MarketNewsPage.newsCardKey('n1')),
      targetLabel: 'the first market news card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-022 filters by breaking and bearish sentiment', (
    tester,
  ) async {
    await pumpNews(tester);

    await tester.tap(find.byKey(MarketNewsPage.categoryBreakingKey));
    await tester.pumpAndSettle();

    expect(find.byKey(MarketNewsPage.newsCardKey('n1')), findsOneWidget);
    expect(find.byKey(MarketNewsPage.newsCardKey('n2')), findsNothing);

    await tester.tap(find.byKey(MarketNewsPage.sentimentBearishKey));
    await tester.pumpAndSettle();

    expect(find.text('Không có tin tức phù hợp'), findsOneWidget);

    await tester.tap(find.text('Xem tất cả'));
    await tester.pumpAndSettle();
    expect(find.byKey(MarketNewsPage.newsCardKey('n5')), findsOneWidget);
  });

  testWidgets('SC-022 save and expanded token navigation work', (tester) async {
    await pumpNews(tester);

    await tester.tap(find.byKey(MarketNewsPage.saveKey('n1')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);

    await tester.tap(find.byKey(MarketNewsPage.newsCardKey('n1')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Cac quy ETF Bitcoin spot'), findsOneWidget);

    await tester.tap(find.byKey(MarketNewsPage.tokenKey('BTC')));
    await tester.pumpAndSettle();
    expect(find.byType(PairDetailPage), findsOneWidget);
  });

  testWidgets('SC-022 back button returns to SC-008 Markets', (tester) async {
    await pumpNews(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
