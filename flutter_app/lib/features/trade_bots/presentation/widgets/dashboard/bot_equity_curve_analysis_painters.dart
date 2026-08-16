part of '../../phone/pages/dashboard/bot_equity_curve_page.dart';

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: _equityGreen.withValues(alpha: .30),
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: AppSpacing.iconSm,
                color: AppColors.successAccentSoft,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Vượt trội mạnh mẽ',
                style: AppTextStyles.caption.copyWith(
                  color: _equityGreen,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.circle,
                  size: AppSpacing.x1,
                  color: AppColors.text3,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last)
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
    return VitCard(radius: VitCardRadius.tight, padding: padding, child: child);
  }
}

class _EquityPainter extends CustomPainter {
  const _EquityPainter(this.points);

  final List<TradeBotEquityCurvePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 7, size.width - 88, size.height - 39);
    _drawAxes(canvas, chart, yLabels: [1800, 1350, 900, 450, 0]);
    const tickIndices = [0, 2, 4, 6, 8, 10, 12];
    for (final index in tickIndices) {
      final x = chart.left + index / (points.length - 1) * chart.width;
      _paintText(
        canvas,
        points[index].monthLabel,
        Offset(x - 14, chart.bottom + 10),
        AppColors.text3,
        width: 30,
        align: TextAlign.center,
      );
    }

    final line = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = chart.bottom - points[i].equity / 1800 * chart.height;
      if (i == 0) {
        line.moveTo(x, y);
      } else {
        line.lineTo(x, y);
      }
    }
    final fill = Path.from(line)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.buy.withValues(alpha: .33),
            AppColors.buy.withValues(alpha: 0),
          ],
        ).createShader(chart),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = _equityGreen
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _EquityPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _SharpePainter extends CustomPainter {
  const _SharpePainter(this.points);

  final List<TradeBotEquityCurvePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(50, 8, size.width - 70, size.height - 36);
    final axisPaint = Paint()
      ..color = _equityAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final value = points[i].rollingSharpe ?? 0;
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = chart.bottom - value / 2.5 * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _equityPrimary
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _SharpePainter oldDelegate) =>
      oldDelegate.points != points;
}

void _drawAxes(Canvas canvas, Rect chart, {required List<int> yLabels}) {
  final axisPaint = Paint()
    ..color = _equityAxis
    ..strokeWidth = 1;
  canvas
    ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
    ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);
  for (final value in yLabels) {
    final y = chart.bottom - value / 1800 * chart.height;
    _paintText(
      canvas,
      '\$$value',
      Offset(8, y - 5),
      AppColors.text3,
      width: 48,
      align: TextAlign.right,
    );
  }
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
        decoration: TextDecoration.none,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout(maxWidth: width);
  painter.paint(canvas, offset);
}
