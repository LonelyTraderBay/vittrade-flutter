import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/contracts/auth_route_args.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/forgot_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/login_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/register_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/reset_password_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/two_fa_setup_page.dart';
import 'package:vit_trade_flutter/features/auth/presentation/web/pages/auth_web_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/phone/pages/force_update_gate_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/phone/pages/maintenance_gate_page.dart';
import 'package:vit_trade_flutter/features/onboarding/presentation/phone/pages/onboarding_flow_page.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_web_utility_page.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';

List<RouteBase> topLevelRoutes(
  ShellRenderMode shellRenderMode, {
  AppSurface? surface,
}) {
  Widget surfacePage({required Widget phone, required Widget web}) {
    return switch (surface) {
      AppSurface.web => web,
      AppSurface.phone || AppSurface.tablet || null => phone,
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
          web: const AuthWebPage(
            semanticIdentifier: 'SC-001',
            title: 'Đăng nhập',
            subtitle: 'Tài khoản · xác thực an toàn',
            description:
                'Đăng nhập trong không gian Web riêng. Hệ thống sẽ kiểm tra thiết bị và yêu cầu bảo mật phù hợp trước khi tiếp tục.',
            actionLabel: 'Tiếp tục đăng nhập',
            fields: [
              AuthWebField(label: 'Email hoặc số điện thoại'),
              AuthWebField(label: 'Mật khẩu', obscureText: true),
            ],
          ),
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
          web: const AuthWebPage(
            semanticIdentifier: 'SC-002',
            title: 'Tạo tài khoản',
            subtitle: 'Đăng ký · xác minh · bảo mật',
            description:
                'Tạo tài khoản trong quy trình Web rõ ràng với các bước xác minh và điều kiện bảo mật được hiển thị trước.',
            actionLabel: 'Tiếp tục đăng ký',
            fields: [
              AuthWebField(label: 'Email hoặc số điện thoại'),
              AuthWebField(label: 'Mật khẩu', obscureText: true),
            ],
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.authOtp,
      name: AppRouteNames.sc003Otp,
      builder: (_, state) => AuthRouteShell(
        renderMode: shellRenderMode,
        child: switch (surface) {
          AppSurface.web => _webOtpPage(state),
          AppSurface.phone || AppSurface.tablet || null => buildOtpPage(state),
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
          web: const AuthWebPage(
            semanticIdentifier: 'SC-004',
            title: 'Thiết lập 2FA',
            subtitle: 'Bảo mật tài khoản · xác minh nhiều lớp',
            description:
                'Thiết lập lớp bảo vệ bổ sung cho tài khoản trong giao diện Web rộng, dễ kiểm tra và xác nhận.',
            actionLabel: 'Tiếp tục thiết lập 2FA',
            fields: [AuthWebField(label: 'Mã xác thực hiện tại')],
          ),
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
          web: const AuthWebPage(
            semanticIdentifier: 'SC-005',
            title: 'Quên mật khẩu',
            subtitle: 'Khôi phục quyền truy cập',
            description:
                'Khôi phục quyền truy cập bằng quy trình Web có bước xác minh rõ ràng và không tiết lộ thông tin nhạy cảm.',
            actionLabel: 'Gửi yêu cầu khôi phục',
            fields: [AuthWebField(label: 'Email hoặc số điện thoại')],
          ),
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
          web: const AuthWebPage(
            semanticIdentifier: 'SC-006',
            title: 'Đặt lại mật khẩu',
            subtitle: 'Mật khẩu mới · xác nhận',
            description:
                'Đặt lại mật khẩu sau khi xác minh. Kiểm tra lại điều kiện an toàn trước khi lưu thay đổi.',
            actionLabel: 'Lưu mật khẩu mới',
            fields: [
              AuthWebField(label: 'Mật khẩu mới', obscureText: true),
              AuthWebField(label: 'Nhập lại mật khẩu', obscureText: true),
            ],
          ),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutePaths.onboarding,
      name: AppRouteNames.sc397Onboarding,
      builder: (context, _) => switch (surface) {
        AppSurface.web => VitWebUtilityPage(
          semanticIdentifier: 'SC-397',
          title: 'Bắt đầu với VitTrade',
          subtitle: 'Onboarding · thiết lập tài khoản',
          description:
              'Không gian Web riêng để hoàn tất các bước giới thiệu và thiết lập ban đầu trước khi giao dịch.',
          facts: const [
            VitWebUtilityFact(label: 'Bước hiện tại', value: 'Giới thiệu'),
            VitWebUtilityFact(label: 'Trạng thái', value: 'Chưa hoàn tất'),
            VitWebUtilityFact(
              label: 'Bước tiếp theo',
              value: 'Rà soát thiết lập',
            ),
          ],
          actionLabel: 'Tiếp tục thiết lập',
          onBack: () => context.go(AppRoutePaths.home),
        ),
        AppSurface.phone ||
        AppSurface.tablet ||
        null => const OnboardingFlowPage(),
      },
    ),
    // GĐ4-F1 kill-switch: 2 trang gate toàn cục, ngoài shell — redirect từ
    // root_routes.dart khi AppConfig.maintenanceMode / forceUpdateRequired
    // bật.
    GoRoute(
      path: AppRoutePaths.maintenanceGate,
      name: AppRouteNames.sc417MaintenanceGate,
      builder: (context, _) => switch (surface) {
        AppSurface.web => VitWebUtilityPage(
          semanticIdentifier: 'SC-417',
          title: 'Hệ thống đang bảo trì',
          subtitle: 'Bảo trì · trạng thái dịch vụ',
          description:
              'VitTrade đang được bảo trì để cải thiện độ ổn định. Vui lòng quay lại sau khi dịch vụ được mở lại.',
          facts: const [
            VitWebUtilityFact(label: 'Trạng thái', value: 'Đang bảo trì'),
            VitWebUtilityFact(label: 'Thao tác', value: 'Chưa khả dụng'),
          ],
          onBack: () => context.go(AppRoutePaths.home),
        ),
        AppSurface.phone ||
        AppSurface.tablet ||
        null => const MaintenanceGatePage(),
      },
    ),
    GoRoute(
      path: AppRoutePaths.forceUpdateGate,
      name: AppRouteNames.sc418ForceUpdateGate,
      builder: (context, _) => switch (surface) {
        AppSurface.web => VitWebUtilityPage(
          semanticIdentifier: 'SC-418',
          title: 'Cần cập nhật ứng dụng',
          subtitle: 'Cập nhật bắt buộc · an toàn hệ thống',
          description:
              'Phiên bản hiện tại cần được cập nhật để tiếp tục sử dụng dịch vụ an toàn.',
          facts: const [
            VitWebUtilityFact(label: 'Trạng thái', value: 'Cần cập nhật'),
            VitWebUtilityFact(
              label: 'Bước tiếp theo',
              value: 'Cài phiên bản mới',
            ),
          ],
          actionLabel: 'Xem hướng dẫn cập nhật',
          onBack: () => context.go(AppRoutePaths.home),
        ),
        AppSurface.phone ||
        AppSurface.tablet ||
        null => const ForceUpdateGatePage(),
      },
    ),
  ];
}

OtpPageRouteArgs _otpArgs(GoRouterState state) {
  return state.extra is OtpPageRouteArgs
      ? state.extra! as OtpPageRouteArgs
      : const OtpPageRouteArgs();
}

Widget _webOtpPage(GoRouterState state) {
  final contact =
      _otpArgs(state).contact ??
      state.uri.queryParameters['contact'] ??
      'your@email.com';
  return AuthWebPage(
    semanticIdentifier: 'SC-003',
    title: 'Xác thực mã OTP',
    subtitle: 'Mã xác thực · bảo vệ tài khoản',
    description:
        'Nhập mã xác thực đã gửi đến $contact. Không chia sẻ mã này với bất kỳ ai.',
    actionLabel: 'Xác nhận mã OTP',
    fields: const [
      AuthWebField(label: 'Mã xác thực', hint: 'Nhập mã gồm 6 chữ số'),
    ],
  );
}
