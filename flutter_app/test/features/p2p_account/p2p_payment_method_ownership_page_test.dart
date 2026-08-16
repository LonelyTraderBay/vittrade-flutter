import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_ownership_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PPaymentMethodOwnership(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pPaymentMethodOwnership('sample'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-234 mock repository exposes ownership BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getPaymentMethodOwnership('sample');

    expect(
      snapshot.endpoint,
      '/api/mobile/p2p/p2p-payment-method-ownership-sample',
    );
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
    );
    expect(snapshot.documents, hasLength(3));
    expect(snapshot.documents.first.id, 'bank_card');
    expect(snapshot.documents.last.optional, isTrue);
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
  });

  testWidgets('SC-234 renders proof of ownership baseline', (tester) async {
    await pumpP2PPaymentMethodOwnership(tester);

    expect(find.byType(P2PPaymentMethodOwnershipPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xác minh sở hữu'), findsOneWidget);
    expect(find.text('Thanh toán · P2P'), findsOneWidget);
    expect(find.text('Chứng minh tài khoản'), findsOneWidget);
    expect(find.text('Tài liệu cần thiết'), findsOneWidget);
    expect(find.text('Ảnh thẻ ATM'), findsOneWidget);
    expect(find.text('Selfie với thẻ'), findsOneWidget);
    expect(find.text('Sao kê ngân hàng (tùy chọn)'), findsOneWidget);
    expect(find.text('Tùy chọn'), findsOneWidget);
    expect(find.text('Tải lên'), findsNWidgets(3));
    expect(find.text('Gửi xác minh'), findsOneWidget);
  });

  testWidgets('SC-234 upload state enables submit and routes to list', (
    tester,
  ) async {
    await pumpP2PPaymentMethodOwnership(tester);

    await tester.tap(
      find.byKey(P2PPaymentMethodOwnershipPage.uploadKey('bank_card')),
    );
    await tester.tap(
      find.byKey(P2PPaymentMethodOwnershipPage.uploadKey('selfie_card')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đã tải lên'), findsNWidgets(2));
    await tester.tap(find.byKey(P2PPaymentMethodOwnershipPage.submitButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Gửi xác minh sở hữu?'), findsOneWidget);
    await tester.tap(
      find.byKey(P2PPaymentMethodOwnershipPage.confirmSubmitKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đã gửi xác minh sở hữu'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức thanh toán'), findsOneWidget);
  });

  testWidgets('SC-234 uploaded document can be removed', (tester) async {
    await pumpP2PPaymentMethodOwnership(tester);

    await tester.tap(
      find.byKey(P2PPaymentMethodOwnershipPage.uploadKey('bank_card')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Đã tải lên'), findsOneWidget);

    await tester.tap(
      find.byKey(P2PPaymentMethodOwnershipPage.removeKey('bank_card')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đã tải lên'), findsNothing);
    expect(
      find.byKey(P2PPaymentMethodOwnershipPage.uploadKey('bank_card')),
      findsOneWidget,
    );
  });

  testWidgets('SC-234 header back returns to payment methods list', (
    tester,
  ) async {
    await pumpP2PPaymentMethodOwnership(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức thanh toán'), findsOneWidget);
  });
}
