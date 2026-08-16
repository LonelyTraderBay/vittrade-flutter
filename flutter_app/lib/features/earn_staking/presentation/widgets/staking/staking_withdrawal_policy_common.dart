part of '../../phone/pages/staking/staking_withdrawal_policy_page.dart';

class _CalculationRow extends StatelessWidget {
  const _CalculationRow({required this.row});

  final StakingWithdrawalCalculationRowDraft row;

  @override
  Widget build(BuildContext context) {
    final color = row.tone == null ? AppColors.text1 : _toneColor(row.tone!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            row.label,
            style: AppTextStyles.caption.copyWith(
              color: row.highlight ? AppColors.text1 : AppColors.text3,
              fontWeight: row.highlight
                  ? AppTextStyles.bold
                  : AppTextStyles.normal,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          row.value,
          textAlign: TextAlign.end,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: row.highlight
                ? AppTextStyles.bold
                : AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _stakingWithdrawalCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: _stakingWithdrawalNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: _stakingWithdrawalNoticeLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warningBg,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppColors.warningBorder),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: _stakingWithdrawalNoticeIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: _stakingWithdrawalNoticeLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: _stakingWithdrawalBulletPadding,
          child: SizedBox(
            width: _stakingWithdrawalBulletSize,
            height: _stakingWithdrawalBulletSize,
            child: Material(color: color, shape: const CircleBorder()),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _stakingWithdrawalBulletLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: _stakingWithdrawalBadgePadding,
        child: Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _stakingWithdrawalBadgeLineHeight,
          ),
        ),
      ),
    );
  }
}

Color _toneColor(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy,
    StakingDisclosureRiskLevel.medium => AppColors.warn,
    StakingDisclosureRiskLevel.high => AppColors.sell,
  };
}
