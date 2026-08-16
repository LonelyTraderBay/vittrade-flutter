import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_fraud_prevention_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_report_merchant_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpFraudPrevention(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pFraudPrevention,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-260 mock repository exposes fraud prevention BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getFraudPrevention();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-fraud-prevention');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.patterns, hasLength(5));
    expect(snapshot.checklist, hasLength(10));
    expect(snapshot.emergencyActions, hasLength(3));
    expect(snapshot.checkedSafetyCount, 6);
    expect(snapshot.safetyScore, 60);
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
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

  testWidgets('SC-260 renders fraud prevention baseline', (tester) async {
    await pumpFraudPrevention(tester);

    expect(find.byType(P2PFraudPreventionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phòng chống gian lận'), findsOneWidget);
    expect(find.text('An toàn · P2P'), findsOneWidget);
    expect(find.byKey(P2PFraudPreventionPage.scoreKey), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('6/10 biện pháp bảo vệ đã áp dụng'), findsOneWidget);
    expect(find.byKey(P2PFraudPreventionPage.patternsKey), findsOneWidget);
    expect(find.text('Các hình thức gian lận phổ biến'), findsOneWidget);
    expect(find.text('Bằng chứng thanh toán giả'), findsOneWidget);
    expect(find.text('Giao dịch ngoài nền tảng'), findsOneWidget);
    expect(find.text('Chargeback sau giao dịch'), findsOneWidget);
    expect(find.text('Mạo danh nhân viên sàn'), findsOneWidget);
    expect(find.text('Gian lận tam giác'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PFraudPreventionPage.emergencyKey));
    expect(find.byKey(P2PFraudPreventionPage.checklistKey), findsOneWidget);
    expect(find.text('Checklist an toàn'), findsOneWidget);
    expect(find.text('Bạn đang bị lừa đảo?'), findsOneWidget);
    expect(find.byKey(P2PFraudPreventionPage.disclosureKey), findsOneWidget);
  });

  testWidgets('SC-260 expands a scam pattern detail', (tester) async {
    await pumpFraudPrevention(tester);

    await tester.tap(
      find.byKey(P2PFraudPreventionPage.patternKey('fake_payment')),
    );
    await tester.pumpAndSettle();

    expect(find.text('CÁCH THỨC HOẠT ĐỘNG'), findsOneWidget);
    expect(find.text('DẤU HIỆU NHẬN BIẾT'), findsOneWidget);
    expect(find.text('CÁCH PHÒNG TRÁNH'), findsOneWidget);
    expect(
      find.textContaining('Luôn kiểm tra tài khoản ngân hàng'),
      findsOneWidget,
    );
  });

  testWidgets('SC-260 checklist tabs and toggles update safety score', (
    tester,
  ) async {
    await pumpFraudPrevention(tester);

    await tester.ensureVisible(
      find.byKey(P2PFraudPreventionPage.checklistItemKey('ck2')),
    );
    expect(find.text('Anti-Phishing Code đã thiết lập'), findsOneWidget);

    await tester.tap(
      find.byKey(P2PFraudPreventionPage.checklistItemKey('ck2')),
    );
    await tester.pumpAndSettle();

    expect(find.text('70%'), findsOneWidget);
    expect(find.text('7/10 biện pháp bảo vệ đã áp dụng'), findsOneWidget);

    await tester.tap(find.byKey(P2PFraudPreventionPage.tabKey('during')));
    await tester.pumpAndSettle();

    expect(find.text('Kiểm tra tên người chuyển'), findsOneWidget);
  });

  testWidgets('SC-260 emergency actions wire insurance and report routes', (
    tester,
  ) async {
    await pumpFraudPrevention(tester);

    await tester.ensureVisible(
      find.byKey(P2PFraudPreventionPage.actionKey('insurance_claim')),
    );
    await tester.tap(
      find.byKey(P2PFraudPreventionPage.actionKey('insurance_claim')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(P2PInsuranceFundPage), findsOneWidget);

    await pumpFraudPrevention(tester);
    await tester.ensureVisible(
      find.byKey(P2PFraudPreventionPage.actionKey('report_merchant')),
    );
    await tester.tap(
      find.byKey(P2PFraudPreventionPage.actionKey('report_merchant')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(P2PReportMerchantPage), findsOneWidget);
  });

  testWidgets('SC-260 support action and back route are safe', (tester) async {
    await pumpFraudPrevention(tester);

    await tester.ensureVisible(
      find.byKey(P2PFraudPreventionPage.actionKey('support')),
    );
    await tester.tap(find.byKey(P2PFraudPreventionPage.actionKey('support')));
    await tester.pumpAndSettle();

    expect(find.text('Liên hệ · Hỗ trợ'), findsOneWidget);

    await pumpFraudPrevention(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PFraudPreventionPage), findsNothing);
  });
}
