import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/widgets/auth_tablet_surface.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for SC-001.
class LoginTabletPage extends ConsumerStatefulWidget {
  const LoginTabletPage({super.key});

  static const contentKey = Key('sc001_login_content');
  static const identifierFieldKey = Key('sc001_login_identifier_field');
  static const passwordFieldKey = Key('sc001_login_password_field');
  static const passwordToggleKey = Key('sc001_login_password_toggle');
  static const submitKey = Key('sc001_login_submit');
  static const demoSubmitKey = Key('sc001_login_demo_submit');
  static const forgotPasswordKey = Key('sc001_login_forgot_password');
  static const registerKey = Key('sc001_login_register');

  @override
  ConsumerState<LoginTabletPage> createState() => _LoginTabletPageState();
}

class _LoginTabletPageState extends ConsumerState<LoginTabletPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit({bool demo = false}) async {
    final identifier = demo
        ? 'demo@vittrade.vn'
        : _identifierController.text.trim();
    final password = demo ? 'demo' : _passwordController.text;
    if (!demo && identifier.isEmpty) {
      setState(() => _error = 'Vui lòng nhập email hoặc số điện thoại.');
      return;
    }
    if (!demo && password.isEmpty) {
      setState(() => _error = 'Vui lòng nhập mật khẩu.');
      return;
    }
    if (_submitting) return;

    setState(() {
      _error = '';
      _submitting = true;
    });
    try {
      await ref
          .read(authSessionControllerProvider.notifier)
          .login(identifier: identifier, password: password, demo: demo);
      if (mounted) context.go(AppRoutePaths.home);
    } catch (error) {
      if (mounted) setState(() => _error = authOperationErrorMessage(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showDemoLogin = ref.watch(appConfigProvider).enableMockData;
    return AuthTabletSurface(
      semanticLabel: 'Đăng nhập tablet',
      semanticIdentifier: 'SC-001-TABLET',
      title: 'Đăng nhập',
      subtitle: 'Truy cập tài khoản được bảo vệ',
      child: AutofillGroup(
        key: LoginTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitInput(
              controller: _identifierController,
              fieldKey: LoginTabletPage.identifierFieldKey,
              label: 'Email / Số điện thoại',
              hintText: 'Nhập email hoặc số điện thoại',
              prefix: const Icon(Icons.mail_outline_rounded),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
              ],
              onChanged: (_) {
                if (_error.isNotEmpty) setState(() => _error = '');
              },
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitInput(
              controller: _passwordController,
              fieldKey: LoginTabletPage.passwordFieldKey,
              label: 'Mật khẩu',
              hintText: 'Nhập mật khẩu',
              prefix: const Icon(Icons.lock_outline_rounded),
              suffix: VitIconButton(
                key: LoginTabletPage.passwordToggleKey,
                icon: _showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                tooltip: _showPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
                onPressed: () => setState(() => _showPassword = !_showPassword),
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.sm,
              ),
              obscureText: !_showPassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onChanged: (_) {
                if (_error.isNotEmpty) setState(() => _error = '');
              },
              onSubmitted: (_) => _submit(),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              AuthTabletErrorBanner(message: _error),
            ],
            const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
            VitCtaButton(
              key: LoginTabletPage.submitKey,
              onPressed: _submitting ? null : _submit,
              loading: _submitting,
              variant: VitCtaButtonVariant.auth,
              child: const Text('Đăng nhập'),
            ),
            if (showDemoLogin) ...[
              const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
              VitCtaButton(
                key: LoginTabletPage.demoSubmitKey,
                onPressed: _submitting ? null : () => _submit(demo: true),
                variant: VitCtaButtonVariant.ghost,
                leading: const Icon(Icons.fingerprint_rounded),
                child: const Text('Dùng tài khoản demo'),
              ),
            ],
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VitCtaButton(
                  key: LoginTabletPage.forgotPasswordKey,
                  onPressed: _submitting
                      ? null
                      : () => context.go(AppRoutePaths.authForgotPassword),
                  fullWidth: false,
                  height: AppSpacing.buttonCompact,
                  variant: VitCtaButtonVariant.ghost,
                  child: Text(
                    'Quên mật khẩu?',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Text('|', style: AppTextStyles.caption),
                VitCtaButton(
                  key: LoginTabletPage.registerKey,
                  onPressed: _submitting
                      ? null
                      : () => context.go(AppRoutePaths.authRegister),
                  fullWidth: false,
                  height: AppSpacing.buttonCompact,
                  variant: VitCtaButtonVariant.ghost,
                  child: Text(
                    'Đăng ký',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
            Text(
              'Bằng cách đăng nhập, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của VitTrade.',
              textAlign: TextAlign.center,
              style: AppTextStyles.navLabel.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
