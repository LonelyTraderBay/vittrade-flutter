part of '../../phone/pages/tools/launchpad_gas_tracker_page.dart';

class _EstimatorTab extends StatelessWidget {
  const _EstimatorTab({required this.estimates});

  final List<LaunchpadGasEstimateDraft> estimates;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadGasTrackerPage.estimatesKey,
      child: VitPageSection(
        label: 'Chi phi uoc tinh',
        accentColor: AppColors.warn,
        children: [
          for (final estimate in estimates) _EstimateCard(estimate: estimate),
        ],
      ),
    );
  }
}

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.estimate});

  final LaunchpadGasEstimateDraft estimate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadGasTrackerPage.estimateKey(estimate.operation),
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: AppColors.warn,
                size: LaunchpadSpacingTokens.launchpadIconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  estimate.operation,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${estimate.gasUnits} gas',
                style: AppTextStyles.numericMicro.copyWith(
                  color: AppColors.text3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final cost in estimate.costs) _EstimateCostRow(cost: cost),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Legend(label: 'Slow', color: AppColors.buy),
              SizedBox(width: AppSpacing.x3),
              _Legend(label: 'Standard', color: AppColors.primary),
              SizedBox(width: AppSpacing.x3),
              _Legend(label: 'Fast', color: AppColors.warn),
            ],
          ),
        ],
      ),
    );
  }
}

class _EstimateCostRow extends StatelessWidget {
  const _EstimateCostRow({required this.cost});

  final LaunchpadGasEstimateCostDraft cost;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  cost.chain,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              _CostText(cost.slow, AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              _CostText(cost.standard, AppColors.primary),
              const SizedBox(width: AppSpacing.x3),
              _CostText(cost.fast, AppColors.warn),
            ],
          ),
        ),
        const Divider(height: AppSpacing.hairlineStroke),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTextStyles.micro.copyWith(color: color));
  }
}

class _CostText extends StatelessWidget {
  const _CostText(this.value, this.color);

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: AppTextStyles.numericMicro.copyWith(
        color: color,
        fontWeight: AppTextStyles.medium,
      ),
    );
  }
}
