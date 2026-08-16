part of '../../phone/pages/dashboard/bot_performance_analytics_page.dart';

class _PnlChartPainter extends CustomPainter {
  const _PnlChartPainter(this.points, {this.progress = 1, this.scrubIndex});

  final List<TradeBotPnlPoint> points;
  final double progress;
  final int? scrubIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 8, size.width - 72, size.height - 42);
    if (points.isEmpty) return;

    var minPnl = points.first.pnl;
    var maxPnl = points.first.pnl;
    for (final point in points) {
      minPnl = math.min(minPnl, point.pnl);
      maxPnl = math.max(maxPnl, point.pnl);
    }
    if ((maxPnl - minPnl).abs() < 0.01) {
      maxPnl += 1;
      minPnl -= 1;
    }
    final pad = (maxPnl - minPnl) * 0.1;
    minPnl -= pad;
    maxPnl += pad;
    final span = maxPnl - minPnl;

    final gridPaint = Paint()
      ..color = _chartAxis.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = _chartAxis
      ..strokeWidth = 1;

    for (var i = 0; i < 5; i++) {
      final t = i / 4;
      final value = maxPnl - span * t;
      final y = chart.top + chart.height * t;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _paintText(
        canvas,
        '\$${value.toStringAsFixed(0)}',
        Offset(0, y - 6),
        AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        width: 42,
        align: TextAlign.right,
      );
    }

    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    final labelIndexes = <int>{
      0,
      if (points.length > 1) points.length - 1,
      if (points.length > 3) (points.length / 3).floor(),
      if (points.length > 3) ((points.length * 2) / 3).floor(),
    };

    for (final index in labelIndexes) {
      final x =
          chart.left + index / (points.length - 1).clamp(1, 999) * chart.width;
      _paintText(
        canvas,
        points[index].date,
        Offset(x - 18, chart.bottom + 10),
        AppTextStyles.micro.copyWith(color: AppColors.text3),
        width: 42,
        align: TextAlign.center,
      );
    }

    Offset pointAt(int i) {
      final x =
          chart.left + (i / (points.length - 1).clamp(1, 999)) * chart.width;
      final y = chart.bottom - ((points[i].pnl - minPnl) / span) * chart.height;
      return Offset(x, y);
    }

    final visibleCount = math.max(
      1,
      (points.length * progress.clamp(0.0, 1.0)).ceil(),
    );
    final path = Path();
    for (var i = 0; i < visibleCount; i++) {
      final p = pointAt(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    final last = pointAt(visibleCount - 1);
    final fillPath = Path.from(path)
      ..lineTo(last.dx, chart.bottom)
      ..lineTo(pointAt(0).dx, chart.bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _analyticsGreen.withValues(alpha: 0.28),
          _analyticsGreen.withValues(alpha: 0.0),
        ],
      ).createShader(chart);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = _analyticsGreen
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = _analyticsGreen;
    for (var i = 0; i < visibleCount; i++) {
      final p = pointAt(i);
      final isLast = i == visibleCount - 1;
      final isScrub = scrubIndex == i;
      canvas.drawCircle(p, isLast || isScrub ? 5.5 : 3.0, dotPaint);
    }

    final calloutIndex = scrubIndex ?? (visibleCount - 1);
    if (calloutIndex >= 0 && calloutIndex < points.length) {
      final p = pointAt(calloutIndex);
      final label = _formatSignedMoney(points[calloutIndex].pnl);
      final labelWidth = 64.0;
      final labelLeft = (p.dx - labelWidth / 2).clamp(
        chart.left,
        chart.right - labelWidth,
      );
      _paintText(
        canvas,
        label,
        Offset(labelLeft, math.max(chart.top, p.dy - 22)),
        AppTextStyles.micro.copyWith(
          color: _analyticsGreen,
          fontWeight: AppTextStyles.bold,
        ),
        width: labelWidth,
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PnlChartPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.progress != progress ||
      oldDelegate.scrubIndex != scrubIndex;
}

class _WinLossChartPainter extends CustomPainter {
  const _WinLossChartPainter(this.points);

  final List<TradeBotWinLossPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 6, size.width - 72, size.height - 36);
    final axisPaint = Paint()
      ..color = _chartAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    if (points.isEmpty) return;

    var maxCount = 1;
    for (final point in points) {
      maxCount = math.max(maxCount, math.max(point.wins, point.losses));
    }
    maxCount = (maxCount * 1.15).ceil().clamp(1, 999);

    final gridPaint = Paint()
      ..color = _chartAxis.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final t = i / 3;
      final value = (maxCount * (1 - t)).round();
      final y = chart.top + chart.height * t;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _paintText(
        canvas,
        '$value',
        Offset(4, y - 6),
        AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        width: 38,
        align: TextAlign.right,
      );
    }

    final groupWidth = chart.width / points.length;
    final barWidth = math.min(22.0, groupWidth * 0.28);
    final gap = math.max(6.0, groupWidth * 0.12);
    const radius = AppRadii.chartBarCorner;
    final winPaint = Paint()..color = _analyticsGreen;
    final lossPaint = Paint()..color = _analyticsRed;

    for (var i = 0; i < points.length; i++) {
      final center = chart.left + groupWidth * i + groupWidth / 2;
      final winHeight = points[i].wins / maxCount * chart.height;
      final lossHeight = points[i].losses / maxCount * chart.height;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            center - barWidth - gap / 2,
            chart.bottom - winHeight,
            barWidth,
            winHeight,
          ),
          topLeft: radius,
          topRight: radius,
        ),
        winPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
            center + gap / 2,
            chart.bottom - lossHeight,
            barWidth,
            lossHeight,
          ),
          topLeft: radius,
          topRight: radius,
        ),
        lossPaint,
      );
      _paintText(
        canvas,
        points[i].week,
        Offset(center - 24, chart.bottom + 8),
        AppTextStyles.micro.copyWith(color: AppColors.text3),
        width: 48,
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WinLossChartPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _DurationDonutPainter extends CustomPainter {
  const _DurationDonutPainter(this.distribution, {required this.colors});

  final List<TradeBotDurationDistribution> distribution;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = distribution.fold<int>(0, (sum, item) => sum + item.count);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    // Ring sits near the outer edge so the KPI hole stays clear (~52px).
    final radius = math.min(size.width, size.height) * 0.42;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;
    for (var i = 0; i < distribution.length; i++) {
      final sweep = distribution[i].count / total * math.pi * 2;
      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, start + .02, math.max(0, sweep - .04), false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DurationDonutPainter oldDelegate) =>
      oldDelegate.distribution != distribution || oldDelegate.colors != colors;
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  TextStyle style, {
  double width = 80,
  TextAlign align = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: style.copyWith(
        fontWeight: style.fontWeight ?? AppTextStyles.medium,
        height: _analyticsPainterLineHeight,
        decoration: TextDecoration.none,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
