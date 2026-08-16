import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_insurance_fund_transparency_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpTransparency(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnInsuranceFundTransparency,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-377 mock repository exposes insurance fund BE draft', () async {
    final snapshot =
        await const MockStakingInsuranceFundTransparencyRepository()
            .getTransparency();

    expect(
      snapshot.endpoint,
      '/api/mobile/earn/earn-insurance-fund-transparency',
    );
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Insurance Fund');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.totalBalance, 50000000);
    expect(snapshot.currentRatio, 165);
    expect(snapshot.targetRatio, 150);
    expect(snapshot.assets, hasLength(3));
    expect(snapshot.assets.first.asset, 'ETH');
    expect(snapshot.claims, hasLength(4));
    expect(snapshot.claims.first.processingDays, 3);
    expect(snapshot.history, hasLength(12));
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

  testWidgets('SC-377 renders overview baseline sections', (tester) async {
    await pumpTransparency(tester);

    expect(find.byType(StakingInsuranceFundTransparencyPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Insurance Fund'), findsOneWidget);
    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.infoKey),
      findsOneWidget,
    );
    expect(find.text('User Protection Fund'), findsOneWidget);
    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.tabsKey),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.fundStatusKey),
      findsOneWidget,
    );
    expect(find.text('Total Fund Balance'), findsOneWidget);
    expect(find.text('\$50,000,000.00'), findsOneWidget);
    expect(find.text('165%'), findsOneWidget);
    expect(find.text('110%'), findsOneWidget);
    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.assetBreakdownKey),
      findsOneWidget,
    );
    expect(find.text('ETH'), findsOneWidget);
    expect(find.text('\$30,000,000.00'), findsOneWidget);
    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.contributionKey),
      findsOneWidget,
    );
    expect(find.text('How the Fund Grows'), findsOneWidget);
    expect(find.text('\$5,200,000.00'), findsOneWidget);
  });

  testWidgets('SC-377 claims tab renders claims history', (tester) async {
    await pumpTransparency(tester);

    await tester.tap(
      find.byKey(StakingInsuranceFundTransparencyPage.tabKey('claims')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.claimsKey),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.claimKey('c-20260220')),
      findsOneWidget,
    );
    expect(find.text('Claims History'), findsOneWidget);
    expect(find.text('User#12345'), findsOneWidget);
    expect(find.textContaining('Validator slashing (2%)'), findsOneWidget);
    expect(find.text('Approved'), findsWidgets);
    expect(find.textContaining('Claim Processing'), findsOneWidget);
  });

  testWidgets('SC-377 history tab renders chart and audit reports', (
    tester,
  ) async {
    await pumpTransparency(tester);

    await tester.tap(
      find.byKey(StakingInsuranceFundTransparencyPage.tabKey('history')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.historyKey),
      findsOneWidget,
    );
    expect(find.text('Historical Performance (12 Months)'), findsOneWidget);
    expect(find.text('12M Growth'), findsOneWidget);
    expect(find.text('+10.6%'), findsOneWidget);
    expect(
      find.byKey(StakingInsuranceFundTransparencyPage.auditsKey),
      findsOneWidget,
    );
    expect(find.text('March 2026 Audit'), findsOneWidget);
    expect(find.text('Third-party verified'), findsWidgets);
  });

  testWidgets('SC-377 header back returns to staking hub', (tester) async {
    await pumpTransparency(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
