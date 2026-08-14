import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/contracts/auth_route_args.dart';
import 'package:vit_trade_flutter/features/auth/domain/entities/auth_entities.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/forgot_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/login_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/register_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/reset_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/two_fa_setup_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/forgot_password_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/login_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/otp_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/register_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/reset_password_tablet_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/pages/two_fa_setup_tablet_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/pages/force_update_gate_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/pages/maintenance_gate_page.dart';
import 'package:vit_trade_flutter/features/onboarding/presentation/pages/onboarding_flow_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> topLevelRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  Widget surfacePage({required Widget phone, required Widget tablet}) {
    return switch (surface) {
      AppSurface.tablet => tablet,
      // Web stays on the Phone auth composition until P7 introduces its own
      // form composition; it never imports Tablet UI.
      AppSurface.phone || AppSurface.web || null => phone,
    };
  }

  return [
    GoRoute(path: AppRoutePaths.root, redirect: (_, _) => AppRoutePaths.home),
    GoRoute(
      path: AppRoutePaths.authLogin,
      name: AppRouteNames.sc001Login,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: surfacePage(
          phone: const LoginPage(),
          tablet: const LoginTabletPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authRegister,
      name: AppRouteNames.sc002Register,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: surfacePage(
          phone: const RegisterPage(),
          tablet: const RegisterTabletPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authOtp,
      name: AppRouteNames.sc003Otp,
      builder: (_, state) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: switch (surface) {
          AppSurface.tablet => OtpTabletPage(
            contact:
                _otpArgs(state).contact ??
                state.uri.queryParameters['contact'] ??
                'your@email.com',
            contactType: _otpArgs(state).contactType ?? _otpContactType(state),
            purpose: _otpArgs(state).purpose ?? _otpPurpose(state),
          ),
          AppSurface.phone || AppSurface.web || null => buildOtpPage(state),
        },
      ),
    ),
    GoRoute(
      path: AppRoutePaths.auth2faSetup,
      name: AppRouteNames.sc004TwoFaSetup,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: surfacePage(
          phone: const TwoFASetupPage(),
          tablet: const TwoFaSetupTabletPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authForgotPassword,
      name: AppRouteNames.sc005ForgotPassword,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: surfacePage(
          phone: const ForgotPasswordPage(),
          tablet: const ForgotPasswordTabletPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authResetPassword,
      name: AppRouteNames.sc006ResetPassword,
      builder: (_, _) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: surfacePage(
          phone: const ResetPasswordPage(),
          tablet: const ResetPasswordTabletPage(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.onboarding,
      name: AppRouteNames.sc397Onboarding,
      builder: (_, _) => const OnboardingFlowPage(),
    ),
    // GĐ4-F1 kill-switch: 2 trang gate toàn cục, ngoài shell — redirect từ
    // root_routes.dart khi AppConfig.maintenanceMode / forceUpdateRequired
    // bật.
    GoRoute(
      path: AppRoutePaths.maintenanceGate,
      name: AppRouteNames.sc417MaintenanceGate,
      builder: (_, _) => const MaintenanceGatePage(),
    ),
    GoRoute(
      path: AppRoutePaths.forceUpdateGate,
      name: AppRouteNames.sc418ForceUpdateGate,
      builder: (_, _) => const ForceUpdateGatePage(),
    ),
  ];
}

OtpPageRouteArgs _otpArgs(GoRouterState state) {
  return state.extra is OtpPageRouteArgs
      ? state.extra! as OtpPageRouteArgs
      : const OtpPageRouteArgs();
}

AuthOtpPurpose _otpPurpose(GoRouterState state) {
  return switch (state.uri.queryParameters['purpose']) {
    'register' => AuthOtpPurpose.register,
    'twoFactor' || '2fa' => AuthOtpPurpose.twoFactor,
    'passwordReset' || 'reset' => AuthOtpPurpose.passwordReset,
    _ => AuthOtpPurpose.verify,
  };
}

AuthContactType _otpContactType(GoRouterState state) {
  return state.uri.queryParameters['type'] == 'phone'
      ? AuthContactType.phone
      : AuthContactType.email;
}
