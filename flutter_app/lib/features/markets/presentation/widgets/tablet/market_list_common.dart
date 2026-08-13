import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

const marketListPrimary = AppColors.primary;
const marketListPredictionAccent = AppColors.accent;
const marketListArenaAccent = AppColors.caution;

class MarketListSparklinePainter extends CustomPainter {
  const MarketListSparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      final y =
          size.height -
          ((values[i] - minValue) / range * (size.height - 6)) -
          3;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant MarketListSparklinePainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

String marketListFormatPrice(double value) {
  if (value >= 1) {
    return _formatFixed(value, 2);
  }
  if (value >= 0.01) {
    return _formatFixed(value, 4);
  }
  return _formatFixed(value, 6);
}

String _formatFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}

String marketListFormatPct(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String marketListFormatVolume(double value) {
  if (value >= 1e9) {
    return '\$${(value / 1e9).toStringAsFixed(1)}B';
  }
  if (value >= 1e6) {
    return '\$${(value / 1e6).toStringAsFixed(1)}M';
  }
  if (value >= 1e3) {
    return '\$${(value / 1e3).toStringAsFixed(1)}K';
  }
  return '\$${value.toStringAsFixed(0)}';
}
