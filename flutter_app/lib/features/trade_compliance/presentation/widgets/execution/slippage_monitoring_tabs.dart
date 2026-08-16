part of '../../phone/pages/execution/slippage_monitoring_page.dart';

class _ProvidersTab extends StatelessWidget {
  const _ProvidersTab({required this.providers});

  final List<TradeSlippageProviderStats> providers;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Provider Performance',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _slipPrimary,
        ),
        for (final provider in providers)
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            padding: AppSpacing.cardPaddingCompact,
            borderColor: _slipBorder.withValues(alpha: .72),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider.provider,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${provider.avgSlippage.toStringAsFixed(1)} bps',
                      style: AppTextStyles.body.copyWith(
                        color: provider.criticalCount > 0
                            ? _slipRed
                            : _slipGreen,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Events',
                        value: provider.eventCount.toString(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: _EventMetric(
                        label: 'Max Slippage',
                        value: '${provider.maxSlippage.toStringAsFixed(1)} bps',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: _EventMetric(
                        label: 'Cost Impact',
                        value: '\$${_formatInt(provider.totalImpact)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.history});

  final List<TradeSlippageHistoryPoint> history;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Slippage Trends (Last 7 Days)',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _slipPrimary,
        ),
        VitCard(
          density: VitDensity.tool,
          radius: VitCardRadius.tight,
          padding: AppSpacing.cardPaddingCompact,
          borderColor: _slipBorder.withValues(alpha: .72),
          child: Column(
            children: [
              for (final point in history) ...[
                Row(
                  children: [
                    SizedBox(
                      width: TradeSpacingTokens.tradeToolDateColumnWidth,
                      child: Text(
                        point.date,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (point.max / 120).clamp(0, 1).toDouble(),
                        minHeight: TradeSpacingTokens.tradeToolProgressHeight,
                        color: _slipRed,
                        backgroundColor: _slipPanel2,
                        borderRadius: AppRadii.pillRadius,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      '${point.max.toStringAsFixed(1)} bps',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                if (point != history.last)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertsTab extends StatelessWidget {
  const _AlertsTab();

  @override
  Widget build(BuildContext context) {
    return const VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        VitSectionHeader(
          title: 'Alert Configuration',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _slipPrimary,
        ),
        _AlertSetting(
          title: 'Critical Slippage Alert',
          subtitle: 'Notify when slippage exceeds 1%',
          value: 'Current Threshold: 100 bps (1.0%)',
          enabled: true,
        ),
        _AlertSetting(
          title: 'Warning Slippage Alert',
          subtitle: 'Notify when slippage exceeds 0.5%',
          value: 'Current Threshold: 50 bps (0.5%)',
          enabled: true,
        ),
        _AlertSetting(
          title: 'Daily Summary Email',
          subtitle: 'Receive daily slippage report at 9:00 AM',
          value: 'Disabled',
          enabled: false,
        ),
      ],
    );
  }
}

class _AlertSetting extends StatelessWidget {
  const _AlertSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.enabled,
  });

  final String title;
  final String subtitle;
  final String value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _slipBorder.withValues(alpha: .72),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      subtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _SwitchVisual(enabled: enabled),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            width: double.infinity,
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x2,
            ),
            child: Text(
              value,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}
