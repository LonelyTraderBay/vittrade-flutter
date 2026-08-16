import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_custody_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpCustody(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnCustody,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-375 mock repository exposes custody BE draft', () async {
    final snapshot = await const MockStakingCustodyRepository().getCustody();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-custody');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Custody & Segregation');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.custodian.name, 'Fireblocks');
    expect(snapshot.custodian.licenses, hasLength(3));
    expect(snapshot.segregation, hasLength(3));
    expect(snapshot.hotCold, hasLength(2));
    expect(snapshot.reconciliationLogs, hasLength(5));
    expect(snapshot.transparencyAddresses, hasLength(3));
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

  testWidgets('SC-375 renders custody baseline sections', (tester) async {
    await pumpCustody(tester);

    expect(find.byType(StakingCustodyPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Custody & Segregation'), findsOneWidget);
    expect(find.byKey(StakingCustodyPage.heroKey), findsOneWidget);
    expect(find.text('Institutional-Grade Custody'), findsOneWidget);
    expect(find.byKey(StakingCustodyPage.custodianKey), findsOneWidget);
    expect(find.text('Fireblocks'), findsOneWidget);
    expect(find.text('NY Trust Charter'), findsOneWidget);
    expect(find.byKey(StakingCustodyPage.segregationKey), findsOneWidget);
    expect(find.text('Fund Segregation'), findsOneWidget);
  });

  testWidgets('SC-375 lower sections render after scroll', (tester) async {
    await pumpCustody(tester);

    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -1800),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(StakingCustodyPage.hotColdKey), findsOneWidget);
    expect(find.text('Hot vs Cold Wallet Distribution'), findsOneWidget);
    expect(find.byKey(StakingCustodyPage.reconciliationKey), findsOneWidget);
    expect(find.text('Daily Reconciliation Audit Trail'), findsOneWidget);
    expect(find.byKey(StakingCustodyPage.transparencyKey), findsOneWidget);
    expect(find.text('Real-time On-Chain Verification'), findsOneWidget);
    expect(find.text('Ethereum Mainnet'), findsOneWidget);
  });

  testWidgets('SC-375 audit trail action shows inline feedback', (
    tester,
  ) async {
    await pumpCustody(tester);

    await tester.ensureVisible(
      find.byKey(StakingCustodyPage.auditTrailButtonKey),
    );
    await tester.tap(find.byKey(StakingCustodyPage.auditTrailButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingCustodyPage.feedbackKey), findsOneWidget);
    expect(find.text('Opening full custody audit trail'), findsOneWidget);
  });

  testWidgets('SC-375 back returns to staking hub', (tester) async {
    await pumpCustody(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
