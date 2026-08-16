part of 'social_signals_page.dart';

class _ProviderMetric extends StatelessWidget {
  const _ProviderMetric({
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
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
      ],
    );
  }
}

class _PerformanceSummary extends StatelessWidget {
  const _PerformanceSummary({required this.snapshot});

  final MarketSocialSignalsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hiệu suất tổng hợp',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.medium,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Win rate',
                  value: '${snapshot.overallWinRate.toStringAsFixed(1)}%',
                  color: AppColors.warn,
                ),
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'TB PnL',
                  value: _formatPercent(snapshot.avgPnl),
                  color: snapshot.avgPnl >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'Tổng signals',
                  value: '${snapshot.totalSignals}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
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
      children: [
        Text(
          value,
          style: AppTextStyles.sectionTitleSm.copyWith(
            color: color,
            fontFeatures: AppTextStyles.tabularFigures,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
      ],
    );
  }
}

class _StatusBreakdown extends StatelessWidget {
  const _StatusBreakdown({required this.snapshot});

  final MarketSocialSignalsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final counts = <TradingSignalStatus, int>{
      for (final status in snapshot.statusConfigs.keys)
        status: snapshot.signals
            .where((signal) => signal.status == status)
            .length,
    };

    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ trạng thái',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              height: AppSpacing.pageRhythmStandardInnerGap,
              child: Row(
                children: [
                  for (final entry in counts.entries)
                    if (entry.value > 0)
                      Expanded(
                        flex: entry.value,
                        child: ColoredBox(
                          color: snapshot.statusConfigs[entry.key]!.color
                              .resolve(),
                        ),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.rowGap,
            runSpacing: MarketsSpacingTokens.marketSocialCompactGap,
            children: [
              for (final entry in counts.entries)
                if (entry.value > 0)
                  _LegendItem(
                    color: snapshot.statusConfigs[entry.key]!.color.resolve(),
                    label:
                        '${snapshot.statusConfigs[entry.key]!.label}: ${entry.value}',
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
          child: const SizedBox.square(
            dimension: MarketsSpacingTokens.marketSocialLegendDot,
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketSocialCompactGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
      ],
    );
  }
}

class _SignalResultRow extends StatelessWidget {
  const _SignalResultRow({required this.signal, required this.statusConfig});

  final TradingSignalDraft signal;
  final SignalStatusConfig statusConfig;

  @override
  Widget build(BuildContext context) {
    final positive = signal.pnlPct >= 0;
    return Material(
      color: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      child: Padding(
        padding: MarketsSpacingTokens.marketSocialResultPadding,
        child: Row(
          children: [
            Icon(
              positive ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: positive ? AppColors.buy : AppColors.sell,
              size: MarketsSpacingTokens.marketSocialResultIcon,
            ),
            const SizedBox(width: AppSpacing.rowGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        signal.pair,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          height: AppTextStyles.numericMicro.height,
                        ),
                      ),
                      const SizedBox(
                        width: MarketsSpacingTokens.marketSocialGap,
                      ),
                      _TinyBadge(
                        label: signal.direction == TradingSignalDirection.long
                            ? 'LONG'
                            : 'SHORT',
                        color: signal.direction == TradingSignalDirection.long
                            ? AppColors.buy
                            : AppColors.sell,
                        background:
                            signal.direction == TradingSignalDirection.long
                            ? AppColors.buy10
                            : AppColors.sell10,
                      ),
                    ],
                  ),
                  Text(
                    '${signal.providerName} · ${signal.timeAgo}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppTextStyles.numericMicro.height,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _formatPercent(signal.pnlPct),
              style: AppTextStyles.caption.copyWith(
                color: positive ? AppColors.buy : AppColors.sell,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
                height: AppTextStyles.numericMicro.height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalsEmptyState extends StatelessWidget {
  const _SignalsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      density: VitDensity.compact,
      icon: Icons.track_changes_rounded,
      title: 'Không có tín hiệu phù hợp',
    );
  }
}

_ConfidenceMeta _confidenceMeta(TradingSignalConfidence confidence) {
  return switch (confidence) {
    TradingSignalConfidence.high => const _ConfidenceMeta('Cao', AppColors.buy),
    TradingSignalConfidence.medium => const _ConfidenceMeta(
      'TB',
      AppColors.warn,
    ),
    TradingSignalConfidence.low => const _ConfidenceMeta(
      'Thấp',
      AppColors.text3,
    ),
  };
}

final class _ConfidenceMeta {
  const _ConfidenceMeta(this.label, this.color);

  final String label;
  final Color color;
}

String _categoryLabel(TradingSignalCategory category) {
  return switch (category) {
    TradingSignalCategory.scalp => 'Scalp',
    TradingSignalCategory.swing => 'Swing',
    TradingSignalCategory.position => 'Position',
  };
}

String _formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatCompact(double value) {
  final abs = value.abs();
  if (abs >= 1000000) return '${(value / 1000000).toStringAsFixed(2)}M';
  if (abs >= 1000) {
    final scaled = value / 1000;
    final fixed = scaled % 1 == 0
        ? scaled.toStringAsFixed(0)
        : scaled.toStringAsFixed(1);
    return '${fixed}K';
  }
  return value.toStringAsFixed(0);
}
