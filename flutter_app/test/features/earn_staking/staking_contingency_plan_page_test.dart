import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_contingency_plan_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpContingencyPlan(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnContingencyPlan,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-386 mock repository exposes contingency plan BE draft', () async {
    final snapshot = await const MockStakingContingencyPlanRepository()
        .getContingencyPlan();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-contingency-plan');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Contingency Plan');
    expect(snapshot.backRoute, AppRoutePaths.earnRiskDashboard);
    expect(snapshot.metrics, hasLength(4));
    expect(snapshot.metrics.last.value, '165%');
    expect(snapshot.scenarios, hasLength(4));
    expect(snapshot.scenarios.first.response, hasLength(5));
    expect(snapshot.validationItems, hasLength(2));
    expect(snapshot.documents, hasLength(3));
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

  testWidgets('SC-386 renders contingency plan hero and recovery metrics', (
    tester,
  ) async {
    await pumpContingencyPlan(tester);

    expect(find.byType(StakingContingencyPlanPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Contingency Plan'), findsOneWidget);
    expect(find.byKey(StakingContingencyPlanPage.infoKey), findsOneWidget);
    expect(
      find.text('Disaster Recovery & Business Continuity'),
      findsOneWidget,
    );
    expect(find.textContaining('continuity of service'), findsOneWidget);

    expect(find.byKey(StakingContingencyPlanPage.metricsKey), findsOneWidget);
    expect(find.text('Recovery Metrics'), findsOneWidget);
    expect(find.text('Recovery Time (RTO)'), findsOneWidget);
    expect(find.text('4 hours'), findsOneWidget);
    expect(find.text('Data Loss Limit (RPO)'), findsOneWidget);
    expect(find.text('15 minutes'), findsOneWidget);
    expect(find.text('165%'), findsOneWidget);
  });

  testWidgets('SC-386 renders scenario playbooks', (tester) async {
    await pumpContingencyPlan(tester);

    await tester.ensureVisible(
      find.byKey(StakingContingencyPlanPage.scenariosKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Contingency Scenarios'), findsOneWidget);
    expect(find.text('Smart Contract Exploit'), findsOneWidget);
    expect(find.text('Critical Impact'), findsOneWidget);
    expect(find.text('Immediate Response'), findsWidgets);
    expect(find.text('Emergency withdrawal enabled'), findsOneWidget);
    expect(find.text('Insurance fund 165% coverage'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingContingencyPlanPage.scenarioKey('Regulatory Action')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Regulatory Action'), findsOneWidget);
    expect(find.text('Geographic restriction if required'), findsOneWidget);
  });

  testWidgets('SC-386 renders validation schedule, documents, and footer', (
    tester,
  ) async {
    await pumpContingencyPlan(tester);

    await tester.ensureVisible(
      find.byKey(StakingContingencyPlanPage.validationKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Testing & Validation'), findsOneWidget);
    expect(find.text('Last DR Test'), findsOneWidget);
    expect(find.text('15 February 2026'), findsOneWidget);
    expect(find.text('Next Scheduled Test'), findsOneWidget);
    expect(find.text('15 May 2026'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingContingencyPlanPage.documentsKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Documentation'), findsOneWidget);
    expect(find.text('Full Contingency Plan (PDF)'), findsOneWidget);
    expect(find.text('Incident Response Playbook'), findsOneWidget);
    expect(find.text('Business Continuity Plan'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingContingencyPlanPage.footerKey),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('reviewed annually'), findsOneWidget);
  });

  testWidgets('SC-386 risk dashboard action navigates to contingency plan', (
    tester,
  ) async {
    await pumpContingencyPlan(
      tester,
      initialLocation: AppRoutePaths.earnRiskDashboard,
    );

    await tester.ensureVisible(
      find.byKey(StakingRiskDashboardPage.actionKey('Contingency Plan')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingRiskDashboardPage.actionKey('Contingency Plan')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StakingContingencyPlanPage), findsOneWidget);
    expect(
      find.text('Disaster Recovery & Business Continuity'),
      findsOneWidget,
    );
  });

  testWidgets('SC-386 header back returns to risk dashboard', (tester) async {
    await pumpContingencyPlan(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingRiskDashboardPage), findsOneWidget);
    expect(find.text('Risk Dashboard'), findsOneWidget);
  });
}
