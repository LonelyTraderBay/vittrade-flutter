import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_gas_optimizer_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_health_score_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_multi_manager_tablet_page.dart';

void main() {
  Future<void> pumpTabletRoute(
    WidgetTester tester,
    String location,
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
            surface: AppSurface.tablet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-148 tablet route uses independent composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletMultiManager);

    expect(find.byType(WalletMultiManagerTabletPage), findsOneWidget);
    expect(find.text('Quản lý đa ví'), findsOneWidget);
    expect(find.byKey(WalletMultiManagerTabletPage.addWalletKey), findsOneWidget);

    await tester.tap(find.byKey(WalletMultiManagerTabletPage.addWalletKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(WalletMultiManagerTabletPage.addWalletNoticeKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-149 tablet route uses independent composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletGasOptimizer);

    expect(find.byType(WalletGasOptimizerTabletPage), findsOneWidget);
    expect(find.text('Tối ưu phí gas'), findsOneWidget);
    expect(find.byKey(WalletGasOptimizerTabletPage.refreshKey), findsOneWidget);

    await tester.tap(find.byKey(WalletGasOptimizerTabletPage.refreshKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(WalletGasOptimizerTabletPage.feedbackKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-151 tablet route uses independent composition', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.walletHealthScore);

    expect(find.byType(WalletHealthScoreTabletPage), findsOneWidget);
    expect(find.text('Điểm sức khỏe ví'), findsOneWidget);
    expect(
      find.byKey(WalletHealthScoreTabletPage.recommendationKey('r1')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(WalletHealthScoreTabletPage.recommendationKey('r1')),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(WalletHealthScoreTabletPage.sheetCloseKey), findsOneWidget);
    await tester.tap(find.byKey(WalletHealthScoreTabletPage.sheetCloseKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(WalletHealthScoreTabletPage.sheetCloseKey),
      findsNothing,
    );
  });
}
