// Batch test tablet sinh từ route group p2p_orders (coverage 2026-09-10:
// group + các trang tablet liên quan chưa phủ). Bất biến: mọi route tablet
// render trang thật — không rơi vào VitTabletUtilityPage, không exception.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('p2p_orders tablet routes render trang thật (lô 1)', (
    tester,
  ) async {
    final locations = <String>[
      AppRoutePaths.p2pEscrowBalance,
      AppRoutePaths.p2pWallet,
      AppRoutePaths.p2pWalletTransfer,
      AppRoutePaths.p2pWalletFundLockHistory,
      AppRoutePaths.p2pWalletHistory,
      AppRoutePaths.p2pMyOrders,
    ];
    for (final location in locations) {
      await pumpTablet(tester, location);

      expect(find.byType(VitTabletUtilityPage), findsNothing, reason: location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}
