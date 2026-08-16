part of '../../phone/pages/event/prediction_advanced_chart_page.dart';

Path _seriesPath(
  Rect chart,
  List<double> values,
  double minValue,
  double maxValue,
) {
  final path = Path();
  for (var i = 0; i < values.length; i += 1) {
    final x = _scaleX(i, values.length, chart);
    final y = _scaleY(values[i], chart, minValue, maxValue);
    if (i == 0) {
      path.moveTo(x, y);
    } else {
      path.lineTo(x, y);
    }
  }
  return path;
}

void _drawSeries(
  Canvas canvas,
  Rect chart,
  List<double> values,
  double minValue,
  double maxValue,
  Color color, {
  double width = 2,
  bool dashed = false,
}) {
  final path = _seriesPath(chart, values, minValue, maxValue);
  final paint = Paint()
    ..color = color
    ..strokeWidth = width
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  if (!dashed) {
    canvas.drawPath(path, paint);
    return;
  }
  for (var i = 0; i < values.length - 1; i += 1) {
    _drawDashedLine(
      canvas,
      Offset(
        _scaleX(i, values.length, chart),
        _scaleY(values[i], chart, minValue, maxValue),
      ),
      Offset(
        _scaleX(i + 1, values.length, chart),
        _scaleY(values[i + 1], chart, minValue, maxValue),
      ),
      paint,
    );
  }
}

double _scaleX(int index, int count, Rect chart) {
  if (count <= 1) return chart.left;
  return chart.left + chart.width * index / (count - 1);
}

double _scaleY(double value, Rect chart, double minValue, double maxValue) {
  final ratio = ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);
  return chart.bottom - chart.height * ratio;
}

void _drawDashedHorizontal(Canvas canvas, Rect chart, double y, Color color) {
  _drawDashedLine(
    canvas,
    Offset(chart.left, y),
    Offset(chart.right, y),
    Paint()
      ..color = color
      ..strokeWidth = 1,
  );
}

void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dash = 3.0;
  const gap = 3.0;
  final vector = end - start;
  final distance = vector.distance;
  if (distance == 0) return;
  final direction = vector / distance;
  var current = 0.0;
  while (current < distance) {
    final next = math.min(current + dash, distance);
    canvas.drawLine(
      start + direction * current,
      start + direction * next,
      paint,
    );
    current += dash + gap;
  }
}

void _paintLabel(Canvas canvas, String label, Offset offset, Color color) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: label,
      style: AppTextStyles.numericMicro.copyWith(color: color),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  textPainter.paint(canvas, offset);
}
