import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_add_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_methods_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PPaymentMethods(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pPaymentMethods,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-237 mock repository exposes payment methods BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getPaymentMethods();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-payment-methods');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
    );
    expect(snapshot.methods, hasLength(4));
    expect(
      snapshot.methods.where(
        (item) => item.type == P2PPaymentListMethodType.bank,
      ),
      hasLength(2),
    );
    expect(snapshot.methods.first.name, 'Vietcombank');
    expect(snapshot.methods.first.isDefault, isTrue);
    expect(snapshot.addBankRoute, '/p2p/payment-method/add?type=bank');
    expect(snapshot.addEwalletRoute, '/p2p/payment-method/add?type=ewallet');
    expect(snapshot.contractNotes, contains('High-risk action'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-237 renders payment methods baseline', (tester) async {
    await pumpP2PPaymentMethods(tester);

    expect(find.byType(P2PPaymentMethodsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phương thức thanh toán'), findsOneWidget);
    expect(find.text('Thanh toán · P2P'), findsOneWidget);
    expect(find.text('Thêm ngân hàng'), findsOneWidget);
    expect(find.text('Thêm ví điện tử'), findsOneWidget);
    expect(find.text('Tài khoản ngân hàng (2)'), findsOneWidget);
    expect(find.text('Ví điện tử (2)'), findsOneWidget);
    expect(find.text('Vietcombank'), findsOneWidget);
    expect(find.text('Techcombank'), findsOneWidget);
    expect(find.text('Momo'), findsOneWidget);
    expect(find.text('ZaloPay'), findsOneWidget);
    expect(find.text('Mặc định'), findsOneWidget);
    expect(
      find.text('Chưa xác minh — Cần xác minh để sử dụng trên P2P'),
      findsOneWidget,
    );
    expect(find.textContaining('VitTrade không lưu trữ'), findsOneWidget);
  });

  testWidgets('SC-237 first viewport reaches saved payment methods', (
    tester,
  ) async {
    await pumpP2PPaymentMethods(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-237 P2PPaymentMethodsPage',
      semanticLabel: 'Phương thức thanh toán',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(P2PPaymentMethodsPage.methodKey('vietcombank-primary')),
      targetLabel: 'first saved bank method',
      minVisibleHeight: 80,
    );
    expect(
      tester
          .getSize(
            find.byKey(P2PPaymentMethodsPage.methodKey('vietcombank-primary')),
          )
          .height,
      lessThanOrEqualTo(112),
      reason: 'Default payment method card should not dominate the viewport.',
    );
  });

  testWidgets('SC-237 add buttons route to bank and e-wallet add flows', (
    tester,
  ) async {
    await pumpP2PPaymentMethods(tester);

    await tester.tap(find.byKey(P2PPaymentMethodsPage.addBankKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PPaymentMethodAddPage), findsOneWidget);
    expect(find.text('Thêm ngân hàng'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pPaymentMethods,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(P2PPaymentMethodsPage.addEwalletKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PPaymentMethodAddPage), findsOneWidget);
    expect(find.text('Thêm ví điện tử'), findsOneWidget);
  });

  testWidgets('SC-237 set default and delete confirmation update local state', (
    tester,
  ) async {
    await pumpP2PPaymentMethods(tester);

    await tester.tap(
      find.byKey(P2PPaymentMethodsPage.defaultKey('techcombank-backup')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(P2PPaymentMethodsPage.defaultKey('techcombank-backup')),
      findsNothing,
    );

    await tester.tap(
      find.byKey(P2PPaymentMethodsPage.deleteKey('zalopay-wallet')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(P2PPaymentMethodsPage.deleteConfirmKey), findsOneWidget);
    expect(find.text('Xóa phương thức thanh toán?'), findsOneWidget);
    expect(find.text('ZaloPay'), findsNWidgets(2));

    await tester.tap(find.text('Xóa'));
    await tester.pumpAndSettle();

    expect(find.text('Đã xóa phương thức'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.text('ZaloPay'), findsNothing);
  });
}
