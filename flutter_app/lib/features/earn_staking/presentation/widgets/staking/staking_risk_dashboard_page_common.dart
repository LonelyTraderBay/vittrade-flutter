part of '../../phone/pages/staking/staking_risk_dashboard_page.dart';

class _MiniRiskMetric extends StatelessWidget {
  const _MiniRiskMetric({
    required this.label,
    required this.value,
    this.color,
    this.borderColor,
  });

  final String label;
  final String value;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
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

class _ScorePill extends StatelessWidget {
  const _ScorePill({required this.score, required this.color});

  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.15),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Text(
          '$score/100',
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingRiskDashboardPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: VitRiskDisclaimerNote(
        message: note,
        height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
      ),
    );
  }
}

class _ExposurePiePainter extends CustomPainter {
  const _ExposurePiePainter(this.items);

  final List<StakingRiskExposureDraft> items;

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()..style = PaintingStyle.fill;
    for (final item in items) {
      final sweep = math.pi * 2 * item.percentage / 100;
      paint.color = _exposureColor(item.risk);
      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
    final border = Paint()
      ..color = AppColors.borderSolid
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, border);
  }

  @override
  bool shouldRepaint(covariant _ExposurePiePainter oldDelegate) {
    return oldDelegate.items != items;
  }
}

Color _riskColor(int score) {
  if (score < 25) return AppColors.buy;
  if (score < 50) return AppColors.warn;
  if (score < 75) return AppColors.riskHigh;
  return AppColors.sell;
}

String _riskLabel(int score) {
  if (score < 25) return 'Low Risk';
  if (score < 50) return 'Moderate Risk';
  if (score < 75) return 'High Risk';
  return 'Critical Risk';
}

VitStatusPillStatus _riskVitStatus(int score) {
  if (score < 25) return VitStatusPillStatus.success;
  if (score < 50) return VitStatusPillStatus.warning;
  if (score < 75) return VitStatusPillStatus.orange;
  return VitStatusPillStatus.error;
}

IconData _riskIcon(String status) {
  return switch (status) {
    'low' => Icons.shield_outlined,
    'critical' => Icons.warning_amber_rounded,
    _ => Icons.error_outline_rounded,
  };
}

Color _exposureColor(String risk) {
  return risk == 'low' ? AppColors.buy : AppColors.warn;
}

Color _eventColor(String type) {
  return switch (type) {
    'warning' => AppColors.warn,
    'resolved' => AppColors.buy,
    _ => AppColors.primarySoft,
  };
}

IconData _eventIcon(String type) {
  return switch (type) {
    'warning' => Icons.warning_amber_rounded,
    'resolved' => Icons.shield_outlined,
    _ => Icons.monitor_heart_outlined,
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'sell' => AppColors.sell,
    'buy' => AppColors.buy,
    'accent' => AppColors.accent,
    _ => AppColors.primarySoft,
  };
}

IconData _actionIcon(String tone) {
  return switch (tone) {
    'sell' => Icons.warning_amber_rounded,
    'buy' => Icons.shield_outlined,
    'accent' => Icons.verified_user_outlined,
    _ => Icons.monitor_heart_outlined,
  };
}
