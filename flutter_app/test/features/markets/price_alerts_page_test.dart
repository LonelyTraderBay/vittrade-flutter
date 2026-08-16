import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/portfolio/price_alerts_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  String keyedText(WidgetTester tester, Key key) {
    return tester.widget<Text>(find.byKey(key)).data!;
  }

  Future<GoRouter> pumpAlerts(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter(
      initialLocation: AppRoutePaths.marketsAlerts,
    );
    await tester.pumpWidget(
      ProviderScope(child: VitTradeApp(routerConfig: router)),
    );
    await tester.pumpAndSettle();
    return router;
  }

  test('SC-014 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getPriceAlerts();

    expect(snapshot.priceAlerts, hasLength(4));
    expect(snapshot.priceAlerts.where((alert) => alert.isActive), hasLength(3));
    expect(
      snapshot.priceAlerts.where((alert) => alert.triggeredAt != null),
      hasLength(1),
    );
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Tất cả',
      'Đang hoạt động',
      'Đã kích hoạt',
    ]);
    expect(snapshot.chartSeries['alert001'], [3521.45, 3600.0]);
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

  testWidgets('SC-014 renders inside the Markets shell', (tester) async {
    await pumpAlerts(tester);

    expect(find.byType(PriceAlertsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Cảnh báo giá'), findsOneWidget);
    expect(find.text('Cảnh báo · Markets'), findsOneWidget);
    expect(find.text('Tổng'), findsOneWidget);
    expect(keyedText(tester, PriceAlertsPage.totalCountKey), '4');
    expect(find.text('Hoạt động'), findsOneWidget);
    expect(keyedText(tester, PriceAlertsPage.activeCountKey), '3');
    expect(find.text('ETH/USDT'), findsOneWidget);
    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('Đã kích hoạt'), findsWidgets);
    expect(find.byKey(PriceAlertsPage.addAlertKey), findsOneWidget);
  });

  testWidgets('SC-014 first viewport reaches first alert card', (tester) async {
    await pumpAlerts(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'PriceAlertsPage',
      semanticLabel: 'Cảnh báo giá',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PriceAlertsPage.cardKey('alert001')),
      targetLabel: 'first price alert card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-014 filters active and triggered alerts', (tester) async {
    await pumpAlerts(tester);

    await tester.tap(find.byKey(PriceAlertsPage.activeFilterKey));
    await tester.pumpAndSettle();

    expect(find.byKey(PriceAlertsPage.cardKey('alert001')), findsOneWidget);
    expect(find.byKey(PriceAlertsPage.cardKey('alert004')), findsNothing);

    await tester.tap(find.byKey(PriceAlertsPage.triggeredFilterKey));
    await tester.pumpAndSettle();

    expect(find.byKey(PriceAlertsPage.cardKey('alert004')), findsOneWidget);
    expect(find.byKey(PriceAlertsPage.cardKey('alert001')), findsNothing);
  });

  testWidgets('SC-014 supports local toggle, delete, and add action', (
    tester,
  ) async {
    await pumpAlerts(tester);

    await tester.tap(find.byKey(PriceAlertsPage.toggleKey('alert001')));
    await tester.pumpAndSettle();

    expect(keyedText(tester, PriceAlertsPage.activeCountKey), '2');

    await tester.tap(find.byKey(PriceAlertsPage.deleteKey('alert002')));
    await tester.pumpAndSettle();

    expect(find.byKey(PriceAlertsPage.cardKey('alert002')), findsNothing);
    expect(keyedText(tester, PriceAlertsPage.totalCountKey), '3');

    await tester.tap(find.byKey(PriceAlertsPage.addAlertKey));
    await tester.pump();

    expect(find.text('Tạo cảnh báo mới sẽ được bổ sung sau'), findsOneWidget);
  });

  testWidgets('SC-014 toggle/delete state persists across a navigation '
      'round-trip', (tester) async {
    final router = await pumpAlerts(tester);

    await tester.tap(find.byKey(PriceAlertsPage.deleteKey('alert002')));
    await tester.pumpAndSettle();

    expect(find.byKey(PriceAlertsPage.cardKey('alert002')), findsNothing);
    expect(keyedText(tester, PriceAlertsPage.totalCountKey), '3');

    // STATE-S23 round-trip: điều hướng đi rồi quay lại — mutation giữ nguyên
    // (state sống ở Notifier, không phải late List của trang).
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(MarketListPage), findsOneWidget);

    router.go(AppRoutePaths.marketsAlerts);
    await tester.pumpAndSettle();
    expect(find.byKey(PriceAlertsPage.cardKey('alert002')), findsNothing);
    expect(keyedText(tester, PriceAlertsPage.totalCountKey), '3');
  });

  testWidgets('SC-014 back button returns to SC-008 Markets', (tester) async {
    await pumpAlerts(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
