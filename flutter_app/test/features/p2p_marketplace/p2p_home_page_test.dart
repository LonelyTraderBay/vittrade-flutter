import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_ad_analytics_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_ad_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_create_ad_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_dashboard_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_express_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_guide_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_home_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_notifications_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_merchant_profile_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_fund_lock_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_my_orders_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_contribution_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_login_history_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.p2p),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-282 mock repository exposes P2P home BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getHome();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'P2P');
    expect(snapshot.subtitle, 'Cấp 3 · Giao dịch P2P');
    expect(snapshot.assets, ['USDT', 'BTC', 'ETH', 'BNB', 'SOL']);
    expect(snapshot.fiatCurrencies, ['VND', 'USD']);
    expect(snapshot.quickActions.map((action) => action.route), [
      AppRoutePaths.p2pExpress,
      AppRoutePaths.p2pCreate,
    ]);
    expect(snapshot.ads.map((ad) => ad.id), ['ad001', 'ad002', 'ad003']);
    expect(snapshot.platformStats.volume24h, 12850000000);
    expect(snapshot.platformStats.onlineTraders, 1892);
    expect(snapshot.platformStats.escrowProtected, 45200000000);
    expect(snapshot.myOrdersRoute, AppRoutePaths.p2pMyOrders);
    expect(snapshot.tradingLevelRoute, AppRoutePaths.p2pTradingLevel);
    expect(snapshot.contractNotes, contains('ký quỹ escrow'));
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

  testWidgets('SC-282 renders P2P marketplace baseline', (tester) async {
    await pumpHome(tester);

    expect(find.byType(P2PHomePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(P2PHomePage.offlineKey), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
    expect(find.text('Cấp 3 · Giao dịch P2P'), findsOneWidget);
    expect(find.byKey(P2PHomePage.createKey), findsOneWidget);
    expect(find.byKey(P2PHomePage.myOrdersKey), findsOneWidget);
    expect(find.byKey(P2PHomePage.toolsKey), findsOneWidget);
    expect(find.byTooltip('Tạo tin'), findsOneWidget);
    expect(find.byTooltip('Đơn của tôi'), findsOneWidget);
    expect(find.byTooltip('Công cụ'), findsOneWidget);
    expect(find.byKey(P2PHomePage.quickHubKey), findsOneWidget);
    expect(find.text('Thao tác nhanh'), findsOneWidget);
    expect(find.text('Ký quỹ escrow bảo vệ giao dịch'), findsOneWidget);
    expect(find.text('Express nhanh'), findsOneWidget);
    expect(find.text('Tạo tin'), findsOneWidget);
    expect(find.text('Express Trade'), findsNothing);
    expect(find.text('Đăng offer'), findsNothing);
    expect(find.text('₫45.20B'), findsOneWidget);
    expect(find.text('94.5%'), findsOneWidget);
    expect(find.byKey(P2PHomePage.kycBannerKey), findsOneWidget);
    expect(
      find.text('P2P yêu cầu xác minh KYC trước khi giao dịch'),
      findsOneWidget,
    );
    expect(find.text('Xác minh KYC'), findsOneWidget);
    expect(find.byKey(P2PHomePage.escrowDisclaimerKey), findsOneWidget);
    expect(find.textContaining('ký quỹ escrow'), findsWidgets);
    expect(find.byKey(P2PHomePage.tradeTabsKey), findsOneWidget);
    expect(find.text('MUA'), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);
    expect(find.byKey(P2PHomePage.assetKey('USDT')), findsOneWidget);
    expect(find.byKey(P2PHomePage.fiatKey('VND')), findsOneWidget);
    expect(find.byKey(P2PHomePage.searchKey), findsOneWidget);
    expect(find.byKey(P2PHomePage.adKey('ad001')), findsOneWidget);
    expect(find.byKey(P2PHomePage.adKey('ad002')), findsOneWidget);
    expect(find.byKey(P2PHomePage.adKey('ad003')), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(find.text('TradeMaster99'), findsOneWidget);
    expect(find.text('CoinHunter_HCM'), findsOneWidget);
    expect(
      find.text('Merchant mới - kiểm tra kỹ trước khi giao dịch'),
      findsOneWidget,
    );
  });

  testWidgets('SC-282 first viewport reaches searchable offer preview', (
    tester,
  ) async {
    await pumpHome(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-282 P2PHomePage',
      semanticLabel: 'Trang chủ giao dịch P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PHomePage.searchKey),
      routeName: 'SC-282 P2PHomePage',
      actionLabel: 'market search',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PHomePage.adKey('ad001')),
      routeName: 'SC-282 P2PHomePage',
      actionLabel: 'first offer preview',
      minVisibleHeight: 24,
    );
    expect(
      tester.getSize(find.byKey(P2PHomePage.quickHubKey)).height,
      lessThanOrEqualTo(200),
      reason: 'P2P quick hub should not consume the first viewport.',
    );
  });

  testWidgets('SC-282 shows cached-data banner below header when offline', (
    tester,
  ) async {
    final offlineSnapshot =
        (await const MockP2PRepository(
          loadDelay: Duration.zero,
        ).getHome()).copyWith(
          currentState: P2PScreenState.offline,
          lastUpdatedLabel: '2 ph\u00FAt tr\u01B0\u1EDBc',
        );

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          p2pHomeProvider.overrideWith((ref, request) => offlineSnapshot),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.p2p),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(P2PHomePage.offlineKey), findsOneWidget);
    expect(
      find.text(
        'M\u1EA5t k\u1EBFt n\u1ED1i. \u0110ang hi\u1EC3n th\u1ECB d\u1EEF li\u1EC7u g\u1EA7n nh\u1EA5t.',
      ),
      findsOneWidget,
    );

    final headerBottom = tester.getBottomLeft(find.text('P2P').first).dy;
    final bannerTop = tester.getTopLeft(find.byKey(P2PHomePage.offlineKey)).dy;
    expect(bannerTop, greaterThan(headerBottom));
  });

  testWidgets('SC-282 search, sell tab, and filters update locally', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.enterText(find.byType(TextField).first, 'Trade');
    await tester.pumpAndSettle();
    expect(find.text('TradeMaster99'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsNothing);

    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PHomePage.tradeTabKey(P2PTradeType.sell)));
    await tester.pumpAndSettle();
    expect(find.text('VIPTrader_HN'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsNothing);

    await tester.tap(find.byTooltip('Enable filters'));
    await tester.pumpAndSettle();
    expect(find.byKey(P2PHomePage.filterKey), findsOneWidget);
    await tester.tap(find.text('Elite').first);
    await tester.pumpAndSettle();
    expect(find.text('VIPTrader_HN'), findsOneWidget);
  });

  testWidgets('SC-282 tools sheet lists all P2P hub entries', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(P2PHomePage.toolsKey));
    await tester.pumpAndSettle();

    expect(find.byKey(P2PHomePage.toolsSheetKey), findsOneWidget);
    expect(find.text('Công cụ P2P'), findsOneWidget);

    const tools = [
      ('express', 'Express nhanh'),
      ('dashboard', 'Bảng điều khiển'),
      ('guide', 'Hướng dẫn'),
      ('compliance_overview', 'Tuân thủ tổng quan'),
      ('insurance_contribution_history', 'Đóng góp bảo hiểm'),
      ('payment_method_history', 'Lịch sử phương thức'),
      ('security_login_history', 'Lịch sử đăng nhập'),
      ('notifications', 'Thông báo P2P'),
      ('fund_lock_history', 'Lịch sử khóa quỹ'),
      ('wallet_history', 'Lịch sử ví P2P (alias)'),
      ('ad_analytics', 'Phân tích tin'),
    ];

    for (final (id, label) in tools) {
      expect(find.byKey(P2PHomePage.toolKey(id)), findsOneWidget);
      expect(find.text(label), findsWidgets);
    }
  });

  testWidgets('SC-282 tools sheet routes to existing P2P hubs', (tester) async {
    Future<void> expectToolRoute(String id, Type pageType) async {
      await pumpHome(tester);
      await tester.tap(find.byKey(P2PHomePage.toolsKey));
      await tester.pumpAndSettle();

      final tool = find.byKey(P2PHomePage.toolKey(id));
      await tester.ensureVisible(tool);
      await tester.tap(tool);
      await tester.pumpAndSettle();

      expect(find.byType(pageType), findsOneWidget);
    }

    await expectToolRoute('express', P2PExpressPage);
    await expectToolRoute('dashboard', P2PDashboardPage);
    await expectToolRoute('guide', P2PGuidePage);
    await expectToolRoute('compliance_overview', P2PComplianceOverviewPage);
    await expectToolRoute(
      'insurance_contribution_history',
      P2PContributionHistoryPage,
    );
    await expectToolRoute(
      'payment_method_history',
      P2PPaymentMethodHistoryPage,
    );
    await expectToolRoute('security_login_history', P2PLoginHistoryPage);
    await expectToolRoute('notifications', P2PNotificationsSettingsPage);
    await expectToolRoute('fund_lock_history', P2PFundLockHistoryPage);
    await expectToolRoute('wallet_history', P2PFundLockHistoryPage);
    await expectToolRoute('ad_analytics', P2PAdAnalyticsPage);
  });

  testWidgets('SC-282 primary navigation edges are wired', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(P2PHomePage.myOrdersKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PMyOrdersPage), findsOneWidget);

    await pumpHome(tester);
    await tester.tap(find.byKey(P2PHomePage.actionKey('express')));
    await tester.pumpAndSettle();
    expect(find.byType(P2PExpressPage), findsOneWidget);

    await pumpHome(tester);
    await tester.tap(find.byKey(P2PHomePage.createKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PCreateAdPage), findsOneWidget);

    await pumpHome(tester);
    await tester.tap(find.byKey(P2PHomePage.adKey('ad001')));
    await tester.pumpAndSettle();
    expect(find.byType(P2PAdDetailPage), findsOneWidget);
  });

  testWidgets('SC-282 ad context menu links to merchant profile', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(P2PHomePage.adMenuKey('ad001')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xem merchant').last);
    await tester.pumpAndSettle();

    expect(find.byType(P2PMerchantProfilePage), findsOneWidget);
  });
}
