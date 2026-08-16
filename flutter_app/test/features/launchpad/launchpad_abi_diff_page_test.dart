import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_abi_diff_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAbiDiff(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadAbiDiff,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-308 mock repository exposes ABI diff BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getAbiDiff('contract001');

    expect(
      snapshot.endpoint,
      '/api/mobile/launchpad/launchpad-abi-diff-contract001',
    );
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'ABI Diff');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.contractId, 'contract001');
    expect(snapshot.diff.riskScore, 72);
    expect(snapshot.diff.added, 5);
    expect(snapshot.diff.removed, 2);
    expect(snapshot.diff.modified, 2);
    expect(snapshot.diff.unchanged, 5);
    expect(snapshot.diff.entries, hasLength(14));
    expect(snapshot.diff.entries.first.name, 'stake');
    expect(snapshot.contractNotes, contains('ABI diff entries'));
    expect(snapshot.contractNotes, contains('contract001'));
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

  testWidgets('SC-308 renders ABI diff baseline', (tester) async {
    await pumpAbiDiff(tester);

    expect(find.byType(LaunchpadAbiDiffPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadAbiDiffPage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadAbiDiffPage.heroKey), findsOneWidget);
    expect(find.byKey(LaunchpadAbiDiffPage.statsKey), findsOneWidget);
    expect(find.byKey(LaunchpadAbiDiffPage.metadataKey), findsOneWidget);
    expect(find.byKey(LaunchpadAbiDiffPage.entriesKey), findsOneWidget);
    expect(find.byKey(LaunchpadAbiDiffPage.entryKey('stake')), findsOneWidget);
    expect(find.text('ABI Diff'), findsOneWidget);
    expect(find.text('Risk Score'), findsOneWidget);
    expect(find.text('Thong tin upgrade'), findsOneWidget);
  });

  testWidgets('SC-308 first viewport reaches ABI filter', (tester) async {
    await pumpAbiDiff(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-308 LaunchpadABIDiffPage',
      semanticLabel: 'So sánh thay đổi ABI hợp đồng thông minh',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadAbiDiffPage.functionsOnlyKey),
      routeName: 'SC-308 LaunchpadABIDiffPage',
      actionLabel: 'the functions-only ABI filter',
    );
  });

  testWidgets('SC-308 filters stats and functions-only entries', (
    tester,
  ) async {
    await pumpAbiDiff(tester);

    await tester.tap(find.byKey(LaunchpadAbiDiffPage.statKey('added')));
    await tester.pumpAndSettle();
    expect(find.text('batchClaim'), findsOneWidget);
    expect(find.text('setEmergencyAdmin'), findsOneWidget);
    expect(find.text('unstake'), findsNothing);

    await tester.tap(find.byKey(LaunchpadAbiDiffPage.functionsOnlyKey));
    await tester.pumpAndSettle();
    expect(find.text('EmergencyUnstake'), findsNothing);
    expect(find.text('migratePositions'), findsOneWidget);
  });

  testWidgets('SC-308 expands ABI entry details', (tester) async {
    await pumpAbiDiff(tester);

    // A11Y-2 grew two VitIconButton copy affordances in the metadata card
    // above this list, pushing 'unstake' just past the unscrolled viewport
    // edge — scroll it into view instead of relying on its prior offset.
    await tester.ensureVisible(
      find.byKey(LaunchpadAbiDiffPage.expandKey('unstake')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LaunchpadAbiDiffPage.expandKey('unstake')));
    await tester.pumpAndSettle();

    expect(find.text('Old signature'), findsOneWidget);
    expect(
      find.text('unstake(uint256 amount, bool emergency) -> bool'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Parameter added - emergency unstake bypass may skip cooldown.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-308 copy affordance and header back work', (tester) async {
    await pumpAbiDiff(tester);

    await tester.tap(find.byKey(LaunchpadAbiDiffPage.copyKey('Tx Hash')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsWidgets);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
