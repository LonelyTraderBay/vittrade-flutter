part of '../../phone/pages/research/social_sentiment_page.dart';

class _SocialDominanceCard extends StatelessWidget {
  const _SocialDominanceCard({required this.global});

  final SocialSentimentGlobal global;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _sentimentDominancePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Social Dominance',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _sentimentDominanceTitleGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              width: double.infinity,
              height: _sentimentDominanceBarHeight,
              child: Row(
                children: [
                  Expanded(
                    flex: (global.socialDominanceBtc * 10).round(),
                    child: const ColoredBox(color: AppAssetColors.btc),
                  ),
                  Expanded(
                    flex: (global.socialDominanceEth * 10).round(),
                    child: const ColoredBox(color: AppAssetColors.eth),
                  ),
                  Expanded(
                    flex: (global.socialDominanceOther * 10).round(),
                    child: const ColoredBox(color: AppColors.surface3),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: _sentimentDominanceTitleGap),
          Row(
            children: [
              _DominanceLegend(
                label: 'BTC ${global.socialDominanceBtc}%',
                color: AppAssetColors.btc,
              ),
              const SizedBox(width: _sentimentDominanceLegendGap),
              _DominanceLegend(
                label: 'ETH ${global.socialDominanceEth}%',
                color: AppAssetColors.eth,
              ),
              const SizedBox(width: _sentimentDominanceLegendGap),
              _DominanceLegend(
                label: 'Khác ${global.socialDominanceOther}%',
                color: AppAssetColors.other,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DominanceLegend extends StatelessWidget {
  const _DominanceLegend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: color, size: _sentimentLegendDot),
        const SizedBox(width: _sentimentLegendGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.points});

  final List<SocialSentimentTimelinePoint> points;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SocialSentimentPage.timelineCardKey,
      padding: _sentimentTimelinePadding,
      child: Column(
        children: [
          for (final point in points)
            Padding(
              padding: _sentimentTimelineRowPadding,
              child: Row(
                children: [
                  SizedBox(
                    width: _sentimentTimelineTimeWidth,
                    child: Text(
                      point.time,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                  const SizedBox(width: _sentimentTimelineTimeGap),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: AppRadii.xlRadius,
                      child: SizedBox(
                        height: _sentimentTimelineBarHeight,
                        child: Stack(
                          children: [
                            const ColoredBox(
                              color: AppColors.surface2,
                              child: SizedBox.expand(),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: ((point.score + 100) / 200)
                                  .clamp(0, 1)
                                  .toDouble(),
                              child: ColoredBox(
                                color: _sentimentColor(point.score),
                                child: const SizedBox.expand(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: _sentimentTimelineScoreGap),
                  SizedBox(
                    width: _sentimentTimelineScoreWidth,
                    child: Text(
                      '${point.score}',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.micro.copyWith(
                        color: _sentimentColor(point.score),
                        fontWeight: AppTextStyles.bold,
                      ),
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
