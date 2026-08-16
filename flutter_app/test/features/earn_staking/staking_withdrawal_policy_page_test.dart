import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_withdrawal_policy_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpWithdrawalPolicy(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnStakingWithdrawalPolicy,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-355 mock repository exposes staking withdrawal BE draft', () async {
    final snapshot = await const MockStakingWithdrawalPolicyRepository()
        .getPolicy();

    expect(
      snapshot.endpoint,
      '/api/mobile/earn/earn-staking-withdrawal-policy',
    );
    expect(snapshot.actionDraft, contains('POST /wallet/withdraw-preview'));
    expect(snapshot.actionDraft, contains('POST /wallet/withdraw-confirm'));
    expect(snapshot.actionDraft, contains('audit trail'));
    expect(snapshot.title, 'Chính sách Rút tiền');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.tabs.map((tab) => tab.id), [
      'timeline',
      'penalties',
      'emergency',
    ]);
    expect(snapshot.processSteps, hasLength(4));
    expect(snapshot.timelines, hasLength(6));
    expect(snapshot.penaltyExamples, hasLength(2));
    expect(snapshot.emergencySteps, hasLength(5));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      ]),
    );
  });

  testWidgets('SC-355 renders timeline baseline in Earn shell', (tester) async {
    await pumpWithdrawalPolicy(tester);

    expect(find.byType(StakingWithdrawalPolicyPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chính sách Rút tiền'), findsOneWidget);
    expect(find.byKey(StakingWithdrawalPolicyPage.infoKey), findsOneWidget);
    expect(find.byKey(StakingWithdrawalPolicyPage.processKey), findsOneWidget);
    expect(find.text('Quy trình Rút tiền'), findsOneWidget);
    expect(find.text('Staking Linh hoạt'), findsOneWidget);
    expect(find.text('Staking Cố định 30D'), findsOneWidget);
  });

  testWidgets('SC-355 first viewport reaches withdrawal process', (
    tester,
  ) async {
    await pumpWithdrawalPolicy(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-355 StakingWithdrawalPolicyPage',
      semanticLabel: 'Chính sách rút tiền staking',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingWithdrawalPolicyPage.processKey),
      routeName: 'SC-355 StakingWithdrawalPolicyPage',
      actionLabel: 'the withdrawal process card',
    );
  });

  testWidgets('SC-355 switches to penalties and opens calculator preview', (
    tester,
  ) async {
    await pumpWithdrawalPolicy(tester);

    await tester.tap(find.text('Phí rút sớm').first);
    await tester.pumpAndSettle();

    expect(find.text('Công thức Phí rút sớm:'), findsOneWidget);
    expect(find.text('Tình huống 1: Rút sớm sau 20 ngày'), findsOneWidget);

    final calculatorCta = find.byKey(
      StakingWithdrawalPolicyPage.calculatorCtaKey,
    );
    await Scrollable.ensureVisible(
      tester.element(calculatorCta),
      alignment: .7,
    );
    await tester.pumpAndSettle();
    await tester.tap(calculatorCta);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('sc355_calculator_principal')),
      '1000',
    );
    await tester.enterText(
      find.byKey(const Key('sc355_calculator_earned')),
      '50',
    );
    await tester.enterText(
      find.byKey(const Key('sc355_calculator_days')),
      '45',
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingWithdrawalPolicyPage.calculatorResultKey),
      findsOneWidget,
    );
    expect(find.text('-25.00 (50%)'), findsOneWidget);
    expect(find.text('+25.00'), findsOneWidget);
    expect(find.text('1025.00'), findsOneWidget);

    await tester.tap(find.text('Xem preview rút'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Preview mock đã sẵn sàng'), findsOneWidget);
  });

  testWidgets('SC-355 switches to emergency policy state', (tester) async {
    await pumpWithdrawalPolicy(tester);

    await tester.tap(find.text('Rút khẩn cấp'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingWithdrawalPolicyPage.emergencyKey),
      findsOneWidget,
    );
    expect(find.text('Khi nào cần rút khẩn cấp?'), findsOneWidget);
    expect(find.text('Quy trình Rút khẩn cấp'), findsOneWidget);
    expect(find.text('Phí Rút khẩn cấp'), findsOneWidget);
    expect(find.text('support.platform.com/chat'), findsOneWidget);
  });

  testWidgets('SC-355 header back returns to staking route', (tester) async {
    await pumpWithdrawalPolicy(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
