part of '../../phone/pages/security/p2p_fraud_prevention_page.dart';

class _Disclosure extends StatelessWidget {
  const _Disclosure({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PFraudPreventionPage.disclosureKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.divider,
      padding: P2PSpacingTokens.p2pFraudInnerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _p2pFraudDisclosureLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.severity});

  final String severity;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: _severityLabel(severity),
      accentColor: _severityColor(severity),
    );
  }
}

String _categoryLabel(String category) {
  return switch (category) {
    'during' => 'Trong giao dịch',
    'after' => 'Sau giao dịch',
    _ => 'Trước giao dịch',
  };
}

String _severityLabel(String severity) {
  return switch (severity) {
    'medium' => 'Trung bình',
    'high' => 'Cao',
    _ => 'Nguy hiểm',
  };
}

Color _scoreColor(int score) {
  if (score >= 80) return AppColors.buy;
  if (score >= 50) return AppColors.warn;
  return AppColors.sell;
}

Color _severityColor(String severity) {
  return switch (severity) {
    'medium' => AppModuleAccents.p2p,
    'high' => AppColors.warn,
    _ => AppColors.sell,
  };
}

Color _actionColor(String toneKey) {
  return switch (toneKey) {
    'warning' => AppColors.warn,
    'muted' => AppColors.text2,
    _ => AppColors.sell,
  };
}

IconData _patternIcon(String iconKey) {
  return switch (iconKey) {
    'globe' => Icons.public_rounded,
    'bank' => Icons.account_balance_wallet_outlined,
    'user' => Icons.person_off_outlined,
    'triangle' => Icons.report_gmailerrorred_rounded,
    _ => Icons.credit_card_off_outlined,
  };
}

IconData _actionIcon(String iconKey) {
  return switch (iconKey) {
    'phone' => Icons.phone_outlined,
    'flag' => Icons.flag_outlined,
    _ => Icons.shield_outlined,
  };
}
