import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/otp_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/reset_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/two_fa_setup_page.dart';
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
  String initialLocation = AppRoutePaths.authOtp,
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

Future<void> _enterCode(WidgetTester tester, String code) async {
  for (var i = 0; i < code.length; i++) {
    await tester.enterText(find.byKey(OTPPage.digitFieldKey(i)), code[i]);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('/auth/otp renders as a standalone auth route', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(OTPPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('Xác minh OTP'), findsOneWidget);
    expect(find.text('Nhập mã xác minh'), findsOneWidget);
  });

  testWidgets('/auth/otp visual QA shell keeps fake status only', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app(shellRenderMode: ShellRenderMode.visualQa));
    await tester.pumpAndSettle();

    expect(find.byType(OTPPage), findsOneWidget);
    expect(find.byType(VitStatusBar), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-003 keeps confirm disabled until six digits are filled', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    var button = tester.widget<VitCtaButton>(find.byKey(OTPPage.submitKey));
    expect(button.onPressed, isNull);

    await tester.enterText(find.byKey(OTPPage.digitFieldKey(0)), '1');
    await tester.pump();

    button = tester.widget<VitCtaButton>(find.byKey(OTPPage.submitKey));
    expect(button.onPressed, isNull);
  });

  testWidgets('SC-003 invalid OTP shows error and clears digits', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await _enterCode(tester, '000000');

    expect(find.text('Mã OTP không đúng. Vui lòng thử lại.'), findsOneWidget);
    final firstField = tester.widget<TextField>(
      find.byKey(OTPPage.digitFieldKey(0)),
    );
    expect(firstField.controller?.text, isEmpty);
  });

  testWidgets('SC-003 valid default OTP navigates to SC-006 reset password', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await _enterCode(tester, '123456');

    expect(find.byType(ResetPasswordPage), findsOneWidget);
    expect(find.byKey(ResetPasswordPage.expiredKey), findsNothing);
    expect(find.byKey(ResetPasswordPage.newPasswordFieldKey), findsOneWidget);
    expect(find.text('Đặt lại mật khẩu'), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-003 register purpose navigates to SC-004 2FA setup', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(
      _app(
        initialLocation:
            '${AppRoutePaths.authOtp}?purpose=register&contact=user@vittrade.vn',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('user@vittrade.vn'), findsOneWidget);

    await _enterCode(tester, '123456');

    expect(find.byType(TwoFASetupPage), findsOneWidget);
    expect(find.text('Thiết lập 2FA'), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-003 2FA purpose navigates to Home', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(
      _app(initialLocation: '${AppRoutePaths.authOtp}?purpose=2fa'),
    );
    await tester.pumpAndSettle();

    await _enterCode(tester, '123456');

    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);
  });
}
