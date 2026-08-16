part of '../../phone/pages/pair/pair_detail_page.dart';

class _PairChartPainter extends CustomPainter {
  const _PairChartPainter(this.series);

  final List<double> series;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(52, 12, size.width - 64, size.height - 42);
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    final labelStyle = AppTextStyles.micro.copyWith(color: AppColors.text3);
    final values = series.isEmpty ? [0.0, 1.0] : series;
    final minValue = values.reduce(math.min) - 120;
    final maxValue = values.reduce(math.max) + 120;

    for (var i = 0; i < 4; i += 1) {
      final y = plot.top + (plot.height / 3) * i;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      final value = maxValue - ((maxValue - minValue) / 3) * i;
      _drawText(
        canvas,
        value.toStringAsFixed(0),
        Offset(28, y - 8),
        labelStyle,
      );
    }

    final path = Path();
    for (var i = 0; i < values.length; i += 1) {
      final x = plot.left + (plot.width / (values.length - 1)) * i;
      final normalized = (values[i] - minValue) / (maxValue - minValue);
      final y = plot.bottom - normalized * plot.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(plot.right, plot.bottom)
      ..lineTo(plot.left, plot.bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.buy20, AppColors.buyTransparent],
      ).createShader(plot);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    const times = ['23:00', '09:00', '19:00', '05:00', '15:00'];
    for (var i = 0; i < times.length; i += 1) {
      final x = plot.left + (plot.width / (times.length - 1)) * i;
      _drawText(canvas, times[i], Offset(x - 14, plot.bottom + 8), labelStyle);
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _PairChartPainter oldDelegate) {
    return oldDelegate.series != series;
  }
}

TextStyle _tableHeaderStyle() {
  return AppTextStyles.micro.copyWith(color: AppColors.text3);
}

String _formatCompact(double value) {
  if (value >= 1000000000) {
    return (value / 1000000000).toStringAsFixed(2);
  }
  if (value >= 1000000) {
    return (value / 1000000).toStringAsFixed(2);
  }
  return value.toStringAsFixed(0);
}
