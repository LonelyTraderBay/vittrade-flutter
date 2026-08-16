import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_analytics_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earnings_calendar_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpDashboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnDashboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-358 mock repository exposes dashboard BE draft', () async {
    final snapshot = await const MockStakingDashboardRepository()
        .getDashboard();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-dashboard');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('realtime-refresh'));
    expect(snapshot.title, 'Staking Dashboard');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.stakingRoute, AppRoutePaths.earnStaking);
    expect(snapshot.analyticsRoute, AppRoutePaths.earnAnalytics);
    expect(snapshot.historyRoute, AppRoutePaths.earnHistory);
    expect(snapshot.calendarRoute, AppRoutePaths.earnCalendar);
    expect(snapshot.positions, hasLength(5));
    expect(snapshot.allocations.map((item) => item.asset), [
      'BTC',
      'USDT',
      'ETH',
      'SOL',
      'LP',
    ]);
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-358 renders dashboard baseline shell', (tester) async {
    await pumpDashboard(tester);

    expect(find.byType(StakingDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Staking Dashboard'), findsOneWidget);
    expect(find.byKey(StakingDashboardPage.summaryKey), findsOneWidget);
    expect(find.text('Tổng giá trị Staking'), findsOneWidget);
    expect(find.text(r'$17,577.00'), findsOneWidget);
    expect(find.text('+\$315.82'), findsOneWidget);
    expect(find.text('8.45%'), findsOneWidget);
    expect(find.text('3 active'), findsOneWidget);
    expect(find.byKey(StakingDashboardPage.performanceKey), findsOneWidget);
    expect(find.byKey(StakingDashboardPage.allocationKey), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);
    expect(find.text('USDT'), findsWidgets);
  });

  testWidgets('SC-358 positions and maturity alert render', (tester) async {
    await pumpDashboard(tester);

    await tester.ensureVisible(
      find.byKey(StakingDashboardPage.positionKey('p1')),
    );
    expect(find.text('Vị thế Hoạt động (5)'), findsOneWidget);
    expect(find.text('BTC Fixed 90D'), findsOneWidget);
    expect(find.text('USDT Flexible'), findsOneWidget);

    await tester.ensureVisible(find.byKey(StakingDashboardPage.alertKey));
    expect(find.text('2 vị thế sắp đáo hạn'), findsOneWidget);
    expect(find.textContaining('không bỏ lỡ rewards'), findsOneWidget);
  });

  testWidgets('SC-358 navigation edges open safe routes', (tester) async {
    await pumpDashboard(tester);

    await tester.ensureVisible(find.byKey(StakingDashboardPage.analyticsKey));
    await tester.tap(find.byKey(StakingDashboardPage.analyticsKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingAnalyticsPage), findsOneWidget);
    expect(find.text('Phân tích Hiệu suất'), findsOneWidget);

    await pumpDashboard(tester);
    await tester.ensureVisible(find.byKey(StakingDashboardPage.historyKey));
    await tester.tap(find.byKey(StakingDashboardPage.historyKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingHistoryPage), findsOneWidget);
    expect(find.text('Lịch sử Staking'), findsOneWidget);

    await pumpDashboard(tester);
    await tester.ensureVisible(find.byKey(StakingDashboardPage.calendarKey));
    await tester.tap(find.byKey(StakingDashboardPage.calendarKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarningsCalendarPage), findsOneWidget);
    expect(find.text('Lịch nhận lãi'), findsOneWidget);

    await pumpDashboard(tester);
    await tester.ensureVisible(find.byKey(StakingDashboardPage.stakeMoreKey));
    await tester.tap(find.byKey(StakingDashboardPage.stakeMoreKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
  });

  testWidgets('SC-358 header back returns to staking hub', (tester) async {
    await pumpDashboard(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
