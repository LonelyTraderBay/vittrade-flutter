import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/auth/data/auth_repository.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/forgot_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/login_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/register_page.dart';
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
  String initialLocation = AppRoutePaths.authLogin,
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

Widget _productionFailClosedApp() {
  return ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(
        AppConfig(
          environment: AppEnvironment.production,
          apiBaseUrl: Uri.parse('https://api.vittrade.example'),
          enableMockData: false,
        ),
      ),
    ],
    child: VitTradeApp(
      routerConfig: createAppRouter(initialLocation: AppRoutePaths.authLogin),
    ),
  );
}

void main() {
  testWidgets('/auth/login renders as a standalone auth route', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('VitTrade'), findsOneWidget);
    expect(find.text('Đăng nhập an toàn'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });

  testWidgets(
    'SC-001 Phone keeps hero, form, and legal content on VitCard surfaces',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.byType(VitCard), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('/auth/login visual QA shell keeps fake status only', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app(shellRenderMode: ShellRenderMode.visualQa));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(VitStatusBar), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-001 validates required login fields', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LoginPage.submitKey));
    await tester.pump();

    expect(
      find.text('Vui lòng nhập email hoặc số điện thoại.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(LoginPage.identifierFieldKey),
      'user@vittrade.vn',
    );
    await tester.tap(find.byKey(LoginPage.submitKey));
    await tester.pump();

    expect(find.text('Vui lòng nhập mật khẩu.'), findsOneWidget);
  });

  testWidgets('SC-001 toggles password visibility', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    var passwordField = tester.widget<TextField>(
      find.byKey(LoginPage.passwordFieldKey),
    );
    expect(passwordField.obscureText, isTrue);

    await tester.tap(find.byKey(LoginPage.passwordToggleKey));
    await tester.pump();

    passwordField = tester.widget<TextField>(
      find.byKey(LoginPage.passwordFieldKey),
    );
    expect(passwordField.obscureText, isFalse);
  });

  testWidgets('SC-001 login and demo actions navigate to Home', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(LoginPage.identifierFieldKey),
      'user@vittrade.vn',
    );
    await tester.enterText(find.byKey(LoginPage.passwordFieldKey), 'password');
    await tester.tap(find.byKey(LoginPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LoginPage.demoSubmitKey));
    await tester.pumpAndSettle();

    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);
  });

  testWidgets('SC-001 hides demo login when mock data is disabled', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_productionFailClosedApp());
    await tester.pumpAndSettle();

    expect(find.byKey(LoginPage.demoSubmitKey), findsNothing);
  });

  testWidgets('SC-001 production auth without backend fails closed in UI', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_productionFailClosedApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(LoginPage.identifierFieldKey),
      'user@vittrade.vn',
    );
    await tester.enterText(find.byKey(LoginPage.passwordFieldKey), 'password');
    await tester.tap(find.byKey(LoginPage.submitKey));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Dịch vụ xác thực chưa sẵn sàng'),
      findsOneWidget,
    );
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('SC-001 outgoing auth links open auth routes', (tester) async {
    _setPhoneViewport(tester);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LoginPage.forgotPasswordKey));
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordPage), findsOneWidget);
    expect(find.text('Quên mật khẩu'), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LoginPage.registerKey));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.text('Tạo tài khoản'), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
  });

  testWidgets('SC-001 login shows error and retries on second attempt', (
    tester,
  ) async {
    _setPhoneViewport(tester);

    final flakyRepository = _FlakyAuthLoginRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(flakyRepository)],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.authLogin,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(LoginPage.identifierFieldKey),
      'user@vittrade.vn',
    );
    await tester.enterText(find.byKey(LoginPage.passwordFieldKey), 'password');
    await tester.tap(find.byKey(LoginPage.submitKey));
    await tester.pumpAndSettle();

    expect(
      find.text('Dịch vụ xác thực tạm thời không khả dụng. Vui lòng thử lại.'),
      findsOneWidget,
    );
    expect(find.byType(LoginPage), findsOneWidget);

    await tester.tap(find.byKey(LoginPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_active_home')), findsOneWidget);
  });
}

final class _FlakyAuthLoginRepository implements AuthRepository {
  _FlakyAuthLoginRepository()
    : _delegate = const MockAuthRepository(delay: Duration.zero);

  final MockAuthRepository _delegate;
  var _loginAttempts = 0;

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
    bool demo = false,
  }) async {
    _loginAttempts++;
    if (_loginAttempts == 1) {
      throw StateError('auth_login_failed');
    }
    return _delegate.login(
      identifier: identifier,
      password: password,
      demo: demo,
    );
  }

  @override
  Future<AuthRegistrationDraft> register({
    required String name,
    required String contact,
    required AuthContactType contactType,
    required String password,
    String? referralCode,
  }) {
    return _delegate.register(
      name: name,
      contact: contact,
      contactType: contactType,
      password: password,
      referralCode: referralCode,
    );
  }

  @override
  Future<AuthOtpVerificationDraft> verifyFactor({
    required String contact,
    required String code,
    required AuthOtpPurpose purpose,
  }) {
    return _delegate.verifyFactor(
      contact: contact,
      code: code,
      purpose: purpose,
    );
  }

  @override
  Future<AuthTwoFaSetupDraft> setupTwoFactor({
    required String secretKey,
    required String code,
    required bool backupCodesSaved,
  }) {
    return _delegate.setupTwoFactor(
      secretKey: secretKey,
      code: code,
      backupCodesSaved: backupCodesSaved,
    );
  }

  @override
  Future<AuthPasswordResetDraft> requestPasswordReset({required String email}) {
    return _delegate.requestPasswordReset(email: email);
  }

  @override
  Future<AuthPasswordResetDraft> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) {
    return _delegate.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );
  }

  @override
  Future<AuthTokenPair> refreshSession({required String refreshToken}) {
    return _delegate.refreshSession(refreshToken: refreshToken);
  }
}
