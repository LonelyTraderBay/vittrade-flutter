import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/auth/domain/validators/password_policy.dart';
import 'package:vit_trade_flutter/features/auth/presentation/tablet/widgets/auth_tablet_surface.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

enum _ForgotTabletStep { email, otp, password, success }

/// Independent Tablet composition for SC-005.
class ForgotPasswordTabletPage extends ConsumerStatefulWidget {
  const ForgotPasswordTabletPage({super.key});

  static const contentKey = Key('sc005_forgot_content');
  static const emailFieldKey = Key('sc005_forgot_email_field');
  static const otpFieldKey = Key('sc005_forgot_otp_field');
  static const newPasswordFieldKey = Key('sc005_forgot_new_password_field');
  static const confirmPasswordFieldKey = Key(
    'sc005_forgot_confirm_password_field',
  );
  static const submitKey = Key('sc005_forgot_submit');

  @override
  ConsumerState<ForgotPasswordTabletPage> createState() =>
      _ForgotPasswordTabletPageState();
}

class _ForgotPasswordTabletPageState
    extends ConsumerState<ForgotPasswordTabletPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  _ForgotTabletStep _step = _ForgotTabletStep.email;
  bool _submitting = false;
  String _error = '';

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Vui lòng nhập email đã đăng ký.');
      return;
    }
    await _run(() async {
      final result = await ref
          .read(authControllerProvider)
          .requestPasswordReset(email: email);
      if (!result.success) {
        throw StateError(result.errorMessage ?? 'Không thể gửi mã xác minh.');
      }
      if (mounted) setState(() => _step = _ForgotTabletStep.otp);
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      setState(() => _error = 'Vui lòng nhập đủ 6 chữ số xác minh.');
      return;
    }
    await _run(() async {
      final result = await ref
          .read(authControllerProvider)
          .verifyFactor(
            contact: _emailController.text.trim(),
            code: otp,
            purpose: AuthOtpPurpose.passwordReset,
          );
      if (!result.success) {
        throw StateError(result.errorMessage ?? 'Mã xác minh chưa đúng.');
      }
      if (mounted) setState(() => _step = _ForgotTabletStep.password);
    });
  }

  Future<void> _resetPassword() async {
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
    await _run(() async {
      final result = await ref
          .read(authControllerProvider)
          .resetPassword(
            email: _emailController.text.trim(),
            otp: _otpController.text.trim(),
            newPassword: password,
          );
      if (!result.success) {
        throw StateError(result.errorMessage ?? 'Không thể cập nhật mật khẩu.');
      }
      if (mounted) setState(() => _step = _ForgotTabletStep.success);
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_submitting) return;
    setState(() {
      _error = '';
      _submitting = true;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) setState(() => _error = authOperationErrorMessage(error));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String get _title => switch (_step) {
    _ForgotTabletStep.email => 'Khôi phục mật khẩu',
    _ForgotTabletStep.otp => 'Xác minh email',
    _ForgotTabletStep.password => 'Đặt mật khẩu mới',
    _ForgotTabletStep.success => 'Đã cập nhật mật khẩu',
  };

  String get _subtitle => switch (_step) {
    _ForgotTabletStep.email => 'Gửi mã xác minh đến email đã đăng ký',
    _ForgotTabletStep.otp => 'Nhập mã gồm 6 chữ số để tiếp tục',
    _ForgotTabletStep.password => 'Thiết lập mật khẩu mới an toàn',
    _ForgotTabletStep.success => 'Bạn có thể đăng nhập bằng mật khẩu mới',
  };

  @override
  Widget build(BuildContext context) {
    return AuthTabletSurface(
      semanticLabel: 'Khôi phục mật khẩu tablet',
      semanticIdentifier: 'SC-005-TABLET',
      title: _title,
      subtitle: _subtitle,
      onBack: () => context.go(AppRoutePaths.authLogin),
      child: Column(
        key: ForgotPasswordTabletPage.contentKey,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_step == _ForgotTabletStep.email) _emailBody(),
          if (_step == _ForgotTabletStep.otp) _otpBody(),
          if (_step == _ForgotTabletStep.password) _passwordBody(),
          if (_step == _ForgotTabletStep.success) _successBody(context),
        ],
      ),
    );
  }

  Widget _emailBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AuthTabletInfoBanner(
          message: 'Chỉ tiếp tục nếu bạn đang sở hữu email của tài khoản.',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitInput(
          controller: _emailController,
          fieldKey: ForgotPasswordTabletPage.emailFieldKey,
          label: 'Email tài khoản',
          hintText: 'Nhập email đã đăng ký',
          prefix: const Icon(Icons.mail_outline_rounded),
          keyboardType: TextInputType.emailAddress,
        ),
        _errorWidget(),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitCtaButton(
          key: ForgotPasswordTabletPage.submitKey,
          onPressed: _submitting ? null : _sendOtp,
          loading: _submitting,
          variant: VitCtaButtonVariant.auth,
          child: const Text('Gửi mã xác minh'),
        ),
      ],
    );
  }

  Widget _otpBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthTabletInfoBanner(
          message: 'Mã đã gửi đến ${_emailController.text}.',
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitInput(
          controller: _otpController,
          fieldKey: ForgotPasswordTabletPage.otpFieldKey,
          label: 'Mã xác minh 6 chữ số',
          hintText: '000000',
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
        ),
        _errorWidget(),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitCtaButton(
          key: ForgotPasswordTabletPage.submitKey,
          onPressed: _submitting ? null : _verifyOtp,
          loading: _submitting,
          variant: VitCtaButtonVariant.auth,
          child: const Text('Xác minh mã'),
        ),
      ],
    );
  }

  Widget _passwordBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitInput(
          controller: _newPasswordController,
          fieldKey: ForgotPasswordTabletPage.newPasswordFieldKey,
          label: 'Mật khẩu mới',
          hintText: 'Tối thiểu 8 ký tự',
          prefix: const Icon(Icons.lock_outline_rounded),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
        VitInput(
          controller: _confirmPasswordController,
          fieldKey: ForgotPasswordTabletPage.confirmPasswordFieldKey,
          label: 'Xác nhận mật khẩu mới',
          hintText: 'Nhập lại mật khẩu',
          prefix: const Icon(Icons.lock_reset_outlined),
          obscureText: true,
        ),
        _errorWidget(),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitCtaButton(
          key: ForgotPasswordTabletPage.submitKey,
          onPressed: _submitting ? null : _resetPassword,
          loading: _submitting,
          variant: VitCtaButtonVariant.auth,
          child: const Text('Cập nhật mật khẩu'),
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
          size: 56,
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const Text(
          'Mật khẩu đã được cập nhật. Hãy đăng nhập lại để tiếp tục giao dịch.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
        VitCtaButton(
          onPressed: () => context.go(AppRoutePaths.authLogin),
          variant: VitCtaButtonVariant.auth,
          child: const Text('Đăng nhập'),
        ),
      ],
    );
  }

  Widget _errorWidget() {
    if (_error.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x4),
      child: AuthTabletErrorBanner(message: _error),
    );
  }
}
