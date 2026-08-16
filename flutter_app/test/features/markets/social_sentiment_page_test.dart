import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/social_sentiment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSentiment(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsSocialSentiment,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-020 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getSocialSentiment();

    expect(snapshot.global.overallScore, 62);
    expect(snapshot.global.totalMentions24h, 2345678);
    expect(snapshot.global.trendingTokens, 47);
    expect(snapshot.tokens, hasLength(8));
    expect(snapshot.tokens.first.symbol, 'SOL');
    expect(snapshot.trendingTokens.map((token) => token.symbol), [
      'BTC',
      'SOL',
      'ETH',
      'DOGE',
    ]);
    expect(snapshot.timeline, hasLength(8));
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Tổng quan',
      'Theo token',
      'Xu hướng',
    ]);
    expect(snapshot.chartSeries['sentimentTimeline'], hasLength(8));
    expect(snapshot.chartSeries['socialDominance'], [38.2, 18.5, 43.3]);
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

    final mentions = await repo.getSocialSentiment(
      sortBy: MarketSentimentSort.mentions,
    );
    expect(mentions.tokens.first.symbol, 'BTC');
  });

  testWidgets('SC-020 renders overview inside the Markets shell', (
    tester,
  ) async {
    await pumpSentiment(tester);

    expect(find.byType(SocialSentimentPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Tâm lý thị trường'), findsOneWidget);
    expect(find.text('Chỉ số tâm lý chung'), findsOneWidget);
    expect(find.text('62'), findsWidgets);
    expect(find.text('2.35M'), findsOneWidget);
    expect(find.text('Social Dominance'), findsOneWidget);
    expect(find.text('Diễn biến 7 ngày'), findsOneWidget);
    expect(find.text('Xu hướng nóng'), findsOneWidget);
  });

  testWidgets('SC-020 first viewport reaches sentiment timeline card', (
    tester,
  ) async {
    await pumpSentiment(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SocialSentimentPage',
      semanticLabel: 'Tâm lý thị trường',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(SocialSentimentPage.timelineCardKey),
      targetLabel: 'sentiment timeline card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-020 token tab sorts by mentions', (tester) async {
    await pumpSentiment(tester);

    await tester.tap(find.byKey(SocialSentimentPage.tokenTabKey));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(SocialSentimentPage.sortKey(MarketSentimentSort.mentions)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sentiment'), findsOneWidget);
    expect(find.text('Mentions'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
  });

  testWidgets('SC-020 trends tab renders topics and heatmap', (tester) async {
    await pumpSentiment(tester);

    await tester.tap(find.byKey(SocialSentimentPage.trendsTabKey));
    await tester.pumpAndSettle();

    expect(find.text('#ETF Flows'), findsOneWidget);
    expect(find.text('Bản đồ tâm lý'), findsOneWidget);
    expect(find.text('Tích cực nhất'), findsOneWidget);
    expect(find.text('Tốc độ đề cập (24h)'), findsOneWidget);
  });

  testWidgets('SC-020 back button returns to SC-008 Markets', (tester) async {
    await pumpSentiment(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
