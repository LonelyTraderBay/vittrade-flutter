import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/pages/address/address_book_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/address_add_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_preview.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAddressAdd(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletAddressBookAdd,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fillRequiredAddressForm(WidgetTester tester) async {
    await tester.tap(find.byKey(AddressAddPage.networkKey('trc20')));
    await tester.tap(find.byKey(AddressAddPage.assetKey('USDT')));
    await tester.enterText(
      find.byKey(AddressAddPage.labelFieldKey),
      'Ví lạnh cá nhân',
    );
    await tester.enterText(
      find.byKey(AddressAddPage.addressFieldKey),
      'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
    );
    await tester.ensureVisible(find.byKey(AddressAddPage.whitelistKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddressAddPage.whitelistKey));
    await tester.ensureVisible(find.byKey(AddressAddPage.agreementKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddressAddPage.agreementKey));
    await tester.pumpAndSettle();
  }

  test('SC-143 mock repository exposes add address BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getAddressAdd();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-address-book-add');
    expect(
      snapshot.actionDraft,
      'POST /wallet/addresses; POST /kyc/submission-step',
    );
    expect(
      snapshot.auditTrailNote,
      'Rủi ro cao: cần xem trước, xác nhận và ghi nhật ký kiểm toán. '
      'Không hoàn tác sau khi lưu. Bước tiếp theo: địa chỉ có thể dùng '
      'để rút tiền theo mạng đã chọn.',
    );
    expect(snapshot.networks, hasLength(6));
    expect(snapshot.networks[1].label, 'ETH (ERC20)');
    expect(snapshot.assets, ['BTC', 'ETH', 'USDT', 'BNB', 'SOL', 'MATIC']);
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

  testWidgets('SC-143 renders address add form in Wallet shell', (
    tester,
  ) async {
    await pumpAddressAdd(tester);

    expect(find.byType(AddressAddPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(find.text('Thêm địa chỉ mới'), findsOneWidget);
    expect(find.text('Sổ địa chỉ · Wallet'), findsOneWidget);
    expect(
      find.textContaining('Tên địa chỉ', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Mạng lưới', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('ETH (ERC20)'), findsOneWidget);
    expect(find.text('Tài sản', findRichText: true), findsOneWidget);
    expect(
      find.textContaining('Địa chỉ ví', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Memo / Tag', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Thêm vào danh sách trắng'), findsOneWidget);
    expect(find.text('Lưu địa chỉ'), findsOneWidget);
    expect(find.byKey(AddressAddPage.saveKey).hitTestable(), findsNothing);
  });

  testWidgets('SC-143 form controls enable safe preview confirmation', (
    tester,
  ) async {
    await pumpAddressAdd(tester);

    await fillRequiredAddressForm(tester);

    expect(find.byKey(AddressAddPage.networkKey('trc20')), findsOneWidget);
    expect(find.byKey(AddressAddPage.assetKey('USDT')), findsOneWidget);
    expect(find.text('Xem trước'), findsOneWidget);

    await tester.ensureVisible(find.byKey(AddressAddPage.saveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddressAddPage.saveKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận lưu địa chỉ'), findsOneWidget);
    expect(find.textContaining('Không hoàn tác sau khi lưu'), findsOneWidget);
    expect(find.text('Xác nhận lưu'), findsOneWidget);
  });

  testWidgets('SC-143 first viewport reaches required address setup', (
    tester,
  ) async {
    await pumpAddressAdd(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-143 AddressAddPage',
      semanticLabel: 'Thêm địa chỉ mới vào sổ địa chỉ ví',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(AddressAddPage.networkKey('erc20')),
      routeName: 'SC-143 AddressAddPage',
      actionLabel: 'the default network selector',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(AddressAddPage.assetKey('ETH')),
      routeName: 'SC-143 AddressAddPage',
      actionLabel: 'the default asset selector',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(AddressAddPage.labelFieldKey),
      targetLabel: 'the address label field',
    );
  });

  testWidgets('SC-143 confirmation saves then returns to address book', (
    tester,
  ) async {
    await pumpAddressAdd(tester);
    await fillRequiredAddressForm(tester);

    await tester.ensureVisible(find.byKey(AddressAddPage.saveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddressAddPage.saveKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận lưu địa chỉ'), findsOneWidget);
    expect(find.text('TQnKxxx4d8eRh9Kf...Np7Yz123'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(AddressConfirmPreviewSheet.confirmButtonKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AddressConfirmPreviewSheet.confirmButtonKey));
    await tester.pump();
    expect(find.byType(AddressSavedState), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();
    expect(find.byType(AddressBookPage), findsOneWidget);
  });
}
