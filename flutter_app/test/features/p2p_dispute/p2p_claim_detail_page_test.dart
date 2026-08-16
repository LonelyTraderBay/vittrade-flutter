import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_claim_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_insurance_fund_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PClaimDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pClaim('sample'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-243 mock repository exposes claim detail BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getClaimDetail('sample');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-insurance-claim-sample');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.claim.claimCode, 'CLM-001');
    expect(snapshot.claim.orderId, 'P2P-78400');
    expect(snapshot.claim.reason, 'Gian lận');
    expect(snapshot.claim.amount, 15000000);
    expect(snapshot.claim.paidAmount, 12750000);
    expect(snapshot.claim.timeline, hasLength(6));
    expect(snapshot.claim.evidence, hasLength(4));
    expect(snapshot.claim.reviewerNotes, hasLength(3));
    expect(snapshot.benchmarks, hasLength(3));
    expect(snapshot.reasonShares.first.percent, 42);
    expect(snapshot.parentRoute, AppRoutePaths.p2pInsurance);
    expect(snapshot.orderRoute, AppRoutePaths.p2pOrder('78400'));
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=p2p_order'));
    expect(snapshot.supportRoute, contains('CLM-001'));
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

  testWidgets('SC-243 renders claim detail timeline in P2P shell', (
    tester,
  ) async {
    await pumpP2PClaimDetail(tester);

    expect(find.byType(P2PClaimDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('CLM-001'), findsWidgets);
    expect(find.text('Bảo hiểm · P2P'), findsOneWidget);
    expect(find.byKey(P2PClaimDetailPage.heroKey), findsOneWidget);
    expect(find.text('Đã chi trả'), findsWidgets);
    expect(find.text('P2P-78400'), findsOneWidget);
    expect(find.text('15.000.000 đ'), findsWidgets);
    expect(find.byKey(P2PClaimDetailPage.benchmarksKey), findsOneWidget);
    expect(find.text('So sánh với nền tảng'), findsOneWidget);
    expect(find.text('334h'), findsOneWidget);
    expect(find.byKey(P2PClaimDetailPage.descriptionKey), findsOneWidget);
    expect(
      find.textContaining('Merchant không giải phóng coin'),
      findsOneWidget,
    );
    expect(find.byKey(P2PClaimDetailPage.tabsKey), findsOneWidget);
    expect(find.text('Lịch sử  6'), findsOneWidget);
    expect(find.byKey(P2PClaimDetailPage.timelineKey), findsOneWidget);
    expect(find.text('Yêu cầu đã gửi'), findsOneWidget);
    expect(find.text('Đã chấp thuận'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PClaimDetailPage.receiptKey));
    expect(find.byKey(P2PClaimDetailPage.notificationsKey), findsOneWidget);
    expect(find.byKey(P2PClaimDetailPage.orderLinkKey), findsOneWidget);
    expect(find.byKey(P2PClaimDetailPage.receiptKey), findsOneWidget);
  });

  testWidgets('SC-243 first viewport reaches claim benchmarks', (tester) async {
    await pumpP2PClaimDetail(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-243 P2PClaimDetailPage',
      semanticLabel: 'Chi tiết yêu cầu bảo hiểm P2P',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(P2PClaimDetailPage.benchmarksKey),
      targetLabel: 'claim benchmark comparison',
      minVisibleHeight: 18,
    );
  });

  testWidgets(
    'SC-243 supports evidence, notes, notification and receipt state',
    (tester) async {
      await pumpP2PClaimDetail(tester);

      await tester.ensureVisible(find.text('Bằng chứng  4'));
      await tester.tap(find.text('Bằng chứng  4'));
      await tester.pumpAndSettle();
      expect(find.byKey(P2PClaimDetailPage.evidenceKey), findsOneWidget);
      expect(find.text('chuyen_khoan_mb.png'), findsOneWidget);
      expect(find.text('sao_ke_ngan_hang.pdf'), findsOneWidget);

      await tester.ensureVisible(find.text('Ghi chú  3'));
      await tester.tap(find.text('Ghi chú  3'));
      await tester.pumpAndSettle();
      expect(find.byKey(P2PClaimDetailPage.notesKey), findsOneWidget);
      expect(find.text('Nguyễn Văn A'), findsOneWidget);
      expect(find.text('Trần Thị B'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(P2PClaimDetailPage.notificationsKey),
      );
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(find.byKey(P2PClaimDetailPage.feedbackKey), findsOneWidget);
      expect(find.textContaining('Đã tắt thông báo'), findsOneWidget);

      await tester.ensureVisible(find.byKey(P2PClaimDetailPage.receiptKey));
      await tester.tap(find.byKey(P2PClaimDetailPage.receiptKey));
      await tester.pumpAndSettle();
      expect(find.textContaining('Đã chuẩn bị biên lai'), findsOneWidget);
    },
  );

  testWidgets('SC-243 navigation edges use canonical P2P routes', (
    tester,
  ) async {
    await pumpP2PClaimDetail(tester);

    await tester.ensureVisible(find.byKey(P2PClaimDetailPage.orderLinkKey));
    await tester.tap(find.byKey(P2PClaimDetailPage.orderLinkKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2POrderPage), findsOneWidget);

    await pumpP2PClaimDetail(tester);
    await tester.ensureVisible(find.byKey(P2PClaimDetailPage.supportLinkKey));
    await tester.tap(find.byKey(P2PClaimDetailPage.supportLinkKey));
    await tester.pumpAndSettle();
    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('P2P claim support for CLM-001'), findsOneWidget);
    expect(find.text('CLM-001'), findsWidgets);

    await pumpP2PClaimDetail(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(P2PInsuranceFundPage), findsOneWidget);
  });

  testWidgets('SC-243 insurance fund claim card opens claim detail', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pInsurance,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(P2PInsuranceFundPage.tourContinueKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yêu cầu của tôi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CLM-001'));
    await tester.pumpAndSettle();

    expect(find.byType(P2PClaimDetailPage), findsOneWidget);
    expect(find.byKey(P2PClaimDetailPage.heroKey), findsOneWidget);
  });
}
