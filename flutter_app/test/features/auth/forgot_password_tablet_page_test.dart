// ForgotPasswordTabletPage (coverage 2026-09-10: 86 dòng chưa phủ) —
// pump route tablet thật, request reset với email hợp lệ và không hợp lệ.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/forgot_password_tablet_page.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: AppRoutePaths.authForgotPassword,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('render form quên mật khẩu tablet', (tester) async {
    await pumpTablet(tester);

    expect(find.byType(ForgotPasswordTabletPage), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('submit email hợp lệ không crash và còn ở trang', (tester) async {
    await pumpTablet(tester);

    await tester.enterText(find.byType(TextField).first, 'user@vittrade.vn');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(ForgotPasswordTabletPage), findsOneWidget);
  });

  // Coverage đợt 2: toàn luồng 4 bước + các nhánh validate.
  testWidgets('luồng đầy đủ: email -> OTP -> mật khẩu -> thành công', (
    tester,
  ) async {
    await pumpTablet(tester);

    // Bước 1: email trống -> lỗi; điền đúng -> sang bước OTP.
    await tester.tap(find.byKey(ForgotPasswordTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập email đã đăng ký.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'user@vittrade.vn');
    await tester.tap(find.byKey(ForgotPasswordTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Xác minh email'), findsOneWidget);

    // Bước 2: OTP ngắn -> lỗi; mã đúng 123456 -> sang bước mật khẩu.
    await tester.enterText(find.byType(TextField).first, '12');
    await tester.tap(find.byKey(ForgotPasswordTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng nhập đủ 6 chữ số xác minh.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '123456');
    await tester.tap(find.byKey(ForgotPasswordTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Đặt mật khẩu mới'), findsOneWidget);

    // Bước 3: mật khẩu yếu -> lỗi; không khớp -> lỗi; hợp lệ -> thành công.
    final fields = find.byType(TextField);
    await tester.enterText(fields.first, 'abc');
    await tester.tap(find.byKey(ForgotPasswordTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Mật khẩu cần đủ'), findsOneWidget);

    await tester.enterText(fields.first, 'Abcdef12');
    await tester.enterText(fields.last, 'Abcdef34');
    await tester.tap(find.byKey(ForgotPasswordTabletPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Mật khẩu xác nhận chưa khớp.'), findsOneWidget);

    await tester.enterText(fields.last, 'Abcdef12');
    await tester.tap(find.byKey(ForgotPasswordTabletPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã cập nhật mật khẩu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
