import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/login_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/otp_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/register_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void _setPhoneViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(440, 956);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _app({
  String initialLocation = AppRoutePaths.authRegister,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        const MockAuthRepository(delay: Duration.zero),
      ),
    ],
    child: VitTradeApp(
      shellRenderMode: shellRenderMode,
      routerConfig: createAppRouter(
        initialLocation: initialLocation,
        shellRenderMode: shellRenderMode,
      ),
    ),
  );
}

void main() {
  testWidgets('/auth/register renders as a standalone auth route', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('Tạo tài khoản'), findsOneWidget);
    expect(find.text('Xác thực · Đăng ký'), findsOneWidget);
  });

  testWidgets('/auth/register visual QA shell keeps fake status only', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app(shellRenderMode: ShellRenderMode.visualQa));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.byType(VitStatusBar), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-002 validates required registration fields', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(RegisterPage.submitKey));
    await tester.tap(find.byKey(RegisterPage.submitKey));
    await tester.pump();

    expect(find.text('Vui lòng nhập họ tên'), findsOneWidget);
    expect(find.text('Vui lòng nhập email'), findsOneWidget);
    expect(find.text('Mật khẩu tối thiểu 8 ký tự'), findsOneWidget);
    expect(find.text('Vui lòng đồng ý điều khoản dịch vụ'), findsOneWidget);
  });

  testWidgets('SC-002 switches to phone registration mode', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(RegisterPage.phoneTabKey));
    await tester.pump();

    expect(find.text('Số điện thoại'), findsOneWidget);

    final contactField = tester.widget<TextField>(
      find.byKey(RegisterPage.contactFieldKey),
    );
    expect(contactField.keyboardType, TextInputType.phone);
  });

  testWidgets('SC-002 toggles password visibility for both password fields', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    var passwordField = tester.widget<TextField>(
      find.byKey(RegisterPage.passwordFieldKey),
    );
    var confirmField = tester.widget<TextField>(
      find.byKey(RegisterPage.confirmFieldKey),
    );
    expect(passwordField.obscureText, isTrue);
    expect(confirmField.obscureText, isTrue);

    await tester.tap(find.byKey(RegisterPage.passwordToggleKey));
    await tester.pump();

    passwordField = tester.widget<TextField>(
      find.byKey(RegisterPage.passwordFieldKey),
    );
    confirmField = tester.widget<TextField>(
      find.byKey(RegisterPage.confirmFieldKey),
    );
    expect(passwordField.obscureText, isFalse);
    expect(confirmField.obscureText, isFalse);
  });

  testWidgets('SC-002 successful register navigates to OTP route', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.enterText(RegisterPage.nameFieldKey.finder, 'Nguyễn Văn A');
    await tester.enterText(
      RegisterPage.contactFieldKey.finder,
      'user@vittrade.vn',
    );
    await tester.enterText(RegisterPage.passwordFieldKey.finder, 'Password1!');
    await tester.enterText(RegisterPage.confirmFieldKey.finder, 'Password1!');
    await tester.ensureVisible(find.byKey(RegisterPage.agreementKey));
    await tester.tap(find.byKey(RegisterPage.agreementKey));
    await tester.ensureVisible(find.byKey(RegisterPage.submitKey));
    await tester.tap(find.byKey(RegisterPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(OTPPage), findsOneWidget);
    expect(find.textContaining('user@vittrade.vn'), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-002 existing-account link returns to login', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(RegisterPage.loginKey));
    await tester.tap(find.byKey(RegisterPage.loginKey));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
