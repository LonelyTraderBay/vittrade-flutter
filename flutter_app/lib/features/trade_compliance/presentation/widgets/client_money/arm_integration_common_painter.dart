part of '../../phone/pages/client_money/arm_integration_status_page.dart';

class _ArmStatusStyle {
  const _ArmStatusStyle({
    required this.color,
    required this.label,
    required this.icon,
  });

  final Color color;
  final String label;
  final IconData icon;
}

_ArmStatusStyle _statusStyle(String status) {
  return switch (status) {
    'healthy' => const _ArmStatusStyle(
      color: _armGreen,
      label: 'Healthy',
      icon: Icons.check_circle_outline,
    ),
    'degraded' => const _ArmStatusStyle(
      color: _armAmber,
      label: 'Degraded',
      icon: Icons.warning_amber_rounded,
    ),
    _ => const _ArmStatusStyle(
      color: _armRed,
      label: 'Down',
      icon: Icons.cancel_outlined,
    ),
  };
}

class _LatencyPainter extends CustomPainter {
  const _LatencyPainter({required this.points});

  final List<TradeArmLatencyPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = _armBorder.withValues(alpha: .62)
      ..strokeWidth = 1;
    final axis = Paint()
      ..color = AppColors.text3.withValues(alpha: .5)
      ..strokeWidth = 1;
    final chartRect = Rect.fromLTWH(58, 8, size.width - 66, size.height - 34);
    const maxValue = 60.0;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final label in const [60, 45, 30, 15, 0]) {
      final y = chartRect.bottom - (label / maxValue) * chartRect.height;
      _drawDashedLine(
        canvas,
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        grid,
      );
      textPainter.text = TextSpan(
        text: '$label',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(chartRect.left - textPainter.width - 8, y - 6),
      );
    }

    for (var i = 0; i < points.length; i++) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      _drawDashedLine(
        canvas,
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        grid,
      );
    }
    canvas.drawLine(chartRect.topLeft, chartRect.bottomLeft, axis);
    canvas.drawLine(chartRect.bottomLeft, chartRect.bottomRight, axis);

    _drawLine(
      canvas,
      chartRect,
      points.map((item) => item.registr.toDouble()).toList(),
      _armGreen,
      maxValue,
    );
    _drawLine(
      canvas,
      chartRect,
      points.map((item) => item.unavista.toDouble()).toList(),
      _armPrimary,
      maxValue,
    );
    _drawLine(
      canvas,
      chartRect,
      points.map((item) => item.bloomberg.toDouble()).toList(),
      _armAmber,
      maxValue,
    );

    for (var i = 0; i < points.length; i++) {
      final x = chartRect.left + chartRect.width * i / (points.length - 1);
      textPainter.text = TextSpan(
        text: points[i].time,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, chartRect.bottom + 8),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dash = 3.0;
    const gap = 3.0;
    final distance = (end - start).distance;
    if (distance == 0) {
      return;
    }
    final direction = Offset(
      (end.dx - start.dx) / distance,
      (end.dy - start.dy) / distance,
    );
    var drawn = 0.0;
    while (drawn < distance) {
      final segmentEnd = math.min(drawn + dash, distance);
      canvas.drawLine(
        start + direction * drawn,
        start + direction * segmentEnd,
        paint,
      );
      drawn += dash + gap;
    }
  }

  void _drawLine(
    Canvas canvas,
    Rect chartRect,
    List<double> values,
    Color color,
    double maxValue,
  ) {
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = chartRect.left + chartRect.width * i / (values.length - 1);
      final normalized = (values[i] / maxValue).clamp(0.0, 1.0).toDouble();
      final y = chartRect.bottom - normalized * chartRect.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = color);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _LatencyPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
