import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

void main() {
  Future<void> pumpTabletRoute(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: location,
            surface: AppSurface.tablet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
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

    expect(find.byType(VitTabletUtilityPage), findsOneWidget);
    expect(find.text('Chi tiết thị trường'), findsOneWidget);
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
}
