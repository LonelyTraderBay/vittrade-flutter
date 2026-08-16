import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_selfie_verification_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSelfieVerification(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pKycSelfie,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-251 mock repository exposes selfie verification BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getSelfieVerification();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-kyc-selfie');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
    );
    expect(snapshot.guidelines, hasLength(5));
    expect(snapshot.tips, hasLength(4));
    expect(snapshot.livenessActions, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2pKycStatus);
    expect(snapshot.statusRoute, AppRoutePaths.p2pKycStatus);
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=kyc'));
    expect(snapshot.supportRoute, contains('p2p-kyc-selfie'));
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

  testWidgets('SC-251 renders selfie guide baseline', (tester) async {
    await pumpSelfieVerification(tester);

    expect(find.byType(P2PSelfieVerificationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xác minh selfie'), findsOneWidget);
    expect(find.text('KYC · P2P'), findsOneWidget);
    expect(find.byKey(P2PSelfieVerificationPage.heroKey), findsOneWidget);
    expect(find.text('Selfie với ID'), findsOneWidget);
    expect(find.byKey(P2PSelfieVerificationPage.sampleKey), findsOneWidget);
    expect(find.text('Ảnh mẫu selfie với ID'), findsOneWidget);
    expect(find.byKey(P2PSelfieVerificationPage.guidelinesKey), findsOneWidget);
    expect(find.text('Hướng dẫn chụp ảnh'), findsOneWidget);
    expect(find.text('Giữ ID card cạnh khuôn mặt'), findsOneWidget);
    expect(find.byKey(P2PSelfieVerificationPage.tipsKey), findsOneWidget);
    expect(find.text('Mẹo để thành công'), findsOneWidget);
    expect(find.byKey(P2PSelfieVerificationPage.startKey), findsOneWidget);
  });

  testWidgets('SC-251 supports mock liveness state and status navigation', (
    tester,
  ) async {
    await pumpSelfieVerification(tester);

    await tester.ensureVisible(find.byKey(P2PSelfieVerificationPage.startKey));
    await tester.tap(find.byKey(P2PSelfieVerificationPage.startKey));
    await tester.pumpAndSettle();
    expect(find.byKey(P2PSelfieVerificationPage.captureKey), findsOneWidget);

    await tester.tap(find.byKey(P2PSelfieVerificationPage.captureKey));
    await tester.pumpAndSettle();
    expect(find.byKey(P2PSelfieVerificationPage.livenessKey), findsOneWidget);
    expect(find.text('Mỉm cười'), findsWidgets);

    for (var i = 0; i < 4; i += 1) {
      await tester.tap(find.byKey(P2PSelfieVerificationPage.livenessActionKey));
      await tester.pumpAndSettle();
    }

    expect(find.byKey(P2PSelfieVerificationPage.resultKey), findsOneWidget);
    expect(find.text('Xác minh thành công!'), findsOneWidget);

    await tester.tap(find.byKey(P2PSelfieVerificationPage.completeKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PKycStatusPage), findsOneWidget);
  });

  testWidgets('SC-251 support opens contextual KYC support', (tester) async {
    await pumpSelfieVerification(tester);

    await tester.ensureVisible(find.byKey(P2PSelfieVerificationPage.startKey));
    await tester.tap(find.byKey(P2PSelfieVerificationPage.startKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PSelfieVerificationPage.captureKey));
    await tester.pumpAndSettle();

    for (var i = 0; i < 4; i += 1) {
      await tester.tap(find.byKey(P2PSelfieVerificationPage.livenessActionKey));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Liên hệ hỗ trợ'));
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('P2P selfie verification support'), findsOneWidget);
    expect(find.text('p2p-kyc-selfie'), findsOneWidget);
  });

  testWidgets('SC-251 back returns to KYC status page', (tester) async {
    await pumpSelfieVerification(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycStatusPage), findsOneWidget);
  });
}
