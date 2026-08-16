part of '../../phone/pages/analytics/performance_attribution_page.dart';

class _LegendItem {
  const _LegendItem(this.label, this.color);

  final String label;
  final Color color;
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.items});

  final List<_LegendItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final item in items) ...[
          SizedBox(
            width: TradeSpacingTokens.tradeBotAttributionLegendLineWidth,
            height: TradeSpacingTokens.tradeBotAttributionLegendLineHeight,
            child: ColoredBox(color: item.color),
          ),
          const SizedBox(
            width: TradeSpacingTokens.tradeBotAttributionLegendItemGap,
          ),
          Text(
            item.label,
            style: AppTextStyles.micro.copyWith(
              color: item.color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            width: TradeSpacingTokens.tradeBotAttributionLegendGroupGap,
          ),
        ],
      ],
    );
  }
}

class _ReturnDecompositionPainter extends CustomPainter {
  const _ReturnDecompositionPainter(this.points);

  final List<TradePerformanceReturnPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(58, 8, size.width - 68, size.height - 42);
    _drawGrid(canvas, plot, yLabels: const ['16', '12', '8', '4', '0']);

    final marketPath = Path();
    final alphaPath = Path();
    final areaPath = Path();
    final minY = 0.0;
    final maxY = 16.0;
    Offset pointFor(TradePerformanceReturnPoint point, double value) {
      final x = plot.left + (point.day - 1) / 29 * plot.width;
      final y = plot.bottom - ((value - minY) / (maxY - minY)) * plot.height;
      return Offset(x, y);
    }

    for (var i = 0; i < points.length; i++) {
      final market = pointFor(points[i], points[i].market);
      final total = pointFor(points[i], points[i].total);
      if (i == 0) {
        marketPath.moveTo(market.dx, market.dy);
        alphaPath.moveTo(total.dx, total.dy);
        areaPath.moveTo(total.dx, plot.bottom);
        areaPath.lineTo(total.dx, total.dy);
      } else {
        marketPath.lineTo(market.dx, market.dy);
        alphaPath.lineTo(total.dx, total.dy);
        areaPath.lineTo(total.dx, total.dy);
      }
    }
    areaPath
      ..lineTo(pointFor(points.last, points.last.total).dx, plot.bottom)
      ..close();

