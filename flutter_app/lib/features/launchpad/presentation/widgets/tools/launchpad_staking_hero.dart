part of '../../phone/pages/tools/launchpad_staking_page.dart';

class _StakingHero extends StatelessWidget {
  const _StakingHero({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadStakingPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      padding: LaunchpadSpacingTokens.launchpadPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const SizedBox(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.buy15,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.buy20),
                      borderRadius: AppRadii.lgRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.currency_exchange_rounded,
                      color: AppColors.buy,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng giá trị stake',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      _formatUsd(snapshot.totalStaked),
                      style: AppTextStyles.numericDisplayXl.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Pools hoạt động',
                  value: '${snapshot.activePoolCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Phần thưởng chờ',
                  value: _formatToken(snapshot.totalPendingRewards),
                  valueColor: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Vị trí',
                  value: '${snapshot.positions.length}',
                  valueColor: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: LaunchpadSpacingTokens.launchpadMetricCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.extraBold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskDisclosure extends StatelessWidget {
  const _RiskDisclosure();

  @override
  Widget build(BuildContext context) {
    return const VitInfoCallout(
      key: LaunchpadStakingPage.disclaimerKey,
      icon: Icons.warning_amber_rounded,
      accentColor: AppColors.warn,
      iconSize: AppSpacing.iconSm,
      message: 'Lưu ý rủi ro đầu tư',
      messageColor: AppColors.warn,
      messageWeight: AppTextStyles.bold,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.text3,
        size: AppSpacing.iconSm,
      ),
    );
  }
}
