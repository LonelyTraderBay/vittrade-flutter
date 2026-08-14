import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/forgot_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/login_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void _setPhoneViewport(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(440, 956);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _app({ShellRenderMode shellRenderMode = ShellRenderMode.native}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        const MockAuthRepository(delay: Duration.zero),
      ),
    ],
    child: VitTradeApp(
      shellRenderMode: shellRenderMode,
      routerConfig: createAppRouter(
        initialLocation: AppRoutePaths.authForgotPassword,
        shellRenderMode: shellRenderMode,
      ),
    ),
  );
}

Future<void> _openOtpStep(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(ForgotPasswordPage.emailFieldKey),
    'user@vittrade.vn',
  );
  await tester.pump();
  await tester.tap(find.byKey(ForgotPasswordPage.submitKey));
  await tester.pumpAndSettle();
}

Future<void> _openResetStep(WidgetTester tester) async {
  await _openOtpStep(tester);
  await tester.enterText(find.byKey(ForgotPasswordPage.otpFieldKey), '123456');
  await tester.pump();
  await tester.tap(find.byKey(ForgotPasswordPage.submitKey));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('/auth/forgot-password renders as a standalone auth route', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('Quên mật khẩu'), findsOneWidget);
    expect(find.text('Đặt lại mật khẩu'), findsOneWidget);
  });

  testWidgets('/auth/forgot-password visual QA shell keeps fake status only', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app(shellRenderMode: ShellRenderMode.visualQa));
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsOneWidget);
    expect(find.byType(VitStatusBar), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-005 keeps send OTP disabled until email is entered', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    var button = tester.widget<VitCtaButton>(
      find.byKey(ForgotPasswordPage.submitKey),
    );
    expect(button.onPressed, isNull);

    await tester.enterText(
      find.byKey(ForgotPasswordPage.emailFieldKey),
      'bad-email',
    );
    await tester.pump();

    button = tester.widget<VitCtaButton>(
      find.byKey(ForgotPasswordPage.submitKey),
    );
    expect(button.onPressed, isNotNull);

    await tester.tap(find.byKey(ForgotPasswordPage.submitKey));
    await tester.pump();

    expect(find.text('Email không hợp lệ.'), findsOneWidget);
  });

  testWidgets('SC-005 send OTP advances to OTP step', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openOtpStep(tester);

    expect(find.text('Nhập mã OTP'), findsOneWidget);
    expect(find.textContaining('user@vittrade.vn'), findsOneWidget);
  });

  testWidgets('SC-005 keeps OTP confirm disabled until six digits', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openOtpStep(tester);

    var button = tester.widget<VitCtaButton>(
      find.byKey(ForgotPasswordPage.submitKey),
    );
    expect(button.onPressed, isNull);

    await tester.enterText(find.byKey(ForgotPasswordPage.otpFieldKey), '12345');
    await tester.pump();

    button = tester.widget<VitCtaButton>(
      find.byKey(ForgotPasswordPage.submitKey),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('SC-005 verified OTP advances to password reset step', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openResetStep(tester);

    expect(find.text('Mật khẩu mới'), findsWidgets);
    expect(find.byKey(ForgotPasswordPage.newPasswordFieldKey), findsOneWidget);
  });

  testWidgets('SC-005 toggles password visibility and validates mismatch', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openResetStep(tester);

    var field = tester.widget<TextField>(
      find.byKey(ForgotPasswordPage.newPasswordFieldKey),
    );
    expect(field.obscureText, isTrue);

    await tester.tap(find.byKey(ForgotPasswordPage.passwordToggleKey));
    await tester.pump();

    field = tester.widget<TextField>(
      find.byKey(ForgotPasswordPage.newPasswordFieldKey),
    );
    expect(field.obscureText, isFalse);

    await tester.enterText(
      find.byKey(ForgotPasswordPage.newPasswordFieldKey),
      'Password1!',
    );
    await tester.enterText(
      find.byKey(ForgotPasswordPage.confirmPasswordFieldKey),
      'Password2!',
    );
    await tester.pump();

    expect(find.text('Mật khẩu không khớp'), findsOneWidget);
  });

  testWidgets('SC-005 reset success returns to login', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    await _openResetStep(tester);

    await tester.enterText(
      find.byKey(ForgotPasswordPage.newPasswordFieldKey),
      'Password1!',
    );
    await tester.enterText(
      find.byKey(ForgotPasswordPage.confirmPasswordFieldKey),
      'Password1!',
    );
    await tester.pump();
    await tester.tap(find.byKey(ForgotPasswordPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.text('Thành công!'), findsOneWidget);

    await tester.tap(find.byKey(ForgotPasswordPage.loginKey));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
  });
}
