part of '../pages/register_page.dart';

class _AgreementRow extends StatelessWidget {
  const _AgreementRow({required this.agreed, required this.onTap, this.error});

  final bool agreed;
  final VoidCallback onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          checked: agreed,
          label: 'Đồng ý điều khoản dịch vụ',
          child: InkWell(
            key: RegisterPage.agreementKey,
            onTap: onTap,
            borderRadius: AppRadii.inputRadius,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AuthSpacingTokens.authAgreementCheckMargin,
                  child: SizedBox.square(
                    dimension: AuthSpacingTokens.authAgreementCheckSize,
                    child: Material(
                      color: agreed ? _authPrimary : AppColors.transparent,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: hasError
                              ? AppColors.sell
                              : agreed
                              ? _authPrimary
                              : AppColors.borderSolid,
                          width: AuthSpacingTokens.authAgreementCheckBorder,
                        ),
                      ),
                      child: agreed
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.onAccent,
                              size: AuthSpacingTokens.authInlineCheckIcon,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'Tôi đã đọc và đồng ý với ',
                      children: [
                        TextSpan(
                          text: 'Điều khoản dịch vụ',
                          style: AppTextStyles.caption.copyWith(
                            color: _authPrimary,
                          ),
                        ),
                        const TextSpan(text: ' và '),
                        TextSpan(
                          text: 'Chính sách bảo mật',
                          style: AppTextStyles.caption.copyWith(
                            color: _authPrimary,
                          ),
                        ),
                        const TextSpan(text: ' của VitTrade.'),
                      ],
                    ),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AuthSpacingTokens.authAgreementLineHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const Padding(padding: AuthSpacingTokens.authTopGapX2),
          Text(
            error!,
            style: AppTextStyles.micro.copyWith(color: AppColors.sell),
          ),
        ],
      ],
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final checks = [
      for (final rule in passwordPolicyRules)
        _PasswordCheck(rule.label, rule.test(password)),
    ];
    final score = passwordStrengthScore(password);
    final color = switch (score) {
      0 || 1 => AppColors.sell,
      2 => AppColors.warn,
      3 || 4 => AppColors.buy,
      _ => AppColors.text3,
    };
    final label = switch (score) {
      1 => 'Yếu',
      2 => 'Trung bình',
      3 => 'Mạnh',
      4 => 'Rất mạnh',
      _ => '',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSegmentedProgressBar(
          segmentCount: 4,
          filledCount: score,
          filledColor: color,
          height: AuthSpacingTokens.authPasswordStrengthHeight,
        ),
        const Padding(padding: AuthSpacingTokens.authTopGapX3),
        Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x2,
          children: [
            for (final check in checks)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    check.ok
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    size: AuthSpacingTokens.authPasswordStrengthIcon,
                    color: check.ok ? AppColors.buy : AppColors.text3,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    check.label,
                    style: AppTextStyles.micro.copyWith(
                      color: check.ok ? AppColors.buy : AppColors.text3,
                    ),
                  ),
                ],
              ),
          ],
        ),
        if (label.isNotEmpty)
          Text(
            'Mật khẩu $label',
            style: AppTextStyles.caption.copyWith(color: color),
          ),
      ],
    );
  }
}

class _PasswordCheck {
  const _PasswordCheck(this.label, this.ok);

  final String label;
  final bool ok;
}
