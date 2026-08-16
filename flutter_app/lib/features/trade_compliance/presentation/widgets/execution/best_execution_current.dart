part of '../../phone/pages/execution/best_execution_reports_page.dart';

class _CurrentReport extends StatelessWidget {
  const _CurrentReport({
    required this.venues,
    required this.onAnalysis,
    required this.onExport,
    required this.onPublish,
  });

  final List<TradeExecutionVenue> venues;
  final VoidCallback onAnalysis;
  final VoidCallback onExport;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        VitPageSection(
          label: 'Top 5 Execution Venues (By Volume)',
          density: VitDensity.tool,
          children: [for (final venue in venues) _VenueCard(venue: venue)],
        ),
        _AnalysisButton(onTap: onAnalysis),
        VitPageSection(
          label: 'Report Actions',
          density: VitDensity.tool,
          children: [_ReportActions(onExport: onExport, onPublish: onPublish)],
        ),
      ],
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.venue});

  final TradeExecutionVenue venue;

  @override
  Widget build(BuildContext context) {
    final isWinner = venue.rank == 1;
    return VitCard(
      key: BestExecutionReportsPage.venueKey(venue.rank),
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _bestBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: AppSpacing.x4,
                backgroundColor: isWinner
                    ? _bestAmber.withValues(alpha: .12)
                    : _bestPanel2,
                child: Text(
                  '#${venue.rank}',
                  style: AppTextStyles.body.copyWith(
                    color: isWinner ? _bestAmber : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            venue.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (isWinner) ...[
                          const SizedBox(
                            width: WalletSpacingTokens.walletAssetPillGap,
                          ),
                          const Icon(
                            Icons.workspace_premium_outlined,
                            color: _bestAmber,
                            size: AppSpacing.iconSm + AppSpacing.hairlineStroke,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_formatInt(venue.volume)} orders • ${_formatUsd(venue.value)} value',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    venue.score.toStringAsFixed(1),
                    style: AppTextStyles.body.copyWith(
                      color: _bestGreen,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Quality',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _VenueMetric(
                  label: 'Avg Price',
                  value: '\$${_formatInt(venue.avgPrice)}',
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: _VenueMetric(
                  label: 'Cost',
                  value:
                      '${venue.avgCost.toStringAsFixed(venue.avgCost == .10 ? 1 : 2)}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: _VenueMetric(
                  label: 'Speed',
                  value:
                      '${venue.avgSpeed.toStringAsFixed(venue.avgSpeed == .3 || venue.avgSpeed == .4 || venue.avgSpeed == .5 ? 1 : 2)}s',
                ),
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: _VenueMetric(
                  label: 'Fill Rate',
                  value: '${venue.fillRate.toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Composite Quality Score',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${venue.score.toStringAsFixed(1)}/100',
                style: AppTextStyles.micro.copyWith(
                  color: _bestGreen,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              minHeight: 3,
              value: (venue.score / 100).clamp(0, 1).toDouble(),
              backgroundColor: _bestPanel2,
              color: _bestGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueMetric extends StatelessWidget {
  const _VenueMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisButton extends StatelessWidget {
  const _AnalysisButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: BestExecutionReportsPage.analysisKey,
      onPressed: onTap,
      variant: VitCtaButtonVariant.secondary,
      density: VitDensity.tool,
      leading: const Icon(Icons.bar_chart_rounded, color: AppColors.text1),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.text1),
      child: Text(
        'View Detailed Analysis',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
