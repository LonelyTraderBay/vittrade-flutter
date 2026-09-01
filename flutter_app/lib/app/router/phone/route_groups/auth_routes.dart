// Phone-only route group. Surface-specific Phone/Web builders stay outside this composition.

import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/forgot_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/login_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/register_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/reset_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/two_fa_setup_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/phone/pages/force_update_gate_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/phone/pages/maintenance_gate_page.dart';
import 'package:vit_trade_flutter/features/onboarding/presentation/phone/pages/onboarding_flow_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/phone/phone_router_helpers.dart';

List<RouteBase> topLevelRoutes(ShellRenderMode shellRenderMode) {
  return [
    GoRoute(path: AppRoutePaths.root, redirect: (_, _) => AppRoutePaths.home),
    GoRoute(
      path: AppRoutePaths.authLogin,
      name: AppRouteNames.sc001Login,
      builder: (_, _) =>
          AuthRouteShell(renderMode: shellRenderMode, child: const LoginPage()),
    ),
    GoRoute(
      path: AppRoutePaths.authRegister,
      name: AppRouteNames.sc002Register,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: const RegisterPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authOtp,
      name: AppRouteNames.sc003Otp,
      builder: (_, state) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: buildOtpPage(state),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.auth2faSetup,
      name: AppRouteNames.sc004TwoFaSetup,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: const TwoFASetupPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authForgotPassword,
      name: AppRouteNames.sc005ForgotPassword,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: const ForgotPasswordPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authResetPassword,
      name: AppRouteNames.sc006ResetPassword,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: const ResetPasswordPage(),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.onboarding,
      name: AppRouteNames.sc397Onboarding,
      builder: (context, _) => const OnboardingFlowPage(),
    ),
    // GĐ4-F1 kill-switch: 2 trang gate toàn cục, ngoài shell — redirect từ
    // root_routes.dart khi AppConfig.maintenanceMode / forceUpdateRequired
    // bật.
    GoRoute(
      path: AppRoutePaths.maintenanceGate,
      name: AppRouteNames.sc417MaintenanceGate,
      builder: (context, _) => const MaintenanceGatePage(),
    ),
    GoRoute(
      path: AppRoutePaths.forceUpdateGate,
      name: AppRouteNames.sc418ForceUpdateGate,
      builder: (context, _) => const ForceUpdateGatePage(),
    ),
  ];
}
