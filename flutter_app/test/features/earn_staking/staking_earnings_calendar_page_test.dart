import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earnings_calendar_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

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
            initialLocation: AppRoutePaths.earnCalendar,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-361 mock repository exposes earnings calendar BE draft', () async {
    final snapshot = await const MockStakingEarningsCalendarRepository()
        .getCalendar();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-calendar');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('POST /calendar/export'));
    expect(snapshot.title, 'Lịch nhận lãi');
    expect(snapshot.backRoute, AppRoutePaths.earnDashboard);
    expect(snapshot.defaultTab, 'calendar');
    expect(snapshot.totalUpcomingUsd, 14359.20);
    expect(snapshot.events, hasLength(10));
    expect(snapshot.events.first.type, StakingCalendarEventType.dailyReward);
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-361 renders calendar baseline', (tester) async {
    await pumpCalendar(tester);

    expect(find.byType(StakingEarningsCalendarPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch nhận lãi'), findsOneWidget);
    expect(find.byKey(StakingEarningsCalendarPage.summaryKey), findsOneWidget);
    expect(find.text(r'+$14,359.20'), findsOneWidget);
    expect(find.textContaining('10 sự kiện sắp tới'), findsOneWidget);
    expect(find.byKey(StakingEarningsCalendarPage.tabsKey), findsOneWidget);
    expect(
      find.byKey(StakingEarningsCalendarPage.calendarCardKey),
      findsOneWidget,
    );
    expect(find.text('Tháng 3 2026'), findsOneWidget);
    expect(find.byKey(StakingEarningsCalendarPage.dayKey(7)), findsOneWidget);
    expect(find.byKey(StakingEarningsCalendarPage.dayKey(25)), findsOneWidget);
    expect(find.byKey(StakingEarningsCalendarPage.legendKey), findsOneWidget);

    await tester.ensureVisible(find.byKey(StakingEarningsCalendarPage.infoKey));
    expect(find.text('Về Lịch nhận lãi'), findsOneWidget);
  });

  testWidgets('SC-361 tab and action state are interactive', (tester) async {
    await pumpCalendar(tester);

    await tester.tap(find.text('Danh sách'));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingEarningsCalendarPage.listKey), findsOneWidget);
    expect(
      find.byKey(StakingEarningsCalendarPage.eventKey('e1')),
      findsOneWidget,
    );
    expect(find.text('USDT Flexible'), findsWidgets);

    await tester.tap(find.byKey(StakingEarningsCalendarPage.notificationKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nhận thông báo trước 24h'), findsNothing);

    await tester.tap(find.byKey(StakingEarningsCalendarPage.exportKey));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-361 month navigation updates visible calendar', (
    tester,
  ) async {
    await pumpCalendar(tester);

    await tester.tap(find.byKey(StakingEarningsCalendarPage.nextMonthKey));
    await tester.pumpAndSettle();
    expect(find.text('Tháng 4 2026'), findsOneWidget);

    await tester.tap(find.byKey(StakingEarningsCalendarPage.previousMonthKey));
    await tester.pumpAndSettle();
    expect(find.text('Tháng 3 2026'), findsOneWidget);
  });

  testWidgets('SC-361 header back returns to staking dashboard', (
    tester,
  ) async {
    await pumpCalendar(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingDashboardPage), findsOneWidget);
    expect(find.text('Staking Dashboard'), findsOneWidget);
  });
}
