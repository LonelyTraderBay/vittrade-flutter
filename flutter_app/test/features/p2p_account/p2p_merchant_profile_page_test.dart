import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_ad_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_blacklist_add_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_merchant_profile_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_report_merchant_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PMerchantProfile(
    WidgetTester tester, {
    double width = 440,
    double height = 956,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, height);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pMerchant('mc001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-228 mock repository exposes P2P merchant profile BE draft',
    () async {
      final snapshot = await const MockP2PRepository(
        loadDelay: Duration.zero,
      ).getMerchantProfile('mc001');

      expect(snapshot.endpoint, '/api/mobile/p2p/p2p-merchant-mc001');
      expect(
        snapshot.actionDraft,
        'POST /p2p/* workflow action where applicable',
      );
      expect(snapshot.merchantId, 'mc001');
      expect(snapshot.merchant.name, 'CryptoKing_VN');
      expect(snapshot.merchant.totalTrades, 1243);
      expect(snapshot.merchant.completionRate, 98.5);
      expect(snapshot.merchant.totalVolume30dUsd, 850000);
      expect(snapshot.merchant.positiveRate, 97.8);
      expect(snapshot.positiveReviewCount, 1216);
      expect(snapshot.ads, hasLength(3));
      expect(snapshot.ads.map((ad) => ad.asset), ['USDT', 'ETH', 'SOL']);
      expect(snapshot.reviews, hasLength(4));
      expect(snapshot.reportRoute, '/p2p/report/mc001');
      expect(snapshot.blacklistAddRoute, '/p2p/blacklist/add');
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
    },
  );

  testWidgets('SC-228 renders merchant profile baseline', (tester) async {
    await pumpP2PMerchantProfile(tester);

    expect(find.byType(P2PMerchantProfilePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hồ sơ Merchant'), findsOneWidget);
    expect(find.text('Merchant · P2P'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(find.text('98.5%'), findsOneWidget);
    expect(find.text('1,243'), findsOneWidget);
    expect(find.text('\$850K'), findsOneWidget);
    expect(find.text('2 phút'), findsOneWidget);
    expect(find.text('Quảng cáo (3)'), findsOneWidget);
    expect(find.text('USDT'), findsOneWidget);
    expect(find.text('25.350'), findsOneWidget);

    await tester.drag(
      find.byKey(P2PMerchantProfilePage.contentKey),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();

    expect(find.text('ETH'), findsOneWidget);
    expect(find.text('SOL'), findsOneWidget);
    expect(find.text('89.500.000'), findsOneWidget);
    expect(find.text('4.870.000'), findsOneWidget);
  });

  testWidgets(
    'SC-228 keeps merchant actions within the 360 px phone baseline',
    (tester) async {
      await pumpP2PMerchantProfile(tester, width: 360, height: 800);

      for (final key in [
        P2PMerchantProfilePage.followButtonKey,
        P2PMerchantProfilePage.reportButtonKey,
        P2PMerchantProfilePage.blockButtonKey,
      ]) {
        final rect = tester.getRect(find.byKey(key));
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(360));
      }
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SC-228 supports follow state and reviews tab', (tester) async {
    await pumpP2PMerchantProfile(tester);

    await tester.tap(find.byKey(P2PMerchantProfilePage.followButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã theo dõi'), findsOneWidget);

    await tester.tap(find.text('Đánh giá (4)'));
    await tester.pumpAndSettle();

    expect(find.text('TraderNewbie'), findsOneWidget);
    expect(find.textContaining('Giao dịch nhanh'), findsOneWidget);
    expect(find.text('Tích cực'), findsWidgets);
  });

  testWidgets('SC-228 wires report and ad navigation edges', (tester) async {
    await pumpP2PMerchantProfile(tester);

    await tester.tap(find.byKey(P2PMerchantProfilePage.reportButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PReportMerchantPage), findsOneWidget);
    expect(find.text('Báo cáo & Chặn'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pMerchant('mc001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mua ngay').first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PAdDetailPage), findsOneWidget);
    expect(find.text('Chi tiết quảng cáo'), findsOneWidget);
  });

  testWidgets('SC-228 confirms block before blacklist route', (tester) async {
    await pumpP2PMerchantProfile(tester);

    await tester.tap(find.byKey(P2PMerchantProfilePage.blockButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Chặn CryptoKing_VN?'), findsOneWidget);

    await tester.tap(find.text('Chặn'));
    await tester.pumpAndSettle();

    expect(find.byType(P2PBlacklistAddPage), findsOneWidget);
  });
}
