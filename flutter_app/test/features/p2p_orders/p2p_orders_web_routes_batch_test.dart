// Batch test WEB sinh từ root route
// group p2p_orders (coverage đợt 2 nhóm b: builders của root groups là trang
// composition phone, chỉ router web (createLegacyAppRouter) tiêu thụ).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';

void main() {
  Future<void> pumpWeb(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.web,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('p2p_orders web routes render (lô 1)', (tester) async {
    final locations = <String>[
      AppRoutePaths.p2pEscrowBalance,
      AppRoutePaths.p2pWallet,
      AppRoutePaths.p2pWalletTransfer,
      AppRoutePaths.p2pWalletFundLockHistory,
      AppRoutePaths.p2pWalletHistory,
      AppRoutePaths.p2pMyOrders,
    ];
    for (final location in locations) {
      await pumpWeb(tester, location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}
