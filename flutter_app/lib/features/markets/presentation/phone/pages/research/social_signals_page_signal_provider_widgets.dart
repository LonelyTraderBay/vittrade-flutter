part of 'social_signals_page.dart';

class _SignalCard extends StatelessWidget {
  const _SignalCard({
    super.key,
    required this.signal,
    required this.tierConfig,
    required this.statusConfig,
    required this.expanded,
    required this.onTap,
  });

  final TradingSignalDraft signal;
  final SignalTierConfig tierConfig;
  final SignalStatusConfig statusConfig;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final directionColor = signal.direction == TradingSignalDirection.long
        ? AppColors.buy
        : AppColors.sell;
    final directionLabel = signal.direction == TradingSignalDirection.long
        ? '▲ LONG'
        : '▼ SHORT';

    return VitCard(
      clip: true,
      onTap: onTap,
      density: VitDensity.compact,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.zeroInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      signal.providerAvatar,
                      style: AppTextStyles.base.copyWith(
                        height: AppTextStyles.numericMicro.height,
                      ),
                    ),
                    const SizedBox(width: MarketsSpacingTokens.marketSocialGap),
                    Flexible(
                      child: Text(
                        signal.providerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketSocialCompactGap,
                    ),
                    _TinyBadge(
                      label: tierConfig.label,
                      color: tierConfig.color.resolve(),
                      background: tierConfig.background.resolve(),
                    ),
                    const SizedBox(width: MarketsSpacingTokens.marketSocialGap),
                    Text(
                      '${signal.providerWinRate.toStringAsFixed(1)}% win',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          signal.timeAgo,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: AppTextStyles.numericMicro.height,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    _TinyBadge(
                      label: directionLabel,
                      color: directionColor,
                      background: directionColor.withValues(alpha: .12),
                      padding:
                          MarketsSpacingTokens.marketSocialTinyBadgePaddingWide,
                    ),
                    const SizedBox(width: MarketsSpacingTokens.marketSocialGap),
                    Flexible(
                      child: Text(
                        signal.pair,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: MarketsSpacingTokens.marketSocialGap),
                    _TinyBadge(
                      label: statusConfig.label,
                      color: statusConfig.color.resolve(),
                      background: statusConfig.color.resolve().withValues(
                        alpha: .12,
                      ),
                    ),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketSocialCompactGap,
                    ),
                    _TinyBadge(
                      label: _categoryLabel(signal.category).toLowerCase(),
                      color: AppColors.text3,
                      background: AppColors.surface2,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: _SignalMetric(
                        label: 'Entry',
                        value: formatMarketPriceAdaptive(signal.entry),
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'Hiện tại',
                        value: formatMarketPriceAdaptive(signal.currentPrice),
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'Stop Loss',
                        value: formatMarketPriceAdaptive(signal.stopLoss),
                        valueColor: AppColors.sell,
                      ),
                    ),
                    Expanded(
                      child: _SignalMetric(
                        label: 'PnL',
                        value: _formatPercent(signal.pnlPct),
                        valueColor: signal.pnlPct >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (expanded) _ExpandedSignalDetail(signal: signal),
        ],
      ),
    );
  }
}

class _ExpandedSignalDetail extends StatelessWidget {
  const _ExpandedSignalDetail({required this.signal});

  final TradingSignalDraft signal;

