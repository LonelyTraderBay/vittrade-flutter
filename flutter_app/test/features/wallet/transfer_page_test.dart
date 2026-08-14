import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transfer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTransfer(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletTransfer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-146 mock repository exposes transfer BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getTransfer();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-transfer');
    expect(
      snapshot.actionDraft,
      'POST /wallet/transfer-preview + POST /wallet/transfer-confirm',
    );
    expect(snapshot.wallets.map((wallet) => wallet.id), [
      'spot',
      'funding',
      'futures',
    ]);
    expect(snapshot.assets.first.symbol, 'USDT');
    expect(snapshot.assets.first.available, 10200);
    expect(snapshot.recentTransfers, hasLength(3));
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

  testWidgets('SC-146 renders transfer baseline in Wallet shell', (
    tester,
  ) async {
    await pumpTransfer(tester);

    expect(find.byType(TransferPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Chuy\u1ec3n n\u1ed9i b\u1ed9'), findsOneWidget);
    expect(find.text('Chuy\u1ec3n ti\u1ec1n \u00b7 Wallet'), findsOneWidget);
    expect(find.text('V\u00ed Spot'), findsOneWidget);
    expect(find.text('\$54,276.79'), findsOneWidget);
    expect(find.text('V\u00ed Funding'), findsOneWidget);
    expect(find.text('\$8,450.20'), findsOneWidget);
    expect(find.text('USDT'), findsWidgets);
    expect(
      find.textContaining('10,200.00 USDT kh\u1ea3 d\u1ee5ng'),
      findsOneWidget,
    );
    expect(find.text('0.00'), findsOneWidget);
    expect(find.byKey(TransferPage.maxKey), findsOneWidget);
    expect(find.text('X\u00e1c nh\u1eadn chuy\u1ec3n'), findsOneWidget);
    expect(
      find.text('L\u1ecbch s\u1eed g\u1ea7n \u0111\u00e2y'),
      findsOneWidget,
    );
    expect(find.textContaining('Spot \u2192 Funding'), findsOneWidget);
  });

  testWidgets('SC-146 first viewport reaches transfer amount field', (
    tester,
  ) async {
    await pumpTransfer(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'TransferPage',
      semanticLabel: 'Chuyển nội bộ',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(TransferPage.amountFieldKey),
      routeName: 'TransferPage',
      actionLabel: 'the transfer amount field',
      minVisibleHeight: 20,
    );
  });

  testWidgets('SC-146 disabled transfer explains invalid amount', (
    tester,
  ) async {
    await pumpTransfer(tester, viewport: VitFirstViewport.minimumPhone);

    expect(
      find.text(
        'Nh\u1eadp s\u1ed1 l\u01b0\u1ee3ng tr\u01b0\u1edbc khi xem l\u1ea1i chuy\u1ec3n n\u1ed9i b\u1ed9.',
      ),
      findsWidgets,
    );

    await tester.ensureVisible(find.byKey(TransferPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TransferPage.submitKey), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(
      find.text('X\u00e1c nh\u1eadn chuy\u1ec3n n\u1ed9i b\u1ed9'),
      findsNothing,
    );
  });

  testWidgets('SC-146 transfer controls support preview confirmation', (
    tester,
  ) async {
    await pumpTransfer(tester);

    await tester.tap(find.byKey(TransferPage.swapKey));
    await tester.pumpAndSettle();
    expect(find.text('V\u00ed Funding'), findsWidgets);
    expect(find.text('\$8,450.20'), findsWidgets);

    await tester.ensureVisible(find.byKey(TransferPage.maxKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TransferPage.maxKey));
    await tester.pumpAndSettle();
    expect(find.text('10,200.00'), findsOneWidget);

    await tester.ensureVisible(find.byKey(TransferPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TransferPage.submitKey));
    await tester.pumpAndSettle();
    expect(
      find.text('X\u00e1c nh\u1eadn chuy\u1ec3n n\u1ed9i b\u1ed9'),
      findsOneWidget,
    );
    expect(find.text('Mi\u1ec5n ph\u00ed'), findsOneWidget);
    expect(
      find.textContaining(
        'Bước tiếp theo: hệ thống ghi nhận lệnh chuyển nội bộ',
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(TransferPage.confirmKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(TransferPage.confirmKey));
    await tester.pumpAndSettle();
    // showVitNoticeSheet replaces the former inline TransferSuccessBanner.
    expect(find.text('Chuy\u1ec3n th\u00e0nh c\u00f4ng'), findsOneWidget);
  });
}
