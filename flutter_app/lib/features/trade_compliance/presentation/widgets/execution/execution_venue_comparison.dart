part of '../../phone/pages/execution/execution_venue_analysis_page.dart';

class _ComparisonTab extends StatelessWidget {
  const _ComparisonTab({required this.venues});

  final List<TradeExecutionVenueAnalysisMetric> venues;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Venue Comparison',
      density: VitDensity.tool,
      children: [
        for (var index = 0; index < venues.length; index++)
          _VenueCard(venue: venues[index], rank: index + 1),
      ],
    );
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({required this.venue, required this.rank});

  final TradeExecutionVenueAnalysisMetric venue;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final isWinner = rank == 1;
    return VitCard(
      key: ExecutionVenueAnalysisPage.venueKey(venue.venue),
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _venueBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            children: [
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              VitCard(
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                alignment: Alignment.center,
                variant: VitCardVariant.inner,
                radius: VitCardRadius.tight,
                borderColor: isWinner
                    ? _venueAmber.withValues(alpha: .28)
                    : AppColors.transparent,
                child: Text(
                  '#$rank',
                  style: AppTextStyles.caption.copyWith(
                    color: isWinner ? _venueAmber : AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: TradeSpacingTokens.executionVenueRankGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.venue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    Text(
                      '${_formatInt(venue.volume)} orders • ${_formatUsd(venue.value)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              if (isWinner)
                const Icon(
                  Icons.workspace_premium_outlined,
                  color: _venueAmber,
                  size: TradeSpacingTokens.executionVenueWinnerIcon,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Total Cost',
                  value: '${venue.totalCost.toStringAsFixed(2)} bps',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Fill Time',
                  value: '${_formatSpeed(venue.avgFillTime)}s',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Fill Rate',
                  value: '${venue.fillRate.toStringAsFixed(1)}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MetricBox(
                  label: 'Liquidity',
                  value: '\$${venue.liquidity}M',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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

class _CostsTab extends StatelessWidget {
  const _CostsTab({required this.venues});

  final List<TradeExecutionVenueAnalysisMetric> venues;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Cost Breakdown',
      density: VitDensity.tool,
      children: [for (final venue in venues) _CostCard(venue: venue)],
    );
  }
}

class _CostCard extends StatelessWidget {
  const _CostCard({required this.venue});

  final TradeExecutionVenueAnalysisMetric venue;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _venueBorder.withValues(alpha: .72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            venue.venue,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _ProgressMetric(
            label: 'Trading Fee',
            value: '${venue.avgFee.toStringAsFixed(2)}%',
            factor: venue.avgFee / .12,
            color: _venuePrimary,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _ProgressMetric(
            label: 'Spread Cost',
            value: '${venue.avgSpread.toStringAsFixed(1)} bps',
            factor: venue.avgSpread / 3.2,
            color: _venueGreen,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _ProgressMetric(
            label: 'Market Impact',
            value: '${venue.marketImpact.toStringAsFixed(1)} bps',
            factor: venue.marketImpact / 1.6,
            color: _venueAmber,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: _venueBorder,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total Cost',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '${venue.totalCost.toStringAsFixed(2)} bps',
                style: AppTextStyles.caption.copyWith(
                  color: _venuePrimary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
