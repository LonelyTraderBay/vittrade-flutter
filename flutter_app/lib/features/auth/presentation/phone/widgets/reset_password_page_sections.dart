part of '../pages/reset_password_page.dart';

class _ResetExpired extends StatelessWidget {
  const _ResetExpired();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ResetPasswordPage.expiredKey,
      padding: AuthSpacingTokens.authStateVerticalPadding,
      child: Column(
        children: [
          const AuthHeroIconBox(
            dimension: AuthSpacingTokens.authHeroIconBoxMd,
            shape: CircleBorder(
              side: BorderSide(
                color: AppColors.warningBorder,
                width: AppSpacing.hairlineStroke,
              ),
            ),
            fillColor: AppColors.warn10,
            child: Icon(
              Icons.lock_clock_outlined,
              color: AppColors.warn,
              size: AuthSpacingTokens.authHeroIconLg,
            ),
          ),
          const Padding(padding: AuthSpacingTokens.authTopGapX6),
          const Text(
            'Phiên xác minh đã hết hạn',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle,
          ),
          const Padding(padding: AuthSpacingTokens.authTopGapX3),
          Text(
            'Vui lòng xác minh OTP lại để tạo mật khẩu mới. '
            'Mã OTP không được lưu trong URL.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: AuthSpacingTokens.authReadableLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetHero extends StatelessWidget {
  const _ResetHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AuthHeroIconBox(
          dimension: AuthSpacingTokens.authHeroIconBoxSm,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.cardRadius,
            side: BorderSide(
              color: _authPrimary30,
              width: AppSpacing.borderWidth,
            ),
          ),
          fillColor: _authPrimary10,
          child: Icon(
            Icons.lock_outline_rounded,
            color: _authPrimary,
            size: AuthSpacingTokens.authHeroIconMd,
          ),
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX5),
        const Text(
          'Tạo mật khẩu mới',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle,
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX3),
        Text(
          'Chọn mật khẩu mạnh để bảo vệ tài khoản của bạn.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: AuthSpacingTokens.authReadableLineHeight,
          ),
        ),
      ],
    );
  }
}

class _PasswordRulesList extends StatelessWidget {
  const _PasswordRulesList({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final rule in passwordPolicyRules) ...[
          _PasswordRuleRow(label: rule.label, pass: rule.test(password)),
          if (rule != passwordPolicyRules.last)
            const Padding(padding: AuthSpacingTokens.authCompactTopPadding),
        ],
      ],
    );
  }
}

class _PasswordRuleRow extends StatelessWidget {
  const _PasswordRuleRow({required this.label, required this.pass});

  final String label;
  final bool pass;

  @override
  Widget build(BuildContext context) {
    final color = pass ? AppColors.buy : AppColors.text3;
    return Row(
      children: [
        SizedBox.square(
          dimension: AuthSpacingTokens.authInlineCheckIcon,
          child: Material(
            color: pass ? AppColors.buy15 : AppColors.hoverBg,
            shape: const CircleBorder(),
            child: Icon(
              Icons.check_rounded,
              color: color,
              size: AuthSpacingTokens.authInlineIconSm,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

class _InlinePasswordState extends StatelessWidget {
  const _InlinePasswordState({this.success = false, this.error});

  final bool success;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final color = success ? AppColors.buy : AppColors.sell;
    final text = success ? 'Mật khẩu khớp' : error ?? 'Mật khẩu không khớp';
    final icon = success
        ? Icons.check_circle_outline_rounded
        : Icons.error_outline_rounded;

    return Row(
      children: [
        Icon(icon, color: color, size: AuthSpacingTokens.authInlineIcon),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(text, style: AppTextStyles.micro.copyWith(color: color)),
        ),
      ],
    );
  }
}

class _ResetSuccess extends StatelessWidget {
  const _ResetSuccess();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AuthSpacingTokens.authStateVerticalPadding,
      child: Column(
        children: [
          const SizedBox.square(
            dimension: AuthSpacingTokens.authStateIconBox,
            child: Material(
              color: AppColors.buy15,
              shape: CircleBorder(
                side: BorderSide(
                  color: AppColors.buy20,
                  width: AppSpacing.hairlineStroke,
                ),
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AuthSpacingTokens.authStateIconLg,
              ),
            ),
          ),
          const Padding(padding: AuthSpacingTokens.authTopGapX6),
          const Text(
            'Đổi mật khẩu thành công!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle,
          ),
          const Padding(padding: AuthSpacingTokens.authTopGapX3),
          Text(
            'Mật khẩu của bạn đã được cập nhật.\n'
            'Vui lòng đăng nhập lại với mật khẩu mới.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: AuthSpacingTokens.authReadableLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
