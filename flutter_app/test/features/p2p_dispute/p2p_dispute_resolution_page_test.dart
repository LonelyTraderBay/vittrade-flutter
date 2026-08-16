import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_dispute_resolution_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/pages/dispute/p2p_disputes_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PDisputeResolution(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pDisputeResolution('sample'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-220 mock repository exposes P2P dispute resolution BE draft',
    () async {
      final snapshot = await const MockP2PRepository(
        loadDelay: Duration.zero,
      ).getDisputeResolution('sample');

      expect(
        snapshot.endpoint,
        '/api/mobile/p2p/p2p-dispute-resolution-sample',
      );
      expect(
        snapshot.actionDraft,
        'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
      );
      expect(snapshot.disputeId, 'sample');
      expect(snapshot.resultTitle, 'Quyết định: Bên mua thắng');
      expect(snapshot.refundAmountLabel, '24.000.000');
      expect(snapshot.mediator, 'Support Team #A5');
      expect(snapshot.contractNotes, contains('escrow'));
      expect(snapshot.highRiskContractId, 'p2p_escrow_order');
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

  testWidgets('SC-220 renders P2P dispute resolution baseline', (tester) async {
    await pumpP2PDisputeResolution(tester);

    expect(find.byType(P2PDisputeResolutionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Kết quả giải quyết'), findsOneWidget);
    expect(find.text('Tranh chấp · P2P'), findsOneWidget);
    expect(find.text('Quyết định: Bên mua thắng'), findsOneWidget);
    expect(find.text('Dispute #sample'), findsOneWidget);
    expect(find.text('Chi tiết quyết định'), findsOneWidget);
    expect(find.text('Số tiền hoàn trả'), findsOneWidget);
    expect(find.text('24.000.000'), findsOneWidget);
    expect(find.text('Trọng tài'), findsOneWidget);
    expect(find.text('Support Team #A5'), findsOneWidget);
    expect(find.text('2026-03-05 16:00'), findsOneWidget);
    expect(find.text('Quyền kháng cáo'), findsOneWidget);
    expect(find.text('Kháng cáo'), findsOneWidget);
    expect(find.text('Quay về danh sách tranh chấp'), findsOneWidget);
  });

  testWidgets('SC-220 appeal button opens appeal state', (tester) async {
    await pumpP2PDisputeResolution(tester);

    await tester.tap(find.byKey(P2PDisputeResolutionPage.appealKey));
    await tester.pumpAndSettle();

    expect(find.text('Đang mở kháng cáo'), findsOneWidget);
    expect(find.textContaining('Mock/fail-closed'), findsOneWidget);
  });

  testWidgets('SC-220 CTA returns to disputes list route', (tester) async {
    await pumpP2PDisputeResolution(tester);

    await tester.tap(find.byKey(P2PDisputeResolutionPage.disputesKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PDisputeResolutionPage), findsNothing);
    expect(find.byType(P2PDisputesPage), findsOneWidget);
    expect(find.text('Tranh chấp P2P'), findsOneWidget);
  });
}
