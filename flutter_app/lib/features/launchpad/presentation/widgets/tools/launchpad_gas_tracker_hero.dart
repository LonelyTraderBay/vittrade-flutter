part of '../../phone/pages/tools/launchpad_gas_tracker_page.dart';

class _FeaturedGasCard extends StatelessWidget {
  const _FeaturedGasCard({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_gas_station_outlined,
                color: AppModuleAccents.launchpad,
                size: LaunchpadSpacingTokens.launchpadIconLg,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Gas ${price.chain}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              VitStatusPill(
                label: _formatChange(price.change24h),
                icon: _trendIcon(price.trend),
                status: switch (price.trend) {
                  LaunchpadGasTrend.up => VitStatusPillStatus.success,
                  LaunchpadGasTrend.down => VitStatusPillStatus.error,
                  _ => VitStatusPillStatus.neutral,
                },
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              _TierValue(
                label: 'Slow',
                value: price.slow,
                color: AppColors.buy,
              ),
              _TierValue(
                label: 'Standard',
                value: price.standard,
                color: AppColors.primary,
              ),
              _TierValue(
                label: 'Fast',
                value: price.fast,
                color: AppColors.warn,
              ),
              _TierValue(
                label: 'Instant',
                value: price.instant,
                color: AppColors.sell,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${price.unit} · Cập nhật ${price.lastUpdated}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierValue extends StatelessWidget {
  const _TierValue({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            _formatGasValue(value),
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: LaunchpadSpacingTokens.launchpadLineHeightTight,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: LaunchpadSpacingTokens.launchpadLineHeightTight,
            ),
          ),
        ],
      ),
    );
  }
}