    canvas.drawPath(
      areaPath,
      Paint()
        ..color = _attributionPurple.withValues(alpha: .28)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      marketPath,
      Paint()
        ..color = _attributionGray
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
    canvas.drawPath(
      alphaPath,
      Paint()
        ..color = _attributionPurple
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    _drawXAxis(canvas, plot);
  }

  @override
  bool shouldRepaint(covariant _ReturnDecompositionPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _DrawdownPainter extends CustomPainter {
  const _DrawdownPainter(this.points);

  final List<TradePerformanceDrawdownPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(54, 8, size.width - 64, size.height - 36);
    _drawGrid(canvas, plot, yLabels: const ['0', '-2', '-4', '-6', '-8']);
    final path = Path();
    final fill = Path();
    Offset pointFor(TradePerformanceDrawdownPoint point) {
      final x = plot.left + (point.day - 1) / 29 * plot.width;
      final y = plot.top + (point.drawdown.abs() / 9) * plot.height;
      return Offset(x, y);
    }

    for (var i = 0; i < points.length; i++) {
      final offset = pointFor(points[i]);
      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
        fill.moveTo(offset.dx, plot.top);
        fill.lineTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
        fill.lineTo(offset.dx, offset.dy);
      }
    }
    fill
      ..lineTo(pointFor(points.last).dx, plot.top)
      ..close();
    canvas.drawPath(
      fill,
      Paint()..color = _attributionRed.withValues(alpha: .22),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = _attributionRed
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
    _drawXAxis(canvas, plot);
  }

  @override
  bool shouldRepaint(covariant _DrawdownPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _ProjectionPainter extends CustomPainter {
  const _ProjectionPainter(this.paths);

  final List<List<TradePerformanceProjectionPoint>> paths;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(58, 8, size.width - 68, size.height - 40);
    _drawGrid(canvas, plot, yLabels: const ['6500', '6000', '5500', '5000']);
    for (var i = 0; i < paths.length; i++) {
      final line = Path();
      for (var j = 0; j < paths[i].length; j++) {
        final p = paths[i][j];
        final x = plot.left + (p.day - 1) / 29 * plot.width;
        final y = plot.bottom - ((p.value - 4800) / 1800) * plot.height;
        if (j == 0) {
          line.moveTo(x, y);
        } else {
          line.lineTo(x, y);
        }
      }
      canvas.drawPath(
        line,
        Paint()
          ..color = _attributionPurple.withValues(alpha: i == 0 ? .9 : .35)
          ..strokeWidth = i == 0 ? 2 : 1.2
          ..style = PaintingStyle.stroke,
      );
    }
    _drawXAxis(canvas, plot);
  }

  @override
  bool shouldRepaint(covariant _ProjectionPainter oldDelegate) {
    return oldDelegate.paths != paths;
  }
}

class _CorrelationPainter extends CustomPainter {
  const _CorrelationPainter(this.points);

  final List<TradePerformanceCorrelationPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(54, 8, size.width - 64, size.height - 38);
    _drawGrid(canvas, plot, yLabels: const ['2', '1', '0', '-1', '-2']);
    final axisPaint = Paint()
      ..color = AppColors.surface3
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(plot.left + plot.width / 2, plot.top),
      Offset(plot.left + plot.width / 2, plot.bottom),
      axisPaint,
    );
    canvas.drawLine(
      Offset(plot.left, plot.top + plot.height / 2),
      Offset(plot.right, plot.top + plot.height / 2),
      axisPaint,
    );
    final dotPaint = Paint()..color = _attributionPrimary;
    for (final point in points) {
      final x = plot.left + ((point.marketReturn + 2.5) / 5) * plot.width;
      final y = plot.bottom - ((point.yourReturn + 2.5) / 5) * plot.height;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CorrelationPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

void _drawGrid(Canvas canvas, Rect plot, {required List<String> yLabels}) {
  final gridPaint = Paint()
    ..color = AppColors.surfaceNavyDarker
    ..strokeWidth = 1;
  final axisPaint = Paint()
    ..color = AppColors.surfaceNavyStroke
    ..strokeWidth = 1;
  for (var i = 0; i < 14; i++) {
    final x = plot.left + i / 13 * plot.width;
    canvas.drawLine(Offset(x, plot.top), Offset(x, plot.bottom), gridPaint);
  }
  for (var i = 0; i < yLabels.length; i++) {
    final y = plot.top + i / (yLabels.length - 1) * plot.height;
    canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
    _drawChartText(
      canvas,
      yLabels[i],
      Offset(plot.left - 12, y - 6),
      align: TextAlign.right,
      width: 34,
    );
  }
  canvas.drawLine(plot.bottomLeft, plot.bottomRight, axisPaint);
  canvas.drawLine(plot.topLeft, plot.bottomLeft, axisPaint);
}

void _drawXAxis(Canvas canvas, Rect plot) {
  for (var day = 2; day <= 30; day += 2) {
    final x = plot.left + (day - 1) / 29 * plot.width;
    _drawChartText(canvas, '$day', Offset(x - 8, plot.bottom + 8), width: 18);
  }
  _drawChartText(canvas, 'Ngày', Offset(plot.center.dx - 18, plot.bottom + 22));
  _drawChartText(
    canvas,
    '%',
    Offset(plot.left - 54, plot.center.dy - 6),
    width: 30,
  );
}

void _drawChartText(
  Canvas canvas,
  String text,
  Offset offset, {
  TextAlign align = TextAlign.center,
  double width = 40,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.attributionText,
        fontWeight: FontWeight.w500,
      ),
    ),
    textAlign: align,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
