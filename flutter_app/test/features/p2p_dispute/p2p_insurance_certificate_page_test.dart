import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_certificate_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PInsuranceCertificate(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pInsuranceCertificate,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-239 mock repository exposes insurance certificate BE draft',
    () async {
      final snapshot = await const MockP2PRepository(
        loadDelay: Duration.zero,
      ).getInsuranceCertificate();

      expect(snapshot.endpoint, '/api/mobile/p2p/p2p-insurance-certificate');
      expect(
        snapshot.actionDraft,
        'POST /p2p/* workflow action where applicable',
      );
      expect(snapshot.certId, 'CERT-PRO-2026-78400');
      expect(snapshot.holderName, 'Nguyễn Văn Minh');
      expect(snapshot.tierName, 'Pro');
      expect(snapshot.coveragePct, 85);
      expect(snapshot.maxCoveragePerClaim, 100000000);
      expect(snapshot.claimWindowDays, 7);
      expect(snapshot.coveredCases, hasLength(4));
      expect(snapshot.parentRoute, AppRoutePaths.p2pInsurance);
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
    },
  );

  testWidgets('SC-239 renders certificate baseline in P2P shell', (
    tester,
  ) async {
    await pumpP2PInsuranceCertificate(tester);

    expect(find.byType(P2PInsuranceCertificatePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chứng nhận bảo hiểm'), findsOneWidget);
    expect(find.text('Bảo hiểm · P2P'), findsOneWidget);
    expect(find.byKey(P2PInsuranceCertificatePage.cardKey), findsOneWidget);
    expect(find.text('CERT-PRO-2026-78400'), findsOneWidget);
    expect(find.text('Nguyễn Văn Minh'), findsOneWidget);
    expect(find.text('Pro'), findsOneWidget);
    expect(find.text('85%'), findsOneWidget);
    expect(find.text('100.000.000 đ'), findsNWidgets(2));
    expect(find.text('Kiểm toán bởi Deloitte Vietnam'), findsOneWidget);
    expect(find.text('Tải chứng nhận'), findsOneWidget);
  });

  testWidgets('SC-239 actions and back navigation are wired', (tester) async {
    await pumpP2PInsuranceCertificate(tester);

    await tester.ensureVisible(
      find.byKey(P2PInsuranceCertificatePage.downloadKey),
    );
    await tester.tap(find.byKey(P2PInsuranceCertificatePage.downloadKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('Đã chuẩn bị chứng nhận'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(P2PInsuranceCertificatePage.shareKey),
    );
    await tester.tap(find.byKey(P2PInsuranceCertificatePage.shareKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã sao chép thông tin chứng nhận'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PInsuranceFundPage), findsOneWidget);
  });
}
