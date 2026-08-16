part of '../../phone/pages/security/p2p_2fa_settings_page.dart';

class _SecurityRecommendation extends StatelessWidget {
  const _SecurityRecommendation({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2P2FASettingsPage.recommendationKey,
      radius: VitCardRadius.standard,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.primary20,
      padding: P2PSpacingTokens.p2pTwoFactorInnerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppModuleAccents.p2p,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khuyến nghị bảo mật',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  text,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: _p2pTwoFactorCaptionLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      size: VitStatusPillSize.sm,
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: color.withValues(alpha: .1),
      borderRadius: AppRadii.lgRadius,
      child: Padding(
        padding: P2PSpacingTokens.p2pSecurityDetailsActionPadding,
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: color,
              size: P2PSpacingTokens.p2pSecurityDetailsInlineIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: _p2pTwoFactorNoticeLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _methodColor(String colorKey) {
  return switch (colorKey) {
    'warning' => AppColors.warn,
    'p2p' => AppModuleAccents.p2p,
    _ => AppColors.buy,
  };
}

IconData _methodIcon(String iconKey) {
  return switch (iconKey) {
    'sms' => Icons.phone_iphone_rounded,
    'authenticator' => Icons.key_rounded,
    'email' => Icons.mail_outline_rounded,
    _ => Icons.security_rounded,
  };
}
