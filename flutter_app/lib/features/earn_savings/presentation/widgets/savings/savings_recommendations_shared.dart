part of '../../phone/pages/savings/savings_recommendations_page.dart';

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.mdRadius,
          side: BorderSide(color: color.withValues(alpha: 0.22)),
        ),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.xlRadius,
          side: BorderSide(color: color.withValues(alpha: 0.25)),
        ),
      ),
      child: SizedBox.square(
        dimension: AppSpacing.x7,
        child: Center(
          child: Text(
            asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.micro.height,
            ),
          ),
        ),
      ),
    );
  }
}

String _formatUsd(double value) {
  final rounded = value.abs() >= 1000
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  final parts = rounded.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) buffer.write('.${parts.last}');
  return '\$$buffer';
}

String _formatPercent(double value) {
  if (value == value.roundToDouble()) return '${value.toStringAsFixed(0)}%';
  return '${value.toStringAsFixed(1)}%';
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primary,
    _ => AppColors.primary,
  };
}

String _riskToleranceLabel(SavingsProfileRiskTolerance value) {
  return switch (value) {
    SavingsProfileRiskTolerance.conservative => 'Thận trọng',
    SavingsProfileRiskTolerance.moderate => 'Trung bình',
    SavingsProfileRiskTolerance.aggressive => 'Tích cực',
  };
}

String _horizonLabel(SavingsInvestmentHorizon value) {
  return switch (value) {
    SavingsInvestmentHorizon.short => 'Ngắn hạn',
    SavingsInvestmentHorizon.medium => 'Trung hạn',
    SavingsInvestmentHorizon.long => 'Dài hạn',
  };
}

String _liquidityLabel(SavingsLiquidityNeed value) {
  return switch (value) {
    SavingsLiquidityNeed.high => 'Cao',
    SavingsLiquidityNeed.medium => 'Trung bình',
    SavingsLiquidityNeed.low => 'Thấp',
  };
}

String _strategyRiskLabel(SavingsStrategyRiskLevel value) {
  return switch (value) {
    SavingsStrategyRiskLevel.low => 'Thấp',
    SavingsStrategyRiskLevel.medium => 'Trung bình',
    SavingsStrategyRiskLevel.high => 'Cao',
  };
}

Color _strategyRiskColor(SavingsStrategyRiskLevel value) {
  return switch (value) {
    SavingsStrategyRiskLevel.low => AppColors.buy,
    SavingsStrategyRiskLevel.medium => AppColors.warn,
    SavingsStrategyRiskLevel.high => AppColors.sell,
  };
}

Color _insightColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.primary,
    EarnRiskLevel.high => AppColors.warn,
  };
}

IconData _insightIcon(String iconKey) {
  return switch (iconKey) {
    'target' => Icons.track_changes_rounded,
    'calculator' => Icons.calculate_outlined,
    'shield' => Icons.shield_outlined,
    'clock' => Icons.schedule_rounded,
    _ => Icons.auto_awesome_rounded,
  };
}
