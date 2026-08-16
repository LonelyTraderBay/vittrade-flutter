part of '../../phone/pages/hub/regulatory_reports_dashboard_page.dart';

class _QueueTab extends StatelessWidget {
  const _QueueTab({required this.snapshot});

  final TradeRegulatoryReportsDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Submission Queue Summary',
      density: VitDensity.tool,
      children: [
        for (final stat in snapshot.dailyStats.take(4))
          VitCard(
            radius: VitCardRadius.tight,
            padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
            borderColor: _dashBorder.withValues(alpha: .7),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: _dashPrimary,
                  size: TradeSpacingTokens.tradeBotActionIcon,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    stat.date,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                _SmallPill(
                  label: '${stat.confirmed} confirmed',
                  color: _dashGreen,
                ),
                const SizedBox(width: AppSpacing.x2),
                _SmallPill(label: '${stat.failed} failed', color: _dashRed),
              ],
            ),
          ),
      ],
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: label,
      status: color == _dashGreen
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.error,
      size: VitStatusPillSize.sm,
    );
  }
}

class _ComplianceTab extends StatelessWidget {
  const _ComplianceTab({required this.totals});

  final TradeRegulatoryDashboardTotals totals;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('SLA Compliance (T+1)', 100.0, '100%', _dashGreen),
      ('Field Accuracy (RTS 22)', 99.8, '99.8%', _dashGreen),
      (
        'Submission Success Rate',
        totals.successRate,
        '${totals.successRate.toStringAsFixed(1)}%',
        _dashGreen,
      ),
      (
        'Latency Performance (<60s)',
        totals.avgLatency / 60 * 100,
        '${totals.avgLatency.round()}s',
        _dashGreen,
      ),
    ];
    return VitPageSection(
      label: 'Compliance Metrics',
      density: VitDensity.tool,
      children: [
        VitCard(
          radius: VitCardRadius.tight,
          padding: TradeSpacingTokens.tradeBotCardPadding,
          borderColor: _dashBorder.withValues(alpha: .7),
          child: VitPageContent(
            rhythm: VitPageRhythm.standard,
            padding: VitContentPadding.none,
            density: VitDensity.tool,
            children: [
              for (final item in items)
                _ProgressMetric(
                  label: item.$1,
                  pct: item.$2,
                  value: item.$3,
                  color: item.$4,
                ),
              VitCard(
                radius: VitCardRadius.tight,
                padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
                variant: VitCardVariant.inner,
                borderColor: _dashGreen.withValues(alpha: .25),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      color: _dashGreen,
                      size: TradeSpacingTokens.tradeBotMediumIcon,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Text(
                        'Full regulatory compliance maintained for 90 consecutive days',
                        style: AppTextStyles.caption.copyWith(
                          color: _dashGreen,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  const _ProgressMetric({
    required this.label,
    required this.pct,
    required this.value,
    required this.color,
  });

  final String label;
  final double pct;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        // card-tile: allow-start — fixed surface, not horizontal strip tile
        VitCard(
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.tight,
          height: AppSpacing.x2,
          clip: true,
          background: const ColoredBox(color: _dashPanel2),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: math.min(pct / 100, 1),
              child: ColoredBox(color: color),
            ),
          ),
        ),
      ],
    );
  }
}
