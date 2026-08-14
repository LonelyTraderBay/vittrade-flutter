import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/deposit_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDeposit(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.walletDeposit,
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-137 mock repository exposes wallet deposit BE draft', () async {
    const repository = MockWalletRepository(loadDelay: Duration.zero);
    final snapshot = await repository.getDeposit('USDT');
    final scopedSnapshot = await repository.getDeposit(
      'USDT',
      assetScoped: true,
    );

    expect(snapshot.asset, 'USDT');
    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-deposit');
    expect(scopedSnapshot.endpoint, '/api/mobile/wallet/wallet-deposit-usdt');
    expect(snapshot.actionDraft, 'POST /wallet/deposit-intent');
    expect(snapshot.networks, hasLength(3));
    expect(snapshot.networks.first.name, 'TRC20 (TRON)');
    expect(snapshot.networks.first.minDeposit, 1);
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ]),
    );
  });

  testWidgets('SC-137 renders deposit baseline in Wallet shell', (
    tester,
  ) async {
    await pumpDeposit(tester);

    expect(find.byType(DepositPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Nạp USDT'), findsOneWidget);
    expect(find.text('Nạp tiền · Wallet'), findsOneWidget);
    expect(find.text('Mạng nạp'), findsOneWidget);
    expect(find.text('TRC20 (TRON)'), findsOneWidget);
    expect(find.text('Quan trọng — Đọc trước khi nạp'), findsOneWidget);
    expect(find.text('Sao chép địa chỉ'), findsOneWidget);
    expect(find.text('Thông tin nạp tiền'), findsOneWidget);
    expect(find.text('Làm mới địa chỉ nạp'), findsOneWidget);
  });

  testWidgets('SC-137 first viewport reaches copy address action', (
    tester,
  ) async {
    await pumpDeposit(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'DepositPage',
      semanticLabel: 'Nạp tiền',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DepositPage.copyAddressKey),
      routeName: 'DepositPage',
      actionLabel: 'the deposit copy address action',
    );
  });

  testWidgets('SC-137 network picker switches selected deposit network', (
    tester,
  ) async {
    await pumpDeposit(tester);

    await tester.tap(find.byKey(DepositPage.networkSelectorKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DepositPage.networkKey('erc20')));
    await tester.pumpAndSettle();

    expect(find.text('ERC20 (Ethereum)'), findsOneWidget);
    expect(find.text('Phí: Miễn phí · Nạp tối thiểu: 10 USDT'), findsOneWidget);
  });

  testWidgets('SC-137 asset route variant uses the route asset parameter', (
    tester,
  ) async {
    await pumpDeposit(
      tester,
      initialLocation: AppRoutePaths.walletDepositAsset('ETH'),
    );

    expect(find.text('Nạp ETH'), findsOneWidget);
    expect(find.text('ERC20 (Ethereum)'), findsOneWidget);
    expect(
      find.text('Phí: Miễn phí · Nạp tối thiểu: 0.01 ETH'),
      findsOneWidget,
    );
  });
}
