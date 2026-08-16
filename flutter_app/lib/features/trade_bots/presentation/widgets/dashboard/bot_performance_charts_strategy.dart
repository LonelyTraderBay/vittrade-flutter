part of '../../phone/pages/dashboard/bot_performance_analytics_page.dart';

class _KeyMetricsCard extends StatelessWidget {
  const _KeyMetricsCard({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      // Compact — card only holds a 2-line metric strip (banner removed in P0).
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      density: VitDensity.tool,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _MetricColumn(
              label: 'Tổng lãi/lỗ',
              value: _formatSignedMoney(metrics.totalPnl),
              color: metrics.totalPnl >= 0 ? _analyticsGreen : _analyticsRed,
            ),
          ),
          Expanded(
            child: _MetricColumn(
              label: 'Tỷ lệ thắng',
              value: '${metrics.winRate.toStringAsFixed(1)}%',
              color: AppColors.text1,
            ),
          ),
          Expanded(
            child: _MetricColumn(
              label: 'Tỷ lệ Sharpe',
              value: metrics.sharpeRatio.toStringAsFixed(2),
              color: AppColors.text1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TimeframeTabs extends StatelessWidget {
  const _TimeframeTabs({required this.active, required this.onChanged});

  final _AnalyticsTimeframe active;
  final ValueChanged<_AnalyticsTimeframe> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      (_AnalyticsTimeframe.sevenDays, '7d', '7 ngày'),
      (_AnalyticsTimeframe.thirtyDays, '30d', '30 ngày'),
      (_AnalyticsTimeframe.allTime, 'all', 'Toàn thời gian'),
    ];

    return VitSegmentedTabBar(
      activeKey: active.name,
      onChanged: (key) =>
          onChanged(tabs.firstWhere((tab) => tab.$1.name == key).$1),
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.$1.name,
            label: tab.$3,
            widgetKey: BotPerformanceAnalyticsPage.timeframeKey(tab.$2),
          ),
      ],
    );
  }
}

class _PnlChartCard extends StatefulWidget {
  const _PnlChartCard({required this.points, required this.reveal});

  final List<TradeBotPnlPoint> points;
  final Animation<double> reveal;

  @override
  State<_PnlChartCard> createState() => _PnlChartCardState();
}

class _PnlChartCardState extends State<_PnlChartCard> {
  int? _scrubIndex;

  void _updateScrub(Offset local, Size size) {
    final points = widget.points;
    if (points.isEmpty) return;
    final chart = Rect.fromLTWH(50, 8, size.width - 72, size.height - 42);
    final t = ((local.dx - chart.left) / chart.width).clamp(0.0, 1.0);
    final index = (t * (points.length - 1)).round().clamp(0, points.length - 1);
    if (index != _scrubIndex) {
      setState(() => _scrubIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrub = _scrubIndex;
    final points = widget.points;
    final scrubPoint = scrub != null && scrub >= 0 && scrub < points.length
        ? points[scrub]
        : null;

    return VitCard(
      key: BotPerformanceAnalyticsPage.pnlChartKey,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (scrubPoint != null) ...[
            Text(
              '${scrubPoint.date} · ${_formatSignedMoney(scrubPoint.pnl)}',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          ],
          SizedBox(
            height: _analyticsChartExtent,
            child: AnimatedBuilder(
              animation: widget.reveal,
              builder: (context, child) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final size = Size(
                      constraints.maxWidth,
                      constraints.maxHeight,
                    );
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) =>
                          _updateScrub(details.localPosition, size),
                      onTapCancel: () => setState(() => _scrubIndex = null),
                      onHorizontalDragUpdate: (details) =>
                          _updateScrub(details.localPosition, size),
                      onHorizontalDragEnd: (_) =>
                          setState(() => _scrubIndex = null),
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: _PnlChartPainter(
                            points,
                            progress: Curves.easeOut.transform(
                              widget.reveal.value,
                            ),
                            scrubIndex: scrub,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WinLossChartCard extends StatelessWidget {
  const _WinLossChartCard({
    required this.points,
    required this.netTrades,
    required this.onViewHistory,
  });

  final List<TradeBotWinLossPoint> points;
  final int netTrades;
  final VoidCallback onViewHistory;

  @override
  Widget build(BuildContext context) {
    final netLabel = netTrades >= 0 ? '+$netTrades lệnh' : '$netTrades lệnh';
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingTall,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: TradeSpacingTokens.tradeBotCardGap,
                  runSpacing: TradeSpacingTokens.tradeBotTinyGap,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const _LegendSwatch(color: _analyticsGreen, label: 'Thắng'),
                    const _LegendSwatch(color: _analyticsRed, label: 'Thua'),
                    VitAccentPill(
                      label: netLabel,
                      accentColor: netTrades >= 0
                          ? _analyticsGreen
                          : _analyticsRed,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          SizedBox(
            height: _analyticsDistributionExtent,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _WinLossChartPainter(points),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: BotPerformanceAnalyticsPage.historyCtaKey,
            density: VitDensity.tool,
            height: TradeSpacingTokens.tradeBotSheetActionHeight,
            variant: VitCtaButtonVariant.secondary,
            onPressed: onViewHistory,
            child: const Text('Xem lịch sử lệnh'),
          ),
        ],
      ),
    );
  }
}

class _LegendSwatch extends StatelessWidget {
  const _LegendSwatch({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
            ),
          ),
          child: const SizedBox(width: AppSpacing.x3, height: AppSpacing.x3),
        ),
        const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _StrategyPerformanceCard extends StatelessWidget {
  const _StrategyPerformanceCard({
    required this.strategies,
    required this.reveal,
  });

  final List<TradeBotStrategyPerformance> strategies;
  final Animation<double> reveal;

  @override
  Widget build(BuildContext context) {
    final maxPnl = strategies
        .map((strategy) => strategy.pnl.abs())
        .fold<double>(0, math.max);

    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPaddingLoose,
      density: VitDensity.tool,
      child: AnimatedBuilder(
        animation: reveal,
        builder: (context, child) {
          final t = Curves.easeOut.transform(reveal.value);
          return Column(
            children: [
              for (final strategy in strategies) ...[
                _StrategyRow(strategy: strategy, maxPnl: maxPnl, progress: t),
                if (strategy != strategies.last)
                  const SizedBox(height: TradeSpacingTokens.tradeBotCardGap),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StrategyRow extends StatelessWidget {
  const _StrategyRow({
    required this.strategy,
    required this.maxPnl,
    required this.progress,
  });

  final TradeBotStrategyPerformance strategy;
  final double maxPnl;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    final isPositive = strategy.pnl >= 0;
    final widthFactor = maxPnl == 0
        ? 0.0
        : (strategy.pnl.abs() / maxPnl) * progress;
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.circle,
              color: color,
              size: TradeSpacingTokens.tradeBotCardGap,
            ),
            const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
            Expanded(
              child: Text(
                '${strategy.strategy} Bot',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              _formatSignedMoney(strategy.pnl),
              style: AppTextStyles.caption.copyWith(
                color: isPositive ? _analyticsGreen : _analyticsRed,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: SizedBox(
            height: _analyticsProgressExtent,
            child: LinearProgressIndicator(
              value: widthFactor.clamp(0, 1),
              backgroundColor: _chartTrack,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
