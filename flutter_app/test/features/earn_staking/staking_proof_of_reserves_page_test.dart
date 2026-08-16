import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_proof_of_reserves_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpProofOfReserves(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnProofOfReserves,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-380 mock repository exposes proof of reserves BE draft', () async {
    final snapshot = await const MockStakingProofOfReservesRepository()
        .getProofOfReserves();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-proof-of-reserves');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Proof of Reserves');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.overall.totalAssetsUsd, 350000000);
    expect(snapshot.overall.reserveRatio, 102.9);
    expect(snapshot.assets, hasLength(3));
    expect(snapshot.assets.first.walletAddress, startsWith('0x742d'));
    expect(snapshot.auditReports, hasLength(3));
    expect(snapshot.history, hasLength(12));
    expect(snapshot.verifySteps, hasLength(4));
    expect(snapshot.contractNotes, contains('Merkle verification'));
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

  testWidgets('SC-380 renders proof of reserves overview baseline', (
    tester,
  ) async {
    await pumpProofOfReserves(tester);

    expect(find.byType(StakingProofOfReservesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Proof of Reserves'), findsOneWidget);
    expect(find.byKey(StakingProofOfReservesPage.infoKey), findsOneWidget);
    expect(find.text('Cryptographic Proof of Reserves'), findsOneWidget);
    expect(find.byKey(StakingProofOfReservesPage.tabsKey), findsOneWidget);
    expect(find.byKey(StakingProofOfReservesPage.overviewKey), findsOneWidget);
    expect(
      find.byKey(StakingProofOfReservesPage.reserveStatusKey),
      findsOneWidget,
    );
    expect(find.text('Overall Reserve Status'), findsOneWidget);
    expect(find.text('\$350,000,000.00'), findsOneWidget);
    expect(find.text('102.9%'), findsWidgets);
    expect(find.text('\$340,000,000.00'), findsOneWidget);
    expect(find.byKey(StakingProofOfReservesPage.trendKey), findsOneWidget);
    expect(find.text('Reserve Ratio Trend (12 Months)'), findsOneWidget);
    expect(find.byKey(StakingProofOfReservesPage.auditsKey), findsOneWidget);
    expect(find.text('Armanino LLP'), findsNWidgets(3));
  });

  testWidgets('SC-380 first viewport reaches reserve trend preview', (
    tester,
  ) async {
    await pumpProofOfReserves(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-380 StakingProofOfReservesPage',
      semanticLabel:
          'Bằng chứng dự trữ staking — minh bạch tài sản và kiểm toán độc lập',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(StakingProofOfReservesPage.trendKey),
      targetLabel: 'the reserve ratio trend preview',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-380 assets tab renders per asset reserves', (tester) async {
    await pumpProofOfReserves(tester);

    await tester.tap(find.byKey(StakingProofOfReservesPage.tabKey('assets')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingProofOfReservesPage.assetsKey), findsOneWidget);
    expect(find.text('Reserve Ratio by Asset'), findsOneWidget);
    expect(find.text('ETH'), findsOneWidget);
    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('SOL'), findsOneWidget);
    expect(find.text('125,430.50 ETH'), findsOneWidget);
    expect(find.text('102.8%'), findsOneWidget);
    expect(find.text('Verify'), findsWidgets);
  });

  testWidgets('SC-380 verify tab opens Merkle proof sheet', (tester) async {
    await pumpProofOfReserves(tester);

    await tester.tap(find.byKey(StakingProofOfReservesPage.tabKey('verify')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingProofOfReservesPage.verifyKey), findsOneWidget);
    expect(find.text('Merkle Tree Verification'), findsOneWidget);
    expect(find.text('How Verification Works'), findsOneWidget);
    expect(find.text('Independent Verification'), findsOneWidget);

    await tester.tap(find.text('Verify My Balance'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingProofOfReservesPage.verifySheetKey),
      findsOneWidget,
    );
    expect(find.text('Verify Your Balance'), findsWidgets);

    await tester.enterText(find.byType(TextField).at(0), 'user_12345');
    await tester.enterText(find.byType(TextField).at(1), '10.50');
    await tester.ensureVisible(
      find.byKey(StakingProofOfReservesPage.verifySubmitKey),
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(StakingProofOfReservesPage.verifySheetKey),
      const Offset(0, -160),
    );
    await tester.pumpAndSettle();
    final submitTopLeft = tester.getTopLeft(
      find.byKey(StakingProofOfReservesPage.verifySubmitKey),
    );
    await tester.tapAt(submitTopLeft + const Offset(24, 12));
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingProofOfReservesPage.proofResultKey),
      findsOneWidget,
    );
    expect(find.text('Verification Successful'), findsOneWidget);
    expect(find.textContaining('10.50 ETH'), findsOneWidget);
    expect(find.text('Merkle Proof'), findsOneWidget);
    expect(find.text('Sibling Hashes (3)'), findsOneWidget);
  });

  testWidgets('SC-380 header back returns to staking hub', (tester) async {
    await pumpProofOfReserves(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });

  testWidgets('SC-380 download report shows coming-soon snack bar', (
    tester,
  ) async {
    await pumpProofOfReserves(tester);

    await tester.ensureVisible(find.text('Download Report (PDF)').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Download Report (PDF)').first);
    await tester.pumpAndSettle();

    expect(find.text('Tải báo cáo (PDF) sẽ sớm ra mắt'), findsOneWidget);
  });
}
