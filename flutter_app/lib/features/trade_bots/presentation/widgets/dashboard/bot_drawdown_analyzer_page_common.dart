part of '../../phone/pages/dashboard/bot_drawdown_analyzer_page.dart';

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.insights});

  final List<TradeBotDrawdownInsight> insights;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân tích sụt giảm vốn',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final insight in insights) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppSpacing.x5,
                  child: insight.symbol == 'alert'
                      ? Text(
                          '!',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption.copyWith(
                            color: Color(insight.colorHex),
                          ),
                        )
                      : Icon(
                          Icons.check_rounded,
                          color: Color(insight.colorHex),
                          size: AppSpacing.iconSm,
                        ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    insight.text,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (insight != insights.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: padding,
      borderColor: AppColors.cardBorder,
      child: child,
    );
  }
}

class _UnderwaterPainter extends CustomPainter {
  const _UnderwaterPainter(this.points);

  final List<TradeBotUnderwaterPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 6, size.width - 88, size.height - 42);
    final axisPaint = Paint()
      ..color = _drawdownAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, -3, -6, -9, -12]) {
      final y = _scaleY(value.toDouble(), chart);
      _paintText(
        canvas,
        '$value%',
        Offset(12, y - 5),
        AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        width: 44,
        align: TextAlign.right,
      );
    }

    const tickIndices = [0, 2, 4, 6, 8, 10, 12, 14];
    for (final index in tickIndices) {
      final x = chart.left + index / (points.length - 1) * chart.width;
      _paintText(
        canvas,
        points[index].monthLabel,
        Offset(x - 14, chart.bottom + 10),
        AppTextStyles.micro.copyWith(color: AppColors.text3),
        width: 30,
        align: TextAlign.center,
      );
    }

    final line = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = _scaleY(points[i].underwaterPct, chart);
      if (i == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }

    final fill = Path.from(line)
      ..lineTo(chart.right, chart.top)
      ..lineTo(chart.left, chart.top)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.sell33, AppColors.sell.withValues(alpha: 0)],
        ).createShader(chart),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = _drawdownRed
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  double _scaleY(double value, Rect chart) {
    const min = -12.0;
    const max = 0.0;
    return chart.bottom - ((value - min) / (max - min)) * chart.height;
  }

  @override
  bool shouldRepaint(covariant _UnderwaterPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _DurationPainter extends CustomPainter {
  const _DurationPainter(this.buckets);

  final List<TradeBotDrawdownDurationBucket> buckets;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 6, size.width - 88, size.height - 36);
    final axisPaint = Paint()
      ..color = _drawdownAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [8, 4, 2, 0]) {
      final y = chart.bottom - value / 8 * chart.height;
      _paintText(
        canvas,
        '$value',
        Offset(22, y - 5),
        AppTextStyles.numericMicro.copyWith(color: AppColors.text3),
        width: 34,
        align: TextAlign.right,
      );
    }

    final barArea = chart.deflate(8);
    final slot = barArea.width / buckets.length;
    final barWidth = math.min(60.0, slot * .78);
    final barPaint = Paint()..color = _drawdownAmber;
    for (var i = 0; i < buckets.length; i++) {
      final item = buckets[i];
      final left = barArea.left + i * slot + (slot - barWidth) / 2;
      final barTop = chart.bottom - item.count / 8 * chart.height;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, barTop, barWidth, chart.bottom - barTop),
        topLeft: AppRadii.xsCorner,
        topRight: AppRadii.xsCorner,
      );
      canvas.drawRRect(rect, barPaint);
      _paintText(
        canvas,
        item.range,
        Offset(barArea.left + i * slot, chart.bottom + 9),
        AppTextStyles.micro.copyWith(color: AppColors.text3),
        width: slot,
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DurationPainter oldDelegate) =>
      oldDelegate.buckets != buckets;
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
        fontWeight: AppTextStyles.medium,
        decoration: TextDecoration.none,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
