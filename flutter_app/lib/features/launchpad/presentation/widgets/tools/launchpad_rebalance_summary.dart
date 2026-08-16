part of '../../phone/pages/tools/launchpad_rebalance_page.dart';

class LaunchpadRebalanceSummaryCard extends StatelessWidget {
  const LaunchpadRebalanceSummaryCard({
    super.key,
    required this.txCount,
    required this.totalGas,
    required this.strategy,
  });

  final int txCount;
  final double totalGas;
  final LaunchpadRebalanceStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: LaunchpadSpacingTokens.launchpadIconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Tom tat rebalance',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          LaunchpadRebalanceSummaryRow(
            label: 'So giao dich can thuc hien',
            value: '$txCount tx',
          ),
          LaunchpadRebalanceSummaryRow(
            label: 'Gas uoc tinh',
            value: '~\$${totalGas.toStringAsFixed(2)}',
          ),
          LaunchpadRebalanceSummaryRow(
            label: 'Chien luoc',
            value: strategy.name,
          ),
          LaunchpadRebalanceSummaryRow(
            label: 'Muc rui ro',
            value: launchpadRebalanceRiskLabel(strategy.riskLevel),
            color: strategy.accent.resolve(),
          ),
        ],
      ),
    );
  }
}

class LaunchpadRebalanceSummaryRow extends StatelessWidget {
  const LaunchpadRebalanceSummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        shape: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LaunchpadRebalanceWarningBanner extends StatelessWidget {
  const LaunchpadRebalanceWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.warn08,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.warn15),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPaddingX3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: LaunchpadSpacingTokens.launchpadIconLg,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                'Day la de xuat tu dong dua tren ty le muc tieu. Gia token co the thay doi giua luc xem va luc thuc hien. Luon kiem tra lai truoc khi giao dich.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
