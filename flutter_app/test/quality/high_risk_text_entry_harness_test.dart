// Origin: 9048cda4 (2026-05-31) - feat(flutter): hoàn thiện nền tảng enterprise VitTrade
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_add_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/address_add_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_sections.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String initialLocation) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-143 Address Add enterText harness reaches saved state', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.walletAddressBookAdd);

    await tester.tap(AddressAddPage.networkKey('trc20').finder);
    await tester.tap(AddressAddPage.assetKey('USDT').finder);
    await tester.enterText(
      AddressAddPage.labelFieldKey.finder,
      'Cold wallet QA',
    );
    await tester.enterText(
      AddressAddPage.addressFieldKey.finder,
      'TQnKxxx4d8eRh9Kf2Lz5mNp7Yz123',
    );
    await tester.ensureVisible(AddressAddPage.agreementKey.finder);
    await tester.tap(AddressAddPage.agreementKey.finder);
    await tester.pumpAndSettle();

    expect(AddressAddPage.saveKey.finder, findsOneWidget);
    await tester.ensureVisible(AddressAddPage.saveKey.finder);
    await tester.pumpAndSettle();
    await tester.tap(AddressAddPage.saveKey.finder);
    await tester.pumpAndSettle();

    expect(AddressConfirmPreviewSheet.confirmButtonKey.finder, findsOneWidget);
    expect(find.textContaining('Rủi ro cao: cần xem trước'), findsOneWidget);

    await tester.ensureVisible(
      AddressConfirmPreviewSheet.confirmButtonKey.finder,
    );
    await tester.pumpAndSettle();
    await tester.tap(AddressConfirmPreviewSheet.confirmButtonKey.finder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(AddressSavedState), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('SC-232 P2P Payment Add enterText harness confirms save', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.p2pPaymentMethodAdd);

    await tester.tap(P2PPaymentMethodAddPage.optionKey('Vietcombank').finder);
    await tester.enterText(
      P2PPaymentMethodAddPage.accountFieldKey.finder,
      '0071000123456',
    );
    await tester.enterText(
      P2PPaymentMethodAddPage.ownerFieldKey.finder,
      'NGUYEN VAN A',
    );
    await tester.pumpAndSettle();

    expect(P2PPaymentMethodAddPage.previewKey.finder, findsOneWidget);
    expect(find.textContaining('Xem xét quyền sở hữu'), findsOneWidget);
    expect(find.textContaining('Giới hạn:'), findsOneWidget);

    await tester.ensureVisible(P2PPaymentMethodAddPage.saveButtonKey.finder);
    await tester.pumpAndSettle();
    await tester.tap(P2PPaymentMethodAddPage.saveButtonKey.finder);
    await tester.pumpAndSettle();

    expect(P2PPaymentMethodAddPage.confirmSaveKey.finder, findsOneWidget);
    await tester.tap(P2PPaymentMethodAddPage.confirmSaveKey.finder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(P2PPaymentMethodAddPage.contentKey.finder, findsNothing);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
