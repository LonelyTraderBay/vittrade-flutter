part of '../../phone/pages/tools/launchpad_gas_tracker_page.dart';

class _AllChainsSection extends StatelessWidget {
  const _AllChainsSection({
    required this.prices,
    required this.selectedChain,
    required this.onSelected,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final String selectedChain;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadGasTrackerPage.allChainsKey,
      child: VitPageSection(
        label: 'Tat ca chains',
        accentColor: AppColors.accent,
        children: [
          for (final price in prices)
            _ChainComparisonCard(
              price: price,
              selected: selectedChain == price.chain,
              onTap: () => onSelected(price.chain),
            ),
        ],
      ),
    );
  }
}

class _ChainComparisonCard extends StatelessWidget {
  const _ChainComparisonCard({
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final LaunchpadGasPriceDraft price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: selected
          ? price.accent.resolve().withValues(alpha: .35)
          : AppColors.cardBorder,
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      onTap: onTap,
      child: Row(
        children: [
          _ChainBadge(price: price),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.chain,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatGasValue(price.slow)} / ${_formatGasValue(price.standard)} / ${_formatGasValue(price.fast)} ${price.unit}',
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ],
            ),
          ),
          _TrendInline(price: price),
        ],
      ),
    );
  }
}

class _ChainBadge extends StatelessWidget {
  const _ChainBadge({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: LaunchpadSpacingTokens.launchpadBox32,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: price.accent.resolve().withValues(alpha: .14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Center(
          child: Text(
            price.chainIcon,
            style: AppTextStyles.micro.copyWith(
              color: price.accent.resolve(),
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _TrendInline extends StatelessWidget {
  const _TrendInline({required this.price});

  final LaunchpadGasPriceDraft price;

  @override
  Widget build(BuildContext context) {
    final color = _trendColor(price.trend);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _trendIcon(price.trend),
          color: color,
          size: LaunchpadSpacingTokens.launchpadIconSm,
        ),
        const SizedBox(width: AppSpacing.x1 + AppSpacing.hairlineStroke),
        Text(
          _formatChange(price.change24h),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}
