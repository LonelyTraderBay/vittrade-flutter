part of '../../phone/pages/staking/staking_auto_compound_page.dart';

class _CompoundChartPainter extends CustomPainter {
  const _CompoundChartPainter({required this.points});

  final List<StakingAutoCompoundPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final chart = Rect.fromLTWH(
      AppSpacing.x6,
      AppSpacing.x2,
      size.width - AppSpacing.x7,
      size.height - AppSpacing.x6,
    );
    final values = [
      for (final point in points) point.withCompound,
      for (final point in points) point.withoutCompound,
      0.0,
    ];
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final span = math.max(maxValue - minValue, 1);

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    for (var i = 0; i <= 4; i++) {
      final y = chart.bottom - chart.height * i / 4;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final value = minValue + span * i / 4;
      labelPainter.text = TextSpan(
        text: '\$${(value / 1000).toStringAsFixed(1)}k',
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      );
      labelPainter.layout(maxWidth: AppSpacing.x6 - AppSpacing.x2);
      labelPainter.paint(
        canvas,
        Offset(
          chart.left - labelPainter.width - AppSpacing.x3,
          y - labelPainter.height / 2,
        ),
      );
    }

    Path buildPath(double Function(StakingAutoCompoundPointDraft point) value) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final point = points[i];
        final x = chart.left + chart.width * i / (points.length - 1);
        final y =
            chart.bottom - ((value(point) - minValue) / span) * chart.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final withoutPaint = Paint()
      ..color = AppColors.sell
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final withPaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(buildPath((point) => point.withoutCompound), withoutPaint);
    canvas.drawPath(buildPath((point) => point.withCompound), withPaint);
  }

  @override
  bool shouldRepaint(covariant _CompoundChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _frequencyLabel(String frequency) {
  return switch (frequency) {
    'daily' => 'Hàng ngày',
    'weekly' => 'Hàng tuần',
    'monthly' => 'Hàng tháng',
    _ => frequency,
  };
}

String _formatAmount(double value) {
  if (value >= 1000) return value.toStringAsFixed(0);
  if (value >= 1) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }
  return value.toString();
}

String _formatCurrency(double value, {bool compact = false}) =>
    compact ? VitFormat.usdWhole(value) : VitFormat.usd(value);

double _parseDouble(String value, double fallback) {
  return double.tryParse(value.replaceAll(',', '').trim()) ?? fallback;
}

int _parseInt(String value, int fallback) {
  return int.tryParse(value.trim()) ?? fallback;
}
