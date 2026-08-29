part of 'markets_pair_detail_pane.dart';

/// Painter chart NẾN của pane chi tiết cặp — khu vực giá (grid ngang +
/// nhãn giá phải căn giữa dọc + TAG giá hiện tại trên rail) tách rõ với
/// dải KHỐI LƯỢNG riêng phía dưới (40% opacity), nến bull thân RỖNG /
/// bear thân ĐẶC (khác hình dạng, không phụ thuộc màu — a11y), đường MA
/// tuỳ chọn, chú giải overlay góc trên-trái, nhãn thời gian đáy.
class _PairChartPainter extends CustomPainter {
  const _PairChartPainter({
    required this.candles,
    required this.maSeries,
    required this.volumes,
    required this.positive,
    required this.lastClose,
    required this.timeframe,
    this.crosshairIndex,
  });

  final List<PairCandle> candles;
  final List<double> maSeries;
  final List<double> volumes;
  final bool positive;
  final double lastClose;
  final String timeframe;
  final int? crosshairIndex;

  static const double _axisWidth = 56;
  static const double _labelHeight = 22;
  static const double _volumeShare = 0.22;

  /// Chiều rộng rail giá — state dùng đổi tọa độ chạm sang index nến.
  static double get axisWidth => _axisWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.length < 2) return;
    final volumeHeight = size.height * _volumeShare;
    final plot = Rect.fromLTWH(
      0,
      0,
      size.width - _axisWidth,
      size.height - _labelHeight - volumeHeight,
    );
    final volumeRect = Rect.fromLTWH(
      plot.left,
      plot.bottom,
      plot.width,
      volumeHeight,
    );

    var minValue = candles.first.low;
    var maxValue = candles.first.high;
    for (final candle in candles) {
      if (candle.low < minValue) minValue = candle.low;
      if (candle.high > maxValue) maxValue = candle.high;
    }
    if (maSeries.isNotEmpty) {
      for (final value in maSeries) {
        if (value < minValue) minValue = value;
        if (value > maxValue) maxValue = value;
      }
    }
    final range = (maxValue - minValue) * 1.06 + 1e-9;

    Offset pointFor(int index, double value) => Offset(
      plot.left + plot.width * (index + 0.5) / candles.length,
      plot.bottom - ((value - minValue) / range) * plot.height,
    );

    _paintGridAndAxisLabels(canvas, size, plot, minValue, range);
    _paintVolumeBars(canvas, volumeRect);
    _paintCandles(canvas, plot, pointFor);
    _paintMaLine(canvas, pointFor);
    _paintTimeLabels(canvas, plot);
    _paintLastPriceTag(canvas, size, plot, minValue, range);
    _paintCrosshair(canvas, plot, minValue, range);
  }

  /// Crosshair (Bybit): đường dọc nét đứt tại nến đang thăm dò + chấm
  /// giao tại giá đóng của nến đó — phản chiếu vào OHLC readout phía trên.
  void _paintCrosshair(Canvas canvas, Rect plot, double min, double range) {
    final index = crosshairIndex;
    if (index == null || index < 0 || index >= candles.length) return;
    final x = plot.left + plot.width * (index + 0.5) / candles.length;
    final y =
        plot.bottom - ((candles[index].close - min) / range) * plot.height;
    if (y < plot.top || y > plot.bottom) return;
    final crossPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.text3.withValues(alpha: .6);
    var cy = plot.top;
    while (cy < plot.bottom) {
      canvas.drawLine(Offset(x, cy), Offset(x, cy + 4), crossPaint);
      cy += 8;
    }
    canvas.drawCircle(Offset(x, y), 3, Paint()..color = AppColors.text1);
  }

  void _paintGridAndAxisLabels(
    Canvas canvas,
    Size size,
    Rect plot,
    double min,
    double range,
  ) {
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .5);
    for (var step = 0; step <= 4; step += 1) {
      final y = plot.top + plot.height * step / 4;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      final value = min + range * (1 - step / 4);
      _drawAxisLabel(
        canvas,
        pairChartAxisLabel(value),
        y,
        size,
        color: AppColors.text3,
      );
    }
  }

  /// V2-B: nhãn giá căn giữa dọc theo vạch grid (trước đây vẽ từ điểm y
  /// nguyên nên lệch xuống), nằm gọn trong rail phải bên trong panel.
  void _drawAxisLabel(
    Canvas canvas,
    String text,
    double y,
    Size size, {
    Color color = AppColors.text3,
    Color? background,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: _axisWidth - 8);
    final dx = size.width - _axisWidth + 8;
    final dy = (y - painter.height / 2).toDouble().clamp(0.0, double.infinity);
    if (background != null) {
      final tagRect = Rect.fromLTWH(
        dx - 3,
        dy - 1,
        painter.width + 6,
        painter.height + 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(tagRect, AppRadii.smRadius.topLeft),
        Paint()..color = background,
      );
    }
    painter.paint(canvas, Offset(dx, dy));
  }

  void _paintVolumeBars(Canvas canvas, Rect rect) {
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.right, rect.top),
      Paint()..color = AppColors.borderSolid.withValues(alpha: .5),
    );
    if (volumes.isEmpty) return;
    final maxVolume = volumes.reduce((a, b) => a > b ? a : b) + 1e-9;
    final barWidth = (rect.width / candles.length * 0.62).clamp(1.0, 10.0);
    for (var index = 0; index < volumes.length; index += 1) {
      final candle = candles[index + 1];
      final x = rect.left + rect.width * (index + 1 + 0.5) / candles.length;
      final height = (volumes[index] / maxVolume) * rect.height;
      final barPaint = Paint()
        ..color = (candle.bullish ? AppColors.buy : AppColors.sell).withValues(
          alpha: .4,
        );
      canvas.drawRect(
        Rect.fromLTWH(x - barWidth / 2, rect.bottom - height, barWidth, height),
        barPaint,
      );
    }
  }

  void _paintCandles(
    Canvas canvas,
    Rect plot,
    Offset Function(int, double) pointFor,
  ) {
    final bodyWidth = (plot.width / candles.length * 0.62).clamp(1.0, 10.0);
    for (var index = 0; index < candles.length; index += 1) {
      final candle = candles[index];
      final color = candle.bullish ? AppColors.buy : AppColors.sell;
      final x = pointFor(index, candle.close).dx;
      final wickPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color;
      canvas.drawLine(
        Offset(x, pointFor(index, candle.high).dy),
        Offset(x, pointFor(index, candle.low).dy),
        wickPaint,
      );
      final bodyTop = pointFor(
        index,
        candle.open > candle.close ? candle.open : candle.close,
      ).dy;
      final bodyBottom = pointFor(
        index,
        candle.open > candle.close ? candle.close : candle.open,
      ).dy;
      final body = Rect.fromLTWH(
        x - bodyWidth / 2,
        bodyTop,
        bodyWidth,
        (bodyBottom - bodyTop).clamp(1.0, double.infinity),
      );
      if (candle.bullish) {
        canvas.drawRect(body, wickPaint);
      } else {
        canvas.drawRect(body, Paint()..color = color);
      }
    }
  }

  void _paintMaLine(Canvas canvas, Offset Function(int, double) pointFor) {
    if (maSeries.length < 2) return;
    final period = candles.length - maSeries.length + 1;
    final path = Path()
      ..moveTo(
        pointFor(period - 1, maSeries[0]).dx,
        pointFor(period - 1, maSeries[0]).dy,
      );
    for (var index = 1; index < maSeries.length; index += 1) {
      final point = pointFor(period - 1 + index, maSeries[index]);
      path.lineTo(point.dx, point.dy);
    }
    final maPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = marketListPrimary;
    canvas.drawPath(path, maPaint);
  }

  /// V2-B (Bybit pattern): đường giá hiện tại nét đứt ngang chart + TAG
  /// giá nền nhấn trên rail phải — mắt neo ngay mức đang giao dịch.
  void _paintLastPriceTag(
    Canvas canvas,
    Size size,
    Rect plot,
    double min,
    double range,
  ) {
    final y = plot.bottom - ((lastClose - min) / range) * plot.height;
    if (y < plot.top || y > plot.bottom) return;
    final dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = (positive ? AppColors.buy : AppColors.sell).withValues(
        alpha: .6,
      );
    var x = plot.left;
    while (x < plot.right) {
      canvas.drawLine(Offset(x, y), Offset(x + 4, y), dashPaint);
      x += 8;
    }
    _drawAxisLabel(
      canvas,
      pairChartAxisLabel(lastClose),
      y,
      size,
      color: AppColors.surface,
      background: positive ? AppColors.buy : AppColors.sell,
    );
  }

  void _paintTimeLabels(Canvas canvas, Rect plot) {
    final labels = pairChartTimeLabels(timeframe, candles.length, 4);
    for (var index = 0; index < labels.length; index += 1) {
      final x = plot.left + plot.width * index / (labels.length - 1);
      _drawLabel(
        canvas,
        labels[index],
        Offset(x.clamp(plot.left, plot.right - 40), plot.bottom + 4),
      );
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset at) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant _PairChartPainter oldDelegate) =>
      oldDelegate.candles != candles ||
      oldDelegate.maSeries != maSeries ||
      oldDelegate.volumes != volumes ||
      oldDelegate.positive != positive ||
      oldDelegate.timeframe != timeframe ||
      oldDelegate.crosshairIndex != crosshairIndex;
}
