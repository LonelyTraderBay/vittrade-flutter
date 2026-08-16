part of '../../phone/pages/staking/staking_liquid_staking_page.dart';

class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid({required this.snapshot});

  final StakingLiquidStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingLiquidStakingPage.benefitsKey,
      label: 'Lợi ích Liquid Staking',
      accentColor: AppColors.primary,
      children: [
        GridView.builder(
          itemCount: snapshot.benefits.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: EarnSpacingTokens.stakingProductGridColumns,
            crossAxisSpacing: AppSpacing.x4,
            mainAxisSpacing: AppSpacing.x4,
            childAspectRatio:
                EarnSpacingTokens.stakingProductLiquidBenefitAspect,
          ),
          itemBuilder: (context, index) {
            final benefit = snapshot.benefits[index];
            return VitCard(
              radius: VitCardRadius.large,
              padding: AppSpacing.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: AppColors.primary12,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                      side: BorderSide(color: AppColors.primary30),
                    ),
                    child: SizedBox(
                      width: AppSpacing.ctaHeight,
                      height: AppSpacing.ctaHeight,
                      child: Icon(
                        _benefitIcon(benefit.icon),
                        color: AppColors.primarySoft,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    benefit.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    benefit.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

IconData _benefitIcon(String icon) {
  return switch (icon) {
    'zap' => Icons.bolt_rounded,
    'trend' => Icons.trending_up_rounded,
    'shield' => Icons.shield_outlined,
    'swap' => Icons.swap_horiz_rounded,
    _ => Icons.water_drop_outlined,
  };
}
