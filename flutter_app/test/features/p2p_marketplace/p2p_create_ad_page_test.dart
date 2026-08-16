import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_create_ad_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_my_ads_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PCreateAd(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pCreate,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-226 mock repository exposes P2P create ad BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getCreateAd();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-create');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.assets, ['USDT', 'BTC', 'ETH']);
    expect(snapshot.currencies, ['VND', 'USD']);
    expect(snapshot.paymentOptions.length, 9);
    expect(snapshot.paymentWindows, [15, 30, 60]);
    expect(snapshot.tradingHours, contains('24/7'));
    expect(snapshot.marketPrices['USDT'], 25300);
    expect(snapshot.defaultAsset, 'USDT');
    expect(snapshot.defaultPaymentWindow, 15);
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

  testWidgets('SC-226 renders P2P create ad baseline form', (tester) async {
    await pumpP2PCreateAd(tester);

    expect(find.byType(P2PCreateAdPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đăng quảng cáo P2P'), findsOneWidget);
    expect(find.text('Tạo mới · P2P'), findsOneWidget);
    expect(find.text('Loại quảng cáo'), findsOneWidget);
    expect(find.text('Tôi muốn MUA'), findsOneWidget);
    expect(find.text('Tôi muốn BÁN'), findsOneWidget);
    expect(find.text('Tài sản'), findsOneWidget);
    expect(find.text('Tiền tệ'), findsOneWidget);
    expect(find.text('Loại giá'), findsOneWidget);
    expect(find.text('Cố định'), findsOneWidget);
    expect(find.text('Thả nổi %'), findsOneWidget);
    expect(find.text('Giá (VND/USDT) *'), findsOneWidget);
    expect(find.text('Tổng USDT giao dịch *'), findsOneWidget);
    expect(find.text('Phương thức thanh toán *'), findsOneWidget);
    expect(find.text('Đăng quảng cáo BÁN USDT'), findsOneWidget);

    expect(find.textContaining('Can bo sung:'), findsOneWidget);
    expect(find.textContaining('Nhap gia'), findsOneWidget);
    expect(find.textContaining('Nhap tong USDT'), findsOneWidget);
    expect(find.textContaining('Chon phuong thuc thanh toan'), findsOneWidget);
    expect(
      tester.getRect(find.byKey(P2PCreateAdPage.publishButtonKey)).top,
      greaterThan(tester.view.physicalSize.height),
    );

    await tester.drag(
      find.byKey(P2PCreateAdPage.contentKey),
      const Offset(0, -920),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thời gian thanh toán'), findsOneWidget);
    expect(find.text('Giờ giao dịch'), findsOneWidget);
    expect(find.text('Yêu cầu đối tác'), findsOneWidget);
    expect(find.text('Live Preview'), findsOneWidget);
  });

  testWidgets('SC-226 form state can publish and route back to my ads', (
    tester,
  ) async {
    await pumpP2PCreateAd(tester);

    await tester.enterText(find.byKey(P2PCreateAdPage.priceFieldKey), '25300');
    await tester.enterText(find.byKey(P2PCreateAdPage.totalFieldKey), '100');
    await tester.tap(find.byKey(P2PCreateAdPage.paymentKey('Vietcombank')));
    await tester.pumpAndSettle();

    expect(find.textContaining('0.00%'), findsOneWidget);
    expect(find.text('Đã chọn 1/5'), findsOneWidget);

    expect(find.textContaining('Can bo sung:'), findsNothing);

    await tester.ensureVisible(find.byKey(P2PCreateAdPage.publishButtonKey));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(P2PCreateAdPage.publishButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận đăng quảng cáo'), findsOneWidget);
    expect(find.text('100 USDT'), findsOneWidget);

    await tester.tap(find.byKey(P2PCreateAdPage.confirmPublishKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã đăng quảng cáo'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.byType(P2PMyAdsPage), findsOneWidget);
    expect(find.text('Quảng cáo của tôi'), findsOneWidget);
  });

  testWidgets('SC-226 supports buy and floating price controls', (
    tester,
  ) async {
    await pumpP2PCreateAd(tester);

    await tester.tap(find.byKey(P2PCreateAdPage.adTypeKey(P2PTradeType.buy)));
    await tester.tap(find.byKey(P2PCreateAdPage.priceTypeKey('floating')));
    await tester.pumpAndSettle();

    expect(find.text('Biên độ giá (%) *'), findsOneWidget);
    await tester.enterText(find.byKey(P2PCreateAdPage.marginFieldKey), '0.5');
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(P2PCreateAdPage.totalFieldKey), '50');
    await tester.ensureVisible(find.byKey(P2PCreateAdPage.paymentKey('Momo')));
    await tester.tap(find.byKey(P2PCreateAdPage.paymentKey('Momo')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Tăng 0.50%'), findsOneWidget);
    expect(find.text('Đăng quảng cáo MUA USDT'), findsOneWidget);
  });
}
