part of '../../phone/pages/hub/regulatory_reports_dashboard_page.dart';

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final TradeRegulatoryReportsDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        VitPageSection(
          label: 'Submission Trend (Last 7 Days)',
          density: VitDensity.tool,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
              borderColor: _dashBorder.withValues(alpha: .7),
              child: AspectRatio(
                aspectRatio: 2.4,
                child: CustomPaint(
                  painter: _TrendPainter(stats: snapshot.dailyStats),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Report Distribution by Regulation',
          density: VitDensity.tool,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: VitCard(
                    radius: VitCardRadius.tight,
                    padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
                    borderColor: _dashBorder.withValues(alpha: .7),
                    child: AspectRatio(
                      aspectRatio: 1.25,
                      child: CustomPaint(
                        painter: _DonutPainter(items: snapshot.distribution),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: _DistributionLegend(
                    items: snapshot.distribution,
                    total: snapshot.totals.distributionTotal,
                  ),
                ),
              ],
            ),
          ],
        ),
        VitPageSection(
          label: 'ARM Provider Performance',
          density: VitDensity.tool,
          children: [
            for (final provider in snapshot.providers)
              _ProviderCard(provider: provider),
          ],
        ),
      ],
    );
  }
}

class _DistributionLegend extends StatelessWidget {
  const _DistributionLegend({required this.items, required this.total});

  final List<TradeRegulatoryDistributionItem> items;
  final int total;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        for (final item in items)
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            variant: VitCardVariant.inner,
            constraints: BoxConstraints(
              minHeight: VitDensity.tool.controlHeight,
            ),
            child: Row(
              children: [
                // card-tile: allow-start — fixed surface, not horizontal strip tile
                VitCard(
                  variant: VitCardVariant.ghost,
                  radius: VitCardRadius.tight,
                  width: AppSpacing.x3,
                  height: AppSpacing.x3,
                  clip: true,
                  background: ColoredBox(color: Color(item.colorHex)),
                  child: const SizedBox.shrink(),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                Text(
                  _formatInt(item.value),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        VitCard(
          padding: TradeSpacingTokens.tradeBotCompactCardPadding,
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.tight,
          borderColor: _dashBorder,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _formatInt(total),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider});

  final TradeRegulatoryArmProvider provider;

  @override
  Widget build(BuildContext context) {
    final healthy = provider.status == 'healthy';
    final color = healthy ? _dashGreen : _dashAmber;
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
      borderColor: _dashBorder.withValues(alpha: .7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.tight,
                width: TradeSpacingTokens.tradeBotCorrelationLegendDot,
                height: TradeSpacingTokens.tradeBotCorrelationLegendDot,
                clip: true,
                background: ColoredBox(color: color),
                child: const SizedBox.shrink(),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  provider.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${_formatInt(provider.reports)} reports',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _SmallMetric(
                  label: 'Success Rate',
                  value: '${provider.successRate.toStringAsFixed(1)}%',
                  color: _dashGreen,
                ),
              ),
              Expanded(
                child: _SmallMetric(
                  label: 'Avg Latency',
                  value: '${provider.avgLatency}s',
                ),
              ),
              Expanded(
                child: _SmallMetric(
                  label: 'Status',
                  value: provider.status,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

String _formatInt(int value) => formatTradeInt(value);
