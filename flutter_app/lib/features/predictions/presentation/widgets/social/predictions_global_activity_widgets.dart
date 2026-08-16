part of '../../phone/pages/social/predictions_global_activity_page.dart';

class _LiveStats extends StatelessWidget {
  const _LiveStats({required this.snapshot});

  final PredictionGlobalActivitySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.settings_input_antenna_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                  Positioned(
                    right: -AppSpacing.hairlineStroke,
                    top: -AppSpacing.hairlineStroke,
                    child: Material(
                      color: AppColors.buy,
                      shape: CircleBorder(),
                      child: SizedBox.square(dimension: AppSpacing.x1),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Feed',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Real-time market activity',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'Volume (1h)',
                  value: _formatVolume(snapshot.totalVolume),
                ),
              ),
              const SizedBox(
                width: 1,
                height: AppSpacing.x6,
                child: ColoredBox(color: AppColors.border),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: 'Buys',
                        value: '${snapshot.buyCount}',
                        valueColor: AppColors.buy,
                      ),
                    ),
                    Expanded(
                      child: _StatBox(
                        label: 'Sells',
                        value: '${snapshot.sellCount}',
                        valueColor: AppColors.sell,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _AmountFilters extends StatelessWidget {
  const _AmountFilters({required this.active, required this.onSelected});

  final double active;
  final ValueChanged<double> onSelected;

  @override
  Widget build(BuildContext context) {
    const filters = [
      (label: 'All', value: 0.0),
      (label: '\$50+', value: 50.0),
      (label: '\$100+', value: 100.0),
      (label: '\$500+', value: 500.0),
      (label: '\$1K+', value: 1000.0),
    ];

    return Row(
      children: [
        const Icon(
          Icons.filter_alt_outlined,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          'Min amount:',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in filters) ...[
                  _AmountChip(
                    key: _amountFilterKey(filter.value),
                    label: filter.label,
                    active: active == filter.value,
                    onTap: () => onSelected(filter.value),
                  ),
                  const SizedBox(width: AppSpacing.x1),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: label,
      selected: active,
      onTap: onTap,
      accentColor: _predictionPrimary,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
    );
  }
}

Key _amountFilterKey(double value) {
  if (value == 0) return PredictionsGlobalActivityPage.allFilterKey;
  if (value == 100) return PredictionsGlobalActivityPage.amount100FilterKey;
  if (value == 500) return PredictionsGlobalActivityPage.amount500FilterKey;
  return Key('sc034_filter_${value.toInt()}');
}

String _formatVolume(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(0)}K';
  return '\$${value.toStringAsFixed(0)}';
}
