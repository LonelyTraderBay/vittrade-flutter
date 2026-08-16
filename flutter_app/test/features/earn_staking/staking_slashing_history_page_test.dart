import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_slashing_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSlashingHistory(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSlashingHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-382 mock repository exposes slashing history BE draft', () async {
    final snapshot = await const MockStakingSlashingHistoryRepository()
        .getSlashingHistory();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-slashing-history');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Slashing History');
    expect(snapshot.backRoute, AppRoutePaths.earnRiskDashboard);
    expect(snapshot.stats.totalEvents, 3);
    expect(snapshot.stats.totalSlashedEth, 5.7);
    expect(snapshot.stats.coverageRate, 89.5);
    expect(snapshot.events, hasLength(3));
    expect(snapshot.events.first.validator, 'Validator #3');
    expect(snapshot.trend, hasLength(12));
    expect(snapshot.networkBreakdown, hasLength(2));
    expect(snapshot.reasonBreakdown, hasLength(3));
    expect(snapshot.preventionMeasures, hasLength(4));
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

  testWidgets('SC-382 renders slashing history baseline', (tester) async {
    await pumpSlashingHistory(tester);

    expect(find.byType(StakingSlashingHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Slashing History'), findsOneWidget);
    expect(find.byKey(StakingSlashingHistoryPage.infoKey), findsOneWidget);
    expect(find.text('Protected by Insurance'), findsOneWidget);
    expect(find.textContaining('89.5%'), findsWidgets);
    expect(find.byKey(StakingSlashingHistoryPage.statsKey), findsOneWidget);
    expect(find.text('Total Events'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('5.7 ETH'), findsOneWidget);
    expect(find.text('5.1 ETH'), findsOneWidget);
    expect(find.text('2.5 days'), findsOneWidget);
    expect(find.byKey(StakingSlashingHistoryPage.tabsKey), findsOneWidget);
    expect(find.byKey(StakingSlashingHistoryPage.historyKey), findsOneWidget);
    expect(find.text('Slashing Events'), findsOneWidget);
    expect(find.text('Validator #3'), findsOneWidget);
    expect(find.text('Validator #7'), findsOneWidget);
    expect(find.text('Fully Covered'), findsNWidgets(2));
  });

  testWidgets('SC-382 statistics tab renders trend and breakdowns', (
    tester,
  ) async {
    await pumpSlashingHistory(tester);

    await tester.tap(
      find.byKey(StakingSlashingHistoryPage.tabKey('statistics')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingSlashingHistoryPage.statisticsKey),
      findsOneWidget,
    );
    expect(find.text('12-Month Trend'), findsOneWidget);
    expect(find.byKey(StakingSlashingHistoryPage.trendKey), findsOneWidget);
    expect(find.text('-40% vs 12 months ago'), findsOneWidget);
    expect(find.text('Breakdown by Network'), findsOneWidget);
    expect(find.text('Ethereum'), findsOneWidget);
    expect(find.text('Solana'), findsOneWidget);
    expect(find.text('Breakdown by Reason'), findsOneWidget);
    expect(find.text('Double Signing'), findsOneWidget);
  });

  testWidgets('SC-382 prevention tab renders active controls', (tester) async {
    await pumpSlashingHistory(tester);

    await tester.tap(
      find.byKey(StakingSlashingHistoryPage.tabKey('prevention')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingSlashingHistoryPage.preventionKey),
      findsOneWidget,
    );
    expect(find.text('Active Prevention Measures'), findsOneWidget);
    expect(find.text('Multi-Validator Distribution'), findsOneWidget);
    expect(find.text('Real-time Monitoring'), findsOneWidget);
    expect(find.text('Auto-Rebalancing'), findsOneWidget);
    expect(find.text('Insurance Fund'), findsOneWidget);
    expect(find.textContaining('Proactive Protection'), findsOneWidget);
  });

  testWidgets('SC-382 header back returns to risk dashboard', (tester) async {
    await pumpSlashingHistory(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingRiskDashboardPage), findsOneWidget);
    expect(find.text('Risk Dashboard'), findsOneWidget);
  });
}
