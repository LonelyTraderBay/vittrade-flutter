// Batch test tablet các trang luồng Wallet (coverage 2026-09-10:
// transfer 78, buy-crypto 74, pending-deposits 52 dòng chưa phủ).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/buy_crypto_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/pending_deposits_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transfer_tablet_page.dart';
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

  testWidgets('trang chuyển khoản tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.walletTransfer);

    expect(find.byType(TransferTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang mua crypto tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.walletBuyCrypto);

    expect(find.byType(BuyCryptoTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang khoản chờ xử lý tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.walletPendingDeposits);

    expect(find.byType(PendingDepositsTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
