part of '../../phone/pages/event/prediction_advanced_chart_page.dart';

class _ProbabilityPainter extends CustomPainter {
  const _ProbabilityPainter({
    required this.points,
    required this.support,
    required this.resistance,
    required this.showMA7,
    required this.showMA25,
    required this.showBB,
  });

  final List<PredictionChartPointDraft> points;
  final double support;
  final double resistance;
  final bool showMA7;
  final bool showMA25;
  final bool showBB;

  @override
  void paint(Canvas canvas, Size size) {
    const minValue = .50;
    const maxValue = .75;
    const left = 66.0;
    const top = 6.0;
    const right = 6.0;
    const bottom = 34.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - right,
      size.height - top - bottom,
    );
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (final value in [.75, .63, .565, .50]) {
      final y = _scaleY(value, chart, minValue, maxValue);
      textPainter.text = TextSpan(
        text: value == .50
            ? '0.5'
            : value.toStringAsFixed(value == .565 ? 3 : 2),
        style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(left - textPainter.width - 8, y - 6));
    }
    for (final index in [1, 3, 5, 7, 9]) {
      final x = _scaleX(index, points.length, chart);
      textPainter.text = TextSpan(
        text: points[index].time,
        style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chart.bottom + 8),
      );
    }

    _drawDashedHorizontal(
      canvas,
      chart,
      _scaleY(resistance, chart, minValue, maxValue),
      AppColors.sell,
    );
    _drawDashedHorizontal(
      canvas,
      chart,
      _scaleY(support, chart, minValue, maxValue),
      AppColors.buy,
    );
    _paintLabel(
      canvas,
      'Resistance',
      Offset(
        chart.left + 124,
        _scaleY(resistance, chart, minValue, maxValue) - 7,
      ),
      AppColors.sell,
    );
    _paintLabel(
      canvas,
      'Support',
      Offset(chart.left + 126, _scaleY(support, chart, minValue, maxValue) - 7),
      AppColors.buy,
    );

    if (showBB) {
      _drawSeries(
        canvas,
        chart,
        points.map((point) => point.bbUpper).toList(),
        minValue,
        maxValue,
        AppColors.warn,
        width: 1,
        dashed: true,
      );
      _drawSeries(
        canvas,
        chart,
        points.map((point) => point.bbLower).toList(),
        minValue,
        maxValue,
        AppColors.warn,
        width: 1,
        dashed: true,
      );
    }
    if (showMA7) {
      _drawSeries(
        canvas,
        chart,
        points.map((point) => point.ma7).toList(),
        minValue,
        maxValue,
        AppColors.buy,
        width: 1.6,
      );
    }
    if (showMA25) {
      _drawSeries(
        canvas,
        chart,
        points.map((point) => point.ma25).toList(),
        minValue,
        maxValue,
        _purple,
        width: 1.6,
      );
    }
    _drawPriceArea(canvas, chart, minValue, maxValue);
  }

  void _drawPriceArea(
    Canvas canvas,
    Rect chart,
    double minValue,
    double maxValue,
  ) {
    final values = points.map((point) => point.price).toList();
    final path = _seriesPath(chart, values, minValue, maxValue);
    final fillPath = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primary30, AppColors.transparent],
      ).createShader(chart);
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(
      path,
      Paint()
        ..color = _predictionPrimary
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ProbabilityPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.showMA7 != showMA7 ||
        oldDelegate.showMA25 != showMA25 ||
        oldDelegate.showBB != showBB;
  }
}

class _VolumePainter extends CustomPainter {
  const _VolumePainter({required this.points});

  final List<PredictionChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 66.0;
    const top = 4.0;
    const bottom = 28.0;
    final chart = Rect.fromLTWH(
      left,
      top,
      size.width - left - 6,
      size.height - top - bottom,
    );
    final axisPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(chart.bottomLeft, chart.bottomRight, axisPaint);
    canvas.drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
    final maxVolume = points
        .map((point) => point.volume)
        .reduce(math.max)
        .toDouble();
    final barWidth = chart.width / points.length * .68;
    for (var i = 0; i < points.length; i += 1) {
      final height = chart.height * points[i].volume / maxVolume;
      final x =
          chart.left +
          chart.width * i / points.length +
          (chart.width / points.length - barWidth) / 2;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, chart.bottom - height, barWidth, height),
        topLeft: AppRadii.xsCorner,
        topRight: AppRadii.xsCorner,
      );
      canvas.drawRRect(rect, Paint()..color = _predictionPrimary);
    }
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (final value in [0, 16000, 32000]) {
      final y = chart.bottom - chart.height * value / 32000;
      textPainter.text = TextSpan(
        text: '$value',
        style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(left - textPainter.width - 8, y - 6));
    }
    for (final index in [1, 3, 5, 7, 9]) {
      final x = chart.left + chart.width * (index + .5) / points.length;
      textPainter.text = TextSpan(
        text: points[index].time,
        style: AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chart.bottom + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VolumePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
