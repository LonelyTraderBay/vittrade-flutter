part of 'token_unlocks_page.dart';

class _UnlockCard extends StatelessWidget {
  const _UnlockCard({
    super.key,
    required this.unlock,
    required this.impactConfig,
    required this.categoryConfig,
    required this.expanded,
    required this.onToggle,
  });

  final TokenUnlockDraft unlock;
  final UnlockImpactConfig impactConfig;
  final UnlockCategoryConfig categoryConfig;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: unlock.impactLevel == MarketUnlockImpact.high
          ? AppColors.sell.withValues(alpha: .16)
          : null,
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: MarketsSpacingTokens.tokenUnlocksCardHeaderPadding,
            onTap: onToggle,
            child: Row(
              children: [
                _TokenAvatar(
                  unlock: unlock,
                  size: MarketsSpacingTokens.tokenUnlocksAvatarLg,
                ),
                const SizedBox(width: MarketsSpacingTokens.tokenUnlocksCardGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: MarketsSpacingTokens.tokenUnlocksBadgeSpacing,
                        runSpacing:
                            MarketsSpacingTokens.tokenUnlocksBadgeRunSpacing,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            unlock.symbol,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          _TinyBadge(
                            label: impactConfig.label,
                            color: impactConfig.color.resolve(),
                            bold: true,
                          ),
                          _TinyBadge(
                            label: categoryConfig.label,
                            color: categoryConfig.color.resolve(),
                          ),
                        ],
                      ),
                      const SizedBox(height: _unlockDateGap),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: MarketsSpacingTokens.tokenUnlocksDateIcon,
                            color: AppColors.text3,
                          ),
                          const SizedBox(width: _unlockDateGap),
                          Flexible(
                            child: Text(
                              unlock.unlockDateLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ),
                          const SizedBox(width: _unlockDateGap),
                          Text(
                            _countdownLabel(unlock),
                            style: AppTextStyles.micro.copyWith(
                              color: _countdownColor(unlock.daysUntil),
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: MarketsSpacingTokens.tokenUnlocksCardGap),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatCompactUsd(unlock.unlockValueUsd),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: _unlockValueGap),
                    Text(
                      '${unlock.unlockPctCirculating.toStringAsFixed(1)}% supply',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.sell,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (expanded)
            _UnlockExpandedDetails(
              unlock: unlock,
              categoryConfig: categoryConfig,
            ),
        ],
      ),
    );
  }
}

class _UnlockExpandedDetails extends StatelessWidget {
  const _UnlockExpandedDetails({
    required this.unlock,
    required this.categoryConfig,
  });

