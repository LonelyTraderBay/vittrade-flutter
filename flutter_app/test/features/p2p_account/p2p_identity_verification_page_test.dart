import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_identity_verification_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_selfie_verification_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpIdentityVerification(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pKycIdentity,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-249 mock repository exposes identity verification BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getIdentityVerification();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-kyc-identity');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
    );
    expect(snapshot.documentTypes, hasLength(3));
    expect(snapshot.documentTypes.first.id, 'cccd');
    expect(snapshot.guidelines, hasLength(5));
    expect(snapshot.securityNotes, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2pKycStatus);
    expect(snapshot.nextRoute, AppRoutePaths.p2pKycFaceMatch);
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

  testWidgets('SC-249 renders identity document selection baseline', (
    tester,
  ) async {
    await pumpIdentityVerification(tester);

    expect(find.byType(P2PIdentityVerificationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xác minh danh tính'), findsNWidgets(2));
    expect(find.text('KYC · P2P'), findsOneWidget);
    expect(find.byKey(P2PIdentityVerificationPage.heroKey), findsOneWidget);
    expect(
      find.byKey(P2PIdentityVerificationPage.documentTypesKey),
      findsOneWidget,
    );
    expect(find.text('Chọn loại giấy tờ'), findsOneWidget);
    expect(find.text('Căn cước công dân'), findsOneWidget);
    expect(find.text('CCCD gắn chip (12 số)'), findsOneWidget);
    expect(find.text('Chứng minh nhân dân'), findsOneWidget);
    expect(find.text('CMND cũ (9 số)'), findsOneWidget);
    expect(find.text('Hộ chiếu'), findsOneWidget);
    expect(find.text('Passport quốc tế'), findsOneWidget);
  });

  testWidgets('SC-249 first viewport reaches document choice safely', (
    tester,
  ) async {
    await pumpIdentityVerification(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-249 P2PIdentityVerificationPage',
      semanticLabel: 'Xác minh danh tính P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PIdentityVerificationPage.documentTypeKey('cccd')),
      routeName: 'SC-249 P2PIdentityVerificationPage',
      actionLabel: 'first identity document type',
      minVisibleHeight: 48,
    );
    expect(
      tester.getSize(find.byKey(P2PIdentityVerificationPage.heroKey)).height,
      lessThanOrEqualTo(112),
      reason:
          'Identity KYC hero should preserve safety copy without dominating.',
    );
  });

  testWidgets('SC-249 supports mock upload state and face-match navigation', (
    tester,
  ) async {
    await pumpIdentityVerification(tester);

    await tester.tap(
      find.byKey(P2PIdentityVerificationPage.documentTypeKey('cccd')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(P2PIdentityVerificationPage.guidelinesKey),
      findsOneWidget,
    );
    expect(find.text('Upload hình ảnh'), findsOneWidget);

    await tester.tap(find.byKey(P2PIdentityVerificationPage.frontUploadKey));
    await tester.pumpAndSettle();
    expect(find.text('Mặt trước đã sẵn sàng'), findsOneWidget);

    await tester.tap(find.byKey(P2PIdentityVerificationPage.backUploadKey));
    await tester.pumpAndSettle();
    expect(find.text('Mặt sau đã sẵn sàng'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(P2PIdentityVerificationPage.submitKey),
    );
    await tester.tap(find.byKey(P2PIdentityVerificationPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PSelfieVerificationPage), findsOneWidget);
    expect(find.text('So khớp khuôn mặt'), findsOneWidget);
  });

  testWidgets('SC-249 back returns to KYC status page', (tester) async {
    await pumpIdentityVerification(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycStatusPage), findsOneWidget);
  });
}
