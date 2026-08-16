import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/comparison_tool_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<GoRouter> pumpCompare(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter(
      initialLocation: AppRoutePaths.marketsCompare,
    );
    await tester.pumpWidget(
      ProviderScope(child: VitTradeApp(routerConfig: router)),
    );
    await tester.pumpAndSettle();
    return router;
  }

  test('SC-016 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getMarketComparison();

    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.selectedPairIds, ['btcusdt', 'ethusdt']);
    expect(snapshot.popularPairIds, [
      'btcusdt',
      'ethusdt',
      'solusdt',
      'bnbusdt',
    ]);
    expect(snapshot.metrics.map((metric) => metric.key), [
      'price',
      'mcap',
      'vol',
      'chg',
      'high',
      'low',
      'range',
      'volmcap',
    ]);
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.chartSeries['btcusdt'], isNotEmpty);
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
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

  testWidgets('SC-016 renders inside the Markets shell', (tester) async {
    await pumpCompare(tester);

    expect(find.byType(ComparisonToolPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('So sánh'), findsOneWidget);
    expect(find.byKey(ComparisonToolPage.tokenKey('btcusdt')), findsOneWidget);
    expect(find.byKey(ComparisonToolPage.tokenKey('ethusdt')), findsOneWidget);
    expect(find.byKey(ComparisonToolPage.addTokenKey), findsOneWidget);
    expect(find.text('Biểu đồ giá 24h'), findsOneWidget);
    expect(find.text('So sánh chi tiết'), findsOneWidget);
    expect(find.text('Giá hiện tại'), findsOneWidget);
    expect(find.text(r'$67,543.21'), findsOneWidget);
  });

  testWidgets('SC-016 opens picker and adds/removes a token', (tester) async {
    await pumpCompare(tester);

    await tester.tap(find.byKey(ComparisonToolPage.addTokenKey));
    await tester.pumpAndSettle();

    expect(find.byKey(ComparisonToolPage.pickerKey), findsOneWidget);

    await tester.tap(find.byKey(ComparisonToolPage.pickerTokenKey('solusdt')));
    await tester.pumpAndSettle();

    expect(find.byKey(ComparisonToolPage.tokenKey('solusdt')), findsOneWidget);
    expect(
      find.byKey(ComparisonToolPage.removeTokenKey('solusdt')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(ComparisonToolPage.removeTokenKey('ethusdt')));
    await tester.pumpAndSettle();

    expect(find.byKey(ComparisonToolPage.tokenKey('ethusdt')), findsNothing);
  });

  testWidgets('SC-016 selected token state persists across a navigation '
      'round-trip', (tester) async {
    final router = await pumpCompare(tester);

    await tester.tap(find.byKey(ComparisonToolPage.addTokenKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ComparisonToolPage.pickerTokenKey('solusdt')));
    await tester.pumpAndSettle();

    expect(find.byKey(ComparisonToolPage.tokenKey('solusdt')), findsOneWidget);

    // STATE-S23 round-trip: điều hướng đi rồi quay lại — mutation giữ nguyên
    // (state sống ở Notifier, không phải late List của trang).
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(MarketListPage), findsOneWidget);

    router.go(AppRoutePaths.marketsCompare);
    await tester.pumpAndSettle();
    expect(find.byKey(ComparisonToolPage.tokenKey('solusdt')), findsOneWidget);
  });

  testWidgets('SC-016 first viewport reaches compare actions', (tester) async {
    await pumpCompare(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-016 ComparisonToolPage',
      semanticLabel: 'So sánh token',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ComparisonToolPage.addTokenKey),
      routeName: 'SC-016 ComparisonToolPage',
      actionLabel: 'add token action',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ComparisonToolPage.tokenKey('btcusdt')),
      routeName: 'SC-016 ComparisonToolPage',
      actionLabel: 'selected token chip',
    );
  });

  testWidgets('SC-016 picker search filters available tokens', (tester) async {
    await pumpCompare(tester);

    await tester.tap(find.byKey(ComparisonToolPage.addTokenKey));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'link');
    await tester.pumpAndSettle();

    expect(
      find.byKey(ComparisonToolPage.pickerTokenKey('linkusdt')),
      findsOneWidget,
    );
    expect(
      find.byKey(ComparisonToolPage.pickerTokenKey('solusdt')),
      findsNothing,
    );
  });

  testWidgets('SC-016 back button returns to SC-008 Markets', (tester) async {
    await pumpCompare(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
