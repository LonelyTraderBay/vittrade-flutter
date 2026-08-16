import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/wallet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpWallet(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.wallet),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpProductionFailClosedWallet(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig(
              environment: AppEnvironment.production,
              apiBaseUrl: Uri.parse('https://api.vittrade.example'),
              enableMockData: false,
            ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.wallet),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-135 mock repository exposes wallet BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getWallet();

    expect(snapshot.totalUsd, 57664);
    expect(snapshot.totalBtc, 0.85373496);
    expect(snapshot.actions.map((item) => item.id), [
      'deposit',
      'withdraw',
      'buy',
      'transfer',
      'pending',
      'limits',
      'dust',
      'network',
      'gas',
      'multi',
      'approval',
    ]);
    expect(snapshot.tools.map((item) => item.id), [
      'history',
      'addressBook',
      'healthScore',
    ]);
    expect(snapshot.assets, hasLength(13));
    expect(snapshot.assets.first.symbol, 'USDT');
    expect(snapshot.dca.activePlans, 3);
    expect(snapshot.endpoint, '/api/mobile/wallet/wallet');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
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

  testWidgets('SC-135 renders wallet baseline in Wallet shell', (tester) async {
    await pumpWallet(tester);

    expect(find.byType(WalletPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Số dư minh bạch · bảo mật đa lớp'), findsOneWidget);
    expect(
      find.text('Một số thao tác ví đang ở chế độ xem trước'),
      findsOneWidget,
    );
    expect(find.text('\$57,664.00'), findsOneWidget);
    expect(find.text('Nạp'), findsOneWidget);
    expect(find.text('Mua định kỳ (DCA)'), findsOneWidget);
    expect(find.text('Tài sản'), findsOneWidget);
    expect(find.text('Công cụ ví'), findsOneWidget);
    expect(find.byKey(WalletPage.actionKey('history')), findsOneWidget);
    expect(find.byKey(WalletPage.actionKey('addressBook')), findsOneWidget);
    expect(find.byKey(WalletPage.actionKey('healthScore')), findsOneWidget);
    expect(find.text('Biến động 24h'), findsOneWidget);
    expect(find.text('Danh sách'), findsOneWidget);
    expect(find.text('Tìm tài sản...'), findsOneWidget);
    expect(find.text('13 tài sản'), findsOneWidget);
    expect(find.text('USDT'), findsOneWidget);
    expect(find.byKey(WalletPage.actionKey('deposit')), findsOneWidget);
    expect(find.byKey(WalletPage.actionKey('withdraw')), findsOneWidget);
    expect(find.byKey(WalletPage.moreActionsKey), findsOneWidget);
  });

  testWidgets('SC-135 first viewport exposes balance and primary actions', (
    tester,
  ) async {
    await pumpWallet(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-135',
      semanticLabel: 'Ví - số dư minh bạch, bảo mật đa lớp',
    );
    expectFirstViewportVisible(
      tester,
      find.text('\$57,664.00'),
      targetLabel: 'wallet balance',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WalletPage.actionKey('deposit')),
      routeName: 'SC-135',
      actionLabel: 'deposit action',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(WalletPage.actionKey('withdraw')),
      routeName: 'SC-135',
      actionLabel: 'withdraw action',
    );
  });

  testWidgets('SC-135 production wallet without backend fails closed in UI', (
    tester,
  ) async {
    await pumpProductionFailClosedWallet(tester);

    expect(find.byType(WalletPage), findsOneWidget);
    expect(
      find.textContaining('Wallet service is unavailable'),
      findsOneWidget,
    );
    expect(find.text('\$0.00'), findsWidgets);
    expect(find.textContaining('0 t'), findsOneWidget);
  });

  testWidgets('SC-135 balance toggle, search, and filter update asset view', (
    tester,
  ) async {
    await pumpWallet(tester);

    await tester.tap(find.byKey(WalletPage.balanceToggleKey));
    await tester.pumpAndSettle();
    expect(find.text('••••••'), findsOneWidget);

    await tester.enterText(find.byKey(WalletPage.searchKey), 'btc');
    await tester.pumpAndSettle();
    expect(find.text('1 tài sản'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);

    await tester.enterText(find.byKey(WalletPage.searchKey), '');
    await tester.tap(find.byKey(WalletPage.filterKey));
    await tester.pumpAndSettle();
    expect(find.text('12 tài sản'), findsOneWidget);
  });

  testWidgets('SC-135 chart tab and wallet child placeholder navigation work', (
    tester,
  ) async {
    await pumpWallet(tester);

    await tester.tap(find.byKey(WalletPage.tabKey('chart')));
    await tester.pumpAndSettle();
    expect(find.text('Phân bổ'), findsWidgets);
    expect(find.text('BTC'), findsWidgets);

    await tester.ensureVisible(find.byKey(WalletPage.actionKey('history')));
    await tester.tap(find.byKey(WalletPage.actionKey('history')));
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử giao dịch'), findsOneWidget);
  });

  testWidgets('SC-135 wallet actions keep their routes after redesign', (
    tester,
  ) async {
    final directCases = [
      (WalletPage.actionKey('deposit'), 'Nạp USDT'),
      (WalletPage.actionKey('withdraw'), 'Rút USDT'),
      (WalletPage.actionKey('history'), 'Lịch sử giao dịch'),
      (WalletPage.actionKey('addressBook'), 'Sổ địa chỉ'),
      (WalletPage.actionKey('healthScore'), 'Wallet Health'),
    ];
    final overflowCases = [
      (WalletPage.actionKey('buy'), 'Mua Crypto'),
      (WalletPage.actionKey('transfer'), 'Chuyển nội bộ'),
      (WalletPage.actionKey('pending'), 'Nạp tiền đang chờ'),
    ];

    for (final testCase in directCases) {
      await pumpWallet(tester);
      await tester.ensureVisible(find.byKey(testCase.$1));
      await tester.tap(find.byKey(testCase.$1));
      await tester.pumpAndSettle();
      expect(find.text(testCase.$2), findsOneWidget);
    }

    for (final testCase in overflowCases) {
      await pumpWallet(tester);
      await tester.ensureVisible(find.byKey(WalletPage.moreActionsKey));
      await tester.tap(find.byKey(WalletPage.moreActionsKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(testCase.$1));
      await tester.pumpAndSettle();
      expect(find.text(testCase.$2), findsOneWidget);
    }
  });
}
