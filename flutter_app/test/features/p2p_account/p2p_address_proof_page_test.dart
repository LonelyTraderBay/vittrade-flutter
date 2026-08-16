import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_address_proof_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAddressProof(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pKycAddress,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-250 mock repository exposes address proof BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getAddressProof();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-kyc-address');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
    );
    expect(snapshot.documentTypes, hasLength(4));
    expect(snapshot.documentTypes.first.id, 'utility');
    expect(snapshot.requirements, hasLength(5));
    expect(snapshot.securityNotes, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2pKycStatus);
    expect(snapshot.submitRoute, AppRoutePaths.p2pKycStatus);
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

  testWidgets('SC-250 renders address proof document selection baseline', (
    tester,
  ) async {
    await pumpAddressProof(tester);

    expect(find.byType(P2PAddressProofPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xác minh địa chỉ'), findsNWidgets(2));
    expect(find.byKey(P2PAddressProofPage.requirementsKey), findsOneWidget);
    expect(find.text('Yêu cầu tài liệu'), findsOneWidget);
    expect(find.byKey(P2PAddressProofPage.documentTypesKey), findsOneWidget);
    expect(find.text('Chọn loại tài liệu'), findsOneWidget);
    expect(find.text('Hóa đơn tiện ích'), findsOneWidget);
    expect(find.text('Điện, nước, gas, internet'), findsOneWidget);
    expect(find.text('Sao kê ngân hàng'), findsOneWidget);
    expect(find.text('Bank statement 3 tháng gần nhất'), findsOneWidget);
    expect(find.text('Giấy tờ chính phủ'), findsOneWidget);
    expect(find.text('Hợp đồng thuê nhà'), findsOneWidget);
  });

  testWidgets('SC-250 first viewport reaches document choice safely', (
    tester,
  ) async {
    await pumpAddressProof(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-250 P2PAddressProofPage',
      semanticLabel: 'Xác minh địa chỉ cư trú P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAddressProofPage.requirementsKey),
      routeName: 'SC-250 P2PAddressProofPage',
      actionLabel: 'document requirements',
      minVisibleHeight: 48,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAddressProofPage.documentTypeKey('utility')),
      routeName: 'SC-250 P2PAddressProofPage',
      actionLabel: 'first document type',
      minVisibleHeight: 48,
    );
    expect(
      tester.getSize(find.byKey(P2PAddressProofPage.heroKey)).height,
      lessThanOrEqualTo(112),
      reason: 'Address proof hero should preserve KYC copy without dominating.',
    );
  });

  testWidgets('SC-250 supports mock upload state and status navigation', (
    tester,
  ) async {
    await pumpAddressProof(tester);

    await tester.tap(
      find.byKey(P2PAddressProofPage.documentTypeKey('utility')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Upload tài liệu'), findsOneWidget);
    expect(find.byKey(P2PAddressProofPage.uploadKey), findsOneWidget);

    await tester.tap(find.byKey(P2PAddressProofPage.uploadKey));
    await tester.pumpAndSettle();
    expect(find.text('Tài liệu đã sẵn sàng'), findsOneWidget);
    expect(find.byKey(P2PAddressProofPage.extractedDataKey), findsOneWidget);
    expect(find.text('NGUYỄN VĂN A'), findsOneWidget);
    expect(find.byKey(P2PAddressProofPage.addressConfirmKey), findsOneWidget);
    expect(find.text('123 Đường Láng, Đống Đa, Hà Nội'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PAddressProofPage.submitKey));
    await tester.tap(find.byKey(P2PAddressProofPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PKycStatusPage), findsOneWidget);
  });

  testWidgets('SC-250 back returns to KYC status page', (tester) async {
    await pumpAddressProof(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycStatusPage), findsOneWidget);
  });
}
