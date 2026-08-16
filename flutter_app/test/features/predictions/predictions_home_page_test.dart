import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_search_page.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPredictions(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictions,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-027 mock repository exposes the BE draft read model', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getHome();

    expect(snapshot.events.map((event) => event.id).take(3), [
      'pred-5',
      'pred-10',
      'pred-1',
    ]);
    expect(snapshot.events, hasLength(12));
    expect(snapshot.categories, containsAll(['Live Crypto', 'Politics', 'AI']));
    expect(snapshot.openPositionCount, 5);
    expect(snapshot.positions, hasLength(5));
    expect(snapshot.orders, hasLength(2));
    expect(snapshot.receipts, hasLength(1));
    expect(snapshot.rewards, hasLength(2));
    expect(snapshot.breakingMovers.map((event) => event.id), [
      'pred-5',
      'pred-10',
      'pred-1',
    ]);
    expect(snapshot.lastUpdatedLabel, 'read-only');
    expect(
      snapshot.supportedStates,
      containsAll([
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      ]),
    );

    final newest = await repo.getHome(filter: PredictionFilterTab.newEvents);
    expect(newest.events.first.id, 'pred-10');

    final liveCrypto = await repo.getHome(category: 'Live Crypto');
    expect(liveCrypto.events.map((event) => event.id), contains('pred-1'));
    expect(liveCrypto.events.map((event) => event.category).toSet(), {
      'Live Crypto',
    });

    final search = await repo.getHome(searchQuery: 'Tesla');
    expect(search.events.single.id, 'pred-10');
  });

  testWidgets('SC-027 renders inside the Markets shell', (tester) async {
    await pumpPredictions(tester);

    expect(find.byType(PredictionsHomePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Dự đoán thị trường'), findsOneWidget);
    expect(find.text('Tìm sự kiện...'), findsOneWidget);
    expect(find.text('Xu hướng'), findsOneWidget);
    expect(find.text('Live Crypto'), findsWidgets);
    expect(find.text('Vị thế của tôi'), findsOneWidget);
    expect(find.text('Biến động 24h'), findsOneWidget);
    expect(find.text('Chỉ điểm Arena'), findsOneWidget);
    expect(find.byKey(PredictionsHomePage.toolsSectionKey), findsOneWidget);
    expect(
      find.byKey(PredictionsHomePage.toolKey('portfolio')),
      findsOneWidget,
    );
    expect(
      find.byKey(PredictionsHomePage.toolKey('portfolio_analyzer')),
      findsOneWidget,
    );
    expect(
      find.byKey(PredictionsHomePage.toolKey('leaderboard')),
      findsOneWidget,
    );
    expect(find.byKey(PredictionsHomePage.toolKey('calendar')), findsOneWidget);
    expect(find.text('Apple releases AR glasses in 2026?'), findsOneWidget);
    expect(find.text('Tesla stock above \$400 by mid-2026?'), findsOneWidget);
  });

  testWidgets('SC-027 first viewport previews prediction action cards', (
    tester,
  ) async {
    await pumpPredictions(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-027 PredictionsHomePage',
      semanticLabel:
          'Trang chủ thị trường dự đoán: xác suất và sự kiện đang mở',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PredictionsHomePage.breakingMoversKey),
      targetLabel: 'the breaking movers action card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-027 filters by tab, category, and search field', (
    tester,
  ) async {
    await pumpPredictions(tester);

    await tester.tap(find.byKey(PredictionsHomePage.newFilterKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(PredictionsHomePage.eventCardKey('pred-10')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(PredictionsHomePage.categoryLiveCryptoKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(PredictionsHomePage.eventCardKey('pred-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(PredictionsHomePage.eventCardKey('pred-5')),
      findsNothing,
    );

    await tester.tap(find.byKey(PredictionsHomePage.categoryAllKey));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Tesla');
    await tester.pumpAndSettle();

    expect(
      find.byKey(PredictionsHomePage.eventCardKey('pred-10')),
      findsOneWidget,
    );
    expect(
      find.byKey(PredictionsHomePage.eventCardKey('pred-1')),
      findsNothing,
    );
    expect(find.text('Biến động 24h'), findsNothing);
  });

  testWidgets(
    'SC-027 navigation edges resolve through ported and placeholder routes',
    (tester) async {
      await pumpPredictions(tester);

      await tester.tap(find.byKey(PredictionsHomePage.searchActionKey));
      await tester.pumpAndSettle();
      expect(find.text('Tìm sự kiện'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(PredictionsHomePage.portfolioHeaderKey));
      await tester.pumpAndSettle();
      expect(find.text('Prediction Portfolio'), findsOneWidget);

      await pumpPredictions(tester);

      await tester.tap(find.byKey(PredictionsHomePage.breakingMoversKey));
      await tester.pumpAndSettle();
      expect(find.text('Biến động'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(PredictionsHomePage.myPredictionsKey));
      await tester.pumpAndSettle();
      expect(find.text('Prediction Portfolio'), findsOneWidget);

      await pumpPredictions(tester);

      await tester.tap(find.byKey(PredictionsHomePage.arenaBridgeKey));
      await tester.pumpAndSettle();
      expect(find.byType(ArenaHomePage), findsOneWidget);
    },
  );

  testWidgets('SC-027 event tap and back button keep the graph connected', (
    tester,
  ) async {
    await pumpPredictions(tester);

    await tester.tap(find.byKey(PredictionsHomePage.eventCardKey('pred-5')));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
    expect(find.text('Apple releases AR glasses in 2026?'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });

  testWidgets('SC-027 PERF-HN3: cap 8 event + "Xem tất cả" dẫn sang tìm kiếm', (
    tester,
  ) async {
    await pumpPredictions(tester);

    // Mock 12 sự kiện nhưng hub chỉ dựng lát cắt bounded 8 card.
    expect(tester.widgetList(find.byType(PredictionsHomePage)).length, 1);

    await tester.fling(
      find.byKey(PredictionsHomePage.contentKey),
      const Offset(0, -1200),
      3000,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(PredictionsHomePage.viewAllEventsKey),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Xem tất cả'), findsOneWidget);

    await tester.tap(find.byKey(PredictionsHomePage.viewAllEventsKey));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsSearchPage), findsOneWidget);
  });
}
