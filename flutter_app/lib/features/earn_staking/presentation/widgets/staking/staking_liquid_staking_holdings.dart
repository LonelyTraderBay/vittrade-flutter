part of '../../phone/pages/staking/staking_liquid_staking_page.dart';

class _HoldingsTab extends StatelessWidget {
  const _HoldingsTab({required this.snapshot, required this.onStakeNow});

  final StakingLiquidStakingSnapshot snapshot;
  final VoidCallback onStakeNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingLiquidStakingPage.holdingsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: AppSpacing.cardPaddingHero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng giá trị Liquid Staking',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Text(
                          _formatUsd(snapshot.holdingsValue),
                          style: AppTextStyles.numericDisplayXl,
                        ),
                      ],
                    ),
                  ),
                  const Material(
                    color: AppColors.primary12,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.xlRadius,
                      side: BorderSide(
                        color: AppColors.primary30,
                        width: EarnSpacingTokens.stakingProductIconBorderWidth,
                      ),
                    ),
                    child: SizedBox(
                      width: AppSpacing.buttonHero,
                      height: AppSpacing.buttonHero,
                      child: Icon(
                        Icons.water_drop_rounded,
                        color: AppColors.primarySoft,
                        size: AppSpacing.iconLg,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              const Row(
                children: [
                  Expanded(child: _HoldingMetric(label: 'stETH Balance')),
                  SizedBox(width: AppSpacing.x3),
                  Expanded(child: _HoldingMetric(label: 'rETH Balance')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _EmptyHoldings(onStakeNow: onStakeNow),
      ],
    );
  }
}

class _HoldingMetric extends StatelessWidget {
  const _HoldingMetric({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          const Text('0.0000', style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _EmptyHoldings extends StatelessWidget {
  const _EmptyHoldings({required this.onStakeNow});

  final VoidCallback onStakeNow;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingLiquidStakingPage.emptyKey,
      children: [
        const Icon(
          Icons.water_drop_outlined,
          color: AppColors.text3,
          size: AppSpacing.x7,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        Text(
          'Bạn chưa có liquid token nào',
          style: AppTextStyles.body.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          fullWidth: false,
          onPressed: onStakeNow,
          child: const Text('Stake ngay'),
        ),
      ],
    );
  }
}
