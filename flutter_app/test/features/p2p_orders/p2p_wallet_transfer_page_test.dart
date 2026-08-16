import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/wallet/p2p_wallet_transfer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PWalletTransfer(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pWalletTransfer,
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-261 mock repository exposes P2P wallet transfer BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getWalletTransfer();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-wallet-transfer');
    expect(
      snapshot.actionDraft,
      'POST /wallet/transfer-preview + POST /wallet/transfer-confirm; POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.defaultAsset, 'USDT');
    expect(snapshot.defaultType, 'deposit');
    expect(snapshot.assets.map((item) => item.symbol), ['USDT', 'BTC', 'VND']);
    expect(snapshot.balances, hasLength(6));
    expect(snapshot.sourceBalance('deposit', 'USDT').available, 45200);
    expect(snapshot.destinationBalance('deposit', 'USDT').available, 12450.50);
    expect(snapshot.parentRoute, AppRoutePaths.p2pWallet);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-261 renders P2P wallet transfer baseline', (tester) async {
    await pumpP2PWalletTransfer(tester);

    expect(find.byType(P2PWalletTransferPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chuyển tiền'), findsOneWidget);
    expect(find.text('Ví · P2P'), findsOneWidget);
    expect(find.byKey(P2PWalletTransferPage.directionKey), findsOneWidget);
    expect(find.text('Main Wallet'), findsOneWidget);
    expect(find.text('P2P Wallet'), findsOneWidget);
    expect(find.text('Khả dụng: 45,200.00 USDT'), findsOneWidget);
    expect(find.text('Số dư: 12,450.50 USDT'), findsOneWidget);
    expect(find.byKey(P2PWalletTransferPage.assetSelectorKey), findsOneWidget);
    expect(find.text('Chọn tài sản'), findsOneWidget);
    expect(find.text('USDT'), findsWidgets);
    expect(find.text('BTC'), findsOneWidget);
    expect(find.text('VND'), findsOneWidget);
    expect(find.text('Số tiền'), findsOneWidget);
    expect(find.text('MAX'), findsOneWidget);
    expect(find.text('25%'), findsOneWidget);
    expect(find.text('Miễn phí & Tức thì'), findsOneWidget);
    expect(find.byKey(P2PWalletTransferPage.escrowNoteKey), findsOneWidget);
  });

  testWidgets('SC-320 uses full-width transfer flow at 360x800', (
    tester,
  ) async {
    await pumpP2PWalletTransfer(tester, viewport: const Size(360, 800));

    expect(find.byType(P2PWalletTransferPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(P2PWalletTransferPage.directionKey), findsOneWidget);
    expect(find.byKey(P2PWalletTransferPage.assetSelectorKey), findsOneWidget);
    expect(find.byKey(P2PWalletTransferPage.amountFieldKey), findsOneWidget);

    final scrollFinder = find.descendant(
      of: find.byType(P2PWalletTransferPage),
      matching: find.byType(SingleChildScrollView),
    );
    expect(scrollFinder, findsOneWidget);

    final scrollRect = tester.getRect(scrollFinder);
    expect(scrollRect.left, closeTo(0, 0.5));
    expect(scrollRect.right, closeTo(360, 0.5));
    expect(scrollRect.height, greaterThan(560));

    await tester.ensureVisible(find.byKey(P2PWalletTransferPage.maxKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PWalletTransferPage.maxKey));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(P2PWalletTransferPage.submitKey));
    await tester.pumpAndSettle();

    final submitRect = tester.getRect(
      find.byKey(P2PWalletTransferPage.submitKey),
    );
    expect(submitRect.bottom, lessThanOrEqualTo(800));

    await tester.tap(find.byKey(P2PWalletTransferPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byKey(P2PWalletTransferPage.confirmPanelKey), findsOneWidget);
    await tester.ensureVisible(find.byKey(P2PWalletTransferPage.confirmKey));
    await tester.pumpAndSettle();

    final confirmRect = tester.getRect(
      find.byKey(P2PWalletTransferPage.confirmKey),
    );
    expect(confirmRect.bottom, lessThanOrEqualTo(800));
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-261 supports max amount and confirm navigation', (
    tester,
  ) async {
    await pumpP2PWalletTransfer(tester);

    await tester.tap(find.byKey(P2PWalletTransferPage.maxKey));
    await tester.pumpAndSettle();

    expect(find.text('45200.00'), findsOneWidget);

    await tester.tap(find.byKey(P2PWalletTransferPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byKey(P2PWalletTransferPage.confirmPanelKey), findsOneWidget);
    expect(find.text('Kiểm tra thông tin'), findsOneWidget);
    expect(find.text('45,200.00 USDT'), findsOneWidget);
    expect(find.text('Miễn phí'), findsOneWidget);

    await tester.tap(find.byKey(P2PWalletTransferPage.confirmKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PWalletTransferPage), findsNothing);
    expect(find.text('P2P Wallet'), findsOneWidget);
  });

  testWidgets('SC-261 query params preselect asset and withdraw direction', (
    tester,
  ) async {
    await pumpP2PWalletTransfer(
      tester,
      initialLocation:
          '${AppRoutePaths.p2pWalletTransfer}?asset=BTC&type=withdraw',
    );

    expect(find.byType(P2PWalletTransferPage), findsOneWidget);
    expect(find.text('Số dư: 0.05240000 BTC'), findsOneWidget);
    expect(find.text('Khả dụng: 0.12340000 BTC'), findsOneWidget);

    await tester.tap(find.byKey(P2PWalletTransferPage.switchKey));
    await tester.pumpAndSettle();

    expect(find.text('Khả dụng: 0.12340000 BTC'), findsOneWidget);
  });

  testWidgets('SC-261 invalid query params fall back to safe defaults', (
    tester,
  ) async {
    await pumpP2PWalletTransfer(
      tester,
      initialLocation:
          '${AppRoutePaths.p2pWalletTransfer}?asset=DOGE&type=unknown&direction=sideways',
    );

    expect(find.byType(P2PWalletTransferPage), findsOneWidget);
    expect(
      find.byKey(P2PWalletTransferPage.activeAssetKey('USDT')),
      findsOneWidget,
    );
    expect(find.text('DOGE'), findsNothing);
  });

  testWidgets('SC-261 quick percentage fills the amount field', (tester) async {
    await pumpP2PWalletTransfer(tester);

    await tester.tap(find.byKey(P2PWalletTransferPage.percentKey(50)));
    await tester.pumpAndSettle();

    expect(find.text('22600.00'), findsOneWidget);
  });
}
