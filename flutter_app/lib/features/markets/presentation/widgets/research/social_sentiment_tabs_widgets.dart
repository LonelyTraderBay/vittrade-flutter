part of '../../phone/pages/research/social_sentiment_page.dart';

class _SentimentTabs extends StatelessWidget {
  const _SentimentTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: MarketsSpacingTokens.marketDepthTabsHeight,
        child: VitTabBar(
          activeKey: activeTab,
          variant: VitTabBarVariant.underline,
          onChanged: onChanged,
          tabs: const [
            VitTabItem(
              key: 'overview',
              label: 'Tổng quan',
              widgetKey: SocialSentimentPage.overviewTabKey,
            ),
            VitTabItem(
              key: 'token',
              label: 'Theo token',
              widgetKey: SocialSentimentPage.tokenTabKey,
            ),
            VitTabItem(
              key: 'trends',
              label: 'Xu hướng',
              widgetKey: SocialSentimentPage.trendsTabKey,
            ),
          ],
        ),
      ),
    );
  }
}

class _SentimentHero extends StatelessWidget {
  const _SentimentHero({required this.global});

  final SocialSentimentGlobal global;

  @override
  Widget build(BuildContext context) {
    final scoreColor = _sentimentColor(global.overallScore);
    final gaugePct = ((global.overallScore + 100) / 2).clamp(0, 100) / 100;
    return VitCard(
      width: double.infinity,
      padding: _sentimentHeroPadding,
      borderColor: _marketPrimary.withValues(alpha: .2),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Chỉ số tâm lý chung',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Text(
                global.overallLabel,
                style: AppTextStyles.micro.copyWith(
                  color: scoreColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _sentimentHeroHeaderGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${global.overallScore}',
                style: AppTextStyles.heroNumber.copyWith(color: scoreColor),
              ),
              const SizedBox(width: _sentimentHeroScoreGap),
              Padding(
                padding: _sentimentHeroScorePadding,
                child: Text(
                  '/ 100',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: _sentimentHeroGaugeGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: SizedBox(
              width: double.infinity,
              height: _sentimentHeroGaugeHeight,
              child: Stack(
                children: [
                  const ColoredBox(
                    color: AppColors.surface2,
                    child: SizedBox.expand(),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: gaugePct.toDouble(),
                    child: ColoredBox(
                      color: scoreColor,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: _sentimentHeroLegendGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cực sợ',
                style: AppTextStyles.micro.copyWith(color: AppColors.sell),
              ),
              Text(
                'Trung lập',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              Text(
                'Cực tham',
                style: AppTextStyles.micro.copyWith(color: AppColors.buy),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SentimentStats extends StatelessWidget {
  const _SentimentStats({required this.global});

  final SocialSentimentGlobal global;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.mode_comment_outlined,
            iconColor: _marketPrimary,
            label: 'Lượt đề cập 24h',
            value: _formatCompact(global.totalMentions24h),
            sub: '+${global.mentionsChange.toStringAsFixed(2)}%',
            subColor: AppColors.buy,
          ),
        ),
        const SizedBox(width: _sentimentStatGap),
        Expanded(
          child: _StatCard(
            icon: Icons.tag_rounded,
            iconColor: AppColors.accent,
            label: 'Token trending',
            value: '${global.trendingTokens}',
            sub: 'trong 24h qua',
            subColor: AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.sub,
    required this.subColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String sub;
  final Color subColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _sentimentStatPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: _sentimentStatIcon, color: iconColor),
              const SizedBox(width: _sentimentStatIconGap),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: _sentimentStatValueGap),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _sentimentStatSubGap),
          Text(sub, style: AppTextStyles.micro.copyWith(color: subColor)),
        ],
      ),
    );
  }
}
