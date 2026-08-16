import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskDashboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnRiskDashboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-381 mock repository exposes risk dashboard BE draft', () async {
    final snapshot = await const MockStakingRiskDashboardRepository()
        .getRiskDashboard();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-risk-dashboard');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Risk Dashboard');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.overallScore, 28);
    expect(snapshot.totalStakedUsd, 100000);
    expect(snapshot.atRiskUsd, 5000);
    expect(snapshot.protectedPercent, 95);
    expect(snapshot.riskMetrics, hasLength(6));
    expect(
      snapshot.riskMetrics.first.actionRoute,
      AppRoutePaths.earnValidatorHealthMonitor,
    );
    expect(snapshot.exposures, hasLength(4));
    expect(snapshot.events, hasLength(3));
    expect(snapshot.actions, hasLength(4));
    expect(snapshot.actions.last.route, AppRoutePaths.earnInsurance);
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

  testWidgets('SC-381 renders overall risk dashboard baseline', (tester) async {
    await pumpRiskDashboard(tester);

    expect(find.byType(StakingRiskDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Risk Dashboard'), findsOneWidget);
    expect(find.byKey(StakingRiskDashboardPage.scoreKey), findsOneWidget);
    expect(find.text('Overall Risk Score'), findsOneWidget);
    expect(find.text('28'), findsOneWidget);
    expect(find.text('/ 100'), findsOneWidget);
    expect(find.text('Moderate Risk'), findsOneWidget);
    expect(find.text('\$100,000.00'), findsOneWidget);
    expect(find.text('\$5,000.00'), findsOneWidget);
    expect(find.text('95%'), findsOneWidget);
    expect(find.byKey(StakingRiskDashboardPage.metricsKey), findsOneWidget);
    expect(find.text('Risk Breakdown'), findsOneWidget);
    expect(find.text('Validator Health'), findsOneWidget);
    expect(find.text('Slashing Risk'), findsOneWidget);
    expect(find.text('Smart Contract Risk'), findsOneWidget);
  });

  testWidgets('SC-381 first viewport reaches first risk metric', (
    tester,
  ) async {
    await pumpRiskDashboard(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-381 StakingRiskDashboardPage',
      semanticLabel: 'Bảng điều khiển rủi ro staking — tổng quan và cảnh báo',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingRiskDashboardPage.metricKey('Validator Health')),
      routeName: 'SC-381 StakingRiskDashboardPage',
      actionLabel: 'the first risk metric card',
    );
  });

  testWidgets('SC-381 renders exposure, events, actions, and footer', (
    tester,
  ) async {
    await pumpRiskDashboard(tester);

    await tester.ensureVisible(
      find.byKey(StakingRiskDashboardPage.exposureKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Exposure by Asset'), findsOneWidget);
    expect(find.text('ETH'), findsOneWidget);
    expect(find.text('\$45,000.00'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);

    await tester.ensureVisible(find.byKey(StakingRiskDashboardPage.eventsKey));
    await tester.pumpAndSettle();
    expect(find.text('Recent Risk Events'), findsOneWidget);
    expect(find.text('High ETH Volatility Detected'), findsOneWidget);
    expect(find.text('Validator Uptime Alert'), findsOneWidget);
    expect(find.text('Smart Contract Upgrade Completed'), findsOneWidget);

    await tester.ensureVisible(find.byKey(StakingRiskDashboardPage.actionsKey));
    await tester.pumpAndSettle();
    expect(find.text('Risk Management Actions'), findsOneWidget);
    expect(find.text('Emergency Actions'), findsOneWidget);
    expect(find.text('Risk Calculator'), findsOneWidget);
    expect(find.text('Contingency Plan'), findsOneWidget);
    expect(find.text('Insurance Fund'), findsOneWidget);

    await tester.ensureVisible(find.byKey(StakingRiskDashboardPage.footerKey));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Risk scores are updated every 10 minutes'),
      findsOneWidget,
    );
  });

  testWidgets('SC-381 metric navigation opens validator monitor edge', (
    tester,
  ) async {
    await pumpRiskDashboard(tester);

    await tester.tap(
      find.byKey(StakingRiskDashboardPage.metricKey('Validator Health')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Validator Health'), findsOneWidget);
  });

  testWidgets('SC-381 action navigation opens risk calculator edge', (
    tester,
  ) async {
    await pumpRiskDashboard(tester);

    await tester.ensureVisible(
      find.byKey(StakingRiskDashboardPage.actionKey('Risk Calculator')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingRiskDashboardPage.actionKey('Risk Calculator')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Risk Calculator'), findsOneWidget);
  });

  testWidgets('SC-381 header back returns to staking hub', (tester) async {
    await pumpRiskDashboard(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
