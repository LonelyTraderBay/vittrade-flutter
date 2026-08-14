import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/address_add_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transfer_tablet_page.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String path) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(820, 1180);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(routerConfig: createTabletAppRouter(initialLocation: path)),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets('Tablet Wallet chọn Transfer composition riêng', (tester) async {
    await pumpRoute(tester, AppRoutePaths.walletTransfer);
    expect(find.byType(TransferTabletPage), findsOneWidget);
    expect(find.byType(AddressAddTabletPage), findsNothing);
  });

  testWidgets('Tablet Wallet chọn Address Add composition riêng', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletAddressBookAdd);
    expect(find.byType(AddressAddTabletPage), findsOneWidget);
    expect(find.byType(TransferTabletPage), findsNothing);
  });
}
