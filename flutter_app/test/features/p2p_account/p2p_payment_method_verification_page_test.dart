import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_verification_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PPaymentMethodVerification(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pPaymentMethodVerification(
              'sample',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-233 mock repository exposes payment verification BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getPaymentMethodVerification('sample');

    expect(
      snapshot.endpoint,
      '/api/mobile/p2p/p2p-payment-method-verification-sample',
    );
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
    );
    expect(snapshot.methods, hasLength(3));
    expect(snapshot.methods.first.id, 'micro_deposit');
    expect(snapshot.methods.first.recommended, isTrue);
    expect(snapshot.microDepositSteps, hasLength(4));
    expect(snapshot.saveRoute, AppRoutePaths.p2pPaymentMethods);
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

  testWidgets('SC-233 renders verification method chooser baseline', (
    tester,
  ) async {
    await pumpP2PPaymentMethodVerification(tester);

    expect(find.byType(P2PPaymentMethodVerificationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xác minh phương thức'), findsOneWidget);
    expect(find.text('Thanh toán · P2P'), findsOneWidget);
    expect(find.text('Xác minh sở hữu'), findsOneWidget);
    expect(find.text('Chọn phương thức xác minh'), findsOneWidget);
    expect(find.text('Micro-deposit'), findsOneWidget);
    expect(find.text('Đề xuất'), findsOneWidget);
    expect(find.text('Upload ảnh'), findsOneWidget);
    expect(find.text('Bank statement'), findsOneWidget);
  });

  testWidgets('SC-233 micro-deposit flow submits and navigates to list', (
    tester,
  ) async {
    await pumpP2PPaymentMethodVerification(tester);

    await tester.tap(
      find.byKey(P2PPaymentMethodVerificationPage.methodKey('micro_deposit')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Xác minh micro-deposit'), findsOneWidget);
    expect(find.text('Xác minh qua Micro-deposit'), findsOneWidget);
    expect(find.text('Số tiền nhận được (VND)'), findsOneWidget);
    expect(find.text('Xác nhận số tiền'), findsOneWidget);

    await tester.enterText(
      find.byKey(P2PPaymentMethodVerificationPage.codeFieldKey),
      '2',
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(P2PPaymentMethodVerificationPage.submitButtonKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gửi yêu cầu xác minh?'), findsOneWidget);
    await tester.tap(
      find.byKey(P2PPaymentMethodVerificationPage.confirmSubmitKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Đã xác minh phương thức'), findsOneWidget);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức thanh toán'), findsOneWidget);
  });

  testWidgets('SC-233 selected flow back returns to chooser', (tester) async {
    await pumpP2PPaymentMethodVerification(tester);

    await tester.tap(
      find.byKey(P2PPaymentMethodVerificationPage.methodKey('micro_deposit')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Xác minh phương thức'), findsOneWidget);
    expect(find.text('Chọn phương thức xác minh'), findsOneWidget);
  });

  testWidgets('SC-233 header back returns to payment methods list', (
    tester,
  ) async {
    await pumpP2PPaymentMethodVerification(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức thanh toán'), findsOneWidget);
  });
}
