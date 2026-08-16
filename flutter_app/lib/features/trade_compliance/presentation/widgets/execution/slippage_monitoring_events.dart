part of '../../phone/pages/execution/slippage_monitoring_page.dart';

class _RealtimeTab extends StatelessWidget {
  const _RealtimeTab({required this.events});

  final List<TradeSlippageEvent> events;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Recent Slippage Events',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _slipPrimary,
        ),
        for (final event in events) _SlippageEventCard(event: event),
      ],
    );
  }
}

class _SlippageEventCard extends StatelessWidget {
  const _SlippageEventCard({required this.event});

  final TradeSlippageEvent event;

  @override
  Widget build(BuildContext context) {
    final style = _severityStyle(event.severity);
    return VitCard(
      key: SlippageMonitoringPage.eventKey(event.id),
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: _slipBorder.withValues(alpha: .72),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            width: AppSpacing.inputHeight - AppSpacing.x4,
            height: AppSpacing.inputHeight - AppSpacing.x4,
            alignment: Alignment.center,
            borderColor: style.color.withValues(alpha: .24),
            child: Icon(style.icon, color: style.color, size: 19),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  event.instrument,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.x2),
                              _SidePill(side: event.side),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.x1),
                          Text(
                            '${event.provider} · ${event.time}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _SeverityPill(style: style),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: _EventMetric(
                        label: 'Expected',
                        value: _formatPrice(event.expectedPrice),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: _EventMetric(
                        label: 'Executed',
                        value: _formatPrice(event.executedPrice),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: _EventMetric(
                        label: 'Slippage',
                        value: '${event.slippagePct.toStringAsFixed(3)}%',
                        color: style.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                VitCard(
                  variant: VitCardVariant.inner,
                  density: VitDensity.tool,
                  radius: VitCardRadius.tight,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x3,
                    vertical: AppSpacing.x2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Cost Impact:',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      Text(
                        '\$${((event.executedPrice - event.expectedPrice).abs() * event.volume).toStringAsFixed(2)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventMetric extends StatelessWidget {
  const _EventMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text2,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      borderColor: color == AppColors.text2
          ? null
          : color.withValues(alpha: .18),
      child: Column(
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
            style: AppTextStyles.micro.copyWith(
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
