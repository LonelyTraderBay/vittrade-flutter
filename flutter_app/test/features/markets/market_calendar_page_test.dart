import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_calendar_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCalendar(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsCalendar,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-017 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getMarketCalendar();

    expect(snapshot.events, hasLength(12));
    expect(snapshot.stats.upcoming, 12);
    expect(snapshot.stats.highImpact, 6);
    expect(snapshot.stats.thisWeek, 7);
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, contains('Token Unlock'));
    expect(snapshot.screenFilters.sortOptions.map((item) => item.id), [
      'high',
      'medium',
      'low',
    ]);
    expect(snapshot.chartSeries['impact'], [12, 6, 7]);
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

    final unlocks = await repo.getMarketCalendar(
      query: const MarketCalendarQuery(type: MarketCalendarEventType.unlock),
    );
    expect(unlocks.events.map((event) => event.title), [
      'Mở khóa ARB',
      'Mở khóa MATIC',
      'Mở khóa OP',
    ]);
  });

  testWidgets('SC-017 renders inside the Markets shell', (tester) async {
    await pumpCalendar(tester);

    expect(find.byType(MarketCalendarPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Lịch sự kiện'), findsOneWidget);
    expect(find.text('Danh sách'), findsOneWidget);
    expect(find.text('Lịch'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Tác động cao'), findsOneWidget);
    expect(find.text('WLD niêm yết trên Coinbase'), findsOneWidget);
    expect(find.text('Mở khóa ARB'), findsOneWidget);
  });

  testWidgets('SC-017 first viewport reaches calendar controls', (
    tester,
  ) async {
    await pumpCalendar(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-017 MarketCalendarPage',
      semanticLabel: 'Lịch sự kiện',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(MarketCalendarPage.listTabKey),
      routeName: 'SC-017 MarketCalendarPage',
      actionLabel: 'the list calendar tab',
    );
  });

  testWidgets('SC-017 filters by event type and impact', (tester) async {
    await pumpCalendar(tester);

    await tester.tap(
      find.byKey(MarketCalendarPage.typeFilterKey('Token Unlock')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mở khóa ARB'), findsOneWidget);
    expect(find.text('Mở khóa MATIC'), findsOneWidget);
    expect(find.text('WLD niêm yết trên Coinbase'), findsNothing);

    await tester.tap(
      find.byKey(MarketCalendarPage.impactFilterKey(MarketCalendarImpact.high)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mở khóa ARB'), findsOneWidget);
    expect(find.text('Mở khóa OP'), findsOneWidget);
    expect(find.text('Mở khóa MATIC'), findsNothing);
  });

  testWidgets('SC-017 calendar tab returns to list and expands an event', (
    tester,
  ) async {
    await pumpCalendar(tester);

    await tester.tap(find.byKey(MarketCalendarPage.calendarTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Tháng 3, 2026'), findsOneWidget);

    // Ô ngày của WLD (ev7, dateIso 2026-03-11T18:00:00Z) phụ thuộc múi giờ
    // máy chạy test vì trang group theo .toLocal() (UTC+7 → ngày 12, UTC trên
    // CI → ngày 11) — tính lại bằng đúng phép biến đổi của trang.
    final wldDay = DateTime.parse('2026-03-11T18:00:00Z').toLocal().day;
    expect(find.byKey(MarketCalendarPage.dayKey(wldDay)), findsOneWidget);

    await tester.tap(find.byKey(MarketCalendarPage.dayKey(wldDay)));
    await tester.pumpAndSettle();

    expect(find.text('Danh sách'), findsOneWidget);
    expect(find.text('WLD niêm yết trên Coinbase'), findsOneWidget);
    expect(
      find.text('Worldcoin (WLD) sẽ được list trên Coinbase với cặp WLD/USD.'),
      findsOneWidget,
    );
  });

  testWidgets('SC-017 back button returns to SC-008 Markets', (tester) async {
    await pumpCalendar(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
