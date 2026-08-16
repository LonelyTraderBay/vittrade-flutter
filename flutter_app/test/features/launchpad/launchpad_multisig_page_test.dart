import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_multisig_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpMultisig(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadMultisig,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-313 mock repository exposes launchpad multisig BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getMultisig();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-multisig');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Multi-sig');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.tabs, ['queue', 'history', 'safes']);
    expect(snapshot.defaultSafeAddress, '0xSafe1111...aaaa');
    expect(snapshot.safes, hasLength(2));
    expect(snapshot.transactions, hasLength(4));
    expect(snapshot.safes.first.threshold, 2);
    expect(
      snapshot.transactions.first.status,
      LaunchpadMultisigTxStatus.pendingSignatures,
    );
    expect(snapshot.contractNotes, contains('multisig safes'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
        LaunchpadScreenState.submitting,
        LaunchpadScreenState.success,
      ]),
    );
  });

  testWidgets('SC-313 renders multisig queue baseline', (tester) async {
    await pumpMultisig(tester);

    expect(find.byType(LaunchpadMultisigPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadMultisigPage.safeSelectorKey), findsOneWidget);
    expect(find.byKey(LaunchpadMultisigPage.statsKey), findsOneWidget);
    expect(find.byKey(LaunchpadMultisigPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadMultisigPage.createKey), findsOneWidget);
    expect(find.byKey(LaunchpadMultisigPage.queueKey), findsOneWidget);
    expect(find.byKey(LaunchpadMultisigPage.noticeKey), findsOneWidget);
    expect(find.text('Multi-sig'), findsOneWidget);
    expect(find.text('Team Treasury'), findsOneWidget);
    expect(find.text('Operations Fund'), findsOneWidget);
    expect(find.text('Tạo giao dịch mới'), findsOneWidget);
    expect(find.text('Withdraw staking rewards'), findsOneWidget);
    expect(find.text('Approve bridge router'), findsOneWidget);
  });

  testWidgets('SC-313 first viewport reaches create transaction action', (
    tester,
  ) async {
    await pumpMultisig(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-313 LaunchpadMultisigPage',
      semanticLabel: 'Quản lý giao dịch đa chữ ký multisig',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadMultisigPage.createKey),
      routeName: 'SC-313 LaunchpadMultisigPage',
      actionLabel: 'the create transaction card',
    );
  });

  testWidgets('SC-313 signs and executes queue transactions', (tester) async {
    await pumpMultisig(tester);

    await tester.tap(find.byKey(LaunchpadMultisigPage.txToggleKey('mtx1')));
    await tester.pumpAndSettle();
    expect(find.text('Rut 500 NEXA rewards tu pool NexaAI'), findsOneWidget);
    expect(find.byKey(LaunchpadMultisigPage.signKey), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadMultisigPage.signKey));
    await tester.pumpAndSettle();
    expect(find.text('Sẵn sàng'), findsWidgets);
    expect(find.byKey(LaunchpadMultisigPage.executeKey), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadMultisigPage.executeKey));
    await tester.pumpAndSettle();
    expect(find.text('Withdraw staking rewards'), findsNothing);

    await tester.tap(find.text('Lịch sử'));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadMultisigPage.historyKey), findsOneWidget);
    expect(find.text('Withdraw staking rewards'), findsOneWidget);
  });

  testWidgets('SC-313 switches safe and safes tab renders owner details', (
    tester,
  ) async {
    await pumpMultisig(tester);

    await tester.tap(
      find.byKey(LaunchpadMultisigPage.safeKey('0xSafe2222...bbbb')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Transfer operations reserve'), findsOneWidget);

    await tester.tap(find.text('Safes'));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadMultisigPage.ownersKey), findsOneWidget);
    expect(find.text('Owners & Signers'), findsOneWidget);
    expect(find.text('CFO'), findsOneWidget);
    expect(find.text('Thông tin Safe'), findsOneWidget);
  });

  testWidgets('SC-313 create transaction sheet opens', (tester) async {
    await pumpMultisig(tester);

    await tester.tap(find.byKey(LaunchpadMultisigPage.createKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadMultisigPage.createSheetKey), findsOneWidget);
    expect(find.text('Tạo giao dịch Multi-sig'), findsOneWidget);
    expect(find.text('Contract Address'), findsOneWidget);
    expect(find.byKey(LaunchpadMultisigPage.submitCreateKey), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadMultisigPage.cancelCreateKey));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadMultisigPage.createSheetKey), findsNothing);
  });

  testWidgets('SC-313 header back returns to launchpad', (tester) async {
    await pumpMultisig(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