  final TokenUnlockDraft unlock;
  final UnlockCategoryConfig categoryConfig;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          height: AppSpacing.dividerHairline,
          color: AppColors.cardBorder,
        ),
        Padding(
          padding: MarketsSpacingTokens.tokenUnlocksExpandedPadding,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _DetailMetric(
                      label: 'Số token mở khóa',
                      value:
                          '${_formatCompactNumber(unlock.unlockAmount)} '
                          '${unlock.symbol}',
                    ),
                  ),
                  const SizedBox(width: _unlockExpandedMetricGap),
                  Expanded(
                    child: _DetailMetric(
                      label: 'Giá hiện tại',
                      value: _formatPriceUsd(unlock.currentPrice),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _unlockExpandedMetricGap),
              Row(
                children: [
                  Expanded(
                    child: _DetailMetric(
                      label: 'Tổng đang khóa',
                      value: _formatCompactUsd(unlock.totalLockedValueUsd),
                    ),
                  ),
                  const SizedBox(width: _unlockExpandedMetricGap),
                  Expanded(
                    child: _DetailMetric(
                      label: 'Loại vesting',
                      value: _vestingTypeLabel(unlock.vestingType),
                    ),
                  ),
                ],
              ),
              if (unlock.priceChange7d < -3) ...[
                const SizedBox(height: _unlockPriceWarningGap),
                VitCard(
                  variant: VitCardVariant.ghost,
                  borderColor: AppColors.sell.withValues(alpha: .12),
                  padding: MarketsSpacingTokens.tokenUnlocksPriceWarningPadding,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.trending_down_rounded,
                        color: AppColors.sell,
                        size: MarketsSpacingTokens.tokenUnlocksPriceWarningIcon,
                      ),
                      const SizedBox(
                        width: MarketsSpacingTokens
                            .tokenUnlocksPriceWarningIconGap,
                      ),
                      Expanded(
                        child: Text(
                          'Giá giảm ${_formatPct(unlock.priceChange7d)} '
                          'trong 7 ngày - có thể liên quan đến unlock sắp tới',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.sell,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: _unlockDetailMetricGap),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _ImpactOverview extends StatelessWidget {
  const _ImpactOverview({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: MarketsSpacingTokens.tokenUnlocksAnalysisCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân bổ theo tác động',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _unlockImpactTitleGap),
          Row(
            children: [
              for (final entry in snapshot.impactConfigs.entries) ...[
                Expanded(
                  child: _ImpactStat(
                    config: entry.value,
                    count: snapshot.unlocks
                        .where((unlock) => unlock.impactLevel == entry.key)
                        .length,
                    value: snapshot.unlocks
                        .where((unlock) => unlock.impactLevel == entry.key)
                        .fold<double>(
                          0,
                          (sum, unlock) => sum + unlock.unlockValueUsd,
                        ),
                  ),
                ),
                if (entry.key != snapshot.impactConfigs.keys.last)
                  const SizedBox(
                    width: MarketsSpacingTokens.tokenUnlocksImpactStatGap,
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  const _ImpactStat({
    required this.config,
    required this.count,
    required this.value,
  });

  final UnlockImpactConfig config;
  final int count;
  final double value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: config.color.resolve().withValues(alpha: .10),
      padding: MarketsSpacingTokens.tokenUnlocksImpactStatPadding,
      child: Column(
        children: [
          Text(
            '$count',
            style: AppTextStyles.sectionTitle.copyWith(
              color: config.color.resolve(),
            ),
          ),
          Text(
            config.label,
            style: AppTextStyles.micro.copyWith(
              color: config.color.resolve(),
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _unlockImpactStatValueGap),
          Text(
            _formatCompactUsd(value),
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final totals = {
      for (final category in snapshot.categoryConfigs.keys)
        category: snapshot.unlocks
            .where((unlock) => unlock.category == category)
            .fold<double>(0, (sum, unlock) => sum + unlock.unlockValueUsd),
    };
    final maxTotal = totals.values.fold<double>(
      1,
      (max, value) => value > max ? value : max,
    );

    return VitCard(
      padding: MarketsSpacingTokens.tokenUnlocksAnalysisCardPadding,
      child: Column(
        children: [
          for (final entry in snapshot.categoryConfigs.entries) ...[
            _CategoryBar(
              label: entry.value.label,
              color: entry.value.color.resolve(),
              value: totals[entry.key] ?? 0,
              maxValue: maxTotal,
            ),
            if (entry.key != snapshot.categoryConfigs.keys.last)
              const SizedBox(height: _unlockCategoryGap),
          ],
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.label,
    required this.color,
    required this.value,
    required this.maxValue,
  });

  final String label;
  final Color color;
  final double value;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.square_rounded,
              color: color,
              size: MarketsSpacingTokens.tokenUnlocksCategoryDot,
            ),
            const SizedBox(
              width: MarketsSpacingTokens.tokenUnlocksCategoryDotGap,
            ),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Text(
              _formatCompactUsd(value),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: _unlockCategoryProgressGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: _unlockCategoryProgressHeight,
            child: LinearProgressIndicator(
              value: maxValue == 0 ? 0 : value / maxValue,
              minHeight: _unlockCategoryProgressHeight,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

class _DilutionRanking extends StatelessWidget {
  const _DilutionRanking({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final unlocks = [
      ...snapshot.unlocks,
    ]..sort((a, b) => b.unlockPctCirculating.compareTo(a.unlockPctCirculating));
    return Column(
      children: [
        for (var index = 0; index < unlocks.length; index += 1) ...[
          _DilutionRow(index: index, unlock: unlocks[index]),
          if (index != unlocks.length - 1)
            const SizedBox(height: _unlockDilutionRowGap),
        ],
      ],
    );
  }
}
