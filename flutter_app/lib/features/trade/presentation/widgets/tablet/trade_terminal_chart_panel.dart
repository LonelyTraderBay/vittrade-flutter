import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_chart_math.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_panel.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_legend_item.dart';

/// Panel chart NẾN của terminal Trade tablet (SC-048, hướng Bybit
/// 2026-08-31): thanh công cụ KHUNG GIỜ + chỉ báo MA/Vol là các nút TEXT
/// PHẲNG trong panel (mọi nút wired thật — đổi khung giờ đổi chuỗi nến,
/// bật MA/Vol đổi lớp vẽ), dòng đọc OHLC theo nến crosshair, canvas nến
/// bull thân RỖNG / bear thân ĐẶC + dải khối lượng riêng + tag giá hiện
/// tại trên rail phải. Nến sinh deterministic theo (cặp, khung giờ) — xem
/// [trade_terminalCandles].
class TradeTerminalChartPanel extends StatefulWidget {
  const TradeTerminalChartPanel({
    super.key,
    required this.pairId,
    required this.anchorPrice,
    required this.positive,
  });

  final String pairId;
  final double anchorPrice;
  final bool positive;

  @override
  State<TradeTerminalChartPanel> createState() =>
      _TradeTerminalChartPanelState();
}

class _TradeTerminalChartPanelState extends State<TradeTerminalChartPanel> {
  String _timeframe = '1h';
  final Set<String> _indicators = {'Vol'};

  /// Nến đang thăm dò bằng crosshair (chạm/kéo trên chart) — null = đọc
  /// nến cuối, như terminal thật (Bybit).
  int? _probeIndex;

