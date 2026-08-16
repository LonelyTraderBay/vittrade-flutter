import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_merchant_apply_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PMerchantApply(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pMerchantApply,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapNext(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(P2PMerchantApplyPage.nextButtonKey));
    await tester.tap(find.byKey(P2PMerchantApplyPage.nextButtonKey));
    await tester.pumpAndSettle();
  }

  test('SC-227 mock repository exposes P2P merchant apply BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getMerchantApply();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-merchant-apply');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.stats.totalTrades, 156);
    expect(snapshot.stats.completionRate, 97.2);
    expect(snapshot.stats.accountAgeDays, 247);
    expect(snapshot.businessTypes, contains('OTC Desk'));
    expect(
      snapshot.documents.where((document) => document.required),
      hasLength(2),
    );
    expect(snapshot.reviewSteps, contains('Phê duyệt'));
    expect(snapshot.contractNotes, contains('escrow'));
    expect(snapshot.allRequirementsMet, isTrue);
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

  testWidgets('SC-227 renders merchant apply baseline requirements', (
    tester,
  ) async {
    await pumpP2PMerchantApply(tester);

    expect(find.byType(P2PMerchantApplyPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đăng ký Merchant'), findsOneWidget);
    expect(find.text('Merchant · P2P'), findsOneWidget);
    expect(find.text('Yêu cầu'), findsOneWidget);
    expect(find.text('Thông tin'), findsOneWidget);
    expect(find.text('Xác minh'), findsOneWidget);
    expect(find.text('Lịch sử'), findsOneWidget);
    expect(find.text('Hoàn tất'), findsOneWidget);
    expect(find.text('Trở thành Merchant'), findsOneWidget);
    expect(find.text('Huy hiệu Merchant'), findsOneWidget);
    expect(find.text('Phí ưu đãi'), findsOneWidget);
    expect(find.text('Ưu tiên hiển thị'), findsOneWidget);
    expect(find.text('Hỗ trợ VIP'), findsOneWidget);
    expect(find.text('Yêu cầu tối thiểu'), findsOneWidget);
    expect(find.text('Tài khoản >= 30 ngày'), findsOneWidget);
    expect(find.text('>= 100 đơn hoàn thành'), findsOneWidget);
    expect(find.text('Tỷ lệ HT >= 95%'), findsOneWidget);
    expect(find.text('KYC cấp 2+'), findsOneWidget);
    expect(find.text('<= 2 tranh chấp'), findsOneWidget);
    expect(find.text('Tiếp tục'), findsOneWidget);
  });

  testWidgets('SC-227 first viewport reaches merchant requirements', (
    tester,
  ) async {
    await pumpP2PMerchantApply(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-227 P2PMerchantApplyPage',
      semanticLabel: 'Đăng ký Merchant P2P',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Yêu cầu tối thiểu'),
      targetLabel: 'merchant minimum requirements',
      minVisibleHeight: 18,
    );
  });

  testWidgets('SC-227 merchant wizard submits and routes back to P2P', (
    tester,
  ) async {
    await pumpP2PMerchantApply(tester);

    await tapNext(tester);

    expect(find.text('Thông tin doanh nghiệp'), findsOneWidget);
    await tester.enterText(
      find.byKey(P2PMerchantApplyPage.businessNameFieldKey),
      'CryptoTrader VN',
    );
    await tester.tap(
      find.byKey(P2PMerchantApplyPage.businessTypeKey('Công ty')),
    );
    await tester.pumpAndSettle();
    await tapNext(tester);

    expect(find.text('Xác minh tài liệu'), findsOneWidget);
    await tester.tap(find.byKey(P2PMerchantApplyPage.documentKey('identity')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(P2PMerchantApplyPage.documentKey('selfie')),
    );
    await tester.tap(find.byKey(P2PMerchantApplyPage.documentKey('selfie')));
    await tester.pumpAndSettle();
    expect(find.text('Đã tải lên (Demo)'), findsNWidgets(2));
    await tapNext(tester);

    expect(find.text('Đánh giá lịch sử'), findsOneWidget);
    expect(find.text('Tổng đơn hoàn thành'), findsOneWidget);
    await tapNext(tester);

    expect(find.text('Xác nhận & Gửi đơn'), findsOneWidget);
    expect(find.text('CryptoTrader VN'), findsOneWidget);
    expect(find.text('Công ty'), findsOneWidget);
    await tester.tap(find.byKey(P2PMerchantApplyPage.agreementKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PMerchantApplyPage.submitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Đơn đã gửi thành công!'), findsOneWidget);
    expect(find.text('Trạng thái: Đang xét duyệt'), findsOneWidget);

    await tester.tap(find.byKey(P2PMerchantApplyPage.successCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PMerchantApplyPage), findsNothing);
    expect(find.text('P2P'), findsWidgets);
  });
}
