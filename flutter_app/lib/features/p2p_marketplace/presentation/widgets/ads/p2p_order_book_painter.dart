part of '../../phone/pages/ads/p2p_order_book_page.dart';

class _DepthChartPainter extends CustomPainter {
  const _DepthChartPainter(this.snapshot);

  final P2POrderBookSnapshot snapshot;

  @override
  void paint(Canvas canvas, Size size) {
    const chartTop = 12.0;
    const chartLeft = 38.0;
    const chartRight = 8.0;
    const chartBottom = 28.0;
    final chartHeight = size.height - chartTop - chartBottom;
    final chartWidth = size.width - chartLeft - chartRight;
    final origin = Offset(chartLeft, chartTop + chartHeight);
    final axisPaint = Paint()
      ..color = AppColors.borderSolid
      ..strokeWidth = 1;
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .25)
      ..strokeWidth = .7;

    canvas.drawLine(const Offset(chartLeft, chartTop), origin, axisPaint);
    canvas.drawLine(
      origin,
      Offset(size.width - chartRight, origin.dy),
      axisPaint,
    );

    const maxAxis = 3200.0;
    final ticks = <double>[0, 800, 1600, 2400, 3200];
    for (final tick in ticks) {
      final y = origin.dy - chartHeight * (tick / maxAxis);
      if (tick > 0) {
        canvas.drawLine(
          Offset(chartLeft, y),
          Offset(size.width - chartRight, y),
          gridPaint,
        );
      }
      _paintText(
        canvas,
        _formatAxis(tick),
        Offset(0, y - 7),
        AppTextStyles.chartLabelXs.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.medium,
        ),
        width: chartLeft - 6,
        align: TextAlign.right,
      );
    }

    final entries = [...snapshot.bids.reversed, ...snapshot.asks];
    final totalBars = entries.length;
    final gap = 4.0;
    final barWidth = (chartWidth - gap * (totalBars - 1)) / totalBars;

    for (var index = 0; index < entries.length; index++) {
      final entry = entries[index];
      final color = index < snapshot.bids.length
          ? AppColors.buy
          : AppColors.sell;
      final height = math.max(4.0, chartHeight * (entry.total / maxAxis));
      final left = chartLeft + index * (barWidth + gap);
      final top = origin.dy - height;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, height),
        AppRadii.chartBarCorner,
      );
      canvas.drawRRect(rect, Paint()..color = color);
    }

    final labels = ['25.0k', '25.1k', '25.2k', '25.4k', '25.5k', '25.6k'];
    for (var i = 0; i < labels.length; i++) {
      final x = chartLeft + (chartWidth / (labels.length - 1)) * i;
      _paintText(
        canvas,
        labels[i],
        Offset(x - 16, origin.dy + 7),
        AppTextStyles.chartLabelXs.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.medium,
        ),
        width: 36,
        align: TextAlign.center,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DepthChartPainter oldDelegate) {
    return oldDelegate.snapshot.selectedAsset.asset !=
        snapshot.selectedAsset.asset;
  }
}

void _paintText(
  Canvas canvas,
  String text,
  Offset offset,
  TextStyle style, {
  double? width,
  TextAlign align = TextAlign.left,
}) {
  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: align,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width ?? double.infinity);
  painter.paint(canvas, offset);
}

String _formatChange(double value) {
  final prefix = value >= 0 ? '+' : '';
  return '$prefix${value.toStringAsFixed(2)}%';
}

String _formatVnd(double value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')}B';
  }
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}M';
  }

  final hasDecimal = value % 1 != 0;
  final whole = value.floor().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  if (hasDecimal) {
    final decimal = ((value - value.floor()) * 10).round();
    return '${buffer.toString()},$decimal';
  }
  return buffer.toString();
}

String _formatWhole(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}

String _formatBookPrice(double value) => (value / 1000).toStringAsFixed(2);

String _formatVolume(double value) => value.toStringAsFixed(4);

String _formatAxis(double value) {
  if (value == 0) return '0';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
