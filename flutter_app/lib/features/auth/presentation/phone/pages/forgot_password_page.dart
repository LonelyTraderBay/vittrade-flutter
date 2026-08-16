import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/auth_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/widgets/auth_hero_icon_box.dart';

part '../../phone/widgets/forgot_password_page_sections.dart';

const _authPrimary = AppColors.primary;
const _authPrimary10 = AppColors.primary12;
const _authPrimary30 = AppColors.primary30;

enum _ForgotPasswordStep { input, otp, reset, success }

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  static const contentKey = Key('sc005_forgot_content');
  static const emailFieldKey = Key('sc005_forgot_email_field');
  static const otpFieldKey = Key('sc005_forgot_otp_field');
  static const newPasswordFieldKey = Key('sc005_forgot_new_password_field');
  static const confirmPasswordFieldKey = Key(
    'sc005_forgot_confirm_password_field',
  );
  static const passwordToggleKey = Key('sc005_forgot_password_toggle');
  static const submitKey = Key('sc005_forgot_submit');
  static const loginKey = Key('sc005_forgot_login');

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  _ForgotPasswordStep _step = _ForgotPasswordStep.input;
  bool _showPassword = false;
  bool _submitting = false;
  String _emailError = '';
  String _otpError = '';
  String _passwordError = '';

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text.trim();

  String get _otp => _otpController.text;

  String get _newPassword => _newPasswordController.text;

  String get _confirmPassword => _confirmPasswordController.text;

  bool get _canSubmit {
    if (_submitting) return false;
    return switch (_step) {
      _ForgotPasswordStep.input => _email.isNotEmpty,
      _ForgotPasswordStep.otp => _otp.length == 6,
      _ForgotPasswordStep.reset =>
        _newPassword.isNotEmpty && _newPassword == _confirmPassword,
      _ForgotPasswordStep.success => true,
    };
  }

  void _goBack() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.authLogin,
      mode: BackNavigationMode.historyThenFallback,
    );
  }

  void _clearEmailError() {
    setState(() => _emailError = '');
  }

  void _clearOtpError() {
    setState(() => _otpError = '');
  }

  void _clearPasswordError() {
    setState(() => _passwordError = '');
  }

  Future<void> _handleSendOtp() async {
    if (_submitting) return;
    if (_email.isEmpty) {
      setState(() => _emailError = 'Vui lòng nhập email đã đăng ký.');
      return;
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(_email)) {
      setState(() => _emailError = 'Email không hợp lệ.');
      return;
    }

    setState(() {
      _submitting = true;
      _emailError = '';
    });
    try {
      final result = await ref
          .read(authControllerProvider)
          .requestPasswordReset(email: _email);

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _emailError =
              result.errorMessage ?? 'Không thể gửi mã. Vui lòng thử lại.';
        });
        return;
      }
      setState(() => _step = _ForgotPasswordStep.otp);
    } catch (error) {
      if (mounted) {
        setState(() => _emailError = authOperationErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (_submitting || _otp.length < 6) return;
    setState(() {
      _submitting = true;
      _otpError = '';
    });

    try {
      final result = await ref
          .read(authControllerProvider)
          .verifyFactor(
            contact: _email,
            code: _otp,
            purpose: AuthOtpPurpose.passwordReset,
          );

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _otpError = result.errorMessage ?? 'Mã OTP không đúng.';
          _otpController.clear();
        });
        return;
      }
      setState(() => _step = _ForgotPasswordStep.reset);
    } catch (error) {
      if (mounted) {
        setState(() => _otpError = authOperationErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _handleResetPassword() async {
    if (_submitting) return;
    if (_newPassword.length < 8) {
      setState(() => _passwordError = 'Mật khẩu tối thiểu 8 ký tự.');
      return;
    }
    if (_newPassword != _confirmPassword) {
      setState(() => _passwordError = 'Mật khẩu không khớp');
      return;
    }

    setState(() {
      _submitting = true;
      _passwordError = '';
    });
    try {
      final result = await ref
          .read(authControllerProvider)
          .resetPassword(email: _email, otp: _otp, newPassword: _newPassword);

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _passwordError =
              result.errorMessage ??
              'Không thể đặt lại mật khẩu. Vui lòng thử lại.';
        });
        return;
      }
      setState(() => _step = _ForgotPasswordStep.success);
    } catch (error) {
      if (mounted) {
        setState(() => _passwordError = authOperationErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _handleOtpChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final next = digits.length > 6 ? digits.substring(0, 6) : digits;
    if (_otpController.text != next) {
      _otpController.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
    _clearOtpError();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      semanticLabel: 'Quên mật khẩu',
      semanticIdentifier: 'SC-005',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Quên mật khẩu',
          subtitle: 'Xác thực · Bảo mật',
          showBack: true,
          onBack: _goBack,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: ForgotPasswordPage.contentKey,
                padding: AuthSpacingTokens.authScrollBottomPadding,
                child: VitPageContent(
                  rhythm: VitPageRhythm.form,
                  children: [
                    if (_step == _ForgotPasswordStep.input)
                      VitCard(
                        variant: VitCardVariant.hero,
                        radius: VitCardRadius.large,
                        padding: AuthSpacingTokens.authSurfacePadding,
                        child: _EmailStep(
                          controller: _emailController,
                          error: _emailError,
                          onChanged: _clearEmailError,
                        ),
                      ),
                    if (_step == _ForgotPasswordStep.otp)
                      VitCard(
                        padding: AuthSpacingTokens.authSurfacePadding,
                        child: _OtpStep(
                          controller: _otpController,
                          email: _email,
                          error: _otpError,
                          onChanged: _handleOtpChanged,
                        ),
                      ),
                    if (_step == _ForgotPasswordStep.reset)
                      VitCard(
                        padding: AuthSpacingTokens.authSurfacePadding,
                        child: _ResetStep(
                          newPasswordController: _newPasswordController,
                          confirmPasswordController: _confirmPasswordController,
                          showPassword: _showPassword,
                          error: _passwordError,
                          onChanged: _clearPasswordError,
                          onTogglePassword: () {
                            setState(() => _showPassword = !_showPassword);
                          },
                        ),
                      ),
                    if (_step == _ForgotPasswordStep.success)
                      const VitCard(
                        variant: VitCardVariant.hero,
                        radius: VitCardRadius.large,
                        padding: AuthSpacingTokens.authSurfacePadding,
                        child: _SuccessStep(),
                      ),
                    VitCard(
                      padding: AuthSpacingTokens.authSurfacePadding,
                      child: VitCtaButton(
                        key: _step == _ForgotPasswordStep.success
                            ? ForgotPasswordPage.loginKey
                            : ForgotPasswordPage.submitKey,
                        onPressed: _canSubmit ? _handlePrimaryAction : null,
                        loading: _submitting,
                        variant: VitCtaButtonVariant.auth,
                        child: Text(_buttonLabel),
                      ),
                    ),
                    const VitCard(
                      variant: VitCardVariant.ghost,
                      borderColor: AppColors.cardBorder,
                      padding: AuthSpacingTokens.authSurfaceCompactPadding,
                      child: Text(
                        'Mã xác minh chỉ dùng một lần và không nên chia sẻ.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.micro,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback get _handlePrimaryAction {
    return switch (_step) {
      _ForgotPasswordStep.input => _handleSendOtp,
      _ForgotPasswordStep.otp => _handleVerifyOtp,
      _ForgotPasswordStep.reset => _handleResetPassword,
      _ForgotPasswordStep.success => () {
        context.go(AppRoutePaths.authLogin);
      },
    };
  }

  String get _buttonLabel {
    if (_submitting && _step == _ForgotPasswordStep.input) return 'Đang gửi...';
    if (_submitting && _step == _ForgotPasswordStep.otp) {
      return 'Đang xác minh...';
    }
    if (_submitting && _step == _ForgotPasswordStep.reset) {
      return 'Đang đặt lại...';
    }
    return switch (_step) {
      _ForgotPasswordStep.input => 'Gửi mã xác minh',
      _ForgotPasswordStep.otp => 'Xác nhận',
      _ForgotPasswordStep.reset => 'Đặt lại mật khẩu',
      _ForgotPasswordStep.success => 'Đến trang đăng nhập',
    };
  }
}
