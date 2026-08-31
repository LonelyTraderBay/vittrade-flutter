import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/auth/domain/validators/password_policy.dart';
import 'package:vit_trade_flutter/features/auth/presentation/controllers/password_reset_flow_controller.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/widgets/auth_tablet_surface.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for SC-006.
class ResetPasswordTabletPage extends ConsumerStatefulWidget {
  const ResetPasswordTabletPage({super.key});

  static const contentKey = Key('sc006_reset_content');
  static const expiredKey = Key('sc006_reset_expired');
  static const newPasswordFieldKey = Key('sc006_reset_new_password_field');
  static const confirmPasswordFieldKey = Key(
    'sc006_reset_confirm_password_field',
  );
  static const submitKey = Key('sc006_reset_submit');
  static const retryKey = Key('sc006_reset_retry');
  static const loginKey = Key('sc006_reset_login');

  @override
  ConsumerState<ResetPasswordTabletPage> createState() =>
      _ResetPasswordTabletPageState();
}

class _ResetPasswordTabletPageState
    extends ConsumerState<ResetPasswordTabletPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _submitting = false;
  bool _success = false;
  String _error = '';

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(PasswordResetChallenge challenge) async {
    final password = _newPasswordController.text;
    if (!passwordMeetsPolicy(password)) {
      setState(
        () => _error = 'Mật khẩu cần đủ độ dài, chữ hoa, chữ thường và chữ số.',
      );
      return;
    }
    if (password != _confirmPasswordController.text) {
      setState(() => _error = 'Mật khẩu xác nhận chưa khớp.');
      return;
    }
    if (_submitting) return;
    setState(() {
      _error = '';
      _submitting = true;
    });
    try {
      final result = await ref
          .read(authControllerProvider)
          .resetPassword(
            email: challenge.email,
            otp: challenge.otp,
            newPassword: password,
          );
      if (!result.success) {
        if (mounted) {
          setState(
            () =>
                _error = result.errorMessage ?? 'Không thể cập nhật mật khẩu.',
          );
        }
        return;
      }
      ref.read(passwordResetChallengeProvider.notifier).clear();
      if (mounted) setState(() => _success = true);
    } catch (error) {
      if (mounted) setState(() => _error = authOperationErrorMessage(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = ref.watch(passwordResetChallengeProvider);
    final expired = challenge == null && !_success;
    return AuthTabletSurface(
      semanticLabel: 'Đặt lại mật khẩu tablet',
      semanticIdentifier: 'SC-006-TABLET',
      title: _success
          ? 'Đã cập nhật mật khẩu'
          : expired
          ? 'Yêu cầu đã hết hạn'
          : 'Đặt mật khẩu mới',
      subtitle: _success
          ? 'Tài khoản đã sẵn sàng để đăng nhập'
          : expired
          ? 'Hãy bắt đầu lại quy trình xác minh'
          : 'Mật khẩu mới phải đáp ứng chính sách bảo mật',
      onBack: () => context.go(AppRoutePaths.authLogin),
      child: Column(
        key: ResetPasswordTabletPage.contentKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_success)
            _successBody(context)
          else if (expired)
            _expiredBody(context)
          else
            _formBody(challenge!),
        ],
      ),
    );
  }

  Widget _formBody(PasswordResetChallenge challenge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTabletInfoBanner(message: 'Đang cập nhật cho ${challenge.email}.'),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitInput(
          controller: _newPasswordController,
          fieldKey: ResetPasswordTabletPage.newPasswordFieldKey,
          label: 'Mật khẩu mới',
          hintText: 'Tối thiểu 8 ký tự',
          prefix: const Icon(Icons.lock_outline_rounded),
          obscureText: true,
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitInput(
          controller: _confirmPasswordController,
          fieldKey: ResetPasswordTabletPage.confirmPasswordFieldKey,
          label: 'Xác nhận mật khẩu mới',
          hintText: 'Nhập lại mật khẩu',
          prefix: const Icon(Icons.lock_reset_outlined),
          obscureText: true,
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: TabletSpacingTokens.x4),
          AuthTabletErrorBanner(message: _error),
        ],
        const SizedBox(height: TabletSpacingTokens.x4),
        VitCtaButton(
          key: ResetPasswordTabletPage.submitKey,
          onPressed: _submitting ? null : () => _submit(challenge),
          loading: _submitting,
          variant: VitCtaButtonVariant.auth,
          child: const Text('Cập nhật mật khẩu'),
        ),
      ],
    );
  }

  Widget _expiredBody(BuildContext context) {
    return Column(
      key: ResetPasswordTabletPage.expiredKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.timer_off_outlined,
          color: AppColors.riskWarning,
          size: 56,
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        const AuthTabletInfoBanner(
          message: 'Mã xác minh không còn hiệu lực hoặc chưa được xác nhận.',
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitCtaButton(
          key: ResetPasswordTabletPage.retryKey,
          onPressed: () => context.go(AppRoutePaths.authForgotPassword),
          variant: VitCtaButtonVariant.auth,
          child: const Text('Xác minh lại'),
        ),
      ],
    );
  }

  Widget _successBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.buy,
          size: 56,
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        const Text(
          'Mật khẩu mới đã được lưu an toàn. Bạn có thể đăng nhập lại.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitCtaButton(
          key: ResetPasswordTabletPage.loginKey,
          onPressed: () => context.go(AppRoutePaths.authLogin),
          variant: VitCtaButtonVariant.auth,
          child: const Text('Đăng nhập'),
        ),
      ],
    );
  }
}
