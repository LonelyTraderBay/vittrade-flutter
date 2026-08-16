import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_large_transaction_justification_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_my_orders_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpLargeTransaction(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pComplianceLargeTransaction,
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
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

  test('SC-270 mock repository exposes large transaction BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getLargeTransactionJustification(amount: 100000000);

    expect(
      snapshot.endpoint,
      '/api/mobile/p2p/p2p-compliance-large-transaction',
    );
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Large Transaction');
    expect(snapshot.subtitle, 'Giao dịch · P2P');
    expect(snapshot.amount, 100000000);
    expect(snapshot.heroTitle, 'Giao dịch lớn: 100.000.000');
    expect(snapshot.purposes, hasLength(5));
    expect(snapshot.parentRoute, AppRoutePaths.p2pComplianceOverview);
    expect(snapshot.successRoute, AppRoutePaths.p2pMyOrders);
    expect(snapshot.highRiskContractId, 'p2p_large_transaction_review');
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

  testWidgets('SC-270 renders large transaction baseline', (tester) async {
    await pumpLargeTransaction(tester);

    expect(find.byType(P2PLargeTransactionJustificationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Large Transaction'), findsOneWidget);
    expect(find.text('Giao dịch · P2P'), findsOneWidget);
    expect(
      find.byKey(P2PLargeTransactionJustificationPage.heroKey),
      findsOneWidget,
    );
    expect(find.text('Giao dịch lớn: 100.000.000'), findsOneWidget);
    expect(
      find.text('Cần giải trình mục đích theo quy định AML/CTF'),
      findsOneWidget,
    );
    expect(find.text('Mục đích giao dịch'), findsOneWidget);
    expect(
      find.byKey(P2PLargeTransactionJustificationPage.purposeListKey),
      findsOneWidget,
    );
    expect(find.text('Mua crypto để đầu tư dài hạn'), findsOneWidget);
    expect(find.text('Trading ngắn hạn'), findsOneWidget);
    expect(find.text('Thanh toán quốc tế'), findsOneWidget);
    expect(find.text('Chuyển đổi tài sản'), findsOneWidget);
    expect(find.text('Khác (ghi rõ)'), findsOneWidget);
    expect(find.text('Giải trình chi tiết'), findsOneWidget);
    expect(
      find.text('VD: Mua BTC để nắm giữ dài hạn, dự kiến hold 1-2 năm...'),
      findsOneWidget,
    );
    expect(find.text('Gửi giải trình'), findsOneWidget);
    expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
  });

  testWidgets('SC-270 remains stable at 360px phone baseline', (tester) async {
    await pumpLargeTransaction(tester, viewport: const Size(360, 800));

    expect(find.byType(P2PLargeTransactionJustificationPage), findsOneWidget);
    expect(
      find.byKey(P2PLargeTransactionJustificationPage.heroKey),
      findsOneWidget,
    );
    expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-270 supports query amount in hero', (tester) async {
    await pumpLargeTransaction(
      tester,
      initialLocation:
          '${AppRoutePaths.p2pComplianceLargeTransaction}?amount=125000000',
    );

    expect(find.text('Giao dịch lớn: 125.000.000'), findsOneWidget);
  });

  testWidgets('SC-270 submits to safe my-orders route', (tester) async {
    await pumpLargeTransaction(tester);

    await tester.tap(
      P2PLargeTransactionJustificationPage.purposeKey(
        'Mua crypto để đầu tư dài hạn',
      ).finder,
    );
    await tester.enterText(
      find.byKey(P2PLargeTransactionJustificationPage.detailsInputKey),
      'Mua BTC để nắm giữ dài hạn, dự kiến hold 1-2 năm.',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PLargeTransactionJustificationPage.ctaKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận gửi giải trình giao dịch lớn'), findsOneWidget);
    await tester.tap(
      find.byKey(P2PLargeTransactionJustificationPage.confirmKey),
    );
    await tester.pumpAndSettle();

    expect(find.byType(P2PLargeTransactionJustificationPage), findsNothing);
    expect(find.byType(P2PMyOrdersPage), findsOneWidget);
  });

  testWidgets('SC-270 back returns to compliance overview', (tester) async {
    await pumpLargeTransaction(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PLargeTransactionJustificationPage), findsNothing);
    expect(find.byType(P2PComplianceOverviewPage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
