part of '../../phone/pages/staking/staking_validator_health_monitor_page.dart';

class _ActionRequiredCard extends StatelessWidget {
  const _ActionRequiredCard({required this.snapshot});

  final StakingValidatorHealthMonitorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorHealthMonitorPage.actionKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn.withValues(alpha: 0.35),
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(snapshot.actionTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.actionBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.primarySoft,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.inputRadius,
                    ),
                  ),
                  child: Padding(
                    padding: EarnSpacingTokens.earnVerticalPaddingX3,
                    child: Center(
                      child: Text(
                        snapshot.actionLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.bg,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
      key: StakingValidatorHealthMonitorPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: VitRiskDisclaimerNote(
        message: note,
        height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  const _SmallButton({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.text1;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: textColor.withValues(alpha: color == null ? 0.06 : 0.15),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnVerticalPaddingX2,
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: textColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: AppSpacing.x2,
          height: AppSpacing.x2,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const CircleBorder(),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _UptimeTrendPainter extends CustomPainter {
  const _UptimeTrendPainter(this.points);

  final List<StakingUptimeHistoryPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gridPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chartRect.top + chartRect.height * i / 4;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }
    for (var i = 0; i < points.length; i++) {
      final x = points.length == 1
          ? chartRect.left
          : chartRect.left + chartRect.width * i / (points.length - 1);
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }

    _drawSeries(
      canvas,
      chartRect,
      points.map((point) => point.validatorOne).toList(),
      AppColors.buy,
    );
    _drawSeries(
      canvas,
      chartRect,
      points.map((point) => point.validatorTwo).toList(),
      AppColors.primarySoft,
    );
    _drawSeries(
      canvas,
      chartRect,
      points.map((point) => point.validatorThree).toList(),
      AppColors.warn,
    );
  }

  void _drawSeries(Canvas canvas, Rect rect, List<double> values, Color color) {
    if (values.isEmpty) return;
    const minValue = 98.0;
    const maxValue = 100.0;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? rect.left
          : rect.left + rect.width * i / (values.length - 1);
      final normalized = ((values[i] - minValue) / (maxValue - minValue)).clamp(
        0.0,
        1.0,
      );
      final y = rect.bottom - normalized * rect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    final dotFill = Paint()
      ..color = AppColors.bg
      ..style = PaintingStyle.fill;
    final dotStroke = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? rect.left
          : rect.left + rect.width * i / (values.length - 1);
      final normalized = ((values[i] - minValue) / (maxValue - minValue)).clamp(
        0.0,
        1.0,
      );
      final y = rect.bottom - normalized * rect.height;
      canvas.drawCircle(Offset(x, y), 3.2, dotFill);
      canvas.drawCircle(Offset(x, y), 3.2, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _UptimeTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

Color _statusColor(String status) {
  return switch (status) {
    'warning' => AppColors.warn,
    'critical' => AppColors.sell,
    _ => AppColors.buy,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'warning' => Icons.error_outline_rounded,
    'critical' => Icons.cancel_outlined,
    _ => Icons.check_circle_outline_rounded,
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'warning' => 'Warning',
    'critical' => 'Critical',
    _ => 'Healthy',
  };
}

VitStatusPillStatus _validatorVitStatus(String status) {
  return switch (status) {
    'warning' => VitStatusPillStatus.warning,
    'critical' => VitStatusPillStatus.error,
    _ => VitStatusPillStatus.success,
  };
}

String _formatPercent(double value) {
  final fixed = value.toStringAsFixed(2);
  return fixed.endsWith('0') ? value.toStringAsFixed(1) : fixed;
}

String _formatEth(double value) => VitFormat.count(value.round());
