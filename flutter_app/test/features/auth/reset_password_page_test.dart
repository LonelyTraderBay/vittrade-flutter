import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/presentation/controllers/password_reset_flow_controller.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/login_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/reset_password_page.dart';
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

Widget _app({
  String initialLocation = AppRoutePaths.authResetPassword,
  ShellRenderMode shellRenderMode = ShellRenderMode.native,
  bool seedChallenge = true,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        const MockAuthRepository(delay: Duration.zero),
      ),
      if (seedChallenge)
        passwordResetChallengeProvider.overrideWithBuild(
          (_, _) => _defaultChallenge(),
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

PasswordResetChallenge _defaultChallenge() {
  return PasswordResetChallenge(
    email: 'user@vittrade.vn',
    otp: '123456',
    verifiedAt: DateTime(2026, 5, 26),
  );
}

void main() {
  testWidgets('/auth/reset-password renders as a standalone auth route', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('Đặt lại mật khẩu'), findsOneWidget);
    expect(find.text('Tạo mật khẩu mới'), findsOneWidget);
  });

  testWidgets('/auth/reset-password without challenge expires safely', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app(seedChallenge: false));
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(ResetPasswordPage.expiredKey), findsOneWidget);
    expect(find.byKey(ResetPasswordPage.retryKey), findsOneWidget);
    expect(find.byKey(ResetPasswordPage.newPasswordFieldKey), findsNothing);
  });

  testWidgets('/auth/reset-password ignores email and otp query params', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(
      _app(
        initialLocation:
            '${AppRoutePaths.authResetPassword}?email=attacker@example.com&otp=123456',
        seedChallenge: false,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordPage), findsOneWidget);
    expect(find.byKey(ResetPasswordPage.expiredKey), findsOneWidget);
    expect(find.byKey(ResetPasswordPage.newPasswordFieldKey), findsNothing);
  });

  testWidgets('/auth/reset-password visual QA shell keeps fake status only', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app(shellRenderMode: ShellRenderMode.visualQa));
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordPage), findsOneWidget);
    expect(find.byType(VitStatusBar), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-006 keeps submit disabled until rules and match pass', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    var button = tester.widget<VitCtaButton>(
      find.byKey(ResetPasswordPage.submitKey),
    );
    expect(button.onPressed, isNull);

    await tester.enterText(
      find.byKey(ResetPasswordPage.newPasswordFieldKey),
      'Password1',
    );
    await tester.pump();

    expect(find.text('Mật khẩu khớp'), findsNothing);
    button = tester.widget<VitCtaButton>(
      find.byKey(ResetPasswordPage.submitKey),
    );
    expect(button.onPressed, isNull);

    await tester.enterText(
      find.byKey(ResetPasswordPage.confirmPasswordFieldKey),
      'Password1',
    );
    await tester.pump();

    expect(find.text('Mật khẩu khớp'), findsOneWidget);
    button = tester.widget<VitCtaButton>(
      find.byKey(ResetPasswordPage.submitKey),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('SC-006 toggles both password fields', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    var newField = tester.widget<TextField>(
      find.byKey(ResetPasswordPage.newPasswordFieldKey),
    );
    var confirmField = tester.widget<TextField>(
      find.byKey(ResetPasswordPage.confirmPasswordFieldKey),
    );
    expect(newField.obscureText, isTrue);
    expect(confirmField.obscureText, isTrue);

    await tester.tap(find.byKey(ResetPasswordPage.newPasswordToggleKey));
    await tester.tap(find.byKey(ResetPasswordPage.confirmPasswordToggleKey));
    await tester.pump();

    newField = tester.widget<TextField>(
      find.byKey(ResetPasswordPage.newPasswordFieldKey),
    );
    confirmField = tester.widget<TextField>(
      find.byKey(ResetPasswordPage.confirmPasswordFieldKey),
    );
    expect(newField.obscureText, isFalse);
    expect(confirmField.obscureText, isFalse);
  });

  testWidgets('SC-006 shows mismatch then success returns to login', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(ResetPasswordPage.newPasswordFieldKey),
      'Password1',
    );
    await tester.enterText(
      find.byKey(ResetPasswordPage.confirmPasswordFieldKey),
      'Password2',
    );
    await tester.pump();

    expect(find.text('Mật khẩu không khớp'), findsOneWidget);

    await tester.enterText(
      find.byKey(ResetPasswordPage.confirmPasswordFieldKey),
      'Password1',
    );
    await tester.pump();
    await tester.tap(find.byKey(ResetPasswordPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.text('Đổi mật khẩu thành công!'), findsOneWidget);

    await tester.tap(find.byKey(ResetPasswordPage.loginKey));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-006 direct header back falls back to login', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(ResetPasswordPage), findsNothing);
  });
}
