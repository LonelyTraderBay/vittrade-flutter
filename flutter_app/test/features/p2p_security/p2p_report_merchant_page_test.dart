import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_blacklist_add_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_merchant_profile_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_report_merchant_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PReportMerchant(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pReport('mc001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-229 mock repository exposes P2P report merchant BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getReportMerchant('mc001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-report-mc001');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /exports',
    );
    expect(snapshot.merchantId, 'mc001');
    expect(snapshot.merchant.name, 'CryptoKing_VN');
    expect(snapshot.reasons, hasLength(6));
    expect(snapshot.reasons.map((reason) => reason.id), [
      'scam',
      'fake_payment',
      'harassment',
      'price_manipulation',
      'identity',
      'other',
    ]);
    expect(snapshot.blacklistAddRoute, '/p2p/blacklist/add');
    expect(snapshot.merchantProfileRoute, '/p2p/merchant/mc001');
    expect(snapshot.reviewNotice, contains('VitTrade'));
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

  testWidgets('SC-229 renders report merchant baseline', (tester) async {
    await pumpP2PReportMerchant(tester);

    expect(find.byType(P2PReportMerchantPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Báo cáo & Chặn'), findsOneWidget);
    expect(find.text('An toàn · P2P'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(find.text('ID: mc001'), findsOneWidget);
    expect(find.text('Chặn người dùng'), findsOneWidget);
    expect(find.text('Xem profile Merchant'), findsOneWidget);
    expect(find.text('Báo cáo vi phạm'), findsOneWidget);
    expect(find.text('Lừa đảo / Gian lận'), findsOneWidget);
    expect(find.text('Thanh toán giả'), findsOneWidget);
    expect(find.text('Quấy rối / Đe dọa'), findsOneWidget);
    expect(find.text('Thao túng giá'), findsOneWidget);
    expect(find.text('Giả mạo danh tính'), findsOneWidget);
    expect(find.text('Lý do khác'), findsOneWidget);
    expect(find.text('Gửi báo cáo'), findsOneWidget);
    expect(find.byKey(P2PReportMerchantPage.detailFieldKey), findsNothing);
  });

  testWidgets('SC-229 first viewport reaches report actions and first reason', (
    tester,
  ) async {
    await pumpP2PReportMerchant(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-229 P2PReportMerchantPage',
      semanticLabel: 'Báo cáo và chặn người bán P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PReportMerchantPage.blockButtonKey),
      routeName: 'SC-229 P2PReportMerchantPage',
      actionLabel: 'the block merchant action',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PReportMerchantPage.profileButtonKey),
      routeName: 'SC-229 P2PReportMerchantPage',
      actionLabel: 'the merchant profile action',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      P2PReportMerchantPage.reasonKey('scam').finder,
      routeName: 'SC-229 P2PReportMerchantPage',
      actionLabel: 'the first report reason',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-229 reason selection reveals detail and submit returns', (
    tester,
  ) async {
    await pumpP2PReportMerchant(tester);

    await tester.tap(P2PReportMerchantPage.reasonKey('scam').finder);
    await tester.pumpAndSettle();

    expect(find.byKey(P2PReportMerchantPage.detailFieldKey), findsOneWidget);
    expect(find.text('Chi tiết bổ sung (tuỳ chọn)'), findsOneWidget);

    await tester.enterText(
      find.byKey(P2PReportMerchantPage.detailFieldKey),
      'Biên lai không khớp với giao dịch.',
    );
    await tester.ensureVisible(
      find.byKey(P2PReportMerchantPage.submitButtonKey),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(P2PReportMerchantPage.submitButtonKey));
    await tester.pump(const Duration(milliseconds: 320));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận gửi báo cáo P2P'), findsOneWidget);
    await tester.tap(find.byKey(P2PReportMerchantPage.confirmKey));
    await tester.pump(const Duration(milliseconds: 320));
    await tester.pumpAndSettle();

    expect(find.byType(P2PMerchantProfilePage), findsOneWidget);
    expect(find.text('Hồ sơ Merchant'), findsOneWidget);
  });

  testWidgets('SC-229 wires quick action navigation edges', (tester) async {
    await pumpP2PReportMerchant(tester);

    await tester.tap(find.byKey(P2PReportMerchantPage.profileButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PMerchantProfilePage), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pReport('mc001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(P2PReportMerchantPage.blockButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PBlacklistAddPage), findsOneWidget);
  });

  testWidgets('SC-229 header back returns to merchant profile fallback', (
    tester,
  ) async {
    await pumpP2PReportMerchant(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PMerchantProfilePage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
