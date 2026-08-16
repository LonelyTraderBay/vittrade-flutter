import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_policy_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PInsurancePolicy(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pInsurancePolicy,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-241 mock repository exposes insurance policy BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getInsurancePolicy();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-insurance-policy');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.version, '2.1');
    expect(snapshot.lastUpdated, '01/03/2026');
    expect(snapshot.sections, hasLength(10));
    expect(snapshot.sections.first.id, 'scope');
    expect(snapshot.sections.last.id, 'amendments');
    expect(snapshot.parentRoute, AppRoutePaths.p2pInsurance);
    expect(snapshot.privacyNotice, contains('support@platform.com'));
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

  testWidgets('SC-241 renders policy document in P2P shell', (tester) async {
    await pumpP2PInsurancePolicy(tester);

    expect(find.byType(P2PInsurancePolicyPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Điều khoản Bảo hiểm P2P'), findsOneWidget);
    expect(find.text('Bảo hiểm · P2P'), findsOneWidget);
    expect(find.byKey(P2PInsurancePolicyPage.heroKey), findsOneWidget);
    expect(find.text('Điều khoản & Chính sách'), findsOneWidget);
    expect(find.text('Phiên bản 2.1'), findsOneWidget);
    expect(find.text('Cập nhật: 01/03/2026'), findsOneWidget);
    expect(find.byKey(P2PInsurancePolicyPage.noticeKey), findsOneWidget);
    expect(find.textContaining('Vui lòng đọc kỹ'), findsOneWidget);
    expect(find.text('1. Phạm vi bảo hiểm'), findsOneWidget);
    expect(find.text('2. Điều kiện đủ tiêu chuẩn'), findsOneWidget);

    await tester.ensureVisible(find.text('10. Sửa đổi điều khoản'));
    expect(find.text('10. Sửa đổi điều khoản'), findsOneWidget);
    expect(find.byKey(P2PInsurancePolicyPage.privacyKey), findsOneWidget);
    expect(find.textContaining('support@platform.com'), findsOneWidget);
  });

  testWidgets('SC-241 first viewport reaches policy notice and sections', (
    tester,
  ) async {
    await pumpP2PInsurancePolicy(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-241 P2PInsurancePolicyPage',
      semanticLabel: 'Điều khoản Bảo hiểm P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PInsurancePolicyPage.heroKey),
      routeName: 'SC-241 P2PInsurancePolicyPage',
      actionLabel: 'the policy version summary',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PInsurancePolicyPage.noticeKey),
      routeName: 'SC-241 P2PInsurancePolicyPage',
      actionLabel: 'the policy coverage notice',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PInsurancePolicyPage.sectionsKey),
      routeName: 'SC-241 P2PInsurancePolicyPage',
      actionLabel: 'the policy section list',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-241 back navigation returns to insurance fund', (
    tester,
  ) async {
    await pumpP2PInsurancePolicy(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PInsuranceFundPage), findsOneWidget);
  });
}
