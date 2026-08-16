import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_insurance_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpInsurance(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnInsurance,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-365 mock repository exposes insurance BE draft', () async {
    final snapshot = await const MockStakingInsuranceRepository()
        .getInsurance();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-insurance');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('insurance/claim'));
    expect(snapshot.title, 'Slashing Insurance');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.plans, hasLength(3));
    expect(snapshot.plans[1].coverage, 50);
    expect(snapshot.positions, hasLength(4));
    expect(snapshot.positions.where((p) => p.insured), hasLength(2));
    expect(snapshot.claims, hasLength(2));
    expect(snapshot.benefits, hasLength(4));
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

  testWidgets('SC-365 renders insurance overview baseline', (tester) async {
    await pumpInsurance(tester);

    expect(find.byType(StakingInsurancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Slashing Insurance'), findsOneWidget);
    expect(find.byKey(StakingInsurancePage.infoKey), findsOneWidget);
    expect(find.text('Bảo vệ Slashing'), findsOneWidget);
    expect(find.byKey(StakingInsurancePage.tabsKey), findsOneWidget);
    expect(find.byKey(StakingInsurancePage.overviewSummaryKey), findsOneWidget);
    expect(find.text('\$7,577.00'), findsOneWidget);
    expect(find.text('2/4'), findsOneWidget);
    expect(find.text('\$96.77'), findsOneWidget);
    expect(find.byKey(StakingInsurancePage.benefitsKey), findsOneWidget);
    expect(find.text('Bảo vệ vốn'), findsOneWidget);
    expect(find.byKey(StakingInsurancePage.warningKey), findsOneWidget);
    expect(find.text('Lưu ý quan trọng'), findsOneWidget);
  });

  testWidgets('SC-365 plan tab opens detail sheet', (tester) async {
    await pumpInsurance(tester);

    await tester.tap(find.byKey(StakingInsurancePage.tabKey('plans')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(StakingInsurancePage.planKey('standard')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(StakingInsurancePage.planKey('standard')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingInsurancePage.planSheetKey), findsOneWidget);
    expect(find.text('Standard Coverage'), findsWidgets);
    expect(find.text('Max Claim'), findsWidgets);
    expect(find.text('\$25,000.00'), findsWidgets);
    expect(find.text('Chọn plan này'), findsOneWidget);
  });

  testWidgets('SC-365 positions tab shows insured and uninsured states', (
    tester,
  ) async {
    await pumpInsurance(tester);

    await tester.tap(find.byKey(StakingInsurancePage.tabKey('positions')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingInsurancePage.positionsKey), findsOneWidget);
    expect(find.byKey(StakingInsurancePage.positionKey('p1')), findsOneWidget);
    expect(find.text('Insured'), findsWidgets);
    expect(find.byKey(StakingInsurancePage.positionKey('p2')), findsOneWidget);
    expect(find.text('No Insurance'), findsWidgets);
    expect(
      find.byKey(StakingInsurancePage.addInsuranceKey('p2')),
      findsOneWidget,
    );
  });

  testWidgets('SC-365 claims tab opens claim form', (tester) async {
    await pumpInsurance(tester);

    await tester.tap(find.byKey(StakingInsurancePage.tabKey('claims')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingInsurancePage.claimsKey), findsOneWidget);
    expect(find.byKey(StakingInsurancePage.claimKey('c1')), findsOneWidget);
    expect(find.text('Claim History'), findsOneWidget);
    expect(find.text('Approved'), findsWidgets);

    await tester.tap(find.text('File Claim'));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingInsurancePage.claimSheetKey), findsOneWidget);
    expect(find.text('Chọn vị thế'), findsOneWidget);
    expect(find.text('Slashing penalty'), findsOneWidget);
    expect(find.text('Submit Claim'), findsOneWidget);
  });

  testWidgets('SC-365 header back returns to staking hub', (tester) async {
    await pumpInsurance(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