  void _probe(Offset local, double width, int count) {
    final axis = width - _TradeTerminalChartPainter.axisWidth;
    final index = ((local.dx / axis) * count).floor().clamp(0, count - 1);
    if (index != _probeIndex) setState(() => _probeIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final candles = tradeTerminalCandles(
      anchorPrice: widget.anchorPrice,
      pairId: widget.pairId,
      timeframe: _timeframe,
    );
    final closes = [for (final candle in candles) candle.close];
    final showMa = _indicators.contains('MA');
    final maSeries = showMa
        ? tradeTerminalMovingAverage(closes)
        : const <double>[];
    final showVolume = _indicators.contains('Vol');
    final volumes = showVolume
        ? tradeTerminalVolumeProfile(candles, seed: widget.pairId)
        : const <double>[];
    final lastClose = candles.isEmpty ? 0.0 : candles.last.close;
    final probe = candles.isEmpty
        ? null
        : candles[_probeIndex ?? candles.length - 1];
    final probeVolume =
        volumes.isEmpty || _probeIndex == null || _probeIndex! < 1
        ? null
        : volumes[_probeIndex! - 1];

    return TradeTerminalPanel(
      panelKey: TradeTabletKeys.chartPanel,
      fill: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: TradeSpacingTokens.tradeTerminalChartToolbarPadding,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final tf in tradeTerminalTimeframes) ...[
                    _TradeTerminalTextButton(
                      key: TradeTabletKeys.timeframe(tf),
                      label: tf,
                      active: tf == _timeframe,
                      onTap: () => setState(() {
                        _timeframe = tf;
                        _probeIndex = null;
                      }),
                    ),
                    const SizedBox(width: TabletSpacingTokens.x4),
                  ],
                  const SizedBox(width: TabletSpacingTokens.x4),
                  for (final item in ['MA', 'Vol']) ...[
                    _TradeTerminalTextButton(
                      key: TradeTabletKeys.indicator(item),
                      label: item == 'Vol' ? 'KL' : item,
                      active: _indicators.contains(item),
                      onTap: () => setState(() {
                        _indicators.contains(item)
                            ? _indicators.remove(item)
                            : _indicators.add(item);
                      }),
                    ),
                    const SizedBox(width: TabletSpacingTokens.x4),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            key: TradeTabletKeys.ohlcReadout,
            padding: TradeSpacingTokens.tradeTerminalPanelBodyPadding,
            child: Wrap(
              spacing: TradeSpacingTokens.tradeTerminalMetaGap,
              runSpacing: TabletSpacingTokens.x1,
              children: [
                for (final (label, value) in [
                  ('O', probe?.open),
                  ('C', probe?.close),
                  ('Cao', probe?.high),
                  ('Thấp', probe?.low),
                  ('KL', probeVolume),
                ])
                  Text(
                    '$label ${value == null
                        ? '—'
                        : value >= 1000
                        ? formatTradeUsdRounded(value)
                        : value.toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => _probe(
                  details.localPosition,
                  constraints.maxWidth,
                  candles.length,
                ),
                onPanUpdate: (details) => _probe(
                  details.localPosition,
                  constraints.maxWidth,
                  candles.length,
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      key: TradeTabletKeys.chartCanvas,
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: _TradeTerminalChartPainter(
                          candles: candles,
                          maSeries: maSeries,
                          volumes: volumes,
                          positive: widget.positive,
                          lastClose: lastClose,
                          timeframe: _timeframe,
                          crosshairIndex: _probeIndex,
                        ),
                      ),
                    ),
                    Positioned(
                      top: TabletSpacingTokens.x2,
                      left: TabletSpacingTokens.x3,
                      child: Row(
                        children: [
                          if (showMa) ...[
                            const VitLegendItem(
                              label: 'MA (7)',
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: TabletSpacingTokens.x4),
                          ],
                          if (showVolume)
                            VitLegendItem(
                              label: 'Khối lượng',
                              color:
                                  (widget.positive
                                          ? AppColors.buy
                                          : AppColors.sell)
                                      .withValues(alpha: .55),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nút text phẳng kiểu terminal (Bybit/TradingView): active = màu nhấn +
/// đậm, không active = text phụ — không viền pill, không nền box.
class _TradeTerminalTextButton extends StatelessWidget {
  const _TradeTerminalTextButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: TradeSpacingTokens.tradeTerminalIntervalButtonPadding,
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.primary : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : null,
          ),
        ),
      ),
    );
  }
}

/// Painter chart nến của terminal Trade — khu vực giá (grid ngang + nhãn
/// giá phải căn giữa dọc + TAG giá hiện tại trên rail) tách rõ với dải
/// KHỐI LƯỢNG riêng phía dưới (40% opacity), nến bull thân RỖNG / bear
/// thân ĐẶC (khác hình dạng, không phụ thuộc màu — a11y), đường MA tuỳ
/// chọn, crosshair nét đứt tại nến đang thăm dò, nhãn thời gian đáy.
class _TradeTerminalChartPainter extends CustomPainter {
  const _TradeTerminalChartPainter({
    required this.candles,
    required this.maSeries,
    required this.volumes,
    required this.positive,
    required this.lastClose,
    required this.timeframe,
    this.crosshairIndex,
  });

  final List<TradeTerminalCandle> candles;
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
        tradeTerminalAxisLabel(value),
        y,
        size,
        color: AppColors.text3,
      );
    }
  }

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
      ..color = AppColors.primary;
    canvas.drawPath(path, maPaint);
  }

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
      tradeTerminalAxisLabel(lastClose),
      y,
      size,
      color: AppColors.surface,
      background: positive ? AppColors.buy : AppColors.sell,
    );
  }

  void _paintTimeLabels(Canvas canvas, Rect plot) {
    final labels = tradeTerminalTimeLabels(timeframe, candles.length, 4);
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
  bool shouldRepaint(covariant _TradeTerminalChartPainter oldDelegate) =>
      oldDelegate.candles != candles ||
      oldDelegate.maSeries != maSeries ||
      oldDelegate.volumes != volumes ||
      oldDelegate.positive != positive ||
      oldDelegate.timeframe != timeframe ||
      oldDelegate.crosshairIndex != crosshairIndex;
}
