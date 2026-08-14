import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/address_add_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/address/address_book_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/hub/wallet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<GoRouter> pumpAddressBook(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    final router = createAppRouter(
      initialLocation: AppRoutePaths.walletAddressBook,
    );
    await tester.pumpWidget(
      ProviderScope(child: VitTradeApp(routerConfig: router)),
    );
    await tester.pumpAndSettle();
    return router;
  }

  test('SC-144 mock repository exposes address book BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getAddressBook();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-address-book');
    expect(snapshot.actionDraft, 'POST /kyc/submission-step');
    expect(snapshot.addresses, hasLength(5));
    expect(snapshot.addresses.first.label, 'Ví lạnh cá nhân');
    expect(snapshot.networkFilters, containsAll(['Tất cả', 'BTC', 'TRC20']));
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

  testWidgets('SC-144 renders address book baseline in Wallet shell', (
    tester,
  ) async {
    await pumpAddressBook(tester);

    expect(find.byType(AddressBookPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Sổ địa chỉ'), findsOneWidget);
    expect(find.text('Quản lý · Wallet'), findsOneWidget);
    expect(find.text('Chế độ danh sách trắng'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Ví lạnh cá nhân'), findsOneWidget);
    expect(find.text('Binance Exchange'), findsOneWidget);
    expect(
      find.text('bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh'),
      findsNothing,
    );
    expect(find.text('bc1qxy...0wlh'), findsOneWidget);
    expect(find.byKey(AddressBookPage.copyKey('addr1')), findsOneWidget);
  });

  testWidgets('SC-144 first viewport reaches first address copy action', (
    tester,
  ) async {
    await pumpAddressBook(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'AddressBookPage',
      semanticLabel: 'Sổ địa chỉ - quản lý địa chỉ ví đã lưu',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(AddressBookPage.copyKey('addr1')),
      routeName: 'AddressBookPage',
      actionLabel: 'the first saved address copy action',
    );
  });

  testWidgets('SC-144 filters and add navigation are wired', (tester) async {
    await pumpAddressBook(tester);

    await tester.tap(find.byKey(AddressBookPage.filterKey('BTC')));
    await tester.pumpAndSettle();
    expect(find.text('Ví lạnh cá nhân'), findsOneWidget);
    expect(find.text('Binance Exchange'), findsNothing);

    await tester.tap(find.byKey(AddressBookPage.addKey));
    await tester.pumpAndSettle();
    expect(find.byType(AddressAddPage), findsOneWidget);
  });

  testWidgets('SC-144 delete confirmation removes a masked saved address', (
    tester,
  ) async {
    await pumpAddressBook(tester);

    await tester.ensureVisible(find.byKey(AddressBookPage.deleteKey('addr1')));
    await tester.tap(find.byKey(AddressBookPage.deleteKey('addr1')));
    await tester.pumpAndSettle();

    expect(find.text('Xóa địa chỉ'), findsOneWidget);
    expect(
      find.text(
        'Bạn có chắc muốn xóa địa chỉ "Ví lạnh cá nhân" (bc1qxy...0wlh)?',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Xóa'));
    await tester.pumpAndSettle();

    expect(find.text('Đã xóa địa chỉ'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.text('Ví lạnh cá nhân'), findsNothing);
  });

  testWidgets(
    'SC-144 round-trip: deleting a saved address survives navigating away '
    'and back (state lives in the Notifier)',
    (tester) async {
      final router = await pumpAddressBook(tester);

      await tester.ensureVisible(
        find.byKey(AddressBookPage.deleteKey('addr1')),
      );
      await tester.tap(find.byKey(AddressBookPage.deleteKey('addr1')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xóa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();

      expect(find.text('Ví lạnh cá nhân'), findsNothing);

      router.go(AppRoutePaths.wallet);
      await tester.pumpAndSettle();
      expect(find.byType(WalletPage), findsOneWidget);

      router.go(AppRoutePaths.walletAddressBook);
      await tester.pumpAndSettle();

      expect(find.text('Ví lạnh cá nhân'), findsNothing);
    },
  );
}
