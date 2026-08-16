import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/claim/launchpad_claim_receipt_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_staking_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpStaking(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadStaking,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-298 mock repository exposes launchpad staking BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getStaking();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-staking');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('POST /launchpad/subscribe'));
    expect(snapshot.title, 'Launchpool Staking');
    expect(snapshot.subtitle, 'Stake token · Nhận phần thưởng');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.detailRoute, AppRoutePaths.launchpadSample);
    expect(snapshot.batchClaimRoute, AppRoutePaths.launchpadBatchClaim);
    expect(
      snapshot.claimReceiptRoute,
      AppRoutePaths.launchpadClaimReceiptPos001,
    );
    expect(snapshot.pools, hasLength(3));
    expect(snapshot.positions, hasLength(2));
    expect(snapshot.totalStaked, 7500);
    expect(snapshot.totalPendingRewards, 2140);
    expect(snapshot.contractNotes, contains('launchpoolPools'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-298 renders pools tab baseline structure', (tester) async {
    await pumpStaking(tester);

    expect(find.byType(LaunchpadStakingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Launchpool Staking'), findsWidgets);
    expect(find.text('Stake token · Nhận phần thưởng'), findsOneWidget);
    expect(find.byKey(LaunchpadStakingPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadStakingPage.heroKey), findsOneWidget);
    expect(find.text('Tổng giá trị stake'), findsOneWidget);
    expect(find.text(r'$7,500'), findsOneWidget);
    expect(find.byKey(LaunchpadStakingPage.poolKey('pool1')), findsOneWidget);
    expect(find.byKey(LaunchpadStakingPage.poolKey('pool2')), findsOneWidget);
    expect(find.byKey(LaunchpadStakingPage.poolKey('pool3')), findsOneWidget);
    expect(find.text('GreenChain Eco'), findsOneWidget);
    expect(find.text('NexaAI Protocol'), findsOneWidget);
    expect(find.text('OmniDEX'), findsOneWidget);
    expect(find.text('Lưu ý rủi ro đầu tư'), findsOneWidget);
  });

  testWidgets('SC-298 first viewport reaches first staking pool', (
    tester,
  ) async {
    await pumpStaking(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-298 LaunchpadStakingPage',
      semanticLabel: 'Stake token Launchpool và nhận phần thưởng',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadStakingPage.poolKey('pool1')),
      routeName: 'SC-298 LaunchpadStakingPage',
      actionLabel: 'the first staking pool',
    );
  });

  testWidgets('SC-298 positions tab wires batch claim and receipt edges', (
    tester,
  ) async {
    await pumpStaking(tester);

    await tester.tap(find.byKey(LaunchpadStakingPage.tabKey('positions')));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadStakingPage.batchClaimKey), findsOneWidget);
    expect(find.byKey(LaunchpadStakingPage.positionKey('sp1')), findsOneWidget);
    expect(find.byKey(LaunchpadStakingPage.positionKey('sp2')), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadStakingPage.batchClaimKey));
    await tester.pumpAndSettle();
    expect(find.text('Nhận hàng loạt'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LaunchpadStakingPage.tabKey('positions')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LaunchpadStakingPage.claimKey('sp1')));
    await tester.pumpAndSettle();
    expect(find.byType(LaunchpadClaimReceiptPage), findsOneWidget);
    expect(find.text('Phần thưởng'), findsOneWidget);
  });

  testWidgets('SC-298 calculator tab renders reward estimator state', (
    tester,
  ) async {
    await pumpStaking(tester);

    await tester.tap(find.byKey(LaunchpadStakingPage.tabKey('calculator')));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadStakingPage.calculatorKey), findsOneWidget);
    expect(find.text('Tính toán phần thưởng'), findsOneWidget);
    expect(find.text('Số tiền stake'), findsOneWidget);
    expect(find.text('Phần thưởng ước tính'), findsOneWidget);
  });

  testWidgets('SC-298 header back returns to launchpad', (tester) async {
    await pumpStaking(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
    expect(find.text('Launchpad'), findsWidgets);
  });
}
