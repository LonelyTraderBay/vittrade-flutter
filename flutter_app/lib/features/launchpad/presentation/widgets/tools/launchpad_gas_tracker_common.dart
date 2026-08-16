part of '../../phone/pages/tools/launchpad_gas_tracker_page.dart';

class _GasChartPainter extends CustomPainter {
  const _GasChartPainter(this.price);

  final LaunchpadGasPriceDraft price;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(34, 12, size.width - 44, size.height - 28);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = chart.top + chart.height * i / 4;
      _drawDashedLine(
        canvas,
        Offset(chart.left, y),
        Offset(chart.right, y),
        gridPaint,
      );
    }
    for (var i = 0; i <= 4; i++) {
      final x = chart.left + chart.width * i / 4;
      _drawDashedLine(
        canvas,
        Offset(x, chart.top),
        Offset(x, chart.bottom),
        gridPaint,
      );
    }

    final slow = _series(price.standard * .7, 25);
    final standard = _series(price.standard, 25);
    final fast = _series(price.standard * 1.4, 25);
    final maxValue = [
      ...slow,
      ...standard,
      ...fast,
      price.instant,
    ].reduce(math.max);

    _drawSeries(canvas, chart, slow, maxValue, AppColors.buy);
    _drawSeries(canvas, chart, standard, maxValue, AppColors.primary);
    _drawSeries(canvas, chart, fast, maxValue, AppColors.warn);

    final labelPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
    for (final label in const ['32', '16', '8', '0']) {
      final index = const ['32', '16', '8', '0'].indexOf(label);
      labelPainter.text = TextSpan(
        text: label,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(0, chart.top + chart.height * index / 3 - 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GasChartPainter oldDelegate) {
    return oldDelegate.price.chain != price.chain;
  }
}

List<double> _series(double base, int count) {
  return [
    for (var i = 0; i < count; i++)
      math.max(
        .01,
        base *
            (1 +
                (math.sin(i * .48) + math.cos(i * .27)) * .16 +
                math.sin(i * .93) * .05),
      ),
  ];
}

void _drawSeries(
  Canvas canvas,
  Rect chart,
  List<double> values,
  double maxValue,
  Color color,
) {
  final path = Path();
  for (var i = 0; i < values.length; i++) {
    final x = chart.left + chart.width * i / (values.length - 1);
    final y = chart.bottom - chart.height * (values[i] / maxValue);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  canvas.drawPath(
    path,
    Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2,
  );
}

void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dash = 4.0;
  const gap = 5.0;
  final delta = end - start;
  final distance = delta.distance;
  final direction = delta / distance;
  var progress = 0.0;
  while (progress < distance) {
    final segmentStart = start + direction * progress;
    final segmentEnd = start + direction * math.min(progress + dash, distance);
    canvas.drawLine(segmentStart, segmentEnd, paint);
    progress += dash + gap;
  }
}

String _formatGasValue(double value) {
  if (value < 1) return value.toStringAsFixed(2);
  if (value == value.roundToDouble()) return value.round().toString();
  return value.toStringAsFixed(1);
}

String _formatChange(double value) {
  if (value == 0) return '0%';
  final prefix = value > 0 ? '+' : '';
  return '$prefix${value.toStringAsFixed(1)}%';
}

Color _trendColor(LaunchpadGasTrend trend) {
  return switch (trend) {
    LaunchpadGasTrend.up => AppColors.sell,
    LaunchpadGasTrend.down => AppColors.buy,
    LaunchpadGasTrend.stable => AppColors.text3,
  };
}

IconData _trendIcon(LaunchpadGasTrend trend) {
  return switch (trend) {
    LaunchpadGasTrend.up => Icons.trending_up_rounded,
    LaunchpadGasTrend.down => Icons.trending_down_rounded,
    LaunchpadGasTrend.stable => Icons.remove_rounded,
  };
}
