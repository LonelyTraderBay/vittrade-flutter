part of '../../phone/pages/execution/market_data_analytics_page.dart';

class _SentimentTab extends StatelessWidget {
  const _SentimentTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final sentiment = snapshot.sentiment;
    return VitPageContent(
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              const _CardHeader(
                icon: Icons.psychology_outlined,
                iconColor: _analyticsPurple,
                title: 'Market Sentiment',
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.square(
                      dimension: TradeSpacingTokens.tradeBotRiskRingSize,
                      child: CircularProgressIndicator(
                        value: sentiment.score / 100,
                        strokeWidth: TradeSpacingTokens.tradeBotCardIconGap,
                        backgroundColor: _analyticsPanel2,
                        color: _analyticsAmber,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${sentiment.score}',
                          style: AppTextStyles.heroNumber.copyWith(
                            color: _analyticsAmber,
                          ),
                        ),
                        Text(
                          sentiment.overall.toUpperCase(),
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              Text(
                'How Sentiment is Calculated',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              for (final component in sentiment.components)
                _SentimentComponentRow(component: component),
            ],
          ),
        ),
        _AnalyticsCard(
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            density: VitDensity.tool,
            children: [
              Text(
                'Trading Implications',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              for (final implication in sentiment.implications)
                _ImplicationRow(implication: implication),
            ],
          ),
        ),
      ],
    );
  }
}

class _SentimentComponentRow extends StatelessWidget {
  const _SentimentComponentRow({required this.component});

  final TradeSentimentComponent component;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  component.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _SmallBadge(label: component.weight, color: AppColors.primary),
            ],
          ),
          Text(
            component.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ImplicationRow extends StatelessWidget {
  const _ImplicationRow({required this.implication});

  final TradeSentimentImplication implication;

  @override
  Widget build(BuildContext context) {
    final color = Color(implication.colorHex);
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      variant: VitCardVariant.inner,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.x1,
            height: AppSpacing.buttonCompact,
            child: ColoredBox(color: color),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  implication.condition,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  implication.action,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
