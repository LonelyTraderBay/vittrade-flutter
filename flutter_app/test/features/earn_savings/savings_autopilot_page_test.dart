import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_autopilot_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_dca_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAutoPilot(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsAutoPilot,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-350 mock repository exposes savings autopilot BE draft', () async {
    final snapshot = await const MockSavingsAutoPilotRepository()
        .getAutoPilot();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-autopilot');
    expect(snapshot.actionDraft, contains('autopilot/activate'));
    expect(snapshot.title, 'AutoPilot');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs.map((tab) => tab.label), [
      'Tổng quan',
      'Hoạt động (1)',
      'Cài đặt',
    ]);
    expect(snapshot.config.status, SavingsAutoPilotStatus.active);
    expect(snapshot.config.mode, SavingsAutoPilotMode.balanced);
    expect(
      snapshot.modules.map((module) => module.route),
      contains('/earn/savings/dca'),
    );
    expect(snapshot.actions, hasLength(6));
    expect(
      snapshot.actions.any(
        (action) => action.status == SavingsAutoPilotActionStatus.needsApproval,
      ),
      isTrue,
    );
    expect(snapshot.contractNotes, contains('approval queue'));
    expect(snapshot.supportedStates, contains(EarnScreenState.success));
  });

  testWidgets('SC-350 renders autopilot overview baseline', (tester) async {
    await pumpAutoPilot(tester);

    expect(find.byType(SavingsAutoPilotPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('AutoPilot'), findsOneWidget);
    expect(find.byKey(SavingsAutoPilotPage.summaryKey), findsOneWidget);
    expect(find.text('AutoPilot Savings'), findsOneWidget);
    expect(find.text('Cân bằng'), findsOneWidget);
    expect(find.text('\$1,000.00'), findsOneWidget);
    expect(find.text('APY hiệu quả'), findsOneWidget);
    expect(find.byKey(SavingsAutoPilotPage.moduleKey('dca')), findsOneWidget);
    expect(find.byKey(SavingsAutoPilotPage.actionKey('act1')), findsOneWidget);
  });

  testWidgets('SC-350 first viewport reaches first automation module', (
    tester,
  ) async {
    await pumpAutoPilot(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-350 SavingsAutoPilotPage',
      semanticLabel: 'Chế độ tiết kiệm tự động',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SavingsAutoPilotPage.moduleKey('dca')),
      routeName: 'SC-350 SavingsAutoPilotPage',
      actionLabel: 'the DCA automation module',
    );
  });

  testWidgets('SC-350 toggles status and approves queued action', (
    tester,
  ) async {
    await pumpAutoPilot(tester);

    await tester.tap(find.byKey(SavingsAutoPilotPage.statusButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Tạm dừng'), findsOneWidget);

    await tester.tap(find.text('Hoạt động (1)'));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsAutoPilotPage.actionsKey), findsOneWidget);
    expect(find.text('Cần phê duyệt (1)'), findsOneWidget);

    await tester.tap(find.byKey(SavingsAutoPilotPage.approveActionKey));
    await tester.pumpAndSettle();

    expect(find.text('Cần phê duyệt (1)'), findsNothing);
    expect(find.text('Đã thực hiện'), findsWidgets);
  });

  testWidgets('SC-350 settings tab updates mode and monthly budget', (
    tester,
  ) async {
    await pumpAutoPilot(tester);

    await tester.tap(find.text('Cài đặt'));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsAutoPilotPage.settingsKey), findsOneWidget);
    final growthMode = find.byKey(
      SavingsAutoPilotPage.modeKey(SavingsAutoPilotMode.growth),
    );
    await Scrollable.ensureVisible(tester.element(growthMode), alignment: .45);
    await tester.pumpAndSettle();
    await tester.tap(growthMode);
    await tester.pumpAndSettle();

    final budget = find.byKey(SavingsAutoPilotPage.budgetKey(2000));
    await Scrollable.ensureVisible(tester.element(budget), alignment: .45);
    await tester.pumpAndSettle();
    await tester.tap(budget);
    await tester.pumpAndSettle();

    expect(find.text('Tăng trưởng'), findsWidgets);
    expect(find.text('\$2,000.00'), findsWidgets);
  });

  testWidgets('SC-350 module tile opens DCA route', (tester) async {
    await pumpAutoPilot(tester);

    await tester.tap(find.byKey(SavingsAutoPilotPage.moduleKey('dca')));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsDCAPage), findsOneWidget);
  });

  testWidgets('SC-350 savings insight edge opens autopilot page', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(SavingsPage.autopilotInsightKey),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(SavingsPage.autopilotInsightKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsAutoPilotPage), findsOneWidget);
  });
}
