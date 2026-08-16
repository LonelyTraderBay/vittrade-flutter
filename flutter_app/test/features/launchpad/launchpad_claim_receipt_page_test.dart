import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/claim/launchpad_claim_receipt_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_staking_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpClaimReceipt(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadClaimReceiptPos001,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-302 mock repository exposes claim receipt BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getClaimReceipt('pos001');

    expect(
      snapshot.endpoint,
      '/api/mobile/launchpad/launchpad-claim-receipt-pos001',
    );
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Phần thưởng');
    expect(snapshot.backRoute, AppRoutePaths.launchpadStaking);
    expect(snapshot.positionId, 'pos001');
    expect(snapshot.receipt.projectName, 'NexaAI Protocol');
    expect(snapshot.receipt.totalEarned, 3850);
    expect(snapshot.receipt.claimableTotal, 462.5);
    expect(snapshot.receipt.vestingSchedule, hasLength(6));
    expect(snapshot.receipt.claimHistory, hasLength(3));
    expect(snapshot.contractNotes, contains('vestingSchedule'));
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

  testWidgets('SC-302 renders claim receipt overview baseline', (tester) async {
    await pumpClaimReceipt(tester);

    expect(find.byType(LaunchpadClaimReceiptPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phần thưởng'), findsOneWidget);
    expect(find.byKey(LaunchpadClaimReceiptPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadClaimReceiptPage.heroKey), findsOneWidget);
    expect(find.text('NexaAI Protocol'), findsWidgets);
    expect(find.byKey(LaunchpadClaimReceiptPage.heroAmountKey), findsOneWidget);
    expect(find.text('Có thể nhận ngay'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(LaunchpadClaimReceiptPage.claimableKey),
        matching: find.text('462.5 NEXA'),
      ),
      findsOneWidget,
    );
    expect(find.byKey(LaunchpadClaimReceiptPage.detailsKey), findsOneWidget);
    expect(find.text('Chi tiết vị trí'), findsOneWidget);
    expect(find.text('Lịch mở khóa'), findsOneWidget);
  });

  testWidgets('SC-302 first viewport reaches claimable reward', (tester) async {
    await pumpClaimReceipt(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-302 LaunchpadClaimReceiptPage',
      semanticLabel: 'Chi tiết phần thưởng và lịch mở khóa',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadClaimReceiptPage.claimableKey),
      routeName: 'SC-302 LaunchpadClaimReceiptPage',
      actionLabel: 'the claimable reward card',
    );
  });

  testWidgets('SC-302 tab state switches to vesting and history', (
    tester,
  ) async {
    await pumpClaimReceipt(tester);

    await tester.tap(find.text('Mở khóa'));
    await tester.pumpAndSettle();

    expect(find.text('Lịch trình mở khóa'), findsOneWidget);
    expect(
      find.byKey(LaunchpadClaimReceiptPage.vestingKey('v6')),
      findsOneWidget,
    );

    await tester.tap(find.text('Lịch sử'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(LaunchpadClaimReceiptPage.historyKey('ch1')),
      findsOneWidget,
    );
    expect(find.text('+770 NEXA'), findsWidgets);
  });

  testWidgets('SC-302 claim CTA opens review sheet', (tester) async {
    await pumpClaimReceipt(tester);

    await tester.tap(find.text('Nhận').first);
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadClaimReceiptPage.claimSheetKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadClaimReceiptPage.claimSheetReviewStateKey),
      findsOneWidget,
    );
    expect(find.text('Rà soát biên lai nhận thưởng'), findsOneWidget);
    expect(find.text('Nhận phần thưởng'), findsOneWidget);
    expect(find.text('Xác nhận nhận 462.5 NEXA'), findsOneWidget);
  });

  testWidgets('SC-302 header back returns to launchpad staking', (
    tester,
  ) async {
    await pumpClaimReceipt(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadStakingPage), findsOneWidget);
    expect(find.text('Launchpool Staking'), findsWidgets);
  });
}
