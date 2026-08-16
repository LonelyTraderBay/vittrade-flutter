part of '../../phone/pages/ads/p2p_ad_analytics_page.dart';

class _VolumeCard extends StatelessWidget {
  const _VolumeCard({required this.points});

  final List<P2PAdDailyPerformanceDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Volume giao dịch',
            icon: Icons.bar_chart_rounded,
            iconColor: AppColors.primary,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          Text(
            'Tổng giá trị giao dịch theo ngày (VND)',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            height: _p2pAdAnalyticsChartTallExtent,
            child: CustomPaint(
              painter: _VolumeBarPainter(points),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.points});

  final List<P2PAdHourlyHeatmapDraft> points;

  @override
  Widget build(BuildContext context) {
    final maxOrders = points.fold<int>(
      0,
      (max, point) => math.max(max, point.orders),
    );

    return VitCard(
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Heatmap theo giờ',
            icon: Icons.monitor_heart_outlined,
            iconColor: AppColors.buy,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          Text(
            'Số đơn hàng phân bổ theo giờ trong ngày (0-23h)',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final gap = AppSpacing.x2;
              final side = (constraints.maxWidth - gap * 11) / 12;
              return Wrap(
                spacing: gap,
                runSpacing: AppSpacing.x3,
                children: [
                  for (final point in points)
                    SizedBox(
                      width: side,
                      child: Column(
                        children: [
                          Material(
                            color: _heatColor(point.orders, maxOrders),
                            borderRadius: AppRadii.smRadius,
                            child: SizedBox(width: side, height: side),
                          ),
                          if (point.hour % 3 == 0) ...[
                            const SizedBox(height: AppSpacing.x1),
                            Text(
                              '${point.hour}h',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                height: _p2pAdAnalyticsTightLine,
                              ),
                            ),
                          ] else
                            const SizedBox(
                              height: AppSpacing.pageRhythmStandardInnerGap,
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LegendDot(color: AppColors.buy10, label: 'Ít'),
              Row(
                children: [
                  _HeatLegendCell(alpha: .22),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .38),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .54),
                  SizedBox(width: AppSpacing.x1),
                  _HeatLegendCell(alpha: .70),
                ],
              ),
              _LegendDot(color: AppColors.buy, label: 'Nhiều'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentBreakdownCard extends StatelessWidget {
  const _PaymentBreakdownCard({required this.snapshot});

  final P2PAdAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final total = snapshot.paymentBreakdown.fold<int>(
      0,
      (sum, item) => sum + item.volume,
    );

    return VitCard(
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Thanh toán phân bổ',
            icon: Icons.credit_card_rounded,
            iconColor: AppColors.warn,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (var i = 0; i < snapshot.paymentBreakdown.length; i++) ...[
            _PaymentRow(
              item: snapshot.paymentBreakdown[i],
              totalVolume: total,
              color: i.isEven ? AppColors.accent : AppColors.primary,
            ),
            if (i < snapshot.paymentBreakdown.length - 1)
              const SizedBox(height: AppSpacing.rowGap),
          ],
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.item,
    required this.totalVolume,
    required this.color,
  });

  final P2PAdPaymentBreakdownDraft item;
  final int totalVolume;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pct = totalVolume == 0 ? 0.0 : item.volume / totalVolume;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.method,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              '${item.count} đơn',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(width: AppSpacing.x4),
            Text(
              _formatCompactVnd(item.volume),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.smRadius,
          child: LinearProgressIndicator(
            value: pct,
            minHeight: AppSpacing.x2,
            backgroundColor: AppColors.surface2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class _CompetitorCard extends StatelessWidget {
  const _CompetitorCard({required this.rows});

  final List<P2PAdCompetitorComparisonDraft> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'So sánh đối thủ',
            icon: Icons.emoji_events_outlined,
            iconColor: AppColors.warn,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          Text(
            'So với trung bình thị trường & top merchant',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          SizedBox(
            height: _p2pAdAnalyticsRadarExtent,
            child: CustomPaint(
              painter: _RadarComparisonPainter(rows),
              child: const SizedBox.expand(),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: AppColors.accent, label: 'Bạn'),
              SizedBox(width: AppSpacing.x4),
              _LegendDot(color: AppColors.text3, label: 'TB thị trường'),
              SizedBox(width: AppSpacing.x4),
              _LegendDot(color: AppColors.buy, label: 'Top'),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.ghost,
            borderColor: AppColors.divider,
            clip: true,
            child: Column(
              children: [
                const _ComparisonTableRow(
                  metric: 'Chỉ số',
                  yours: 'Bạn',
                  average: 'TB',
                  top: 'Top',
                  header: true,
                ),
                for (final row in rows)
                  _ComparisonTableRow(
                    metric: row.metric,
                    yours: _formatComparison(row.metric, row.yours),
                    average: _formatComparison(row.metric, row.average),
                    top: _formatComparison(row.metric, row.top),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonTableRow extends StatelessWidget {
  const _ComparisonTableRow({
    required this.metric,
    required this.yours,
    required this.average,
    required this.top,
    this.header = false,
  });

  final String metric;
  final String yours;
  final String average;
  final String top;
  final bool header;

  @override
  Widget build(BuildContext context) {
    final bg = header ? AppColors.surface2 : AppColors.transparent;
    final weight = header ? AppTextStyles.bold : AppTextStyles.normal;

    return ColoredBox(
      color: bg,
      child: Column(
        children: [
          if (!header)
            const Divider(
              height: _p2pAdAnalyticsDividerExtent,
              color: AppColors.divider,
            ),
          Padding(
            padding: P2PSpacingTokens.p2pMarketplaceAnalyticsTableCellPadding,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    metric,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: header ? AppColors.text3 : AppColors.text2,
                      fontWeight: weight,
                    ),
                  ),
                ),
                Expanded(
                  child: _TableCell(
                    text: yours,
                    color: header ? AppColors.accent : AppColors.text1,
                    bold: header,
                  ),
                ),
                Expanded(
                  child: _TableCell(
                    text: average,
                    color: AppColors.text3,
                    bold: header,
                  ),
                ),
                Expanded(
                  child: _TableCell(
                    text: top,
                    color: AppColors.buy,
                    bold: header,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({
    required this.text,
    required this.color,
    required this.bold,
  });

  final String text;
  final Color color;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: AppTextStyles.micro.copyWith(
        color: color,
        fontWeight: bold ? AppTextStyles.bold : AppTextStyles.medium,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard({required this.tips});

  final List<P2PAdOptimizationTipDraft> tips;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSectionHeader(
            title: 'Gợi ý tối ưu',
            icon: Icons.bolt_rounded,
            iconColor: AppColors.warn,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (var i = 0; i < tips.length; i++) ...[
            _TipRow(tip: tips[i]),
            if (i < tips.length - 1) const SizedBox(height: AppSpacing.rowGap),
          ],
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.tip});

  final P2PAdOptimizationTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.tone);

    return Material(
      color: color.withValues(alpha: .06),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color.withValues(alpha: .14)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pMarketplaceAnalyticsCompactPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_tipIcon(tip.iconKey), color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                tip.text,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  height: _p2pAdAnalyticsBodyLine,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallInlineStat extends StatelessWidget {
  const _SmallInlineStat({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}
