import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_add_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

void main() {
  Future<void> pumpP2PPaymentMethodAdd(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pPaymentMethodAdd,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
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

  test(
    'SC-232 mock repository exposes P2P payment-method add BE draft',
    () async {
      final snapshot = await const MockP2PRepository(
        loadDelay: Duration.zero,
      ).getPaymentMethodAdd();

      expect(snapshot.endpoint, '/api/mobile/p2p/p2p-payment-method-add');
      expect(
        snapshot.actionDraft,
        'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
      );
      expect(snapshot.bankOptions, containsAll(['Vietcombank', 'TPBank']));
      expect(snapshot.ewalletOptions, containsAll(['Momo', 'ShopeePay']));
      expect(snapshot.defaultBankAccountHint, '0071000123456');
      expect(snapshot.ownerNameHint, 'NGUYEN VAN A');
      expect(snapshot.saveRoute, AppRoutePaths.p2pPaymentMethods);
      expect(snapshot.contractNotes, contains('Hành động rủi ro cao'));
      expect(
        snapshot.supportedStates,
        containsAll([
          P2PScreenState.loading,
          P2PScreenState.empty,
          P2PScreenState.error,
          P2PScreenState.offline,
        ]),
      );
    },
  );

  testWidgets('SC-232 renders bank payment-method baseline form', (
    tester,
  ) async {
    await pumpP2PPaymentMethodAdd(tester);

    expect(find.byType(P2PPaymentMethodAddPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thêm ngân hàng'), findsOneWidget);
    expect(find.text('Thanh toán · P2P'), findsOneWidget);
    expect(find.text('Ngân hàng'), findsOneWidget);
    expect(find.text('Ví điện tử'), findsOneWidget);
    expect(find.text('Chọn ngân hàng'), findsOneWidget);
    expect(find.text('Vietcombank'), findsOneWidget);
    expect(find.text('Techcombank'), findsOneWidget);
    expect(find.text('TPBank'), findsOneWidget);
    expect(find.text('Số tài khoản'), findsOneWidget);
    expect(find.text('Tên chủ tài khoản'), findsOneWidget);
    expect(find.text('Thêm phương thức'), findsOneWidget);
    expect(find.byType(VitStickyFooter), findsNothing);
  });

  testWidgets('SC-232 supports e-wallet query state', (tester) async {
    await pumpP2PPaymentMethodAdd(
      tester,
      initialLocation: '${AppRoutePaths.p2pPaymentMethodAdd}?type=ewallet',
    );

    expect(find.text('Thêm ví điện tử'), findsOneWidget);
    expect(find.text('Chọn ví điện tử'), findsOneWidget);
    expect(find.text('Momo'), findsOneWidget);
    expect(find.text('ZaloPay'), findsOneWidget);
    expect(find.text('ShopeePay'), findsOneWidget);
    expect(find.text('Số điện thoại / tài khoản ví'), findsOneWidget);
  });

  testWidgets('SC-232 validates, previews, confirms, and navigates to list', (
    tester,
  ) async {
    await pumpP2PPaymentMethodAdd(tester);

    await tester.tap(
      find.byKey(P2PPaymentMethodAddPage.optionKey('Vietcombank')),
    );
    await tester.enterText(
      find.byKey(P2PPaymentMethodAddPage.accountFieldKey),
      '0071000123456',
    );
    await tester.enterText(
      find.byKey(P2PPaymentMethodAddPage.ownerFieldKey),
      'NGUYEN VAN A',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(P2PPaymentMethodAddPage.previewKey), findsOneWidget);
    expect(find.text('Tài khoản'), findsOneWidget);
    expect(find.text('Chủ tài khoản'), findsOneWidget);
    expect(find.text('007...3456'), findsOneWidget);
    expect(find.textContaining('Xem xét quyền sở hữu'), findsOneWidget);
    expect(find.textContaining('Giới hạn:'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(P2PPaymentMethodAddPage.saveButtonKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PPaymentMethodAddPage.saveButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận thêm phương thức?'), findsOneWidget);
    expect(find.text('Vietcombank'), findsNWidgets(3));
    expect(find.text('007...3456'), findsNWidgets(2));

    await tester.tap(find.byKey(P2PPaymentMethodAddPage.confirmSaveKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã thêm phương thức thanh toán'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức thanh toán'), findsOneWidget);
  });

  testWidgets('SC-232 header back returns to payment methods list', (
    tester,
  ) async {
    await pumpP2PPaymentMethodAdd(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức thanh toán'), findsOneWidget);
  });
}
