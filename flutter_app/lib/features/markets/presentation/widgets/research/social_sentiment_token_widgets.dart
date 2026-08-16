part of '../../phone/pages/research/social_sentiment_page.dart';

class _TrendingList extends StatelessWidget {
  const _TrendingList({required this.tokens});

  final List<SocialSentimentToken> tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final token in tokens) ...[
          _SentimentRow(token: token),
          if (token != tokens.last) const SizedBox(height: _sentimentListGap),
        ],
      ],
    );
  }
}

class _SentimentRow extends StatelessWidget {
  const _SentimentRow({required this.token});

  final SocialSentimentToken token;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _sentimentRowPadding,
      child: Row(
        children: [
          CircleAvatar(
            radius: _sentimentAvatarLg / 2,
            backgroundColor: AppAssetColors.forSymbol(
              token.symbol,
            ).withValues(alpha: .16),
            child: Text(
              token.symbol.substring(0, math.min(2, token.symbol.length)),
              style: AppTextStyles.caption.copyWith(
                color: AppAssetColors.forSymbol(token.symbol),
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: _sentimentRowGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                    children: [
                      TextSpan(text: token.symbol),
                      if (token.trendingRank != null)
                        TextSpan(
                          text: '  🔥 #${token.trendingRank}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.warn,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  '${_formatCompact(token.mentions24h)} đề cập',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${token.sentimentScore}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: _sentimentColor(token.sentimentScore),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Icon(
                Icons.circle,
                color: _sentimentColor(token.sentimentScore),
                size: _sentimentStatusDot,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SentimentSortChips extends StatelessWidget {
  const _SentimentSortChips({required this.active, required this.onSelected});

  final MarketSentimentSort active;
  final ValueChanged<MarketSentimentSort> onSelected;

  @override
  Widget build(BuildContext context) {
    const chips = {
      MarketSentimentSort.sentiment: 'Sentiment',
      MarketSentimentSort.mentions: 'Mentions',
      MarketSentimentSort.trending: 'Trending',
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in chips.entries) ...[
            VitFilterChip(
              key: SocialSentimentPage.sortKey(entry.key),
              label: entry.value,
              active: active == entry.key,
              onTap: () => onSelected(entry.key),
              color: AppColors.primarySoft,
              padding: _sentimentSortChipPadding,
            ),
            if (entry.key != chips.keys.last)
              const SizedBox(width: _sentimentSortGap),
          ],
        ],
      ),
    );
  }
}

class _TokenDetailCard extends StatelessWidget {
  const _TokenDetailCard({required this.token});

  final SocialSentimentToken token;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _sentimentTokenDetailPadding,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: _sentimentAvatarMd / 2,
                backgroundColor: AppAssetColors.forSymbol(
                  token.symbol,
                ).withValues(alpha: .16),
                child: Text(
                  token.symbol.substring(0, math.min(2, token.symbol.length)),
                  style: AppTextStyles.caption.copyWith(
                    color: AppAssetColors.forSymbol(token.symbol),
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: _sentimentRowGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      token.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      token.name,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${token.sentimentScore}',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: _sentimentColor(token.sentimentScore),
                ),
              ),
            ],
          ),
          const SizedBox(height: _sentimentRowGap),
          ClipRRect(
            borderRadius: AppRadii.smRadius,
            child: SizedBox(
              width: double.infinity,
              height: _sentimentSplitBarHeight,
              child: Row(
                children: [
                  Expanded(
                    flex: token.bullishPct,
                    child: const ColoredBox(color: AppColors.buy),
                  ),
                  Expanded(
                    flex: token.neutralPct,
                    child: const ColoredBox(color: AppColors.text3),
                  ),
                  Expanded(
                    flex: token.bearishPct,
                    child: const ColoredBox(color: AppColors.sell),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: _sentimentTokenMetricGap),
          Row(
            children: [
              _TokenMetric('Đề cập 24h', _formatCompact(token.mentions24h)),
              _TokenMetric('Twitter', _formatCompact(token.twitterFollowers)),
              _TokenMetric('Telegram', _formatCompact(token.telegramMembers)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenMetric extends StatelessWidget {
  const _TokenMetric(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
