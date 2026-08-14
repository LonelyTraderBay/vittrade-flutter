import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/tablet/tablet_app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/forgot_password_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/login_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/otp_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/register_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/reset_password_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/two_fa_setup_tablet_page.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String path) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(820, 1180);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(routerConfig: createTabletAppRouter(initialLocation: path)),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  testWidgets('Tablet Auth dùng composition Login riêng', (tester) async {
    await pumpRoute(tester, AppRoutePaths.authLogin);
    expect(find.byType(LoginTabletPage), findsOneWidget);
  });

  testWidgets('Tablet Auth dùng composition Register riêng', (tester) async {
    await pumpRoute(tester, AppRoutePaths.authRegister);
    expect(find.byType(RegisterTabletPage), findsOneWidget);
  });

  testWidgets('Tablet Auth dùng composition OTP riêng', (tester) async {
    await pumpRoute(tester, AppRoutePaths.authOtp);
    expect(find.byType(OtpTabletPage), findsOneWidget);
  });

  testWidgets('Tablet Auth dùng composition 2FA riêng', (tester) async {
    await pumpRoute(tester, AppRoutePaths.auth2faSetup);
    expect(find.byType(TwoFaSetupTabletPage), findsOneWidget);
  });

  testWidgets('Tablet Auth dùng composition quên mật khẩu riêng', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.authForgotPassword);
    expect(find.byType(ForgotPasswordTabletPage), findsOneWidget);
  });

  testWidgets('Tablet Auth dùng composition đặt lại mật khẩu riêng', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.authResetPassword);
    expect(find.byType(ResetPasswordTabletPage), findsOneWidget);
  });
}
