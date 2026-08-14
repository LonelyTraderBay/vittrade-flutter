import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/withdraw_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpWithdraw(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.walletWithdraw,
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

  test('SC-139 mock repository exposes withdraw BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getWithdraw('USDT');

    expect(snapshot.asset, 'USDT');
    expect(snapshot.available, 10200);
    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-withdraw');
    expect(
      snapshot.actionDraft,
      'POST /wallet/withdraw-preview + POST /wallet/withdraw-confirm',
    );
    expect(snapshot.networks.first.name, 'TRC20 (TRON)');
    expect(snapshot.recentAddresses, hasLength(3));
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

  test(
    'SC-140 mock repository exposes asset-scoped withdraw BE draft',
    () async {
      final snapshot = await const MockWalletRepository(
        loadDelay: Duration.zero,
      ).getWithdraw('USDT', assetScoped: true);

      expect(snapshot.asset, 'USDT');
      expect(snapshot.endpoint, '/api/mobile/wallet/wallet-withdraw-usdt');
      expect(
        snapshot.actionDraft,
        'POST /wallet/withdraw-preview + POST /wallet/withdraw-confirm',
      );
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
    },
  );

  testWidgets('SC-139 renders withdraw baseline in Wallet shell', (
    tester,
  ) async {
    await pumpWithdraw(tester);

    expect(find.byType(WithdrawPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Rút USDT'), findsOneWidget);
    expect(find.text('Rút tiền · Wallet'), findsOneWidget);
    expect(find.text('Số dư khả dụng'), findsOneWidget);
    expect(find.text('10,200.00 USDT'), findsOneWidget);
    expect(find.byKey(WithdrawPage.supportKey), findsOneWidget);
    expect(find.text('TRC20 (TRON)'), findsOneWidget);
    expect(find.text('Địa chỉ nhận'), findsOneWidget);
    expect(find.text('Ví lạnh cá nhân'), findsOneWidget);
    expect(find.text('Số lượng'), findsOneWidget);
    expect(find.text('Tiếp tục →'), findsOneWidget);
  });

  testWidgets('SC-139 network picker and amount shortcut work', (tester) async {
    await pumpWithdraw(tester);

    await tester.tap(find.byKey(WithdrawPage.networkSelectorKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WithdrawPage.networkKey('erc20')));
    await tester.pumpAndSettle();
    expect(find.text('ERC20 (Ethereum)'), findsOneWidget);

    await tester.ensureVisible(find.byKey(WithdrawPage.allAmountKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WithdrawPage.allAmountKey));
    await tester.pumpAndSettle();
    expect(find.text('10,200.00'), findsOneWidget);
  });

  testWidgets('SC-139 first viewport reaches withdrawal controls', (
    tester,
  ) async {
    await pumpWithdraw(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-139 WithdrawPage',
      semanticLabel: 'Rút tiền',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WithdrawPage.networkSelectorKey),
      routeName: 'SC-139 WithdrawPage',
      actionLabel: 'network selector',
    );
  });

  testWidgets('SC-139 disabled preview explains missing withdrawal input', (
    tester,
  ) async {
    await pumpWithdraw(tester);

    expect(
      find.text('Enter a complete destination address before preview.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(WithdrawPage.nextKey), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận rút tiền'), findsNothing);
  });

  testWidgets('SC-139 valid withdrawal opens fee and risk preview sheet', (
    tester,
  ) async {
    await pumpWithdraw(tester, viewport: VitFirstViewport.minimumPhone);

    await tester.enterText(
      find.byKey(WithdrawPage.addressFieldKey),
      'TXYZ1234567890abcdef',
    );
    await tester.ensureVisible(find.byKey(WithdrawPage.amountFieldKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(WithdrawPage.amountFieldKey), '100');
    await tester.pumpAndSettle();

    expect(
      find.text('Enter a complete destination address before preview.'),
      findsNothing,
    );

    await tester.ensureVisible(find.byKey(WithdrawPage.nextKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WithdrawPage.nextKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận rút tiền'), findsOneWidget);
    expect(find.text('Phí mạng'), findsOneWidget);
    expect(find.text('Nhận dự kiến'), findsOneWidget);
    expect(find.text('TXYZ12...cdef'), findsOneWidget);
    expect(find.byKey(WithdrawPage.cancelConfirmKey), findsOneWidget);
    expect(find.byKey(WithdrawPage.confirmWithdrawKey), findsOneWidget);
    expect(find.text('Hủy'), findsOneWidget);
    expect(find.text('Xác nhận rút'), findsOneWidget);
  });

  testWidgets('SC-139 support opens contextual withdrawal support', (
    tester,
  ) async {
    await pumpWithdraw(tester);

    await tester.ensureVisible(find.byKey(WithdrawPage.supportKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(WithdrawPage.supportKey));
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('Withdrawal support for USDT'), findsOneWidget);
    expect(find.text('withdraw-usdt'), findsOneWidget);
  });

  testWidgets('SC-140 renders asset-scoped withdraw route in Wallet shell', (
    tester,
  ) async {
    await pumpWithdraw(
      tester,
      initialLocation: AppRoutePaths.walletWithdrawAsset('USDT'),
    );

    expect(find.byType(WithdrawPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Rút USDT'), findsOneWidget);
    expect(find.text('TRC20 (TRON)'), findsOneWidget);
    expect(find.text('10,200.00 USDT'), findsOneWidget);
    expect(find.text('Tiếp tục →'), findsOneWidget);
  });
}
