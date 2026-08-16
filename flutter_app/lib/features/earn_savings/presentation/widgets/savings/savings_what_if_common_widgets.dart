part of '../../phone/pages/savings/savings_what_if_page.dart';

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: _captionBold.copyWith(
                color: color ?? AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactBadge extends StatelessWidget {
  const _ImpactBadge({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              positive
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: color,
              size: EarnSpacingTokens.savingsWhatIfBadgeIcon,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '${positive ? '+' : ''}${value.toStringAsFixed(2)}%',
              style: _microBold.copyWith(
                color: color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.level});

  final SavingsWhatIfRiskLevel level;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(level);
    return Material(
      color: color.withValues(alpha: .14),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          _riskLabel(level),
          style: _microBold.copyWith(
            color: color,
            height: EarnSpacingTokens.savingsWhatIfRiskPillLineHeight,
          ),
        ),
      ),
    );
  }
}

class _MicroMetric extends StatelessWidget {
  const _MicroMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.isEmpty ? value : '$label: $value',
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: EarnSpacingTokens.savingsWhatIfRoundIconBox,
      child: Material(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
        child: Icon(
          icon,
          color: color,
          size: EarnSpacingTokens.savingsWhatIfInlineIcon,
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: EarnSpacingTokens.savingsWhatIfScoreRing,
      height: EarnSpacingTokens.savingsWhatIfScoreRing,
      child: CustomPaint(
        painter: _RingPainter(score: score, color: color),
        child: Center(
          child: Text(
            '$score',
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ),
    );
  }
}
