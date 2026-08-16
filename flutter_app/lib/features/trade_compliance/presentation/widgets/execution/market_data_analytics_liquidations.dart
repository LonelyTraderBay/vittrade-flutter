part of '../../phone/pages/execution/market_data_analytics_page.dart';

class _LiquidationsTab extends StatelessWidget {
  const _LiquidationsTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.liquidationStats;
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              const _CardHeader(
                icon: Icons.flash_on_rounded,
                iconColor: _analyticsAmber,
                title: 'Liquidation Stats',
              ),
              Row(
                children: [
                  Expanded(
                    child: _MetricBubble(
                      label: '24h Total',
                      value: _formatCompactUsd(stats.total24h),
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBubble(
                      label: 'Long Liq',
                      value: _formatCompactUsd(stats.long24h),
                      color: _analyticsGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: _MetricBubble(
                      label: 'Short Liq',
                      value: _formatCompactUsd(stats.short24h),
                      color: _analyticsRed,
                    ),
                  ),
                ],
              ),
              _ValueRow(
                label: 'Largest liquidation',
                value: _formatCompactUsd(stats.largest24h),
              ),
              _ValueRow(
                label: 'Liquidation count',
                value: _formatInt(stats.count24h),
              ),
            ],
          ),
        ),
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              const _CardHeader(
                icon: Icons.grid_view_rounded,
                iconColor: _analyticsRed,
                title: 'Liquidation Heatmap',
              ),
              for (final cluster in snapshot.liquidationClusters)
                _HeatmapRow(cluster: cluster),
            ],
          ),
        ),
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              const _CardHeader(
                icon: Icons.history_rounded,
                iconColor: _analyticsPrimary,
                title: 'Recent Liquidations',
                badge: 'Live',
              ),
              for (final liquidation in snapshot.recentLiquidations)
                _LiquidationRow(liquidation: liquidation),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _HeatmapRow extends StatelessWidget {
  const _HeatmapRow({required this.cluster});

  final TradeLiquidationCluster cluster;

  @override
  Widget build(BuildContext context) {
    final isCurrent = cluster.intensity == 0;
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Text(
            '\$${cluster.price.toStringAsFixed(0)}',
            style: AppTextStyles.caption.copyWith(
              color: isCurrent ? _analyticsPrimary : AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x3,
              value: math.max(cluster.intensity / 100, .02),
              backgroundColor: _analyticsPanel2,
              color:
                  (cluster.shortLiquidations >= cluster.longLiquidations
                          ? _analyticsRed
                          : _analyticsGreen)
                      .withValues(alpha: isCurrent ? .18 : .78),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Text(
            isCurrent ? 'Mark' : _formatCompactUsd(cluster.total),
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: isCurrent ? _analyticsPrimary : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _LiquidationRow extends StatelessWidget {
  const _LiquidationRow({required this.liquidation});

  final TradeRecentLiquidation liquidation;

  @override
  Widget build(BuildContext context) {
    final isLong = liquidation.side == 'long';
    final color = isLong ? _analyticsGreen : _analyticsRed;
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      child: Row(
        children: [
          _SmallBadge(label: liquidation.side.toUpperCase(), color: color),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              '${liquidation.pair} @ \$${_formatMoney(liquidation.price)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            _formatCompactUsd(liquidation.size),
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
