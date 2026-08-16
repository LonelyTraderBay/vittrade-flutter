part of '../../phone/pages/tools/market_correlations_page.dart';

class _DiversificationHero extends StatelessWidget {
  const _DiversificationHero({required this.score});

  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score.score);
    return VitCard(
      variant: VitCardVariant.hero,
      padding: MarketsSpacingTokens.marketCorrelationsHeroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chỉ số đa dạng hóa',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: _corrHeroLabelGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${score.score}',
                style: AppTextStyles.heroNumber.copyWith(color: color),
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketCorrelationsHeroMetaGap,
              ),
              Padding(
                padding: MarketsSpacingTokens.marketCorrelationsHeroMetaPadding,
                child: Text(
                  '/ 100',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ),
              const SizedBox(
                width: MarketsSpacingTokens.marketCorrelationsHeroPillGap,
              ),
              Padding(
                padding: MarketsSpacingTokens.marketCorrelationsHeroMetaPadding,
                child: _SmallPill(label: score.label, color: color),
              ),
            ],
          ),
          const SizedBox(height: _corrHeroProgressGap),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              height: _corrHeroProgressHeight,
              child: LinearProgressIndicator(
                value: score.score / 100,
                backgroundColor: AppColors.surface2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(height: _corrHeroScaleGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kém',
                style: AppTextStyles.micro.copyWith(color: AppColors.sell),
              ),
              Text(
                'TB',
                style: AppTextStyles.micro.copyWith(color: AppColors.warn),
              ),
              Text(
                'Tốt',
                style: AppTextStyles.micro.copyWith(color: AppColors.buy),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      semanticStatus: VitStatusPillStatus.info,
    );
  }
}

class _DiversificationMetrics extends StatelessWidget {
  const _DiversificationMetrics({required this.score});

  final DiversificationScoreDraft score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCard(
            padding: MarketsSpacingTokens.marketCorrelationsMetricPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tương quan TB',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: _corrMetricValueGap),
                Text(
                  score.avgCorrelation.toStringAsFixed(2),
                  style: AppTextStyles.base.copyWith(
                    color: score.avgCorrelation > .7
                        ? AppColors.sell
                        : AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketCorrelationsMetricGap),
        Expanded(
          child: VitCard(
            padding: MarketsSpacingTokens.marketCorrelationsMetricPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cặp ít tương quan nhất',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: _corrMetricValueGap),
                Text(
                  score.lowestCorr.pair,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  score.lowestCorr.value.toStringAsFixed(2),
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Bẫy mới (GD4-F3): cần 3 snapshot song song (d7/d30/d90) NGOÀI cái đã
/// gate trang (mục 5) — mỗi timeframe đọc qua provider "phụ" `.value` +
/// fallback null (dash) thay vì lồng 3 tầng `.when()`.
class _TimeframeScoreCard extends ConsumerWidget {
  const _TimeframeScoreCard({required this.sortOrder});

  final CorrelationSortOrder sortOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const timeframes = [
      MarketCorrelationTimeframe.d7,
      MarketCorrelationTimeframe.d30,
      MarketCorrelationTimeframe.d90,
    ];
    return VitCard(
      padding: MarketsSpacingTokens.marketCorrelationsScoreCardPadding,
      child: Column(
        children: [
          for (final timeframe in timeframes)
            Padding(
              padding: MarketsSpacingTokens.marketCorrelationsScoreRowPadding,
              child: _TimeframeScoreRow(
                label: _timeframeLabel(timeframe),
                score: ref
                    .watch(
                      marketCorrelationsSnapshotProvider((
                        timeframe: timeframe,
                        sortOrder: sortOrder,
                      )),
                    )
                    .value
                    ?.diversificationScore,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimeframeScoreRow extends StatelessWidget {
  const _TimeframeScoreRow({required this.label, required this.score});

  final String label;

  /// `null` khi provider "phụ" của timeframe này chưa resolve (xem
  /// [_TimeframeScoreCard]) — render dash thay vì chặn cả card.
  final DiversificationScoreDraft? score;

  @override
  Widget build(BuildContext context) {
    final resolvedScore = score;
    final color = resolvedScore == null
        ? AppColors.text3
        : _scoreColor(resolvedScore.score);
    return Row(
      children: [
        SizedBox(
          width: MarketsSpacingTokens.marketCorrelationsScoreLabelWidth,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: LinearProgressIndicator(
              minHeight: _corrScoreBarHeight,
              value: resolvedScore == null ? 0 : resolvedScore.score / 100,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketCorrelationsScoreGap),
        SizedBox(
          width: MarketsSpacingTokens.marketCorrelationsScoreValueWidth,
          child: Text(
            resolvedScore == null ? '—' : '${resolvedScore.score}',
            textAlign: TextAlign.right,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _CorrelationDisclaimer extends StatelessWidget {
  const _CorrelationDisclaimer();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: MarketsSpacingTokens.marketCorrelationsDisclaimerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: MarketsSpacingTokens.marketCorrelationsDisclaimerIcon,
            color: AppColors.warn,
          ),
          const SizedBox(
            width: MarketsSpacingTokens.marketCorrelationsDisclaimerIconGap,
          ),
          Expanded(
            child: Text(
              'Tương quan quá khứ không đảm bảo tương lai. Trong giai đoạn biến động mạnh, tương quan giữa crypto thường tăng cao (risk-on/risk-off). Chỉ mang tính tham khảo.',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

double _correlationValueFor(
  CorrelationPairDraft pair,
  MarketCorrelationTimeframe timeframe,
) {
  return switch (timeframe) {
    MarketCorrelationTimeframe.d7 => pair.correlation7d,
    MarketCorrelationTimeframe.d30 => pair.correlation30d,
    MarketCorrelationTimeframe.d90 => pair.correlation90d,
  };
}

Color _correlationColor(double value) {
  if (value >= .85) return AppDataVizColors.correlationVeryHigh;
  if (value >= .70) return AppColors.sell;
  if (value >= .50) return AppColors.warn;
  if (value >= .30) return AppColors.buy;
  if (value >= .0) return AppDataVizColors.correlationVeryLow;
  return _marketPrimary;
}

String _correlationLabel(double value) {
  if (value >= .85) return 'Rất cao';
  if (value >= .70) return 'Cao';
  if (value >= .50) return 'Trung bình';
  if (value >= .30) return 'Thấp';
  return 'Rất thấp';
}

String _timeframeLabel(MarketCorrelationTimeframe timeframe) {
  return switch (timeframe) {
    MarketCorrelationTimeframe.d7 => '7d',
    MarketCorrelationTimeframe.d30 => '30d',
    MarketCorrelationTimeframe.d90 => '90d',
  };
}

Color _scoreColor(int score) {
  if (score >= 50) return AppColors.buy;
  if (score >= 30) return AppColors.warn;
  return AppColors.sell;
}
