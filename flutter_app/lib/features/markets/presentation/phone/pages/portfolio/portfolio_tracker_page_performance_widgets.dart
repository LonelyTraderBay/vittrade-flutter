part of 'portfolio_tracker_page.dart';

class _PnlBreakdown extends StatelessWidget {
  const _PnlBreakdown({required this.holdings, required this.hidden});

  final List<PortfolioHolding> holdings;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    final sorted = [...holdings]..sort((a, b) => b.pnl.compareTo(a.pnl));
    final maxPnl = sorted.fold<double>(
      0,
      (value, holding) => math.max(value, holding.pnl.abs()),
    );
    return Column(
      children: [
        for (final holding in sorted) ...[
          Material(
            color: AppColors.surface,
            borderRadius: AppRadii.cardRadius,
            child: Padding(
              padding: _portfolioPnlRowPadding,
              child: Row(
                children: [
                  _TokenBadge(
                    holding: holding,
                    size: _portfolioHoldingAvatarSm,
                  ),
                  const SizedBox(width: _portfolioPnlAvatarGap),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                holding.symbol,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            Text(
                              _mask(
                                '${holding.pnl >= 0 ? '+' : ''}${_formatUsd(holding.pnl)}',
                                hidden,
                              ),
                              style: AppTextStyles.caption.copyWith(
                                color: holding.pnl >= 0
                                    ? AppColors.buy
                                    : AppColors.sell,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: _portfolioPnlProgressGap),
                        ClipRRect(
                          borderRadius: AppRadii.xlRadius,
                          child: LinearProgressIndicator(
                            minHeight: _portfolioPnlProgressHeight,
                            value: maxPnl == 0 ? 0 : holding.pnl.abs() / maxPnl,
                            backgroundColor: AppColors.surface2,
                            valueColor: AlwaysStoppedAnimation(
                              holding.pnl >= 0 ? AppColors.buy : AppColors.sell,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (holding != sorted.last)
            const SizedBox(height: _portfolioPnlRowGap),
        ],
      ],
    );
  }
}

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({required this.stats, required this.hidden});

  final PortfolioStats stats;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCard(
            padding: _portfolioSummaryPadding,
            child: _SummaryStat(
              label: 'Tổng lãi/lỗ',
              value: _mask(
                '${stats.totalPnl >= 0 ? '+' : ''}${_formatUsd(stats.totalPnl)}',
                hidden,
              ),
              color: stats.totalPnl >= 0 ? AppColors.buy : AppColors.sell,
            ),
          ),
        ),
        const SizedBox(width: _portfolioSummaryGap),
        Expanded(
          child: VitCard(
            padding: _portfolioSummaryPadding,
            child: _SummaryStat(
              label: 'ROI tổng',
              value: _formatSignedPercent(stats.totalPnlPct),
              color: stats.totalPnlPct >= 0 ? AppColors.buy : AppColors.sell,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: _portfolioSummaryValueGap),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _TokenBadge extends StatelessWidget {
  const _TokenBadge({required this.holding, required this.size});

  final PortfolioHolding holding;
  final double size;

  @override
  Widget build(BuildContext context) {
    final textStyle = size <= 28
        ? AppTextStyles.numericMicro
        : AppTextStyles.caption;

    final color = AppAssetColors.forSymbol(holding.symbol);
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color.withValues(alpha: .14),
      child: Text(
        holding.symbol.substring(0, math.min(2, holding.symbol.length)),
        style: textStyle.copyWith(color: color, fontWeight: AppTextStyles.bold),
      ),
    );
  }
}

class _AllocationDonutPainter extends CustomPainter {
  const _AllocationDonutPainter({required this.holdings});

  final List<PortfolioHolding> holdings;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(
      center: center,
      radius: size.shortestSide / 2 - _portfolioAllocationDonutInset,
    );
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _portfolioAllocationDonutStroke
      ..strokeCap = StrokeCap.butt;

    for (final holding in holdings) {
      final sweep = (holding.allocation / 100) * math.pi * 2;
      paint.color = AppAssetColors.forSymbol(
        holding.symbol,
      ).withValues(alpha: .86);
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _AllocationDonutPainter oldDelegate) {
    return oldDelegate.holdings != holdings;
  }
}

class _PerformancePainter extends CustomPainter {
  const _PerformancePainter({required this.points});

  final List<PortfolioPerformancePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final values = [for (final point in points) point.value];
    final minValue = values.reduce(math.min) * .995;
    final maxValue = values.reduce(math.max) * 1.005;
    final range = maxValue - minValue;
    const topPadding = _portfolioPerformanceTopPadding;
    const bottomPadding = _portfolioPerformanceBottomPadding;
    final chartHeight = size.height - topPadding - bottomPadding;
    final linePath = Path();

    Offset pointAt(int index) {
      final x = index / (points.length - 1) * size.width;
      final normalized = range == 0 ? .5 : (values[index] - minValue) / range;
      final y = topPadding + (1 - normalized) * chartHeight;
      return Offset(x, y);
    }

    for (var index = 0; index < points.length; index += 1) {
      final point = pointAt(index);
      if (index == 0) {
        linePath.moveTo(point.dx, point.dy);
      } else {
        linePath.lineTo(point.dx, point.dy);
      }
    }

    final areaPath = Path.from(linePath)
      ..lineTo(size.width, topPadding + chartHeight)
      ..lineTo(0, topPadding + chartHeight)
      ..close();
    final areaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.buy20, AppColors.buyTransparent],
      ).createShader(Offset.zero & size);
    canvas.drawPath(areaPath, areaPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = _portfolioPerformanceLineStroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    final last = pointAt(points.length - 1);
    canvas
      ..drawCircle(
        last,
        _portfolioPerformanceLastPoint,
        Paint()..color = AppColors.buy,
      )
      ..drawCircle(
        last,
        _portfolioPerformanceInnerPoint,
        Paint()..color = AppColors.text1,
      );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    for (final index in [0, points.length ~/ 2, points.length - 1]) {
      textPainter.text = TextSpan(
        text: points[index].date,
        style: AppTextStyles.chartLabelXs.copyWith(color: AppColors.text3),
      );
      textPainter.layout();
      final x = (index / (points.length - 1) * size.width).clamp(
        textPainter.width / 2,
        size.width - textPainter.width / 2,
      );
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          size.height - _portfolioPerformanceDateBottom,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PerformancePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

List<PortfolioHolding> _overviewHoldings(List<PortfolioHolding> holdings) {
  const order = ['btc', 'eth', 'usdt', 'sol', 'bnb', 'ada'];
  final sorted = [...holdings];
  sorted.sort((a, b) => order.indexOf(a.id).compareTo(order.indexOf(b.id)));
  return sorted;
}

String _mask(String value, bool hidden, {bool long = false}) {
  if (!hidden) return value;
  return long ? '••••••' : '••••';
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value, 2)}';
}

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (value >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(2)}';
}

String _formatPrice(double value) {
  if (value >= 1000) return _formatNumber(value, 2);
  if (value >= 1) return _formatNumber(value, 2);
  return _formatNumber(value, 4);
}

String _formatNumber(double value, int fractionDigits) {
  final sign = value < 0 ? '-' : '';
  final fixed = value.abs().toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    if (index > 0 && (whole.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[index]);
  }
  if (fractionDigits == 0) return '$sign$buffer';
  return '$sign$buffer.${parts[1]}';
}
