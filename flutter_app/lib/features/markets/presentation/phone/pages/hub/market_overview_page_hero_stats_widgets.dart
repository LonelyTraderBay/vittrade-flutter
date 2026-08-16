part of 'market_overview_page.dart';

class _MarketCapHero extends StatelessWidget {
  const _MarketCapHero({required this.stats});

  final GlobalMarketStats stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      density: VitDensity.compact,
      borderColor: _marketPrimary.withValues(alpha: 0.24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.language_rounded,
                color: _marketPrimary,
                size: 16,
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketAnalyticsCompactGap,
              ),
              Text(
                'Tổng vốn hóa thị trường',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                  height: AppTextStyles.numericMicro.height,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.contentPad),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  formatMarketCompact(stats.totalMarketCap, prefix: r'$'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.pageTitle.copyWith(
                    height: AppTextStyles.numericDisplayMd.height,
                  ),
                ),
              ),
              const SizedBox(width: MarketsSpacingTokens.marketAnalyticsGap),
              Padding(
                padding: MarketsSpacingTokens.marketMetricDeltaPillPadding,
                child: VitMetricDeltaPill(
                  label:
                      '${stats.totalMarketCapChange24h.abs().toStringAsFixed(2)}%',
                  tone: stats.totalMarketCapChange24h >= 0
                      ? VitMetricDeltaTone.positive
                      : VitMetricDeltaTone.negative,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Tỷ trọng BTC',
                  value: '${stats.btcDominance.toStringAsFixed(1)}%',
                  valueColor: _btcOrange,
                ),
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketAnalyticsCompactGap,
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'Tỷ trọng ETH',
                  value: '${stats.ethDominance.toStringAsFixed(1)}%',
                  valueColor: _ethPrimary,
                ),
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketAnalyticsCompactGap,
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'KL 24h',
                  value: formatMarketCompact(
                    stats.total24hVolume,
                    prefix: r'$',
                  ),
                  valueColor: AppColors.text1,
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
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: MarketsSpacingTokens.marketAnalyticsMetricPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final GlobalMarketStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'TVL DeFi',
                value: formatMarketCompact(stats.defiTVL, prefix: r'$'),
                change: stats.defiTVLChange24h,
                icon: Icons.layers_rounded,
                color: _sectorPurple,
              ),
            ),
            const SizedBox(width: MarketsSpacingTokens.marketAnalyticsGap),
            Expanded(
              child: _StatCard(
                label: 'KL Stablecoin',
                value: formatMarketCompact(
                  stats.stablecoinVolume24h,
                  prefix: r'$',
                ),
                icon: Icons.monitor_heart_outlined,
                color: _marketPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: MarketsSpacingTokens.marketAnalyticsStatIcon),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Tổng coin',
                value: _formatInt(stats.totalCoins),
                icon: Icons.pie_chart_outline_rounded,
                color: AppColors.buy,
              ),
            ),
            const SizedBox(width: MarketsSpacingTokens.marketAnalyticsGap),
            Expanded(
              child: _StatCard(
                label: 'Sàn giao dịch',
                value: _formatInt(stats.totalExchanges),
                icon: Icons.bar_chart_rounded,
                color: AppColors.primarySoft,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.change,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double? change;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VitAccentIconBox(
                icon: icon,
                color: color,
                iconSize: MarketsSpacingTokens.marketAnalyticsStatIcon,
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketAnalyticsCompactGap,
              ),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
          if (change != null) ...[
            const SizedBox(height: AppSpacing.x1),
            Row(
              children: [
                Icon(
                  change! >= 0
                      ? Icons.arrow_outward_rounded
                      : Icons.south_east_rounded,
                  color: change! >= 0 ? AppColors.buy : AppColors.sell,
                  size: MarketsSpacingTokens.marketAnalyticsTrendIcon,
                ),
                const SizedBox(
                  width: MarketsSpacingTokens.marketAnalyticsTinyGap,
                ),
                Text(
                  _formatSignedPercent(change!),
                  style: AppTextStyles.micro.copyWith(
                    color: change! >= 0 ? AppColors.buy : AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                    height: AppTextStyles.numericMicro.height,
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

class _SentimentGrid extends StatelessWidget {
  const _SentimentGrid({required this.stats, required this.breadth});

  final GlobalMarketStats stats;
  final MarketBreadth breadth;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          child: VitCard(
            density: VitDensity.compact,
            height: AppSpacing.x7 + AppSpacing.x7 + AppSpacing.x3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _MiniHeader(
                  icon: Icons.speed_rounded,
                  color: AppColors.primarySoft,
                  label: 'Sợ hãi & Tham lam',
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Expanded(
                  child: _FearGreedGauge(
                    value: stats.fearGreedIndex,
                    label: stats.fearGreedLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketAnalyticsGap),
        Expanded(
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          child: VitCard(
            density: VitDensity.compact,
            height: AppSpacing.x7 + AppSpacing.x7 + AppSpacing.x3,
            child: _MarketBreadthCard(breadth: breadth),
          ),
        ),
      ],
    );
  }
}

class _MarketBreadthCard extends StatelessWidget {
  const _MarketBreadthCard({required this.breadth});

  final MarketBreadth breadth;

  @override
  Widget build(BuildContext context) {
    final total = breadth.advancing + breadth.declining;
    final advancingPct = total == 0 ? 0.0 : breadth.advancing / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _MiniHeader(
          icon: Icons.gps_fixed_rounded,
          color: _marketPrimary,
          label: 'Biến động thị trường',
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _BreadthLine(
          label: 'Tăng',
          value: breadth.advancing,
          color: AppColors.buy,
        ),
        const SizedBox(height: AppSpacing.x1),
        _BreadthLine(
          label: 'Giảm',
          value: breadth.declining,
          color: AppColors.sell,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: AppSpacing.pageRhythmCompactInnerGap,
            child: Row(
              children: [
                Expanded(
                  flex: (advancingPct * 1000).round(),
                  child: const ColoredBox(color: AppColors.buy),
                ),
                Expanded(
                  flex: ((1 - advancingPct) * 1000).round(),
                  child: const ColoredBox(color: AppColors.sell),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            Expanded(
              child: Text(
                '${breadth.newATH} ATH mới',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  height: AppTextStyles.badge.height,
                ),
              ),
            ),
            Text(
              '${breadth.dropping10Pct} giảm >10%',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.sell,
                height: AppTextStyles.badge.height,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BreadthLine extends StatelessWidget {
  const _BreadthLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: MarketsSpacingTokens.marketAnalyticsBreadthDot,
          child: Material(color: color, shape: const CircleBorder()),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketAnalyticsSmallGap),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: AppTextStyles.badge.height,
            ),
          ),
        ),
        Text(
          _formatInt(value),
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
            height: AppTextStyles.badge.height,
          ),
        ),
      ],
    );
  }
}

class _FearGreedGauge extends StatelessWidget {
  const _FearGreedGauge({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = _fearGreedColor(value);
    return Column(
      children: [
        SizedBox(
          width: MarketsSpacingTokens.marketAnalyticsGaugeWidth,
          height: AppSpacing.x6,
          child: CustomPaint(painter: _FearGreedGaugePainter(value: value)),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '$value',
          style: AppTextStyles.amountSm.copyWith(
            color: color,
            height: AppTextStyles.badge.height,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppTextStyles.badge.height,
          ),
        ),
      ],
    );
  }
}
