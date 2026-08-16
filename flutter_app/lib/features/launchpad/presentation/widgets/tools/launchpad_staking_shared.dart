part of '../../phone/pages/tools/launchpad_staking_page.dart';

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({
    required this.label,
    required this.color,
    required this.size,
  });

  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: color.withValues(alpha: .34),
              width: LaunchpadSpacingTokens.launchpadBorderWidthFocus,
            ),
            borderRadius: AppRadii.lgRadius,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.extraBold,
              height: LaunchpadSpacingTokens.launchpadLineHeightTight,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: LaunchpadSpacingTokens.launchpadPaddingX3,
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

LaunchpadStakingTierDraft? _currentTier(
  List<LaunchpadStakingTierDraft> tiers,
  double amount,
) {
  LaunchpadStakingTierDraft? selected;
  for (final tier in tiers) {
    if (amount >= tier.minStake) selected = tier;
  }
  return selected;
}

LaunchpadStakingTierDraft? _nextTier(
  List<LaunchpadStakingTierDraft> tiers,
  double amount,
) {
  for (final tier in tiers) {
    if (amount < tier.minStake) return tier;
  }
  return null;
}

String _formatUsd(double value) => '\$${_comma(value.round())}';

String _formatToken(double value) => _comma(value.round());

String _formatApy(double value) {
  final rounded = value.toStringAsFixed(
    value.truncateToDouble() == value ? 0 : 1,
  );
  return rounded;
}

String _comma(int value) {
  final sign = value < 0 ? '-' : '';
  final text = value.abs().toString();
  final buffer = StringBuffer(sign);
  for (var index = 0; index < text.length; index++) {
    final fromEnd = text.length - index;
    buffer.write(text[index]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
