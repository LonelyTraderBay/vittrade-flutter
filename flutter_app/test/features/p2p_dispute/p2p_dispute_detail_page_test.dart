import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_evidence_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_disputes_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PDisputeDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pDisputeDetail('sample'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-218 mock repository exposes P2P dispute detail BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDisputeDetail('sample');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-dispute-detail-sample');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
    );
    expect(snapshot.dispute.id, 'disp001');
    expect(snapshot.dispute.orderId, 'p2p006');
    expect(snapshot.dispute.status, P2PDisputeStatus.underReview);
    expect(snapshot.dispute.currentLevel, 2);
    expect(snapshot.evidence.length, 2);
    expect(snapshot.timeline.length, 5);
    expect(snapshot.supportMessages.length, 3);
    expect(snapshot.contractNotes, contains('escrow'));
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

  testWidgets('SC-218 renders P2P dispute detail baseline', (tester) async {
    await pumpP2PDisputeDetail(tester);

    expect(find.byType(P2PDisputeDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết khiếu nại'), findsOneWidget);
    expect(find.text('Tranh chấp · P2P'), findsOneWidget);
    expect(find.text('Đang xem xét'), findsWidgets);
    expect(find.text('Đơn hàng #VT-P2P-20240219-006'), findsOneWidget);
    expect(find.text('Cấp độ xử lý'), findsOneWidget);
    expect(find.text('Cấp 2/4'), findsOneWidget);
    expect(find.text('Cấp 2: Nhân viên hỗ trợ'), findsOneWidget);
    expect(find.text('Lý do khiếu nại'), findsOneWidget);
    expect(
      find.text('Đã thanh toán nhưng người bán không xác nhận'),
      findsOneWidget,
    );
    expect(find.text('Bằng chứng (2)'), findsOneWidget);
    expect(find.text('Tiến trình'), findsOneWidget);
    expect(find.text('Chat với hỗ trợ'), findsOneWidget);
    expect(find.text('Hành động'), findsOneWidget);
    expect(find.textContaining('mock/fail-closed'), findsOneWidget);
  });

  testWidgets('SC-218 escalation and support message state work', (
    tester,
  ) async {
    await pumpP2PDisputeDetail(tester);

    await tester.ensureVisible(find.byKey(P2PDisputeDetailPage.escalateKey));
    await tester.tap(find.byKey(P2PDisputeDetailPage.escalateKey));
    await tester.pumpAndSettle();

    expect(find.text('Cấp 3/4'), findsOneWidget);
    expect(find.text('Cấp 3: Trọng tài'), findsOneWidget);
    expect(find.text('09:15'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PDisputeDetailPage.inputKey));
    await tester.enterText(
      find.byKey(P2PDisputeDetailPage.inputKey),
      'Tôi đã bổ sung sao kê ngân hàng.',
    );
    await tester.tap(find.byKey(P2PDisputeDetailPage.sendKey));
    await tester.pumpAndSettle();

    expect(find.text('Tôi đã bổ sung sao kê ngân hàng.'), findsOneWidget);
    expect(find.text('09:20'), findsOneWidget);
  });

  testWidgets('SC-218 wires evidence and disputes navigation safely', (
    tester,
  ) async {
    await pumpP2PDisputeDetail(tester);

    await tester.ensureVisible(
      find.byKey(P2PDisputeDetailPage.manageEvidenceKey),
    );
    await tester.tap(find.byKey(P2PDisputeDetailPage.manageEvidenceKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PDisputeEvidencePage), findsOneWidget);

    await pumpP2PDisputeDetail(tester);
    await tester.ensureVisible(find.byKey(P2PDisputeDetailPage.disputesKey));
    await tester.tap(find.byKey(P2PDisputeDetailPage.disputesKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PDisputesPage), findsOneWidget);
    expect(find.text('Tranh chấp P2P'), findsOneWidget);
  });
}
