part of '../../phone/pages/dashboard/bot_performance_analytics_page.dart';

class _AdvancedMetricsGrid extends StatelessWidget {
  const _AdvancedMetricsGrid({required this.metrics});

  final TradeBotPerformanceMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final items = [
      _AdvancedMetricData(
        icon: Icons.adjust_rounded,
        label: 'Hệ số lợi nhuận',
        value: metrics.profitFactor.toStringAsFixed(2),
        helper: 'Lãi gộp / Lỗ gộp',
        color: _analyticsPrimary,
      ),
      _AdvancedMetricData(
        icon: Icons.workspace_premium_outlined,
        label: 'Lãi TB',
        value: _formatSignedMoney(metrics.avgWin),
        helper: 'Mỗi lệnh thắng',
        color: _analyticsAmber,
        valueColor: _analyticsGreen,
      ),
      _AdvancedMetricData(
        icon: Icons.trending_up_rounded,
        label: 'Lệnh tốt nhất',
        value: _formatSignedMoney(metrics.bestTrade),
        helper: 'Lệnh thắng lớn nhất',
        color: _analyticsGreen,
        valueColor: _analyticsGreen,
      ),
      _AdvancedMetricData(
        icon: Icons.show_chart_rounded,
        label: 'Lỗ TB',
        value: _formatSignedMoney(metrics.avgLoss),
        helper: 'Mỗi lệnh thua',
        color: _analyticsRed,
        valueColor: _analyticsRed,
      ),
      _AdvancedMetricData(
        icon: Icons.trending_down_rounded,
        label: 'Lệnh tệ nhất',
        value: _formatSignedMoney(metrics.worstTrade),
        helper: 'Lệnh thua lớn nhất',
        color: _analyticsRed,
        valueColor: _analyticsRed,
      ),
      _AdvancedMetricData(
        icon: Icons.receipt_long_rounded,
        label: 'Tổng số lệnh',
        value: '${metrics.totalTrades}',
        helper: 'Trong kỳ đang chọn',
        color: _analyticsPrimary,
      ),
    ];

    // Intrinsic 2-column rows — avoid GridView childAspectRatio which forced
    // ~130px cells and left empty space under short metric stacks.
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _AdvancedMetricCard(item: items[i])),
            const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
            Expanded(
              child: i + 1 < items.length
                  ? _AdvancedMetricCard(item: items[i + 1])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < items.length) {
        rows.add(const SizedBox(height: TradeSpacingTokens.tradeBotCardGap));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _AdvancedMetricData {
  const _AdvancedMetricData({
    required this.icon,
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final String helper;
  final Color color;
  final Color? valueColor;
}

class _AdvancedMetricCard extends StatelessWidget {
  const _AdvancedMetricCard({required this.item});

  final _AdvancedMetricData item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitAccentIconBox(icon: item.icon, color: item.color),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          Text(
            item.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          Text(
            item.value,
            style: AppTextStyles.baseMedium.copyWith(
              color: item.valueColor ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
          Text(
            item.helper,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  const _DurationCard({required this.distribution});

  final List<TradeBotDurationDistribution> distribution;

  static const _donutSize = 112.0;

  static const _palette = [
    AppColors.info,
    AppColors.buy,
    AppColors.caution,
    AppColors.primary,
  ];

  @override
  Widget build(BuildContext context) {
    final total = distribution.fold<int>(0, (sum, item) => sum + item.count);
    final maxCount = distribution.fold<int>(
      0,
      (max, item) => item.count > max ? item.count : max,
    );

    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      density: VitDensity.tool,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // CustomPaint must size to [child] — bare paint in a Stack collapses
          // and the KPI text then overlaps a tiny ring.
          RepaintBoundary(
            child: CustomPaint(
              painter: _DurationDonutPainter(distribution, colors: _palette),
              child: SizedBox(
                width: _donutSize,
                height: _donutSize,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$total',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(
                        height: TradeSpacingTokens.tradeBotTinyGap,
                      ),
                      Text(
                        'lệnh',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < distribution.length; i++) ...[
                  _DurationLegendRow(
                    color: _palette[i % _palette.length],
                    label: _durationLabel(distribution[i].duration),
                    count: distribution[i].count,
                    percent: total == 0
                        ? 0
                        : distribution[i].count / total * 100,
                    barFactor: maxCount == 0
                        ? 0
                        : distribution[i].count / maxCount,
                  ),
                  if (i != distribution.length - 1)
                    const SizedBox(height: TradeSpacingTokens.tradeBotCardGap),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _durationLabel(String raw) {
  return switch (raw) {
    '<1h' => 'Dưới 1 giờ',
    '1-6h' => '1–6 giờ',
    '6-24h' => '6–24 giờ',
    '>24h' => 'Trên 24 giờ',
    _ => raw,
  };
}

class _DurationLegendRow extends StatelessWidget {
  const _DurationLegendRow({
    required this.color,
    required this.label,
    required this.count,
    required this.percent,
    required this.barFactor,
  });

  final Color color;
  final String label;
  final int count;
  final double percent;
  final double barFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            DecoratedBox(
              decoration: ShapeDecoration(
                color: color,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: const SizedBox(
                width: AppSpacing.x3,
                height: AppSpacing.x3,
              ),
            ),
            const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text1),
              ),
            ),
            Text(
              '${percent.toStringAsFixed(0)}%',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: AppRadii.pillRadius,
                child: SizedBox(
                  height: AppSpacing.pageRhythmCompactInnerGap,
                  child: LinearProgressIndicator(
                    value: barFactor.clamp(0, 1),
                    backgroundColor: _chartTrack,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
            ),
            const SizedBox(width: TradeSpacingTokens.tradeBotTinyGap),
            Text(
              '$count',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCardPadding,
      density: VitDensity.tool,
      borderColor: _analyticsGreen.withValues(alpha: .22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitAccentIconBox(
            icon: Icons.workspace_premium_outlined,
            color: _analyticsGreen,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hiệu suất xuất sắc (A+)',
                  style: AppTextStyles.caption.copyWith(
                    color: _analyticsGreen,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                Text(
                  'Các bot giao dịch của bạn đang hoạt động trên mức trung bình. Tỷ lệ Sharpe > 1.5, tỷ lệ thắng > 65% và hệ số lợi nhuận > 2 cho thấy lợi nhuận đã điều chỉnh theo rủi ro ở mức mạnh. Tiếp tục theo dõi và điều chỉnh khi điều kiện thị trường thay đổi.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
