part of 'app_router.dart';

OTPPage buildOtpPage(GoRouterState state) {
  final extra = state.extra;
  final query = state.uri.queryParameters;
  OtpPageRouteArgs? args;
  if (extra is OtpPageRouteArgs) {
    args = extra;
  }

  final purposeText = args?.purpose?.name ?? query['purpose'];
  final purpose = switch (purposeText) {
    'register' => AuthOtpPurpose.register,
    'twoFactor' || '2fa' => AuthOtpPurpose.twoFactor,
    'passwordReset' || 'reset' => AuthOtpPurpose.passwordReset,
    _ => AuthOtpPurpose.verify,
  };

  final contactTypeText = args?.contactType?.name ?? query['type'];
  final contactType = contactTypeText == 'phone'
      ? AuthContactType.phone
      : AuthContactType.email;

  return OTPPage(
    contact: args?.contact ?? query['contact'] ?? 'your@email.com',
    contactType: contactType,
    purpose: purpose,
  );
}

class AuthRouteShell extends StatelessWidget {
  const AuthRouteShell({
    super.key,
    required this.child,
    required this.renderMode,
  });

  final Widget child;
  final ShellRenderMode renderMode;

  @override
  Widget build(BuildContext context) {
    final body = Material(
      color: AppColors.bg,
      child: SizedBox.expand(child: child),
    );

    if (!renderMode.usesVisualQaFrame) {
      return SafeArea(top: true, bottom: false, child: body);
    }

    return Material(
      color: AppColors.bg,
      child: Column(
        children: [
          const VitStatusBar(time: '23:27'),
          Expanded(child: body),
        ],
      ),
    );
  }
}
