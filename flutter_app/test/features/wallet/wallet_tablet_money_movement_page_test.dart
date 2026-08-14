import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/deposit_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/withdraw_tablet_page.dart';

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

  testWidgets('Tablet Wallet chọn Deposit composition riêng', (tester) async {
    await pumpRoute(tester, AppRoutePaths.walletDeposit);
    expect(find.byType(DepositTabletPage), findsOneWidget);
    expect(find.byType(WithdrawTabletPage), findsNothing);
  });

  testWidgets('Tablet Wallet chọn Deposit asset composition riêng', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletDepositAsset('ETH'));
    expect(find.byType(DepositTabletPage), findsOneWidget);
  });

  testWidgets('Tablet Wallet chọn Withdraw composition riêng', (tester) async {
    await pumpRoute(tester, AppRoutePaths.walletWithdraw);
    expect(find.byType(WithdrawTabletPage), findsOneWidget);
    expect(find.byType(DepositTabletPage), findsNothing);
  });

  testWidgets('Tablet Wallet chọn Withdraw asset composition riêng', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletWithdrawAsset('ETH'));
    expect(find.byType(WithdrawTabletPage), findsOneWidget);
  });
}
