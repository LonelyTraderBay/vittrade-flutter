import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/tools/wallet_multi_manager_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpMultiManager(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletMultiManager,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-148 mock repository exposes multi-manager BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getMultiManager();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-multi-manager');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.wallets.length, 4);
    expect(snapshot.groups.length, 2);
    expect(snapshot.totalBalance, 267680);
    expect(snapshot.totalChangeUsd, closeTo(3453.96, .01));
    expect(snapshot.totalChangePct, closeTo(1.29, .01));
    expect(snapshot.wallets.first.name, 'Main Wallet');
    expect(snapshot.wallets.first.maskedAddress, '0x742d...0bEb');
    expect(snapshot.groups.first.name, 'Active Trading');
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-148 renders multi-wallet manager baseline shell', (
    tester,
  ) async {
    await pumpMultiManager(tester);

    expect(find.byType(WalletMultiManagerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Quản lý đa ví'), findsOneWidget);
    expect(
      find.text('Địa chỉ ẩn mặc định · kiểm soát sao chép'),
      findsOneWidget,
    );
    expect(find.text('T\u1EA5t c\u1EA3'), findsOneWidget);
    expect(find.text('Nh\u00F3m'), findsWidgets);
    expect(find.text('Ho\u1EA1t \u0111\u1ED9ng'), findsOneWidget);
    expect(find.text('Tổng giá trị danh mục'), findsOneWidget);
    expect(find.text('\$267,680'), findsOneWidget);
    expect(find.text('+1.29%'), findsOneWidget);
    expect(find.text('+\$3,454'), findsOneWidget);
    expect(find.text('Portfolio Distribution'), findsOneWidget);
    expect(find.text('T\u1EA5t c\u1EA3 v\u00ED'), findsOneWidget);
    expect(find.text('Main Wallet'), findsOneWidget);
    expect(find.text('Trading Wallet'), findsOneWidget);
    expect(find.text('Cold Storage'), findsOneWidget);
    expect(find.text('Hardware Ledger'), findsOneWidget);
    expect(find.text('Thêm ví'), findsOneWidget);
    expect(
      find.text('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb'),
      findsNothing,
    );
    expect(find.textContaining('Địa chỉ được ẩn mặc định'), findsOneWidget);
  });

  testWidgets('SC-148 first viewport reaches wallet controls', (tester) async {
    await pumpMultiManager(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'WalletMultiManagerPage',
      semanticLabel: 'Quản lý đa ví - kiểm soát địa chỉ và sao chép',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WalletMultiManagerPage.tabKey('T\u1EA5t c\u1EA3')),
      routeName: 'WalletMultiManagerPage',
      actionLabel: 'the manager tabs',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WalletMultiManagerPage.walletKey('w1')),
      routeName: 'WalletMultiManagerPage',
      actionLabel: 'the first wallet row',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WalletMultiManagerPage.revealKey('w1')),
      routeName: 'WalletMultiManagerPage',
      actionLabel: 'the reveal wallet address control',
    );
  });

  testWidgets('SC-148 reveal and tabs are local interactions', (tester) async {
    await pumpMultiManager(tester);

    expect(find.text('0x742d...0bEb'), findsOneWidget);
    expect(find.byTooltip('Hiện địa chỉ Main Wallet'), findsOneWidget);
    expect(find.byTooltip('Sao chép địa chỉ Main Wallet'), findsOneWidget);

    await tester.tap(find.byKey(WalletMultiManagerPage.copyKey('w1')));
    await tester.pumpAndSettle();
    expect(
      find.text('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb'),
      findsNothing,
    );

    await tester.tap(find.byKey(WalletMultiManagerPage.revealKey('w1')));
    await tester.pumpAndSettle();
    expect(
      find.text('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb'),
      findsOneWidget,
    );
    expect(find.byTooltip('Ẩn địa chỉ Main Wallet'), findsOneWidget);

    await tester.tap(find.byKey(WalletMultiManagerPage.tabKey('Nh\u00F3m')));
    await tester.pumpAndSettle();
    expect(find.text('Wallet Groups'), findsOneWidget);
    expect(find.text('Active Trading'), findsOneWidget);
    expect(find.text('\$74,180'), findsOneWidget);

    await tester.tap(
      find.byKey(WalletMultiManagerPage.tabKey('Ho\u1EA1t \u0111\u1ED9ng')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Recent Activity'), findsOneWidget);
    expect(find.text('22:32'), findsOneWidget);
  });

  testWidgets('SC-148 add wallet action shows deferred state', (tester) async {
    await pumpMultiManager(tester);

    await tester.tap(find.byKey(WalletMultiManagerPage.addWalletKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(WalletMultiManagerPage.addWalletNoticeKey),
      findsOneWidget,
    );
    expect(find.text('Chưa kết nối tạo ví mới.'), findsOneWidget);
  });
}
