import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_requirements_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PKycStatus(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pKycStatus,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-248 mock repository exposes P2P KYC status BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getKycStatus();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-kyc-status');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
    );
    expect(snapshot.tier, 2);
    expect(snapshot.tierName, 'Intermediate');
    expect(snapshot.statusLabel, 'Đang xử lý');
    expect(snapshot.completedSteps, 2);
    expect(snapshot.totalSteps, 5);
    expect(snapshot.progressLabel, '2/5 bước');
    expect(snapshot.steps, hasLength(5));
    expect(snapshot.steps[3].actionRoute, AppRoutePaths.p2pKycSelfie);
    expect(snapshot.parentRoute, AppRoutePaths.p2pKycRequirements);
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=kyc'));
    expect(snapshot.supportRoute, contains('p2p-kyc-pending-tier-2'));
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-248 renders KYC status baseline in P2P shell', (
    tester,
  ) async {
    await pumpP2PKycStatus(tester);

    expect(find.byType(P2PKycStatusPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trạng thái KYC'), findsOneWidget);
    expect(find.text('KYC · P2P'), findsOneWidget);
    expect(find.byKey(P2PKycStatusPage.statusCardKey), findsOneWidget);
    expect(find.text('Tier 2 - Intermediate'), findsOneWidget);
    expect(find.text('Gửi lúc 2026-03-04 14:30'), findsOneWidget);
    expect(find.text('Đang xử lý'), findsNWidgets(2));
    expect(find.text('2/5 bước'), findsOneWidget);
    expect(find.text('Chi tiết các bước'), findsOneWidget);
    expect(find.byKey(P2PKycStatusPage.timelineKey), findsOneWidget);
    expect(find.text('Identity Verification'), findsOneWidget);
    expect(find.text('Face Match'), findsOneWidget);
    expect(find.text('Address Proof'), findsOneWidget);
    expect(find.text('Selfie Verification'), findsOneWidget);
    expect(find.text('Compliance Review'), findsOneWidget);
    expect(
      find.byKey(P2PKycStatusPage.actionKey('selfie_verification')),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(P2PKycStatusPage.supportKey));
    expect(find.text('Cần hỗ trợ?'), findsOneWidget);
    expect(find.text('Mở Support Chat'), findsOneWidget);
  });

  testWidgets('SC-248 first viewport reaches next KYC step', (tester) async {
    await pumpP2PKycStatus(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-248 P2PKycStatusPage',
      semanticLabel: 'Trạng thái KYC P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PKycStatusPage.stepKey('selfie_verification')),
      routeName: 'SC-248 P2PKycStatusPage',
      actionLabel: 'selfie verification step preview',
      minVisibleHeight: 48,
    );
  });

  testWidgets('SC-248 wires step action, support, and back navigation', (
    tester,
  ) async {
    await pumpP2PKycStatus(tester);

    await tester.ensureVisible(
      find.byKey(P2PKycStatusPage.actionKey('selfie_verification')),
    );
    await tester.tap(
      find.byKey(P2PKycStatusPage.actionKey('selfie_verification')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Xác minh selfie'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(P2PKycStatusPage), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PKycStatusPage.supportKey));
    await tester.tap(find.text('Mở Support Chat'));
    await tester.pumpAndSettle();
    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('P2P KYC status support'), findsOneWidget);
    expect(find.text('p2p-kyc-pending-tier-2'), findsOneWidget);
  });

  testWidgets('SC-248 back returns to requirements page', (tester) async {
    await pumpP2PKycStatus(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycRequirementsPage), findsOneWidget);
  });
}
