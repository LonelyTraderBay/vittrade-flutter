part of '../../phone/pages/disclosures/riy_calculator_page.dart';

class _RiyChartPainter extends CustomPainter {
  const _RiyChartPainter(this.projections);

  final List<TradeRiyProjection> projections;

  @override
  void paint(Canvas canvas, Size size) {
    if (projections.length < 2) return;

    const leftPad = 66.0;
    const rightPad = 6.0;
    const topPad = 7.0;
    const bottomPad = 25.0;
    final chart = Rect.fromLTWH(
      leftPad,
      topPad,
      size.width - leftPad - rightPad,
      size.height - topPad - bottomPad,
    );

    final gridPaint = Paint()
      ..color = _riyGrid
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = AppColors.text3.withValues(alpha: .48)
      ..strokeWidth = 1.2;

    const maxValue = 16000.0;
    const yTicks = [16000, 12000, 8000, 4000, 0];
    for (final tick in yTicks) {
      final y = chart.top + (1 - tick / maxValue) * chart.height;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _drawLabel(
        canvas,
        '$tick',
        Offset(chart.left - 8, y - 7),
        alignRight: true,
      );
    }

    final maxYear = math.max(1, projections.last.year);
    for (final projection in projections) {
      final x = chart.left + (projection.year / maxYear) * chart.width;
      canvas.drawLine(Offset(x, chart.top), Offset(x, chart.bottom), gridPaint);
      _drawLabel(
        canvas,
        '${projection.year}',
        Offset(x, chart.bottom + 7),
        centered: true,
      );
    }

    canvas
      ..drawLine(
        Offset(chart.left, chart.top),
        Offset(chart.left, chart.bottom),
        axisPaint,
      )
      ..drawLine(
        Offset(chart.left, chart.bottom),
        Offset(chart.right, chart.bottom),
        axisPaint,
      );

    _drawSeries(canvas, chart, maxValue, _riyGreen, (point) {
      return point.withoutCosts;
    });
    _drawSeries(canvas, chart, maxValue, _riyRed, (point) => point.withCosts);
  }

  void _drawSeries(
    Canvas canvas,
    Rect chart,
    double maxValue,
    Color color,
    double Function(TradeRiyProjection point) valueFor,
  ) {
    final maxYear = math.max(1, projections.last.year);
    final path = Path();
    for (var index = 0; index < projections.length; index += 1) {
      final point = projections[index];
      final x = chart.left + (point.year / maxYear) * chart.width;
      final y =
          chart.top +
          (1 - (valueFor(point).clamp(0, maxValue).toDouble() / maxValue)) *
              chart.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset offset, {
    bool alignRight = false,
    bool centered = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final dx = alignRight
        ? offset.dx - painter.width
        : centered
        ? offset.dx - painter.width / 2
        : offset.dx;
    painter.paint(canvas, Offset(dx, offset.dy));
  }

  @override
  bool shouldRepaint(covariant _RiyChartPainter oldDelegate) {
    return oldDelegate.projections != projections;
  }
}

OutlineInputBorder _fieldBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: AppRadii.smRadius,
    borderSide: BorderSide(color: color.withValues(alpha: .72)),
  );
}

List<TradeRiyProjection> _buildProjections({
  required double investment,
  required double expectedReturn,
  required double totalCosts,
  required int years,
}) {
  final safeYears = years.clamp(1, 20).toInt();
  return [
    for (var year = 0; year <= safeYears; year += 1)
      TradeRiyProjection(
        year: year,
        withoutCosts:
            investment * math.pow(1 + expectedReturn / 100, year).toDouble(),
        withCosts:
            investment *
            math.pow(1 + (expectedReturn - totalCosts) / 100, year).toDouble(),
      ),
  ];
}

String _formatInput(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}

String _formatEur(double value) => formatTradeEur(value);
