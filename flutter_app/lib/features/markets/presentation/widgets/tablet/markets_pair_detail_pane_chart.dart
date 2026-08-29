part of 'markets_pair_detail_pane.dart';

/// Khung nhìn biểu đồ giá (SC-044): toolbar khung giờ + hàng chỉ báo +
/// chú giải + chart NẾN OHLC thật — mọi nút hiển thị đều wired (timeframe
/// đổi chuỗi dữ liệu, MA vẽ SMA(7) thật, Vol vẽ dải khối lượng riêng).
///
/// [desk] bật chế độ "Trading Desk" (Hướng 1, 2026-08-29): chiều cao chart
/// 400dp cho cột chính của bố cục 2 cột; tắt thì giữ 220dp của khuôn 1
/// cột 4 tab (pane hẹp).
class _PairChartWorkspace extends StatelessWidget {
  const _PairChartWorkspace({
    required this.series,
    required this.pairId,
    required this.positive,
    required this.timeframe,
    required this.onTimeframeChanged,
    required this.indicators,
    required this.onIndicatorToggle,
    required this.onAdvanced,
    this.desk = false,
  });

  final List<double> series;
  final String pairId;
  final bool positive;
  final String timeframe;
  final ValueChanged<String> onTimeframeChanged;
  final Set<String> indicators;
  final ValueChanged<String> onIndicatorToggle;
  final VoidCallback onAdvanced;
  final bool desk;