  @override
  Widget build(BuildContext context) {
    final confidence = _confidenceMeta(signal.confidence);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          height: AppSpacing.dividerHairline,
          color: AppColors.borderSolid,
        ),
        Padding(
          padding: VitDensity.compact.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mục tiêu',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  for (var index = 0; index < signal.targets.length; index += 1)
                    Expanded(
                      child: Padding(
                        padding: index == signal.targets.length - 1
                            ? AppSpacing.zeroInsets
                            : MarketsSpacingTokens.marketSocialTargetSpacing,
                        child: Material(
                          color: AppColors.buy10,
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadii.smRadius,
                            side: BorderSide(color: AppColors.buy20),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                              vertical: AppSpacing.x2,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'TP${index + 1}',
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                    height: AppTextStyles.numericMicro.height,
                                  ),
                                ),
                                Text(
                                  formatMarketPriceAdaptive(
                                    signal.targets[index],
                                  ),
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.buy,
                                    fontWeight: AppTextStyles.bold,
                                    fontFeatures: AppTextStyles.tabularFigures,
                                    height: AppTextStyles.numericMicro.height,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Text(
                    'Độ tin cậy: ',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Text(
                    confidence.label,
                    style: AppTextStyles.micro.copyWith(
                      color: confidence.color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.marketSocialLargeGap,
                  ),
                  const Icon(
                    Icons.schedule_rounded,
                    size: MarketsSpacingTokens.marketDepthTrendIcon,
                    color: AppColors.text3,
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.marketSocialSmallGap,
                  ),
                  Text(
                    signal.expiresIn,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                signal.reasoning,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    size: MarketsSpacingTokens.marketOverviewMoverHeaderIcon,
                    color: AppColors.text3,
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.marketSocialSmallGap,
                  ),
                  Text(
                    '${signal.likes}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.marketAdvancedTipIcon,
                  ),
                  const Icon(
                    Icons.content_copy_rounded,
                    size: MarketsSpacingTokens.marketOverviewMoverHeaderIcon,
                    color: AppColors.text3,
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.marketSocialSmallGap,
                  ),
                  Text(
                    '${signal.copies} copies',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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

class _SignalMetric extends StatelessWidget {
  const _SignalMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
    this.padding = MarketsSpacingTokens.marketSocialTinyBadgePadding,
  });

  final String label;
  final Color color;
  final Color background;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      child: Padding(
        padding: padding,
        child: Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    super.key,
    required this.rank,
    required this.provider,
    required this.tierConfig,
  });

  final int rank;
  final SignalProviderSummary provider;
  final SignalTierConfig tierConfig;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: rank <= 3
                    ? tierConfig.color.resolve().withValues(alpha: .15)
                    : AppColors.surface2,
                shape: CircleBorder(
                  side: BorderSide(
                    color: rank <= 3
                        ? tierConfig.color.resolve()
                        : AppColors.borderSolid,
                  ),
                ),
                child: SizedBox.square(
                  dimension: MarketsSpacingTokens.marketSocialProviderRank,
                  child: Center(
                    child: Text(
                      '$rank',
                      style: AppTextStyles.micro.copyWith(
                        color: rank <= 3
                            ? tierConfig.color.resolve()
                            : AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                        height: AppTextStyles.numericMicro.height,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              Text(
                provider.avatar,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  height: AppTextStyles.numericMicro.height,
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            provider.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              height: AppTextStyles.numericMicro.height,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: MarketsSpacingTokens.marketSocialCompactGap,
                        ),
                        _TinyBadge(
                          label: tierConfig.label,
                          color: tierConfig.color.resolve(),
                          background: tierConfig.background.resolve(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_formatCompact(provider.followers.toDouble())} followers · ${provider.totalSignals} tín hiệu',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: AppTextStyles.numericMicro.height,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: MarketsSpacingTokens.marketSocialGap),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${provider.winRate.toStringAsFixed(1)}%',
                    style: AppTextStyles.base.copyWith(
                      color: provider.winRate >= 65
                          ? AppColors.buy
                          : AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      height: AppTextStyles.numericMicro.height,
                    ),
                  ),
                  Text(
                    'Win rate',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppTextStyles.numericMicro.height,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _ProviderMetric(
                  label: 'Đang active',
                  value: '${provider.activeSignals}',
                  color: _marketPrimary,
                ),
              ),
              Expanded(
                child: _ProviderMetric(
                  label: 'Tổng signals',
                  value: '${provider.totalSignals}',
                ),
              ),
              Expanded(
                child: _ProviderMetric(
                  label: 'TB PnL',
                  value: _formatPercent(provider.avgPnl),
                  color: provider.avgPnl >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
