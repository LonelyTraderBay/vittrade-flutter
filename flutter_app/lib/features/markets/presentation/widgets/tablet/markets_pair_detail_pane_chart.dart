part of 'markets_pair_detail_pane.dart';

/// Khung nhìn biểu đồ giá (SC-044): PANEL chart kiểu Bybit (V2 2026-08-30)
/// — thanh công cụ MỘT hàng nằm TRONG khung panel (nút khung giờ dạng text
/// phẳng, chỉ báo MA/Vol/Nâng cao), chú giải vẽ overlay trong chart, nến
/// OHLC + dải khối lượng riêng. Mọi nút hiển thị đều wired thật.
///
/// [desk] bật chế độ "Trading Desk": chart cao 400dp cho cột chính của bố
/// cục 2 cột; tắt thì 220dp của khuôn 1 cột 4 tab (pane hẹp).
class _PairChartWorkspace extends StatefulWidget {
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
  State<_PairChartWorkspace> createState() => _PairChartWorkspaceState();
}

class _PairChartWorkspaceState extends State<_PairChartWorkspace> {
  /// Vị trí nến đang thăm dò bằng crosshair (chạm/kéo trên chart) — null
  /// = đọc nến cuối. Terminal thật luôn đọc OHLC theo con trỏ (Bybit).
  int? _probeIndex;

  void _probe(Offset local, double width, int count) {
    final axis = width - _PairChartPainter.axisWidth;
    final index = ((local.dx / axis) * count).floor().clamp(0, count - 1);
    if (index != _probeIndex) setState(() => _probeIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final candles = pairCandleSeriesForTimeframe(
      widget.series,
      timeframe: widget.timeframe,
      seed: widget.pairId,
    );
    final closes = [for (final candle in candles) candle.close];
    final showMa = widget.indicators.contains('MA');
    final maSeries = showMa ? computeMovingAverage(closes) : const <double>[];
    final showVolume = widget.indicators.contains('Vol');
    final volumes = showVolume
        ? computeVolumeProfile(
            closes,
            seed: '${widget.pairId}|${widget.timeframe}',
          )
        : const <double>[];
    final lastClose = closes.isEmpty ? 0.0 : closes.last;
    final probe = candles.isEmpty
        ? null
        : candles[_probeIndex ?? candles.length - 1];
    final probeVolume =
        volumes.isEmpty || _probeIndex == null || _probeIndex! < 1
        ? null
        : volumes[_probeIndex! - 1];
    return VitCard(
      borderColor: AppColors.border,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // V2-A (Bybit pattern): MỘT hàng công cụ trong panel — hàng khung
          // giờ text phẳng, hàng MA/Vol + Nâng cao (cột desk ~400dp).
          Padding(
            padding: MarketsSpacingTokens.pairChartToolbarPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (final tf in ['15m', '1H', '4H', '1D', '1W', '1M']) ...[
                      _PairIntervalButton(
                        label: tf,
                        active: tf == widget.timeframe,
                        onTap: () => widget.onTimeframeChanged(tf),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                    ],
                  ],
                ),
                Row(
                  children: [
                    for (final item in ['MA', 'Vol']) ...[
                      _PairIndicatorButton(
                        label: item,
                        active: widget.indicators.contains(item),
                        onTap: () => widget.onIndicatorToggle(item),
                      ),
                      const SizedBox(width: AppSpacing.x4),
                    ],
                    _PairIndicatorButton(
                      label: 'Nâng cao',
                      active: true,
                      warning: true,
                      onTap: widget.onAdvanced,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // OHLC readout: O/H/L/C (+Vol) của nến crosshair đang chọn (mặc
          // định nến cuối) — terminal thật luôn hiển thị dòng đọc này.
          Padding(
            key: MarketsTabletKeys.pairOhlcReadout,
            padding: MarketsSpacingTokens.pairBookRowPadding,
            child: Wrap(
              spacing: MarketsSpacingTokens.pairMetaGap,
              runSpacing: AppSpacing.x1,
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
                        ? formatMarketCompact(value)
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
          // Chart: desk co giãn chiếm hết chiều cao còn lại của panel
          // (grid cố định); pane hẹp giữ 220dp. Chạm/kéo = crosshair.
          Expanded(
            flex: widget.desk ? 1 : 0,
            child: widget.desk
                ? LayoutBuilder(
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
                      child: _buildChart(
                        candles,
                        maSeries,
                        volumes,
                        lastClose,
                        showMa,
                        showVolume,
                      ),
                    ),
                  )
                : _buildChart(
                    candles,
                    maSeries,
                    volumes,
                    lastClose,
                    showMa,
                    showVolume,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(
    List<PairCandle> candles,
    List<double> maSeries,
    List<double> volumes,
    double lastClose,
    bool showMa,
    bool showVolume,
  ) {
    final chart = SizedBox(
      key: MarketsTabletKeys.pairPaneChart,
      width: double.infinity,
      height: widget.desk
          ? double.infinity
          : MarketsSpacingTokens.pairDetailChartHeight,
      child: CustomPaint(
        size: Size.infinite,
        painter: _PairChartPainter(
          candles: candles,
          maSeries: maSeries,
          volumes: volumes,
          positive: widget.positive,
          lastClose: lastClose,
          timeframe: widget.timeframe,
          crosshairIndex: _probeIndex,
        ),
      ),
    );
    // Legend overlay (Bybit): MA(7)/Khối lượng đè lên góc trên-trái chart.
    return Stack(
      children: [
        chart,
        Positioned(
          top: AppSpacing.x2,
          left: AppSpacing.x3,
          child: Row(
            children: [
              if (showMa) ...[
                const VitLegendItem(
                  label: 'MA (7)',
                  color: marketListPrimary,
                  dotSize: MarketsSpacingTokens.marketDepthLegendDot,
                ),
                const SizedBox(width: AppSpacing.x4),
              ],
              if (showVolume)
                VitLegendItem(
                  label: 'Khối lượng',
                  color: (widget.positive ? AppColors.buy : AppColors.sell)
                      .withValues(alpha: .55),
                  dotSize: MarketsSpacingTokens.marketDepthLegendDot,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Nút khung giờ text phẳng kiểu terminal (Bybit/TradingView): active =
/// màu nhấn + đậm, không active = text phụ — không viền pill, không nền
/// box, các nút tự nhiên tách rời nhau.
class _PairIntervalButton extends StatelessWidget {
  const _PairIntervalButton({
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
      key: MarketsTabletKeys.pairInterval(label),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: MarketsSpacingTokens.pairIntervalButtonPadding,
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? marketListPrimary : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : null,
          ),
        ),
      ),
    );
  }
}

/// Nút chỉ báo (MA/Vol/Nâng cao) — cùng ngôn ngữ text phẳng; trạng thái
/// bật/tắt thể hiện bằng chấm màu + chữ đậm (không chỉ dựa màu — a11y).
class _PairIndicatorButton extends StatelessWidget {
  const _PairIndicatorButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.warning = false,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final color = warning
        ? AppColors.warn
        : active
        ? marketListPrimary
        : AppColors.text3;
    return InkWell(
      key: MarketsTabletKeys.pairIndicator(label),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: MarketsSpacingTokens.pairIntervalButtonPadding,
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: active ? AppTextStyles.bold : null,
          ),
        ),
      ),
    );
  }
}
