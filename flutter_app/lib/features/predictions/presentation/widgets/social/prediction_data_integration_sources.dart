part of '../../phone/pages/social/prediction_data_integration_page.dart';

class _DataIntegrationTabBar extends StatelessWidget {
  const _DataIntegrationTabBar({
    required this.activeTab,
    required this.onChanged,
  });

  final _DataIntegrationTab activeTab;
  final ValueChanged<_DataIntegrationTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return PredictionEnumTabBar<_DataIntegrationTab>(
      activeTab: activeTab,
      onChanged: onChanged,
      items: const [
        (
          PredictionDataIntegrationPage.sourcesTabKey,
          _DataIntegrationTab.sources,
          'Nguon du lieu',
        ),
        (
          PredictionDataIntegrationPage.apiKeysTabKey,
          _DataIntegrationTab.apiKeys,
          'API Keys',
        ),
        (
          PredictionDataIntegrationPage.webhooksTabKey,
          _DataIntegrationTab.webhooks,
          'Webhooks',
        ),
      ],
    );
  }
}

class _SourcesOverview extends StatelessWidget {
  const _SourcesOverview({required this.snapshot});

  final PredictionDataIntegrationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: AppColors.buy.withValues(alpha: .1),
                borderRadius: AppRadii.inputRadius,
                child: const SizedBox.square(
                  dimension: PredictionsSpacingTokens.predictionDataHeroIconBox,
                  child: Icon(
                    Icons.storage_rounded,
                    color: AppColors.buy,
                    size: PredictionsSpacingTokens.predictionDataHeroIcon,
                  ),
                ),
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionDataHeroGap,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oracle Data Sources',
                      style: AppTextStyles.base.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'External data feeds for event resolution',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _OverviewMetric(
                  label: 'Active',
                  value: '${snapshot.activeSources}',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Avg Reliability',
                  value: '${snapshot.averageReliability.toStringAsFixed(1)}%',
                ),
              ),
              Expanded(
                child: _OverviewMetric(
                  label: 'Events Resolved',
                  value: '${snapshot.eventsResolved}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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

class _SourceSection extends StatelessWidget {
  const _SourceSection({required this.sources});

  final List<PredictionDataSourceDraft> sources;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Configured Sources',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [for (final source in sources) _SourceCard(source: source)],
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({required this.source});

  final PredictionDataSourceDraft source;

  @override
  Widget build(BuildContext context) {
    final color = _sourceStatusColor(source.status);
    return VitCard(
      key: PredictionDataIntegrationPage.sourceKey(source.id),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing:
                          PredictionsSpacingTokens.predictionDataHeaderWrapGap,
                      runSpacing:
                          PredictionsSpacingTokens.predictionDataHeaderRunGap,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          source.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _MiniStatusPill(
                          label: _sourceStatusLabel(source.status),
                          color: color,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${source.provider} - ${source.category}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Material(
                color: AppColors.bg,
                shape: CircleBorder(),
                child: SizedBox.square(
                  dimension: PredictionsSpacingTokens.predictionDataIconBubble,
                  child: Icon(
                    Icons.refresh_rounded,
                    color: AppColors.text3,
                    size: PredictionsSpacingTokens.predictionDataIconBubbleIcon,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'Last Sync',
                  value: source.lastSyncLabel,
                ),
              ),
              Expanded(
                child: _CompactMetric(
                  label: 'Events',
                  value: '${source.eventsResolved}',
                ),
              ),
              Expanded(
                child: _CompactMetric(
                  label: 'Reliability',
                  value: _formatPercent(source.reliability),
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
          if (source.apiUrl != null) ...[
            const SizedBox(height: AppSpacing.x1),
            Row(
              children: [
                const Icon(
                  Icons.link_rounded,
                  color: AppColors.text3,
                  size: PredictionsSpacingTokens.predictionDataSourceLinkIcon,
                ),
                const SizedBox(
                  width: PredictionsSpacingTokens.predictionDataSourceLinkGap,
                ),
                Expanded(
                  child: Text(
                    source.apiUrl!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
