part of '../../phone/pages/savings/savings_auto_rebalance_page.dart';

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        children: [
          Icon(icon, color: color, size: _savingsRebalanceInlineIcon),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: _smBold.copyWith(color: AppColors.text1)),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _AxisText extends StatelessWidget {
  const _AxisText(this.text, {this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

double _totalDrift(
  List<SavingsRebalancePositionDraft> positions,
  SavingsRebalanceStrategyDraft strategy,
) {
  final total = positions.fold<double>(0, (sum, position) {
    final target = strategy.allocations[position.asset] ?? position.targetPct;
    return sum + (position.currentPct - target).abs();
  });
  return total / 2;
}

Color _assetColor(SavingsRebalancePositionDraft position) {
  return _assetColorName(position.asset);
}

Color _assetColorName(String asset) {
  switch (asset) {
    case 'USDT':
      return AppColors.buy;
    case 'BTC':
      return AppColors.primary;
    case 'SOL':
      return AppColors.accent;
    case 'ETH':
      return AppColors.text2;
    default:
      return AppColors.text3;
  }
}

Color _driftColor(double drift) {
  if (drift < 2.5) return AppColors.buy;
  if (drift < 8) return AppColors.primary;
  return AppColors.sell;
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(value >= 1000 ? 2 : 0);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) return '\$$buffer.${parts.last}';
  return '\$$buffer';
}
