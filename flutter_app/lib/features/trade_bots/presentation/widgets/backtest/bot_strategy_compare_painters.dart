part of '../../phone/pages/backtest/bot_strategy_compare_page.dart';

class _EquityChartPainter extends CustomPainter {
  const _EquityChartPainter(this.points, this.strategies);

  final List<TradeBotCompareEquityPoint> points;
  final List<TradeBotCompareStrategy> strategies;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 8, size.width - 90, size.height - 55);
    final axisPaint = Paint()
      ..color = _compareAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, 450, 900, 1350, 1800]) {
      final y = chart.bottom - (value / 1800) * chart.height;
      _paintText(
        canvas,
        '\$$value',
        Offset(10, y - 6),
        AppColors.text3,
        width: 48,
        align: TextAlign.right,
      );
    }
    for (var i = 0; i < points.length; i++) {
      final x =
          chart.left + i / (points.length - 1).clamp(1, 999) * chart.width;
      _paintText(
        canvas,
        points[i].date,
        Offset(x - 14, chart.bottom + 10),
        AppColors.text3,
        width: 30,
        align: TextAlign.center,
      );
    }

    for (final strategy in strategies) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final x =
            chart.left + i / (points.length - 1).clamp(1, 999) * chart.width;
        final y =
            chart.bottom -
            (points[i].valueFor(strategy.id) / 1900).clamp(0, 1) * chart.height;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = Color(strategy.colorHex)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    final legendY = size.height - 18;
    var legendX = size.width / 2 - 70;
    for (final strategy in strategies) {
      final color = Color(strategy.colorHex);
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(legendX, legendY),
        Offset(legendX + 10, legendY),
        paint,
      );
      canvas.drawCircle(
        Offset(legendX + 5, legendY),
        2.5,
        Paint()..color = color,
      );
      _paintText(
        canvas,
        strategy.name,
        Offset(legendX + 14, legendY - 6),
        color,
        width: 90,
      );
      legendX += 106;
    }
  }

  @override
  bool shouldRepaint(covariant _EquityChartPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.strategies != strategies;
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter(this.strategies);

  final List<TradeBotCompareStrategy> strategies;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 10);
    const radius = 84.0;
    final labels = [
      'Lợi nhuận',
      'Sharpe',
      'Tỷ lệ thắng',
      'Hệ số lợi nhuận',
      'Rủi ro thấp',
    ];
    final gridPaint = Paint()
      ..color = AppColors.text3
      ..strokeWidth = .7
      ..style = PaintingStyle.stroke;

    for (final scale in [.25, .5, .75, 1.0]) {
      final path = Path();
      for (var i = 0; i < labels.length; i++) {
        final point = _radarPoint(center, radius * scale, i, labels.length);
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }
    for (var i = 0; i < labels.length; i++) {
      final point = _radarPoint(center, radius, i, labels.length);
      canvas.drawLine(center, point, gridPaint);
      _paintText(
        canvas,
        labels[i],
        Offset(point.dx - 36, point.dy - 7),
        AppColors.text2,
        width: 72,
        align: TextAlign.center,
      );
    }

    for (final strategy in strategies) {
      final color = Color(strategy.colorHex);
      final values = _radarValues(strategy);
      final path = Path();
      for (var i = 0; i < values.length; i++) {
        final point = _radarPoint(
          center,
          radius * values[i].clamp(0, 100) / 100,
          i,
          values.length,
        );
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      path.close();
      canvas
        ..drawPath(path, Paint()..color = color.withValues(alpha: .15))
        ..drawPath(
          path,
          Paint()
            ..color = color
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke,
        );
    }

    var legendX = center.dx - 92;
    final legendY = size.height - 20;
    for (final strategy in strategies) {
      final color = Color(strategy.colorHex);
      canvas.drawRect(
        Rect.fromLTWH(legendX, legendY - 6, 14, 10),
        Paint()..color = color,
      );
      _paintText(
        canvas,
        strategy.name,
        Offset(legendX + 18, legendY - 8),
        color,
        width: 100,
      );
      legendX += 118;
    }
  }

  List<double> _radarValues(TradeBotCompareStrategy strategy) {
    final metrics = strategy.metrics;
    return [
      metrics.totalReturn,
      metrics.sharpeRatio / 3 * 100,
      metrics.winRate,
      metrics.profitFactor / 3 * 100,
      math.max(0, 100 + metrics.maxDrawdown),
    ];
  }

  Offset _radarPoint(Offset center, double radius, int index, int count) {
    final angle = -math.pi / 2 + math.pi * 2 * index / count;
    return Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.strategies != strategies;
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  Color color, {
  double width = 80,
  TextAlign align = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
        height: TradeSpacingTokens.tradeBotLineHeightTight,
        decoration: TextDecoration.none,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
