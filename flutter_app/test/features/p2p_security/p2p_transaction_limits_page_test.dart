import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_requirements_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_limit_tracker_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_transaction_limits_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpTransactionLimits(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pLimits,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-266 mock repository exposes transaction limits BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getTransactionLimits();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-limits');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.currentTier.tier, 1);
    expect(snapshot.currentTier.dailyBuy, 50000000);
    expect(snapshot.nextTier.tier, 2);
    expect(snapshot.usageItems, hasLength(4));
    expect(snapshot.detailItems, hasLength(5));
    expect(snapshot.infoBullets, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.trackerRoute, AppRoutePaths.p2pLimitsTracker);
    expect(snapshot.kycRequirementsRoute, AppRoutePaths.p2pKycRequirements);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-266 renders transaction limits baseline', (tester) async {
    await pumpTransactionLimits(tester);

    expect(find.byType(P2PTransactionLimitsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Transaction Limits'), findsOneWidget);
    expect(find.text('Hạn mức · P2P'), findsOneWidget);
    expect(find.byKey(P2PTransactionLimitsPage.tierHeroKey), findsOneWidget);
    expect(find.text('Tier 1 - Basic'), findsOneWidget);
    expect(find.text('Đang dùng'), findsOneWidget);
    expect(find.text('50M VND'), findsNWidgets(2));
    expect(find.byKey(P2PTransactionLimitsPage.usageKey), findsOneWidget);
    expect(find.text('Sử dụng hiện tại'), findsOneWidget);
    expect(find.text('70.0% đã dùng'), findsOneWidget);
    expect(find.text('30.0% đã dùng'), findsOneWidget);
    expect(find.text('65.0% đã dùng'), findsOneWidget);
    expect(find.byKey(P2PTransactionLimitsPage.detailsKey), findsOneWidget);
    expect(find.text('Chi tiết giới hạn'), findsOneWidget);
    expect(find.text('50,000,000 VND'), findsNWidgets(2));
  });

  testWidgets('SC-266 navigation opens tracker and KYC requirement routes', (
    tester,
  ) async {
    await pumpTransactionLimits(tester);

    await tester.tap(find.byKey(P2PTransactionLimitsPage.trackerLinkKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PLimitTrackerPage), findsOneWidget);

    await pumpTransactionLimits(tester);
    await tester.ensureVisible(
      find.byKey(P2PTransactionLimitsPage.upgradeCtaKey),
    );
    await tester.tap(find.byKey(P2PTransactionLimitsPage.upgradeCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycRequirementsPage), findsOneWidget);
  });

  testWidgets('SC-266 back returns to P2P parent safely', (tester) async {
    await pumpTransactionLimits(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PTransactionLimitsPage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}
