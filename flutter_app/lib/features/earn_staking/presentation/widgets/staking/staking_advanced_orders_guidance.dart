part of '../../phone/pages/staking/staking_advanced_orders_page.dart';

class _HowItWorks extends StatelessWidget {
  const _HowItWorks({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingAdvancedOrdersPage.howItWorksKey,
      label: 'How It Works',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < snapshot.howItWorks.length; i++) ...[
                if (i > 0) const Divider(color: AppColors.borderSolid),
                Text(
                  snapshot.howItWorks[i].title,
                  style: AppTextStyles.baseMedium,
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.howItWorks[i].description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RiskDisclosure extends StatelessWidget {
  const _RiskDisclosure({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.riskKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.sell20,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.sell,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.riskTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.riskBody,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
