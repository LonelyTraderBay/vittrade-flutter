import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/features/auth/presentation/controllers/password_reset_flow_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/auth_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/widgets/auth_hero_icon_box.dart';
import 'package:vit_trade_flutter/features/auth/domain/validators/password_policy.dart';

part '../../phone/widgets/reset_password_page_sections.dart';

const _authPrimary = AppColors.primary;
const _authPrimary10 = AppColors.primary12;
const _authPrimary30 = AppColors.primary30;

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  static const contentKey = Key('sc006_reset_content');
  static const expiredKey = Key('sc006_reset_expired');
  static const newPasswordFieldKey = Key('sc006_reset_new_password_field');
  static const confirmPasswordFieldKey = Key(
    'sc006_reset_confirm_password_field',
  );
  static const newPasswordToggleKey = Key('sc006_reset_new_password_toggle');
  static const confirmPasswordToggleKey = Key(
    'sc006_reset_confirm_password_toggle',
  );
  static const submitKey = Key('sc006_reset_submit');
  static const retryKey = Key('sc006_reset_retry');
  static const loginKey = Key('sc006_reset_login');

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _submitting = false;
  bool _success = false;
  bool _confirmTouched = false;
  String _error = '';

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _newPassword => _newPasswordController.text;

  String get _confirmPassword => _confirmPasswordController.text;

  bool get _allRulesPass => passwordMeetsPolicy(_newPassword);

  bool get _passwordsMatch => _newPassword == _confirmPassword;

  bool get _showMismatch =>
      _confirmTouched && _confirmPassword.isNotEmpty && !_passwordsMatch;

  bool get _showMatch =>
      _confirmTouched && _confirmPassword.isNotEmpty && _passwordsMatch;

  bool _canSubmit(PasswordResetChallenge? challenge) =>
      !_submitting &&
      challenge != null &&
      _allRulesPass &&
      _passwordsMatch &&
      _confirmPassword.isNotEmpty;

  void _goBack() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.authLogin,
      mode: BackNavigationMode.historyThenFallback,
    );
  }

  void _handleNewPasswordChanged() {
    setState(() {
      _error = '';
    });
  }

  void _handleConfirmPasswordChanged() {
    setState(() {
      _confirmTouched = true;
      _error = '';
    });
  }

  Future<void> _handleSubmit() async {
    final challenge = ref.read(passwordResetChallengeProvider);
    if (challenge == null || !_canSubmit(challenge)) return;

    setState(() {
      _submitting = true;
      _error = '';
    });

    try {
      final result = await ref
          .read(authControllerProvider)
          .resetPassword(
            email: challenge.email,
            otp: challenge.otp,
            newPassword: _newPassword,
          );

      if (!mounted) return;
      if (!result.success) {
        setState(() {
          _error =
              result.errorMessage ??
              'Không thể cập nhật mật khẩu. Vui lòng thử lại.';
        });
        return;
      }

      ref.read(passwordResetChallengeControllerProvider).clear();
      setState(() => _success = true);
    } catch (error) {
      if (mounted) {
        setState(() => _error = authOperationErrorMessage(error));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = ref.watch(passwordResetChallengeProvider);

    return VitPageLayout(
      semanticLabel: 'Đặt lại mật khẩu',
      semanticIdentifier: 'SC-006',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Đặt lại mật khẩu',
          subtitle: 'Xác thực · Bảo mật',
          showBack: true,
          onBack: _goBack,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: ResetPasswordPage.contentKey,
                padding: AuthSpacingTokens.authScrollBottomPadding,
                child: VitPageContent(
                  rhythm: VitPageRhythm.form,
                  children: _success
                      ? _successContent
                      : challenge == null
                      ? _expiredContent
                      : _formContent(challenge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _formContent(PasswordResetChallenge challenge) => [
    const _ResetHero(),
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitInput(
          controller: _newPasswordController,
          fieldKey: ResetPasswordPage.newPasswordFieldKey,
          label: 'Mật khẩu mới',
          hintText: '••••••••',
          prefix: const Icon(Icons.lock_outline_rounded),
          suffix: VitIconButton(
            key: ResetPasswordPage.newPasswordToggleKey,
            icon: _showNewPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            tooltip: _showNewPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
            onPressed: () {
              setState(() => _showNewPassword = !_showNewPassword);
            },
            variant: VitIconButtonVariant.transparent,
            size: VitIconButtonSize.sm,
          ),
          errorText: _newPassword.isNotEmpty && !_allRulesPass ? ' ' : null,
          obscureText: !_showNewPassword,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: (_) => _handleNewPasswordChanged(),
        ),
        const Padding(padding: AuthSpacingTokens.authOtpDigitTopPadding),
        _PasswordRulesList(password: _newPassword),
      ],
    ),
    VitInput(
      controller: _confirmPasswordController,
      fieldKey: ResetPasswordPage.confirmPasswordFieldKey,
      label: 'Nhập lại mật khẩu',
      hintText: '••••••••',
      prefix: const Icon(Icons.lock_outline_rounded),
      suffix: VitIconButton(
        key: ResetPasswordPage.confirmPasswordToggleKey,
        icon: _showConfirmPassword
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        tooltip: _showConfirmPassword ? 'Ẩn mật khẩu' : 'Hiện mật khẩu',
        onPressed: () {
          setState(() => _showConfirmPassword = !_showConfirmPassword);
        },
        variant: VitIconButtonVariant.transparent,
        size: VitIconButtonSize.sm,
      ),
      errorText: _showMismatch ? 'Mật khẩu không khớp' : null,
      obscureText: !_showConfirmPassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.newPassword],
      onChanged: (_) => _handleConfirmPasswordChanged(),
      onSubmitted: (_) => _handleSubmit(),
    ),
    if (_showMatch) const _InlinePasswordState(success: true),
    if (_error.isNotEmpty) _InlinePasswordState(error: _error),
    VitCtaButton(
      key: ResetPasswordPage.submitKey,
      onPressed: _canSubmit(challenge) ? _handleSubmit : null,
      loading: _submitting,
      variant: VitCtaButtonVariant.auth,
      child: Text(_submitting ? 'Đang cập nhật...' : 'Cập nhật mật khẩu'),
    ),
    VitCtaButton(
      key: ResetPasswordPage.loginKey,
      onPressed: _submitting ? null : () => context.go(AppRoutePaths.authLogin),
      variant: VitCtaButtonVariant.ghost,
      fullWidth: false,
      height: AuthSpacingTokens.authTextButtonHeightLg,
      padding: AuthSpacingTokens.authInlineTextButtonPadding,
      child: Text(
        'Quay lại đăng nhập',
        style: AppTextStyles.caption.copyWith(
          color: _authPrimary,
          fontWeight: AppTextStyles.medium,
        ),
      ),
    ),
  ];

  List<Widget> get _expiredContent => [
    const _ResetExpired(),
    VitCtaButton(
      key: ResetPasswordPage.retryKey,
      onPressed: () => context.go(AppRoutePaths.authForgotPassword),
      variant: VitCtaButtonVariant.auth,
      child: const Text('Xác minh lại'),
    ),
    VitCtaButton(
      key: ResetPasswordPage.loginKey,
      onPressed: () => context.go(AppRoutePaths.authLogin),
      variant: VitCtaButtonVariant.ghost,
      fullWidth: false,
      height: AuthSpacingTokens.authTextButtonHeightLg,
      padding: AuthSpacingTokens.authInlineTextButtonPadding,
      child: Text(
        'Quay lại đăng nhập',
        style: AppTextStyles.caption.copyWith(
          color: _authPrimary,
          fontWeight: AppTextStyles.medium,
        ),
      ),
    ),
  ];

  List<Widget> get _successContent => [
    const _ResetSuccess(),
    VitCtaButton(
      key: ResetPasswordPage.loginKey,
      onPressed: () => context.go(AppRoutePaths.authLogin),
      variant: VitCtaButtonVariant.auth,
      child: const Text('Đăng nhập'),
    ),
  ];
}
