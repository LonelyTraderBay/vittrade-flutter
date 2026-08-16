import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_disputes_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PDisputes(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pDisputes,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-222 mock repository exposes P2P disputes BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDisputes();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-disputes');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
    );
    expect(snapshot.totalCount, 1);
    expect(snapshot.activeCount, 1);
    expect(snapshot.resolvedCount, 0);
    expect(snapshot.disputes.single.id, 'disp001');
    expect(snapshot.disputes.single.shortOrderNumber, '19-006');
    expect(snapshot.guideSteps.length, 4);
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

  testWidgets('SC-222 renders P2P disputes baseline', (tester) async {
    await pumpP2PDisputes(tester);

    expect(find.byType(P2PDisputesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tranh chấp P2P'), findsOneWidget);
    expect(find.text('Tranh chấp · P2P'), findsOneWidget);
    expect(find.text('Tổng cộng'), findsOneWidget);
    expect(find.text('Đang xử lý'), findsOneWidget);
    expect(find.text('Đã giải quyết'), findsOneWidget);
    expect(find.text('Quy trình xử lý tranh chấp'), findsOneWidget);
    expect(find.text('Danh sách tranh chấp'), findsOneWidget);
    expect(find.text('1 đang xử lý'), findsOneWidget);
    expect(find.text('#19-006'), findsOneWidget);
    expect(find.text('2024-02-19 08:50'), findsOneWidget);
    expect(
      find.text('Đã thanh toán nhưng người bán không xác nhận'),
      findsOneWidget,
    );
    expect(find.text('2 bằng chứng'), findsOneWidget);
    expect(find.text('5 sự kiện'), findsOneWidget);
    expect(find.text('Cách mở tranh chấp'), findsOneWidget);
  });

  testWidgets('SC-222 first viewport reaches dispute list start', (
    tester,
  ) async {
    await pumpP2PDisputes(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-222 P2PDisputesPage',
      semanticLabel: 'Tranh chấp P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.text('1'),
      routeName: 'SC-222 P2PDisputesPage',
      actionLabel: 'the active dispute count',
      minVisibleHeight: 18,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PDisputesPage.disputeKey('disp001')),
      routeName: 'SC-222 P2PDisputesPage',
      actionLabel: 'the first dispute tile',
      minVisibleHeight: 40,
    );
  });

  testWidgets('SC-222 dispute tile opens dispute detail route', (tester) async {
    await pumpP2PDisputes(tester);

    await tester.tap(find.byKey(P2PDisputesPage.disputeKey('disp001')));
    await tester.pumpAndSettle();

    expect(find.byType(P2PDisputeDetailPage), findsOneWidget);
    expect(find.text('Chi tiết khiếu nại'), findsOneWidget);
  });
}
