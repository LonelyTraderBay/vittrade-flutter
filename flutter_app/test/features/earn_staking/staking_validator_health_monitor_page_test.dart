import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_validator_health_monitor_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpValidatorHealth(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnValidatorHealthMonitor,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-383 mock repository exposes validator health BE draft', () async {
    final snapshot = await const MockStakingValidatorHealthMonitorRepository()
        .getValidatorHealth();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-validator-health-monitor');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Validator Health');
    expect(snapshot.backRoute, AppRoutePaths.earnRiskDashboard);
    expect(snapshot.validators, hasLength(3));
    expect(snapshot.healthyCount, 2);
    expect(snapshot.warningCount, 1);
    expect(snapshot.averageUptime.toStringAsFixed(2), '99.46');
    expect(snapshot.validators.first.address, '0x1234...5678');
    expect(snapshot.validators.last.missedBlocks, 15);
    expect(snapshot.uptimeHistory, hasLength(7));
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

  testWidgets('SC-383 renders validator health monitor baseline', (
    tester,
  ) async {
    await pumpValidatorHealth(tester);

    expect(find.byType(StakingValidatorHealthMonitorPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Validator Health'), findsOneWidget);
    expect(
      find.byKey(StakingValidatorHealthMonitorPage.statsKey),
      findsOneWidget,
    );
    expect(find.text('Healthy'), findsWidgets);
    expect(find.text('Warning'), findsWidgets);
    expect(find.text('99.46%'), findsOneWidget);
    expect(
      find.byKey(StakingValidatorHealthMonitorPage.validatorsKey),
      findsOneWidget,
    );
    expect(find.text('Active Validators'), findsOneWidget);
    expect(find.text('Validator #1'), findsWidgets);
    expect(find.text('Validator #2'), findsWidgets);
    expect(find.text('Validator #3'), findsWidgets);
    expect(find.text('15,000 ETH'), findsOneWidget);
    expect(find.text('10,000 ETH'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
  });

  testWidgets('SC-383 first viewport reaches first validator', (tester) async {
    await pumpValidatorHealth(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-383 StakingValidatorHealthMonitorPage',
      semanticLabel: 'Giám sát sức khỏe validator staking',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingValidatorHealthMonitorPage.validatorKey('v1')),
      routeName: 'SC-383 StakingValidatorHealthMonitorPage',
      actionLabel: 'the first validator card',
    );
  });

  testWidgets('SC-383 expands warning validator details', (tester) async {
    await pumpValidatorHealth(tester);

    await tester.tap(
      find.byKey(StakingValidatorHealthMonitorPage.validatorKey('v3')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Last Block Produced'), findsOneWidget);
    expect(find.text('5 mins ago'), findsOneWidget);
    expect(find.text('View Details'), findsOneWidget);
    expect(find.text('Rebalance Stake'), findsOneWidget);
  });

  testWidgets('SC-383 renders trend, action warning, and footer', (
    tester,
  ) async {
    await pumpValidatorHealth(tester);

    await tester.ensureVisible(
      find.byKey(StakingValidatorHealthMonitorPage.trendKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('7-Day Uptime Trend'), findsOneWidget);
    expect(find.text('Validator #1'), findsWidgets);
    expect(find.text('Validator #2'), findsWidgets);
    expect(find.text('Validator #3'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(StakingValidatorHealthMonitorPage.actionKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Action Required'), findsOneWidget);
    expect(find.textContaining('degraded performance'), findsOneWidget);
    expect(find.text('Auto-Rebalance Stake'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingValidatorHealthMonitorPage.footerKey),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Validator metrics updated'), findsOneWidget);
  });

  testWidgets('SC-383 header back returns to risk dashboard', (tester) async {
    await pumpValidatorHealth(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingRiskDashboardPage), findsOneWidget);
    expect(find.text('Risk Dashboard'), findsOneWidget);
  });
}
