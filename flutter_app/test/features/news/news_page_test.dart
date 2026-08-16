import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/news/data/news_repository.dart';
import 'package:vit_trade_flutter/features/news/presentation/phone/pages/news_page.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_empty_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_offline_banner.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

final class _FixedStateNewsRepository implements NewsRepository {
  const _FixedStateNewsRepository(this.screenState, {this.articles = const []});

  final NewsScreenState screenState;
  final List<NewsArticle> articles;

  @override
  Future<NewsScreenSnapshot> getNews() async {
    return NewsScreenSnapshot(
      articles: articles,
      pinnedArticles: articles.where((article) => article.isPinned).toList(),
      normalArticles: articles.where((article) => !article.isPinned).toList(),
      newsReferenceData: const NewsReferenceData(
        endpoint: '/api/mobile/news/news',
        filters: NewsArticleType.values,
        lastUpdatedLabel: 'read-only',
      ),
      screenState: screenState,
      supportedStates: const [
        NewsScreenState.loading,
        NewsScreenState.empty,
        NewsScreenState.error,
        NewsScreenState.offline,
      ],
    );
  }
}

final class _FlakyNewsRepository implements NewsRepository {
  var _attempts = 0;

  @override
  Future<NewsScreenSnapshot> getNews() async {
    _attempts++;
    if (_attempts == 1) {
      throw StateError('news_fetch_failed');
    }
    return const MockNewsRepository(loadDelay: Duration.zero).getNews();
  }
}

void main() {
  Future<void> pumpNews(
    WidgetTester tester, {
    NewsRepository? repository,
    bool settle = true,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          newsRepositoryProvider.overrideWithValue(
            repository ?? const MockNewsRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.news),
        ),
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  test('SC-047 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockNewsRepository(
      loadDelay: Duration.zero,
    ).getNews();

    expect(snapshot.newsReferenceData.endpoint, '/api/mobile/news/news');
    expect(snapshot.newsReferenceData.lastUpdatedLabel, 'read-only');
    expect(snapshot.articles, hasLength(5));
    expect(snapshot.pinnedArticles.map((article) => article.id), [
      'news001',
      'news002',
    ]);
    expect(snapshot.normalArticles, hasLength(3));
    expect(snapshot.newsReferenceData.filters, NewsArticleType.values);
    expect(snapshot.screenState, NewsScreenState.ready);
    expect(
      snapshot.supportedStates,
      containsAll([
        NewsScreenState.loading,
        NewsScreenState.empty,
        NewsScreenState.error,
        NewsScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-047 renders the announcements feed inside the shell', (
    tester,
  ) async {
    await pumpNews(tester);

    expect(find.byType(NewsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tin tức & Thông báo'), findsOneWidget);
    expect(find.text('Sản phẩm · bảo trì · niêm yết'), findsOneWidget);
    expect(find.text('GHIM (2)'), findsOneWidget);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsOneWidget);
    expect(find.text('Ra mắt tính năng P2P Trading'), findsOneWidget);
  });

  testWidgets('SC-047 first viewport reaches pinned news card', (tester) async {
    await pumpNews(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-047 NewsPage',
      semanticLabel: 'Tin tức & Thông báo',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(NewsPage.articleCardKey('news001')),
      targetLabel: 'the first pinned news card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-047 filters by article type', (tester) async {
    await pumpNews(tester);

    await tester.tap(
      find.byKey(NewsPage.filterKey(NewsArticleType.maintenance)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bảo trì hệ thống định kỳ'), findsOneWidget);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsNothing);

    await tester.tap(find.byKey(NewsPage.filterAllKey));
    await tester.pumpAndSettle();
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsOneWidget);
  });

  testWidgets('SC-047 opens and closes article detail sheet', (tester) async {
    await pumpNews(tester);

    await tester.tap(find.byKey(NewsPage.articleCardKey('news001')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Chào mừng sự kiện đặc biệt'), findsOneWidget);
    expect(find.text('Đóng'), findsOneWidget);

    await tester.tap(find.byKey(NewsPage.closeSheetKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Chào mừng sự kiện đặc biệt'), findsNothing);
  });

  testWidgets('SC-047 back button returns to Home', (tester) async {
    await pumpNews(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('SC-047 shows empty state when no articles match', (
    tester,
  ) async {
    await pumpNews(
      tester,
      repository: const _FixedStateNewsRepository(NewsScreenState.empty),
    );

    expect(find.byKey(NewsPage.emptyKey), findsOneWidget);
    expect(find.byType(VitEmptyState), findsOneWidget);
    expect(find.text('Không có tin tức nào'), findsOneWidget);
  });

  testWidgets('SC-047 renders loading skeleton state', (tester) async {
    await pumpNews(
      tester,
      repository: const MockNewsRepository(
        loadDelay: Duration(milliseconds: 500),
      ),
      settle: false,
    );

    expect(find.byKey(NewsPage.loadingKey), findsOneWidget);
    expect(find.byType(VitSkeletonList), findsOneWidget);

    // Drain the pending delay timer so it doesn't leak into later tests.
    await tester.pumpAndSettle();
  });

  testWidgets('SC-047 renders error state with retry', (tester) async {
    await pumpNews(
      tester,
      repository: const _FixedStateNewsRepository(NewsScreenState.error),
    );

    expect(find.byKey(NewsPage.errorKey), findsOneWidget);
    expect(find.byType(VitErrorState), findsOneWidget);
    expect(find.text('Không tải được tin tức'), findsOneWidget);
    expect(find.text('Thử lại'), findsOneWidget);
  });

  testWidgets('SC-047 error state retries the news fetch', (tester) async {
    final flakyRepository = _FlakyNewsRepository();

    await pumpNews(tester, repository: flakyRepository);

    expect(find.byKey(NewsPage.errorKey), findsOneWidget);
    expect(find.text('Không tải được tin tức'), findsOneWidget);

    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();

    expect(find.byKey(NewsPage.errorKey), findsNothing);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsOneWidget);
  });

  testWidgets('SC-047 renders offline banner with cached articles', (
    tester,
  ) async {
    // `getNews()` awaits a real Future.delayed, so it must run through
    // `runAsync` — a bare `await` inside a testWidgets body never resolves
    // because the fake test clock is only advanced by `tester.pump`.
    final cachedSnapshot = await tester.runAsync(
      () => const MockNewsRepository(loadDelay: Duration.zero).getNews(),
    );
    final cachedArticles = cachedSnapshot!.articles;
    await pumpNews(
      tester,
      repository: _FixedStateNewsRepository(
        NewsScreenState.offline,
        articles: cachedArticles,
      ),
    );

    expect(find.byKey(NewsPage.offlineKey), findsOneWidget);
    expect(find.byType(VitOfflineBanner), findsOneWidget);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsOneWidget);
  });
}
