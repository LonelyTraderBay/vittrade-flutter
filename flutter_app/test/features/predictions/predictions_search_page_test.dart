import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_search_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSearch(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsSearch,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-028 mock repository exposes search filters for the BE draft',
    () async {
      final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
      final snapshot = await repo.getSearch();

      expect(snapshot.results, hasLength(12));
      expect(snapshot.results.map((event) => event.id).take(3), [
        'pred-5',
        'pred-10',
        'pred-1',
      ]);
      expect(snapshot.categories, containsAll(['Live Crypto', 'Sports', 'AI']));
      expect(snapshot.orders, hasLength(2));
      expect(snapshot.receipts, hasLength(1));
      expect(snapshot.rewards, hasLength(2));
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

      final liquidity = await repo.getSearch(
        sort: PredictionSearchSort.liquidity,
      );
      expect(liquidity.results.first.id, 'pred-1');

      final resolved = await repo.getSearch(
        status: PredictionStatusFilter.resolved,
      );
      expect(resolved.results.map((event) => event.id), ['pred-r1', 'pred-r2']);

      final liveCrypto = await repo.getSearch(category: 'Live Crypto');
      expect(liveCrypto.results.map((event) => event.category).toSet(), {
        'Live Crypto',
      });

      final search = await repo.getSearch(searchQuery: 'Tesla');
      expect(search.results.single.id, 'pred-10');
    },
  );

  testWidgets('SC-028 renders search inside the Markets shell', (tester) async {
    await pumpSearch(tester);

    expect(find.byType(PredictionsSearchPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Tìm sự kiện'), findsOneWidget);
    expect(find.text('Tìm theo tiêu đề, thẻ, danh mục...'), findsOneWidget);
    expect(find.text('Sắp xếp'), findsOneWidget);
    expect(find.text('Trạng thái'), findsOneWidget);
    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.text('Tìm thấy 12 sự kiện'), findsOneWidget);
    expect(find.text('Apple releases AR glasses in 2026?'), findsOneWidget);
    expect(find.text('Tesla stock above \$400 by mid-2026?'), findsOneWidget);
  });

  testWidgets('SC-028 first viewport reaches first search result', (
    tester,
  ) async {
    await pumpSearch(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'PredictionsSearchPage',
      semanticLabel: 'Tìm sự kiện dự đoán: lọc theo chủ đề và xác suất',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PredictionsSearchPage.resultKey('pred-5')),
      minVisibleHeight: 12,
      targetLabel: 'first prediction search result',
      reason:
          'Prediction search should expose a real event result above bottom '
          'navigation after the compact search and filter controls.',
    );
  });

  testWidgets('SC-028 supports search, status, category, and clear filters', (
    tester,
  ) async {
    await pumpSearch(tester);

    await tester.enterText(find.byType(TextField), 'Tesla');
    await tester.pumpAndSettle();

    expect(find.text('Tìm thấy 1 sự kiện'), findsOneWidget);
    expect(
      find.byKey(PredictionsSearchPage.resultKey('pred-10')),
      findsOneWidget,
    );
    expect(find.byKey(PredictionsSearchPage.resultKey('pred-5')), findsNothing);

    await tester.tap(find.byKey(PredictionsSearchPage.clearFiltersKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(PredictionsSearchPage.statusResolvedKey));
    await tester.pumpAndSettle();

    expect(find.text('Tìm thấy 2 sự kiện'), findsOneWidget);
    expect(
      find.byKey(PredictionsSearchPage.resultKey('pred-r1')),
      findsOneWidget,
    );
    expect(find.text('ĐÃ KẾT THÚC'), findsWidgets);

    await tester.tap(find.byKey(PredictionsSearchPage.statusActiveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(PredictionsSearchPage.categoryLiveCryptoKey));
    await tester.pumpAndSettle();

    expect(find.text('Tìm thấy 4 sự kiện'), findsOneWidget);
    expect(
      find.byKey(PredictionsSearchPage.resultKey('pred-1')),
      findsOneWidget,
    );
    expect(find.byKey(PredictionsSearchPage.resultKey('pred-5')), findsNothing);
  });

  testWidgets('SC-028 filter toggle and result navigation are wired', (
    tester,
  ) async {
    await pumpSearch(tester);

    await tester.tap(find.byKey(PredictionsSearchPage.filtersToggleKey));
    await tester.pumpAndSettle();

    expect(find.text('Sắp xếp'), findsNothing);

    await tester.tap(find.byKey(PredictionsSearchPage.resultKey('pred-5')));
    await tester.pumpAndSettle();

    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
    expect(find.text('Apple releases AR glasses in 2026?'), findsOneWidget);
  });

  testWidgets('SC-028 back button returns to SC-027 Predictions home', (
    tester,
  ) async {
    await pumpSearch(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
