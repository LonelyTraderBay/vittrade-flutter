import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transaction_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transaction_history_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_history_shell.dart';

void main() {
  Future<void> pumpRoute(
    WidgetTester tester,
    String path, {
    Size size = const Size(1280, 800),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(routerConfig: createTabletAppRouter(initialLocation: path)),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('hub lịch sử: shell render master list + pane empty state', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletHistory);

    expect(find.byType(WalletTabletHistoryShell), findsOneWidget);
    expect(find.byKey(WalletTabletHistoryShell.masterListKey), findsOneWidget);
    // Rule 6: pane chưa chọn gì phải là empty state thật, không được trống.
    expect(find.text('Chọn một giao dịch'), findsOneWidget);
    expect(find.byKey(TransactionHistoryTabletPage.contentKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chọn dòng giao dịch: pane render chi tiết, dòng tô đậm', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletHistory);

    final firstRow = find
        .byKey(TransactionHistoryTabletPage.transactionKey('tx001'))
        .first;
    await tester.tap(firstRow);
    await tester.pumpAndSettle();

    // Vẫn nằm trong shell; pane chi tiết render thay empty state.
    expect(find.byType(WalletTabletHistoryShell), findsOneWidget);
    expect(find.byType(TransactionDetailTabletPage), findsOneWidget);
    expect(find.text('Chọn một giao dịch'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('deep-link thẳng vào chi tiết vẫn nằm trong shell', (tester) async {
    await pumpRoute(tester, AppRoutePaths.walletTransaction('tx001'));

    expect(find.byType(WalletTabletHistoryShell), findsOneWidget);
    expect(find.byType(TransactionDetailTabletPage), findsOneWidget);
    // Dòng tương ứng trong master được tô đậm theo route.
    expect(
      find.byKey(TransactionHistoryTabletPage.transactionKey('tx001')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('dưới 680px: hub render danh sách toàn chiều rộng', (tester) async {
    await pumpRoute(
      tester,
      AppRoutePaths.walletHistory,
      size: const Size(640, 900),
    );

    expect(find.byType(WalletTabletHistoryShell), findsOneWidget);
    expect(find.byKey(WalletTabletHistoryShell.masterListKey), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
