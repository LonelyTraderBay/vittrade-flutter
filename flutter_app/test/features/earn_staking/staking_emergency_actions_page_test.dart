import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_emergency_actions_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpEmergencyActions(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnEmergencyActions,
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

  test('SC-385 mock repository exposes emergency actions BE draft', () async {
    final snapshot = await const MockStakingEmergencyActionsRepository()
        .getEmergencyActions();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-emergency-actions');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Emergency Actions');
    expect(snapshot.backRoute, AppRoutePaths.earnRiskDashboard);
    expect(snapshot.warningTitle, 'Emergency Actions Only');
    expect(snapshot.actions, hasLength(3));
    expect(snapshot.actions.first.id, 'pause');
    expect(snapshot.actions[1].id, 'withdraw');
    expect(snapshot.useCases, hasLength(4));
    expect(snapshot.statusCards, hasLength(2));
    expect(snapshot.pauseSheet.confirmLabel, 'Confirm Pause');
    expect(snapshot.withdrawSheet.confirmLabel, 'Confirm Emergency Withdrawal');
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

  testWidgets('SC-385 renders emergency actions baseline', (tester) async {
    await pumpEmergencyActions(tester);

    expect(find.byType(StakingEmergencyActionsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Emergency Actions'), findsOneWidget);
    expect(find.byKey(StakingEmergencyActionsPage.warningKey), findsOneWidget);
    expect(find.text('Emergency Actions Only'), findsOneWidget);
    expect(find.textContaining('critical situations'), findsOneWidget);

    expect(find.byKey(StakingEmergencyActionsPage.actionsKey), findsOneWidget);
    expect(find.text('Available Actions'), findsOneWidget);
    expect(find.text('Pause All Staking'), findsOneWidget);
    expect(find.text('Emergency Withdrawal'), findsOneWidget);
    expect(find.text('Auto-Rebalance Validators'), findsOneWidget);
    expect(find.text('Moderate Impact - Reversible'), findsOneWidget);
    expect(find.text('High Impact - Penalties Apply'), findsOneWidget);
    expect(find.text('Low Impact - Recommended'), findsOneWidget);
  });

  testWidgets('SC-385 first viewport reaches primary emergency action', (
    tester,
  ) async {
    await pumpEmergencyActions(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-385 StakingEmergencyActionsPage',
      semanticLabel: 'Hành động khẩn cấp cần xác nhận',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingEmergencyActionsPage.actionKey('pause')),
      routeName: 'SC-385 StakingEmergencyActionsPage',
      actionLabel: 'the primary emergency action',
    );
  });

  testWidgets('SC-385 renders use cases, status, and footer', (tester) async {
    await pumpEmergencyActions(tester);

    await tester.ensureVisible(
      find.byKey(StakingEmergencyActionsPage.useCasesKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('When to Use Emergency Actions'), findsOneWidget);
    expect(find.text('Smart Contract Exploit'), findsOneWidget);
    expect(find.text('Validator Mass Failure'), findsOneWidget);
    expect(find.text('Extreme Market Event'), findsOneWidget);
    expect(find.text('Regulatory Action'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingEmergencyActionsPage.statusKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Current Status'), findsOneWidget);
    expect(find.text('All Systems Normal'), findsOneWidget);
    expect(find.text('Never'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingEmergencyActionsPage.footerKey),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Emergency actions are monitored'),
      findsOneWidget,
    );
  });

  testWidgets('SC-385 opens pause and withdrawal confirmation sheets', (
    tester,
  ) async {
    await pumpEmergencyActions(tester);

    await tester.tap(StakingEmergencyActionsPage.actionKey('pause').finder);
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingEmergencyActionsPage.pauseSheetKey),
      findsOneWidget,
    );
    expect(find.text('Confirm Pause'), findsOneWidget);
    await tester.tap(find.text('Confirm Pause'));
    await tester.pumpAndSettle();
    expect(find.byKey(StakingEmergencyActionsPage.pauseSheetKey), findsNothing);

    await tester.tap(StakingEmergencyActionsPage.actionKey('withdraw').finder);
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingEmergencyActionsPage.withdrawSheetKey),
      findsOneWidget,
    );
    expect(find.textContaining('5% early withdrawal penalty'), findsOneWidget);
    expect(find.text('Confirm Emergency Withdrawal'), findsOneWidget);
  });

  testWidgets('SC-385 risk dashboard action navigates to emergency actions', (
    tester,
  ) async {
    await pumpEmergencyActions(
      tester,
      initialLocation: AppRoutePaths.earnRiskDashboard,
    );

    await tester.ensureVisible(
      find.byKey(StakingRiskDashboardPage.actionKey('Emergency Actions')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingRiskDashboardPage.actionKey('Emergency Actions')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StakingEmergencyActionsPage), findsOneWidget);
    expect(find.text('Emergency Actions Only'), findsOneWidget);
  });

  testWidgets('SC-385 header back returns to risk dashboard', (tester) async {
    await pumpEmergencyActions(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingRiskDashboardPage), findsOneWidget);
    expect(find.text('Risk Dashboard'), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
