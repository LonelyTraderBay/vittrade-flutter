import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/presentation/web/pages/auth_web_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/web/pages/home_web_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_web_utility_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_detail_pane.dart';

void main() {
  Future<void> pumpSurfaceRoute(
    WidgetTester tester,
    String location,
    AppSurface surface,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: location,
            surface: surface,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpTabletRoute(WidgetTester tester, String location) {
    return pumpSurfaceRoute(tester, location, AppSurface.tablet);
  }

  Future<void> pumpWebRoute(WidgetTester tester, String location) {
    return pumpSurfaceRoute(tester, location, AppSurface.web);
  }

  testWidgets('SC-294 Tablet uses the independent support composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.support);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Hỗ trợ VitTrade'), findsOneWidget);
  });

  testWidgets('SC-319 Tablet uses the independent rewards composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.rewards);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Trung tâm phần thưởng'), findsOneWidget);
  });

  testWidgets('SC-410 Tablet keeps admin settings behind the internal gate', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.adminSettings);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Cài đặt quản trị'), findsOneWidget);
  });

  testWidgets('SC-027 Tablet uses the independent prediction composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictions);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Prediction Markets'), findsOneWidget);
  });

  testWidgets('SC-044 Tablet uses the independent pair composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.pairDetail('btcusdt'));

    // Terminal master-detail: pair detail giờ là pane phân tích thật trong
    // shell — không còn utility placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(MarketsPairDetailPane), findsOneWidget);
  });

  testWidgets('SC-169 Tablet uses the independent DCA composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.dca);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('DCA'), findsOneWidget);
  });

  testWidgets('SC-060 Tablet keeps trade risk review explicit', (tester) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeRiskManagement);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Rà soát trước khi xác nhận'), findsOneWidget);
  });

  testWidgets('SC-184 Tablet keeps Arena points separate', (tester) async {
    await pumpTabletRoute(tester, AppRoutePaths.arena);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Open Arena'), findsOneWidget);
  });

  testWidgets('SC-295 Tablet uses the independent Launchpad composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.launchpad);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Launchpad'), findsOneWidget);
  });

  testWidgets('SC-329 Tablet uses the independent Savings composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.earnSavings);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Earn Savings'), findsOneWidget);
  });

  testWidgets('SC-327 Tablet uses the independent Staking composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.earn);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Earn Staking'), findsOneWidget);
  });

  testWidgets('SC-059 Tablet uses the independent Trading Bots composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeBots);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Trading Bots'), findsOneWidget);
  });

  testWidgets('SC-063 Tablet uses the independent Copy Trading composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeCopyTrading);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Copy Trading'), findsOneWidget);
  });

  testWidgets('SC-084 Tablet uses the independent compliance composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeCopyRegulatoryDisclosures);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Tuân thủ giao dịch'), findsOneWidget);
  });

  testWidgets('SC-009 Tablet uses the independent market tool composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsOverview);

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Công cụ thị trường'), findsOneWidget);
  });

  testWidgets('Web Wallet uses an independent Web composition', (tester) async {
    await pumpWebRoute(tester, AppRoutePaths.wallet);

    expect(find.byType(VitWebUtilityPage), findsOneWidget);
    expect(find.text('Ví và tài sản'), findsOneWidget);
  });

  testWidgets('Web Trade uses an independent Web composition', (tester) async {
    await pumpWebRoute(tester, AppRoutePaths.trade);

    expect(find.byType(VitWebUtilityPage), findsOneWidget);
    expect(find.text('Thị trường · lệnh · quản trị rủi ro'), findsOneWidget);
  });

  testWidgets('Web Profile uses an independent Web composition', (
    tester,
  ) async {
    await pumpWebRoute(tester, AppRoutePaths.profile);

    expect(find.byType(VitWebUtilityPage), findsOneWidget);
    expect(find.text('Tài khoản'), findsOneWidget);
  });

  testWidgets('Web P2P account uses an independent Web composition', (
    tester,
  ) async {
    await pumpWebRoute(tester, AppRoutePaths.p2pMerchantApply);

    expect(find.byType(VitWebUtilityPage), findsOneWidget);
    expect(find.text('Tài khoản P2P'), findsOneWidget);
  });

  testWidgets('Web P2P security uses an independent Web composition', (
    tester,
  ) async {
    await pumpWebRoute(tester, AppRoutePaths.p2pFraudPrevention);

    expect(find.byType(VitWebUtilityPage), findsOneWidget);
    expect(find.text('Bảo mật và tuân thủ P2P'), findsOneWidget);
  });

  testWidgets('Web Home uses its own dashboard composition', (tester) async {
    await pumpWebRoute(tester, AppRoutePaths.home);

    expect(find.byType(HomeWebPage), findsOneWidget);
    expect(find.text('Tổng quan hôm nay'), findsOneWidget);
  });

  testWidgets('Web Login uses its own authentication composition', (
    tester,
  ) async {
    await pumpWebRoute(tester, AppRoutePaths.authLogin);

    expect(find.byType(AuthWebPage), findsOneWidget);
    expect(find.text('Tài khoản · xác thực an toàn'), findsOneWidget);
  });

  testWidgets('Web News uses an independent Web composition', (tester) async {
    await pumpWebRoute(tester, AppRoutePaths.news);

    expect(find.byType(VitWebUtilityPage), findsOneWidget);
    expect(find.text('Tin tức thị trường'), findsOneWidget);
  });

  testWidgets('Web onboarding uses an independent Web composition', (
    tester,
  ) async {
    await pumpWebRoute(tester, AppRoutePaths.onboarding);

    expect(find.byType(VitWebUtilityPage), findsOneWidget);
    expect(find.text('Bắt đầu với VitTrade'), findsOneWidget);
  });
}
