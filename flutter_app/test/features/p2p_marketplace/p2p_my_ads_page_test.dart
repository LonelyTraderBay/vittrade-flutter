import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_ad_analytics_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_create_ad_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_my_ads_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PMyAds(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pMyAds,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-225 mock repository exposes P2P my ads BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getMyAds();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-my-ads');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.ads.length, 3);
    expect(snapshot.activeCount, 2);
    expect(snapshot.pausedCount, 1);
    expect(snapshot.totalVolume30dUsd, 84000);
    expect(snapshot.ads.first.id, 'myad001');
    expect(snapshot.ads.first.available, 3000);
    expect(
      snapshot.quickLinks.map((link) => link.route),
      contains('/p2p/settings'),
    );
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

  testWidgets('SC-225 renders P2P my ads baseline', (tester) async {
    await pumpP2PMyAds(tester);

    expect(find.byType(P2PMyAdsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Quảng cáo của tôi'), findsOneWidget);
    expect(find.text('Quảng cáo · P2P'), findsOneWidget);
    expect(find.byKey(P2PMyAdsPage.createButtonKey), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    expect(find.text('1'), findsWidgets);
    expect(find.text('\$84K'), findsOneWidget);
    expect(find.text('Tất cả (3)'), findsOneWidget);
    expect(find.text('Hoạt động (2)'), findsOneWidget);
    expect(find.text('Tạm dừng (1)'), findsOneWidget);
    expect(find.text('BÁN USDT'), findsOneWidget);
    expect(find.text('MUA USDT'), findsOneWidget);
    expect(find.text('25.360'), findsOneWidget);
    expect(find.text('25.250'), findsOneWidget);
    expect(find.text('3,000.00 USDT'), findsOneWidget);
    expect(find.text('Phân tích'), findsNothing);
    expect(find.text('Dừng'), findsWidgets);

    await tester.drag(
      find.byKey(P2PMyAdsPage.contentKey),
      const Offset(0, -760),
    );
    await tester.pumpAndSettle();

    expect(find.text('LIÊN KẾT NHANH'), findsOneWidget);
    expect(find.text('Cài đặt P2P'), findsOneWidget);
    expect(find.text('Danh sách chặn'), findsOneWidget);
    expect(find.text('Hướng dẫn'), findsOneWidget);
  });

  testWidgets('SC-225 filters, toggles, and deletes ads locally', (
    tester,
  ) async {
    await pumpP2PMyAds(tester);

    await tester.tap(find.text('Tạm dừng (1)'));
    await tester.pumpAndSettle();

    expect(find.text('BÁN BTC'), findsOneWidget);
    expect(find.text('Bật'), findsOneWidget);

    await tester.tap(find.byKey(P2PMyAdsPage.toggleKey('myad003')));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có quảng cáo nào'), findsOneWidget);
    expect(find.text('Đăng quảng cáo đầu tiên'), findsOneWidget);

    await tester.tap(find.text('Tất cả (3)'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PMyAdsPage.adMenuKey('myad001')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PMyAdsPage.deleteKey('myad001')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa'));
    await tester.pumpAndSettle();
    expect(find.text('Đã xóa quảng cáo'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.text('Tất cả (2)'), findsOneWidget);
    expect(find.text('BÁN USDT'), findsNothing);
  });

  testWidgets('SC-225 wires analytics, create, and quick links', (
    tester,
  ) async {
    await pumpP2PMyAds(tester);

    await tester.tap(find.byKey(P2PMyAdsPage.adMenuKey('myad001')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PMyAdsPage.analyticsKey('myad001')));
    await tester.pumpAndSettle();
    expect(find.byType(P2PAdAnalyticsPage), findsOneWidget);

    await pumpP2PMyAds(tester);
    await tester.tap(find.byKey(P2PMyAdsPage.createButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PCreateAdPage), findsOneWidget);

    await pumpP2PMyAds(tester);
    await tester.drag(
      find.byKey(P2PMyAdsPage.contentKey),
      const Offset(0, -760),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(P2PMyAdsPage.quickLinkKey('settings')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PMyAdsPage.quickLinkKey('settings')));
    await tester.pumpAndSettle();
    expect(find.byType(P2PSettingsPage), findsOneWidget);
  });
}
