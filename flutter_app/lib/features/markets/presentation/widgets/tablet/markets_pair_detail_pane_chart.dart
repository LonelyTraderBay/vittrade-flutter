part of 'markets_pair_detail_pane.dart';

/// Khung nhìn biểu đồ: hàng timeframe + hàng chỉ báo + chart giá thật
/// (painter riêng: grid + nhãn giá + volume + MA) — mọi nút hiển thị đều
/// wired thật (P1 "một UI chi tiết coin hoàn chỉnh" 2026-08-29: timeframe
/// đổi chuỗi dữ liệu, MA vẽ đường thật, chỉ indicator đã wired mới hiển).
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
  });

  final List<double> series;
  final String pairId;
  final bool positive;
  final String timeframe;
  final ValueChanged<String> onTimeframeChanged;
  final Set<String> indicators;
  final ValueChanged<String> onIndicatorToggle;
  final VoidCallback onAdvanced;

  @override
  Widget build(BuildContext context) {
    final chartSeries = pairChartSeriesForTimeframe(
      series,
      timeframe: timeframe,
      seed: pairId,
    );
    final showMa = indicators.contains('MA');
    final maSeries = showMa
        ? computeMovingAverage(chartSeries)
        : const <double>[];
    final showVolume = indicators.contains('Vol');
    final volumes = showVolume
        ? computeVolumeProfile(chartSeries, seed: '$pairId|$timeframe')
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
            padding: EdgeInsets.zero,
            gap: AppSpacing.x1,
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
            height: MarketsSpacingTokens.pairDetailChartHeight,
            child: CustomPaint(
              size: Size.infinite,
              painter: _PairChartPainter(
                series: chartSeries,
                maSeries: maSeries,
                volumes: volumes,
                positive: positive,
                timeframe: timeframe,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Painter chart giá của pane chi tiết cặp — grid ngang + nhãn giá hai bên +
/// fill gradient theo hướng phiên + cột khối lượng + đường MA (tuỳ chọn) +
/// nhãn thời gian tương đối đáy. Nhịp vẽ theo khuôn `_DepthChartPainter`.
class _PairChartPainter extends CustomPainter {
  const _PairChartPainter({
    required this.series,
    required this.maSeries,
    required this.volumes,
    required this.positive,
    required this.timeframe,
  });

  final List<double> series;
  final List<double> maSeries;
  final List<double> volumes;
  final bool positive;
  final String timeframe;

  static const double _axisWidth = 56;
  static const double _labelHeight = 22;

  @override
  void paint(Canvas canvas, Size size) {
    if (series.length < 2) return;
    // Chỉ reserve dải PHẢI cho nhãn giá — không reserve trái (từng để
    // 56dp trống hoàn toàn bên trái chart, lệch lẻ với các hàng trên).
    final plot = Rect.fromLTWH(
      0,
      0,
      size.width - _axisWidth,
      size.height - _labelHeight,
    );

    var minValue = series.reduce((a, b) => a < b ? a : b);
    var maxValue = series.reduce((a, b) => a > b ? a : b);
    if (maSeries.isNotEmpty) {
      for (final value in maSeries) {
        if (value < minValue) minValue = value;
        if (value > maxValue) maxValue = value;
      }
    }
    final range = (maxValue - minValue) * 1.08 + 1e-9;

    Offset pointFor(int index, double value, int count) => Offset(
      plot.left + plot.width * index / (count - 1),
      plot.bottom - ((value - minValue) / range) * plot.height,
    );

    _paintGridAndAxisLabels(canvas, plot, minValue, range);
    _paintVolumeBars(canvas, plot);
    _paintPriceLineAndFill(canvas, plot, pointFor);
    _paintMaLine(canvas, plot, pointFor);
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

  void _paintVolumeBars(Canvas canvas, Rect plot) {
    if (volumes.isEmpty) return;
    final maxVolume = volumes.reduce((a, b) => a > b ? a : b) + 1e-9;
    final barWidth = (plot.width / volumes.length * 0.6).clamp(1.0, 8.0);
    final barPaint = Paint()
      ..color = (positive ? AppColors.buy : AppColors.sell).withValues(
        alpha: .35,
      );
    for (var index = 0; index < volumes.length; index += 1) {
      final height = (volumes[index] / maxVolume) * plot.height * 0.22;
      final x = plot.left + plot.width * index / (volumes.length - 1);
      canvas.drawRect(
        Rect.fromLTWH(x - barWidth / 2, plot.bottom - height, barWidth, height),
        barPaint,
      );
    }
  }

  void _paintPriceLineAndFill(
    Canvas canvas,
    Rect plot,
    Offset Function(int, double, int) pointFor,
  ) {
    final line = Path()
      ..moveTo(pointFor(0, series[0], series.length).dx, plot.top);
    for (var index = 0; index < series.length; index += 1) {
      final point = pointFor(index, series[index], series.length);
      line.lineTo(point.dx, point.dy);
    }
    final fill = Path.from(line)
      ..lineTo(
        pointFor(series.length - 1, series.last, series.length).dx,
        plot.bottom,
      )
      ..lineTo(plot.left, plot.bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          (positive ? AppColors.buy : AppColors.sell).withValues(alpha: .22),
          (positive ? AppColors.buy : AppColors.sell).withValues(alpha: .02),
        ],
      ).createShader(plot);
    canvas.drawPath(fill, fillPaint);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = positive ? AppColors.buy : AppColors.sell;
    canvas.drawPath(line, linePaint);
  }

  void _paintMaLine(
    Canvas canvas,
    Rect plot,
    Offset Function(int, double, int) pointFor,
  ) {
    if (maSeries.length < 2) return;
    final period = series.length - maSeries.length + 1;
    final path = Path()
      ..moveTo(
        pointFor(period - 1, maSeries[0], series.length).dx,
        pointFor(period - 1, maSeries[0], series.length).dy,
      );
    for (var index = 1; index < maSeries.length; index += 1) {
      final point = pointFor(
        period - 1 + index,
        maSeries[index],
        series.length,
      );
      path.lineTo(point.dx, point.dy);
    }
    final maPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = marketListPrimary;
    canvas.drawPath(path, maPaint);
  }

  void _paintTimeLabels(Canvas canvas, Rect plot) {
    final labels = pairChartTimeLabels(timeframe, series.length, 4);
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
      oldDelegate.series != series ||
      oldDelegate.maSeries != maSeries ||
      oldDelegate.volumes != volumes ||
      oldDelegate.positive != positive ||
      oldDelegate.timeframe != timeframe;
}
