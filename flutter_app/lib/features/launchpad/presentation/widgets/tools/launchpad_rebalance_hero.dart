part of '../../phone/pages/tools/launchpad_rebalance_page.dart';

class LaunchpadRebalanceHero extends StatelessWidget {
  const LaunchpadRebalanceHero({
    super.key,
    required this.totalValue,
    required this.assetCount,
    required this.totalDeviation,
  });

  final double totalValue;
  final int assetCount;
  final double totalDeviation;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.pie_chart_outline_rounded,
                color: AppModuleAccents.launchpad,
                size: LaunchpadSpacingTokens.launchpadIconLg,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Giá trị danh mục',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            '\$${launchpadRebalanceMoney(totalValue)}',
            style: AppTextStyles.numericDisplayXl.copyWith(
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '$assetCount tài sản · Lệch: ${totalDeviation.toStringAsFixed(1)}%',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
