import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/assets/asset_detail_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transaction_detail_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/transfer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAssetDetail(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletAsset('btc'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-147 mock repository exposes asset detail BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getAssetDetail('btc');

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-asset-btc');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.symbol, 'BTC');
    expect(snapshot.name, 'Bitcoin');
    expect(snapshot.usdValue, 15842.10);
    expect(snapshot.available, 0.214510);
    expect(snapshot.actions.map((action) => action.id), [
      'deposit',
      'withdraw',
      'transfer',
      'dca',
    ]);
    expect(snapshot.chart.length, greaterThan(20));
    expect(snapshot.transactions.first.route, '/wallet/transaction/tx001');
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

  testWidgets('SC-147 renders BTC asset detail baseline in Wallet shell', (
    tester,
  ) async {
    await pumpAssetDetail(tester);

    expect(find.byType(AssetDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('BTC'), findsWidgets);
    expect(find.text('Chi tiết tài sản · số dư minh bạch'), findsOneWidget);
    expect(find.text('Bitcoin'), findsOneWidget);
    expect(find.text('\$15,842.10'), findsOneWidget);
    expect(find.text('0.234510 BTC'), findsOneWidget);
    expect(find.text('+2.34%'), findsOneWidget);
    expect(find.text('Khả dụng'), findsOneWidget);
    expect(find.text('0.214510'), findsOneWidget);
    expect(find.text('Nạp'), findsOneWidget);
    expect(find.text('Rút'), findsOneWidget);
    expect(find.text('Chuyển'), findsOneWidget);
    expect(find.text('DCA'), findsOneWidget);
    expect(find.text('Biểu đồ giá'), findsOneWidget);
    expect(find.text('Lịch sử giao dịch'), findsOneWidget);
    expect(find.text('+0.100000 BTC'), findsOneWidget);
  });

  testWidgets(
    'SC-147 first viewport reaches asset actions and period controls',
    (tester) async {
      await pumpAssetDetail(tester, viewport: VitFirstViewport.minimumPhone);

      expectRouteSemanticInFirstViewport(
        tester,
        routeName: 'AssetDetailPage',
        semanticLabel: 'Chi tiết tài sản - số dư minh bạch',
      );
      expectActionableInFirstViewport(
        tester,
        find.byKey(AssetDetailPage.actionKey('deposit')),
        routeName: 'AssetDetailPage',
        actionLabel: 'the deposit asset action',
      );
      expectActionableInFirstViewport(
        tester,
        find.byKey(AssetDetailPage.periodKey('1M')),
        routeName: 'AssetDetailPage',
        actionLabel: 'the active chart period control',
      );
    },
  );

  testWidgets('SC-147 period, action, and transaction navigation work', (
    tester,
  ) async {
    await pumpAssetDetail(tester);

    await tester.tap(find.byKey(AssetDetailPage.periodKey('3M')));
    await tester.pumpAndSettle();
    expect(find.byKey(AssetDetailPage.periodKey('3M')), findsOneWidget);

    await tester.tap(find.byKey(AssetDetailPage.actionKey('transfer')));
    await tester.pumpAndSettle();
    expect(find.byType(TransferPage), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletAsset('btc'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AssetDetailPage.transactionKey('tx001')));
    await tester.pumpAndSettle();
    expect(find.byType(TransactionDetailPage), findsOneWidget);
  });
}
