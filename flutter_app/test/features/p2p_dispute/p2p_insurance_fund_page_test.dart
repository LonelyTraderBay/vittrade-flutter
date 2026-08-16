import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PInsuranceFund(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pInsurance,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-238/SC-244 mock repository exposes insurance BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getInsuranceFund();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-insurance');
    expect(snapshot.legacyEndpoint, '/api/mobile/p2p/p2p-insurance-fund');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.totalFund, 523000000);
    expect(snapshot.activeClaims, 3);
    expect(snapshot.userCoveragePct, 85);
    expect(snapshot.tierName, 'Pro');
    expect(snapshot.solvencyRatio, 6.3);
    expect(snapshot.claims, hasLength(5));
    expect(snapshot.certificateRoute, AppRoutePaths.p2pInsuranceCertificate);
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

  testWidgets('SC-238 renders onboarding overlay and overview baseline', (
    tester,
  ) async {
    await pumpP2PInsuranceFund(tester);

    expect(find.byType(P2PInsuranceFundPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(P2PInsuranceFundPage.tourKey), findsOneWidget);
    expect(find.byKey(P2PInsuranceFundPage.tourContinueKey), findsOneWidget);

    await tester.tap(find.byKey(P2PInsuranceFundPage.tourContinueKey));
    await tester.pumpAndSettle();

    expect(find.byKey(P2PInsuranceFundPage.tourKey), findsNothing);
    expect(find.text('Quỹ bảo hiểm P2P'), findsOneWidget);
    expect(find.text('523.000.000 đ'), findsOneWidget);
    expect(find.text('Điều kiện bồi thường'), findsOneWidget);
    expect(find.text('Sức khỏe quỹ'), findsOneWidget);
    expect(find.text('Biến động quỹ'), findsOneWidget);
    expect(find.text('Mức bảo hiểm của bạn'), findsOneWidget);
  });

  testWidgets('SC-238 first viewport reaches eligibility card', (tester) async {
    await pumpP2PInsuranceFund(tester);
    await tester.tap(find.byKey(P2PInsuranceFundPage.tourContinueKey));
    await tester.pumpAndSettle();

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-238 P2PInsuranceFundPage',
      semanticLabel: 'Quỹ bảo hiểm P2P',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Điều kiện bồi thường'),
      targetLabel: 'insurance eligibility card',
      minVisibleHeight: 18,
    );
  });

  testWidgets('SC-238 switches claims tab and opens certificate route', (
    tester,
  ) async {
    await pumpP2PInsuranceFund(tester);
    await tester.tap(find.byKey(P2PInsuranceFundPage.tourContinueKey));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yêu cầu của tôi'));
    await tester.pumpAndSettle();

    expect(find.text('Gửi yêu cầu bồi thường'), findsOneWidget);
    expect(find.text('CLM-001'), findsOneWidget);
    expect(find.text('Đã chi trả'), findsOneWidget);

    await tester.tap(find.text('Tổng quan'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(P2PInsuranceFundPage.certificateKey));
    await tester.tap(find.byKey(P2PInsuranceFundPage.certificateKey));
    await tester.pumpAndSettle();

    expect(find.text('Chứng nhận bảo hiểm'), findsOneWidget);
  });

  testWidgets('SC-244 legacy insurance fund route renders the same screen', (
    tester,
  ) async {
    await pumpP2PInsuranceFund(
      tester,
      initialLocation: AppRoutePaths.p2pInsuranceFundAlias,
    );

    expect(find.byType(P2PInsuranceFundPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(P2PInsuranceFundPage.tourKey), findsOneWidget);
    expect(find.byKey(P2PInsuranceFundPage.tourContinueKey), findsOneWidget);
  });
}
