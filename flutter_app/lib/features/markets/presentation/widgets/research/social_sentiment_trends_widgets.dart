part of '../../phone/pages/research/social_sentiment_page.dart';

class _TopicCloud extends StatelessWidget {
  const _TopicCloud({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    final topics = <String>{};
    for (final token in tokens) {
      topics.addAll(token.topTopics);
    }
    return VitCard(
      padding: _sentimentTopicCardPadding,
      child: Wrap(
        spacing: _sentimentTopicGap,
        runSpacing: _sentimentTopicGap,
        children: [
          for (final topic in topics)
            VitAccentPill(
              label: '#$topic',
              accentColor: AppColors.text2,
              size: VitStatusPillSize.md,
            ),
        ],
      ),
    );
  }
}

class _SentimentHeatmap extends StatelessWidget {
  const _SentimentHeatmap({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _sentimentHeatmapCrossAxisCount,
      crossAxisSpacing: _sentimentHeatmapGap,
      mainAxisSpacing: _sentimentHeatmapGap,
      childAspectRatio: _sentimentHeatmapAspectRatio,
      children: [
        for (final token in tokens)
          VitCard(
            alignment: Alignment.center,
            variant: VitCardVariant.ghost,
            borderColor: _sentimentColor(
              token.sentimentScore,
            ).withValues(alpha: .16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  token.symbol,
                  style: AppTextStyles.caption.copyWith(
                    color: AppAssetColors.forSymbol(token.symbol),
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${token.sentimentScore}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _sentimentColor(token.sentimentScore),
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TrendLeaderboards extends StatelessWidget {
  const _TrendLeaderboards({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    final positive = [...tokens]
      ..sort((a, b) => b.sentimentScore.compareTo(a.sentimentScore));
    final negative = [...tokens]
      ..sort((a, b) => a.sentimentScore.compareTo(b.sentimentScore));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _LeaderboardColumn(
            label: 'Tích cực nhất',
            color: AppColors.buy,
            tokens: positive.take(4).toList(),
            positive: true,
          ),
        ),
        const SizedBox(width: _sentimentLeaderboardGap),
        Expanded(
          child: _LeaderboardColumn(
            label: 'Tiêu cực nhất',
            color: AppColors.sell,
            tokens: negative.take(4).toList(),
            positive: false,
          ),
        ),
      ],
    );
  }
}

class _LeaderboardColumn extends StatelessWidget {
  const _LeaderboardColumn({
    required this.label,
    required this.color,
    required this.tokens,
    required this.positive,
  });

  final String label;
  final Color color;
  final List<SocialSentimentToken> tokens;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitSectionHeader(
          title: label,
          accentColor: color,
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        const SizedBox(height: _sentimentLeaderboardGap),
        for (var index = 0; index < tokens.length; index += 1) ...[
          VitCard(
            padding: _sentimentLeaderboardRowPadding,
            child: Row(
              children: [
                SizedBox(
                  width: _sentimentLeaderboardRankWidth,
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                Expanded(
                  child: Text(
                    tokens[index].symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppAssetColors.forSymbol(tokens[index].symbol),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  '${positive ? '+' : ''}${tokens[index].sentimentScore}',
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          if (index != tokens.length - 1)
            const SizedBox(height: _sentimentLeaderboardRowGap),
        ],
      ],
    );
  }
}

class _MentionVelocity extends StatelessWidget {
  const _MentionVelocity({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    final sorted = [...tokens]
      ..sort((a, b) => b.mentionsChange.compareTo(a.mentionsChange));
    final maxChange = sorted.fold<double>(
      0,
      (maxValue, token) => math.max(maxValue, token.mentionsChange.abs()),
    );
    return Column(
      children: [
        for (final token in sorted.take(5)) ...[
          VitCard(
            padding: _sentimentVelocityRowPadding,
            child: Row(
              children: [
                SizedBox(
                  width: _sentimentVelocitySymbolWidth,
                  child: Text(
                    token.symbol,
                    style: AppTextStyles.caption.copyWith(
                      color: AppAssetColors.forSymbol(token.symbol),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.xlRadius,
                    child: SizedBox(
                      height: _sentimentVelocityBarHeight,
                      child: Stack(
                        children: [
                          const ColoredBox(
                            color: AppColors.surface2,
                            child: SizedBox.expand(),
                          ),
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: maxChange == 0
                                ? 0
                                : token.mentionsChange.abs() / maxChange,
                            child: ColoredBox(
                              color: token.mentionsChange >= 0
                                  ? AppColors.buy
                                  : AppColors.sell,
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: _sentimentVelocityGap),
                SizedBox(
                  width: _sentimentVelocityValueWidth,
                  child: Text(
                    '${token.mentionsChange >= 0 ? '+' : ''}${token.mentionsChange.toStringAsFixed(1)}%',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.caption.copyWith(
                      color: token.mentionsChange >= 0
                          ? AppColors.buy
                          : AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (token != sorted.take(5).last)
            const SizedBox(height: _sentimentListGap),
        ],
      ],
    );
  }
}

Color _sentimentColor(int score) {
  if (score >= 60) return AppColors.buy;
  if (score >= 30) return _marketPrimary;
  if (score >= -10) return AppColors.text3;
  if (score >= -40) return AppColors.warn;
  return AppColors.sell;
}

String _formatCompact(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(2)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}
