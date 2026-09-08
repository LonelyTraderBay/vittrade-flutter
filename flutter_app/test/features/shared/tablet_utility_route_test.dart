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
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_overview_pane.dart';
import 'package:vit_trade_flutter/features/rewards/presentation/tablet/pages/rewards_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_detail_pane.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/risk_management_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/tablet/pages/regulatory_disclosures_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/tablet/pages/copy_trading_tablet_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/tablet/pages/dca_tablet_pages.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/tablet/pages/earn_savings_tablet_pages.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/tablet/pages/staking_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/tablet/pages/trade_bots_tablet_pages.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/tablet/pages/launchpad_tablet_pages.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';
import 'package:vit_trade_flutter/features/cross_module/presentation/tablet/pages/cross_module_tablet_pages.dart';

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

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(SupportHubTabletPage), findsOneWidget);
  });

  testWidgets('SC-319 Tablet renders the real rewards hub page', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.rewards);

    // SC-319 đã port trang thật (GĐ1.3) — KHÔNG còn placeholder.
    expect(find.byType(RewardsTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.text('Điểm hiện có'), findsOneWidget);
  });

  testWidgets('SC-410 Tablet keeps admin settings behind the internal gate', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.adminSettings);

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(AdminSettingsTabletPage), findsOneWidget);
  });

  testWidgets('SC-027 Tablet uses the independent prediction composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsPredictions);

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(PredictionsHomeTabletPage), findsOneWidget);
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

    // SC-169 đã port composition thật (GĐ3 DCA) — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(DcaOverviewTabletPage), findsOneWidget);
  });

  testWidgets('SC-060 Tablet renders the real risk-management composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeRiskManagement);

    // SC-060 đã port composition thật (GĐ1.1) — KHÔNG còn placeholder.
    expect(find.byType(RiskManagementTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.text('Xem lại công cụ rủi ro'), findsOneWidget);
  });

  testWidgets('SC-184 Tablet keeps Arena points separate', (tester) async {
    await pumpTabletRoute(tester, AppRoutePaths.arena);

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(ArenaHomeTabletPage), findsOneWidget);
  });

  testWidgets('SC-295 Tablet uses the independent Launchpad composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.launchpad);

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(LaunchpadHomeTabletPage), findsOneWidget);
  });

  testWidgets('SC-329 Tablet uses the independent Savings composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.earnSavings);

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(SavingsHubTabletPage), findsOneWidget);
  });

  testWidgets('SC-327 Tablet uses the independent Staking composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.earn);

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(StakingEarnTabletPage), findsOneWidget);
  });

  testWidgets('SC-059 Tablet uses the independent Trading Bots composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeBots);

    // Đã port composition thật — KHÔNG còn placeholder.
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.byType(TradingBotsTabletPage), findsOneWidget);
  });

  testWidgets('SC-063 Tablet renders the real Copy Trading hub', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeCopyTrading);

    expect(find.byType(CopyTradingTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
  });

  testWidgets('SC-084 Tablet renders the real compliance hub', (tester) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeCopyRegulatoryDisclosures);

    expect(find.byType(RegulatoryDisclosuresTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
  });

  testWidgets('SC-009 Tablet renders the real market overview pane', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.marketsOverview);

    // SC-009 đã port pane thật (GĐ1.2) — KHÔNG còn placeholder.
    expect(find.byType(MarketsOverviewPane), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(find.text('Vốn hóa toàn thị trường'), findsOneWidget);
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
