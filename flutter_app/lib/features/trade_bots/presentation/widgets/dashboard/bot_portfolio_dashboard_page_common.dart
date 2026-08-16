part of '../../phone/pages/dashboard/bot_portfolio_dashboard_page.dart';

class _HealthCard extends StatelessWidget {
  const _HealthCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: _portfolioGreen.withValues(alpha: .30),
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: AppSpacing.iconSm,
                color: _portfolioGreen,
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
              Expanded(
                child: Text(
                  'Portfolio Health: Excellent',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: _portfolioGreen,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.circle,
                  color: AppColors.text3,
                  size: AppSpacing.x1,
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
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

class _EquityPainter extends CustomPainter {
  const _EquityPainter(this.points);

  final List<TradeBotPortfolioEquityPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(66, 14, size.width - 90, size.height - 48);
    final axisPaint = Paint()
      ..color = _portfolioAxis
      ..strokeWidth = 1;
    canvas
      ..drawLine(chart.bottomLeft, chart.bottomRight, axisPaint)
      ..drawLine(chart.bottomLeft, chart.topLeft, axisPaint);

    for (final value in [0, 850, 1700, 3400]) {
      final y = chart.bottom - (value / 3400) * chart.height;
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
      final x = chart.left + i / (points.length - 1) * chart.width;
      _paintText(
        canvas,
        points[i].date,
        Offset(x - 14, chart.bottom + 10),
        AppColors.text3,
        width: 30,
        align: TextAlign.center,
      );
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + i / (points.length - 1) * chart.width;
      final y = chart.bottom - (points[i].equity / 3400) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _portfolioGreen
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _EquityPainter oldDelegate) =>
      oldDelegate.points != points;
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.allocations);

  final List<TradeBotPortfolioAllocation> allocations;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const outerRadius = 65.0;
    const strokeWidth = 30.0;
    final rect = Rect.fromCircle(center: center, radius: outerRadius);
    final total = allocations.fold<double>(0, (sum, item) => sum + item.value);
    var start = -math.pi / 2;

    for (final item in allocations) {
      final sweep = item.value / total * math.pi * 2;
      canvas.drawArc(
        rect,
        start + .02,
        sweep - .04,
        false,
        Paint()
          ..color = Color(item.colorHex)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.allocations != allocations;
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

String _formatUsd(double value) => formatTradeUsdRounded(value);