  @override
  Widget build(BuildContext context) {
    final candles = pairCandleSeriesForTimeframe(
      series,
      timeframe: timeframe,
      seed: pairId,
    );
    final closes = [for (final candle in candles) candle.close];
    final showMa = indicators.contains('MA');
    final maSeries = showMa ? computeMovingAverage(closes) : const <double>[];
    final showVolume = indicators.contains('Vol');
    final volumes = showVolume
        ? computeVolumeProfile(closes, seed: '$pairId|$timeframe')
        : const <double>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          // S7/P2: lề trái contentPad thẳng hàng khối giá — token Phone từng
          // lệch 24 literal và không đối xứng với phải (20).
          padding: MarketsSpacingTokens.pairPaneChartRowPadding,
          child: VitPresetChipRow<String>(
            selectedValue: timeframe,
            onTap: onTimeframeChanged,
            accentColor: marketListPrimary,
            height: MarketsSpacingTokens.pairTimeframeHeight,
            // 2026-08-29 (user duyệt Phương án A): chip khung giờ ôm nội
            // dung + gap x3 — Tier S3 fullWidth căng đều hợp trên Phone
            // (chip ~55dp) nhưng trên pane tablet ~780dp chip phình 124dp
            // và gap x1 (3dp) đọc là một thanh liền "dính nhau"; giờ cùng
            // nhịp với hàng MA/Vol bên dưới (pill dùng padding compact x3
            // mặc định — bỏ padding zero để chip không chạm viền).
            fullWidth: false,
            gap: AppSpacing.x3,
            items: const [
              VitPresetChipItem(value: '15m', label: '15m'),
              VitPresetChipItem(value: '1H', label: '1H'),
              VitPresetChipItem(value: '4H', label: '4H'),
              VitPresetChipItem(value: '1D', label: '1D'),
              VitPresetChipItem(value: '1W', label: '1W'),
              VitPresetChipItem(value: '1M', label: '1M'),
            ],
          ),
        ),
        SizedBox(
          height: VitDensity.compact.controlHeight,
          child: ListView(
            padding: MarketsSpacingTokens.pairIndicatorListPadding,
            scrollDirection: Axis.horizontal,
            children: [
              // Chỉ indicator ĐÃ WIRED được hiển thị: MA vẽ SMA(7) thật, Vol
              // bật/tắt cột khối lượng. EMA/BOLL/MACD/RSI đã gỡ theo cùng
              // quy tắc "nút hiển thị phải có hành vi thật".
              for (final item in ['MA', 'Vol']) ...[
                VitChoicePill(
                  label: item,
                  selected: indicators.contains(item),
                  onTap: () => onIndicatorToggle(item),
                  accentColor: marketListPrimary,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x3,
                  ),
                  semanticLabel: item,
                ),
                const SizedBox(width: MarketsSpacingTokens.pairIndicatorGap),
              ],
              VitChoicePill(
                label: 'Nâng cao',
                selected: true,
                onTap: onAdvanced,
                tone: VitChoicePillTone.warning,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x3,
                ),
                semanticLabel: 'Nâng cao',
              ),
            ],
          ),
        ),
        Padding(
          padding: MarketsSpacingTokens.pairPaneChartRowPadding,
          child: Row(
            children: [
              if (showMa) ...[
                const VitLegendItem(
                  label: 'MA (7)',
                  color: marketListPrimary,
                  dotSize: MarketsSpacingTokens.marketDepthLegendDot,
                ),
                const SizedBox(width: MarketsSpacingTokens.pairIndicatorGap),
              ],
              if (showVolume)
                VitLegendItem(
                  label: 'Khối lượng',
                  color: (positive ? AppColors.buy : AppColors.sell).withValues(
                    alpha: .35,
                  ),
                  dotSize: MarketsSpacingTokens.marketDepthLegendDot,
                ),
            ],
          ),
        ),
        Padding(
          // P2: thụng lề ngang contentPad để mép trái vùng vẽ thẳng hàng với
          // hàng khung giờ/chú giải — painter không còn reserve dải trái.
          padding: MarketsSpacingTokens.pairPaneChildFlushPadding,
          child: SizedBox(
            key: MarketsTabletKeys.pairPaneChart,
            height: desk
                ? MarketsSpacingTokens.pairDeskChartHeight
                : MarketsSpacingTokens.pairDetailChartHeight,
            child: CustomPaint(
              size: Size.infinite,
              painter: _PairChartPainter(
                candles: candles,
                maSeries: maSeries,
                volumes: volumes,
                timeframe: timeframe,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Painter chart NẾN của pane chi tiết cặp — khu vực giá (grid ngang +
/// nhãn giá phải) tách rõ với dải KHỐI LƯỢNG riêng phía dưới (40% opacity
/// theo khuyến nghị chart tài chính), nến bull thân RỖNG / bear thân ĐẶC
/// (khác hình dạng, không phụ thuộc màu — a11y), đường MA tuỳ chọn, nhãn
/// thời gian tương đối đáy.
class _PairChartPainter extends CustomPainter {
  const _PairChartPainter({
    required this.candles,
    required this.maSeries,
    required this.volumes,
    required this.timeframe,
  });

  final List<PairCandle> candles;
  final List<double> maSeries;
  final List<double> volumes;
  final String timeframe;

  static const double _axisWidth = 56;
  static const double _labelHeight = 22;
  static const double _volumeShare = 0.22;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.length < 2) return;
    // Chỉ reserve dải PHẢI cho nhãn giá — không reserve trái (từng để
    // 56dp trống hoàn toàn bên trái chart, lệch lẻ với các hàng trên).
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

    _paintGridAndAxisLabels(canvas, plot, minValue, range);
    _paintVolumeBars(canvas, volumeRect);
    _paintCandles(canvas, plot, pointFor);
    _paintMaLine(canvas, pointFor);
    _paintTimeLabels(canvas, plot);
  }

  void _paintGridAndAxisLabels(
    Canvas canvas,
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
        Offset(plot.right + 6, y),
      );
    }
  }

  void _paintVolumeBars(Canvas canvas, Rect rect) {
    // Đường chân tách khu khối lượng với khu giá — cùng chất grid.
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.right, rect.top),
      Paint()..color = AppColors.borderSolid.withValues(alpha: .5),
    );
    if (volumes.isEmpty) return;
    final maxVolume = volumes.reduce((a, b) => a > b ? a : b) + 1e-9;
    final barWidth = (rect.width / candles.length * 0.62).clamp(1.0, 10.0);
    for (var index = 0; index < volumes.length; index += 1) {
      // volumes[i] = biên độ chuyển giá nến i → i+1 ⇒ cột nằm giữa nến i+1.
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
        // Bull: thân RỖNG (viền) — khác hình dạng với bear (đặc).
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

  void _drawAxisLabel(Canvas canvas, String text, Offset at) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: _axisWidth - 8);
    painter.paint(canvas, at);
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
      oldDelegate.timeframe != timeframe;
}
