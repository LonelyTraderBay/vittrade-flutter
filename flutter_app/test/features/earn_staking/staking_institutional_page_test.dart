import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_institutional_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpInstitutional(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnInstitutional,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-368 mock repository exposes institutional BE draft', () async {
    final snapshot = await const MockStakingInstitutionalRepository()
        .getInstitutional();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-institutional');
    expect(snapshot.actionDraft, contains('institutional/batches'));
    expect(snapshot.actionDraft, contains('approve'));
    expect(snapshot.title, 'Institutional Dashboard');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.stats, hasLength(3));
    expect(snapshot.pendingBatches, hasLength(2));
    expect(snapshot.executedBatches, hasLength(2));
    expect(snapshot.signers, hasLength(3));
    expect(snapshot.features, hasLength(4));
    expect(snapshot.operationTypes.first, 'Batch Stake');
    expect(snapshot.csvFormatNote, 'Format: address, amount, validator');
    expect(snapshot.contractNotes, contains('riskData'));
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

  testWidgets('SC-368 renders institutional pending baseline', (tester) async {
    await pumpInstitutional(tester);

    expect(find.byType(StakingInstitutionalPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Institutional Dashboard'), findsOneWidget);
    expect(find.byKey(StakingInstitutionalPage.infoKey), findsOneWidget);
    expect(find.text('Enterprise Staking Platform'), findsOneWidget);
    expect(find.byKey(StakingInstitutionalPage.statsKey), findsOneWidget);
    expect(find.text('\$25.6M'), findsOneWidget);
    expect(find.text('3/5'), findsOneWidget);
    expect(find.text('SOC 2'), findsOneWidget);
    expect(
      find.byKey(StakingInstitutionalPage.createButtonKey),
      findsOneWidget,
    );
    expect(find.byKey(StakingInstitutionalPage.tabsKey), findsOneWidget);
    expect(find.text('Pending Approvals'), findsOneWidget);
    expect(find.byKey(StakingInstitutionalPage.batchKey('b1')), findsOneWidget);
    expect(find.byKey(StakingInstitutionalPage.batchKey('b2')), findsOneWidget);
    expect(find.text('Approve'), findsOneWidget);
    expect(find.text('Execute'), findsOneWidget);
  });

  testWidgets('SC-368 create batch sheet shows upload contract', (
    tester,
  ) async {
    await pumpInstitutional(tester);

    await tester.tap(find.byKey(StakingInstitutionalPage.createButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingInstitutionalPage.createSheetKey), findsOneWidget);
    expect(find.text('Create Batch Operation'), findsWidgets);
    expect(find.text('Operation Type'), findsOneWidget);
    expect(find.text('Batch Stake'), findsWidgets);
    expect(find.text('Upload CSV File'), findsOneWidget);
    expect(find.text('Drop CSV or click to upload'), findsOneWidget);
    expect(find.text('Format: address, amount, validator'), findsOneWidget);
    expect(find.text('Submit for Approval'), findsOneWidget);
  });

  testWidgets('SC-368 executed tab shows completed batches', (tester) async {
    await pumpInstitutional(tester);

    await tester.tap(find.byKey(StakingInstitutionalPage.tabKey('executed')));
    await tester.pumpAndSettle();

    expect(find.text('Executed Batches'), findsOneWidget);
    expect(find.byKey(StakingInstitutionalPage.batchKey('e1')), findsOneWidget);
    expect(find.byKey(StakingInstitutionalPage.batchKey('e2')), findsOneWidget);
    expect(find.text('Batch Unstake'), findsOneWidget);
    expect(find.text('Executed'), findsWidgets);
  });

  testWidgets('SC-368 full content includes signers features compliance', (
    tester,
  ) async {
    await pumpInstitutional(tester);

    expect(find.byKey(StakingInstitutionalPage.signersKey), findsOneWidget);
    expect(find.text('Alice Chen'), findsOneWidget);
    expect(find.text('Carol Wu'), findsOneWidget);
    expect(find.byKey(StakingInstitutionalPage.featuresKey), findsOneWidget);
    expect(find.text('Cold Storage'), findsOneWidget);
    expect(find.text('Audit Trail'), findsOneWidget);
    expect(find.byKey(StakingInstitutionalPage.complianceKey), findsOneWidget);
    expect(find.text('Institutional Compliance'), findsOneWidget);
  });

  testWidgets('SC-368 header back returns to staking hub', (tester) async {
    await pumpInstitutional(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
