import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_evidence_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PDisputeEvidence(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pDisputeEvidence('sample'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-219 mock repository exposes P2P dispute evidence BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDisputeEvidence('sample');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-dispute-evidence-sample');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
    );
    expect(snapshot.disputeId, 'sample');
    expect(snapshot.title, 'Dispute #sample');
    expect(snapshot.documents.length, 3);
    expect(snapshot.documents.where((item) => item.uploaded).length, 2);
    expect(snapshot.contractNotes, contains('escrow'));
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

  testWidgets('SC-219 renders P2P dispute evidence baseline', (tester) async {
    await pumpP2PDisputeEvidence(tester);

    expect(find.byType(P2PDisputeEvidencePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Bằng chứng tranh chấp'), findsOneWidget);
    expect(find.text('Tranh chấp · P2P'), findsOneWidget);
    expect(find.text('Dispute #sample'), findsOneWidget);
    expect(find.text('Upload tài liệu chứng minh'), findsOneWidget);
    expect(find.textContaining('Mock/fail-closed'), findsOneWidget);
    expect(find.text('Payment Receipt'), findsOneWidget);
    expect(find.text('Chat Screenshot'), findsOneWidget);
    expect(find.text('Transaction Proof'), findsOneWidget);
    expect(find.text('Đã tải lên'), findsNWidgets(2));
    expect(find.text('Upload'), findsOneWidget);
    expect(find.text('Gửi bằng chứng'), findsOneWidget);
  });

  testWidgets('SC-219 upload state marks pending evidence uploaded', (
    tester,
  ) async {
    await pumpP2PDisputeEvidence(tester);

    await tester.tap(
      find.byKey(P2PDisputeEvidencePage.uploadKey('transaction')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Upload'), findsNothing);
    expect(find.text('Đã tải lên'), findsNWidgets(3));
  });

  testWidgets('SC-219 submit returns to dispute detail route', (tester) async {
    await pumpP2PDisputeEvidence(tester);

    await tester.tap(find.byKey(P2PDisputeEvidencePage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PDisputeDetailPage), findsOneWidget);
    expect(find.text('Chi tiết khiếu nại'), findsOneWidget);
  });
}
