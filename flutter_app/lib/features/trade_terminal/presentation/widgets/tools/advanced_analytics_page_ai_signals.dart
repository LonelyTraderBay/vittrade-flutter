part of '../../phone/pages/tools/advanced_analytics_page.dart';

class _AiSignalsTab extends StatelessWidget {
  const _AiSignalsTab({
    required this.snapshot,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final TradeAdvancedAnalyticsSnapshot snapshot;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final visibleSignals = activeFilter == 'all'
        ? snapshot.signals
        : snapshot.signals
              .where((signal) => signal.direction == activeFilter)
              .toList();
    final avgConfidence =
        snapshot.signals.fold<int>(0, (sum, item) => sum + item.confidence) /
        snapshot.signals.length;
    final longCount = snapshot.signals
        .where((signal) => signal.direction == 'long')
        .length;
    final shortCount = snapshot.signals
        .where((signal) => signal.direction == 'short')
        .length;

    return _Card(
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          const _SectionHeader(
            icon: Icons.psychology_rounded,
            color: _advancedPurple,
            title: 'AI Trading Signals',
            subtitle: 'Machine learning powered predictions',
            iconSize: 24,
          ),
          Row(
            children: [
              Expanded(
                child: _MiniStatBox(
                  label: 'Active',
                  value: '${snapshot.signals.length}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatBox(
                  label: 'Avg Confidence',
                  value: '${avgConfidence.toStringAsFixed(0)}%',
                  valueColor: _advancedGreen,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniStatBox(
                  label: 'L/S Ratio',
                  value: '$longCount/$shortCount',
                ),
              ),
            ],
          ),
          Row(
            children: [
              for (final filter in const ['all', 'long', 'short']) ...[
                Expanded(
                  child: VitChoicePill(
                    key: AdvancedAnalyticsPage.filterKey(filter),
                    label: filter.toUpperCase(),
                    selected: activeFilter == filter,
                    onTap: () => onFilterChanged(filter),
                    accentColor: _advancedPurple,
                    fullWidth: true,
                  ),
                ),
                if (filter != 'short') const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
          for (final signal in visibleSignals) _SignalCard(signal: signal),
          const _DisclaimerCard(),
        ],
      ),
    );
  }
}

class _MiniStatBox extends StatelessWidget {
  const _MiniStatBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      child: Column(
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
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return const VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      density: VitDensity.tool,
      title: 'AI Prediction Disclaimer',
      message:
          'Signals are predictions, not guarantees. Always conduct your own research and risk management. Past accuracy does not guarantee future results.',
    );
  }
}
