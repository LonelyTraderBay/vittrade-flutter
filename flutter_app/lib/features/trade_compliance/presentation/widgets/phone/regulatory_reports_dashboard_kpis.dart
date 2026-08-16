part of '../../phone/pages/hub/regulatory_reports_dashboard_page.dart';

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.totals});

  final TradeRegulatoryDashboardTotals totals;

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        'Total Reports',
        _formatInt(totals.total),
        '+12% vs last week',
        _dashPrimary,
        Icons.description_outlined,
      ),
      (
        'Success Rate',
        '${totals.successRate.toStringAsFixed(1)}%',
        '${totals.confirmed}/${totals.total} confirmed',
        _dashGreen,
        Icons.check_circle_outline,
      ),
      (
        'Avg Latency',
        '${totals.avgLatency.round()}s',
        'Under 60s SLA',
        _dashAmber,
        Icons.bolt_rounded,
      ),
      (
        'Failed',
        '${totals.failed}',
        '${(totals.failed / totals.total * 100).toStringAsFixed(1)}% failure rate',
        _dashRed,
        Icons.cancel_outlined,
      ),
    ];

    return Row(
      key: RegulatoryReportsDashboardPage.kpiGridKey,
      children: [
        for (final item in items) ...[
          Expanded(child: _KpiCard(item: item)),
          if (item != items.last)
            const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
        ],
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.item});

  final (String, String, String, Color, IconData) item;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _dashBorder.withValues(alpha: .68),
      constraints: const BoxConstraints(
        minHeight: AppSpacing.x7 + AppSpacing.x5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                item.$5,
                color: item.$4,
                size: TradeSpacingTokens.tradeBotMediumIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  item.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            item.$2,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            item.$3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: item.$4 == _dashAmber ? _dashGreen : item.$4,
            ),
          ),
        ],
      ),
    );
  }
}
