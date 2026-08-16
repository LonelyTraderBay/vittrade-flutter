part of 'market_overview_page.dart';

class _FearGreedHistory extends StatelessWidget {
  const _FearGreedHistory({required this.points});

  final List<FearGreedPoint> points;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Lịch sử sợ hãi & tham lam (7 ngày)',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              SizedBox(
                height: AppSpacing.x7,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < points.length; i++) ...[
                      Expanded(
                        child: _HistoryBar(
                          point: points[i],
                          active: i == points.length - 1,
                        ),
                      ),
                      if (i < points.length - 1)
                        const SizedBox(
                          width: MarketsSpacingTokens.marketAnalyticsMicroGap,
                        ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '7 ngày trước',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppTextStyles.numericMicro.height,
                    ),
                  ),
                  Text(
                    'Hôm nay',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: AppTextStyles.numericMicro.height,
                    ),
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

class _HistoryBar extends StatelessWidget {
  const _HistoryBar({required this.point, required this.active});

  final FearGreedPoint point;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final height =
        point.value /
        100 *
        MarketsSpacingTokens.marketOverviewHistoryBarMaxHeight;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${point.value}',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            // T3.3 exception: compact chart-axis label for Fear&Greed bars.
            // Keep 8px equivalent spacing to prevent overlap on mini chart points.
            fontFeatures: AppTextStyles.tabularFigures,
            height: AppTextStyles.chartLabelXs.height,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        ClipRRect(
          borderRadius: AppRadii.smRadius,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: ColoredBox(
              color: _fearGreedColor(
                point.value,
              ).withValues(alpha: active ? 1 : 0.62),
            ),
          ),
        ),
      ],
    );
  }
}

class _MarketTools extends StatelessWidget {
  const _MarketTools();

  @override
  Widget build(BuildContext context) {
    const tools = [
      _MarketTool(
        buttonKey: MarketOverviewPage.watchlistToolKey,
        label: 'Danh sách theo dõi',
        icon: Icons.star_rounded,
        color: AppColors.primarySoft,
        route: '/markets/watchlist',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.alertsToolKey,
        label: 'Cảnh báo giá',
        icon: Icons.notifications_rounded,
        color: AppColors.primarySoft,
        route: '/markets/alerts',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.heatmapToolKey,
        label: 'Biểu đồ nhiệt',
        icon: Icons.map_rounded,
        color: AppAssetColors.cyanChain,
        route: '/markets/heatmap',
      ),
      _MarketTool(
        buttonKey: MarketOverviewPage.marketListToolKey,
        label: 'Danh sách thị trường',
        icon: Icons.article_rounded,
        color: AppColors.caution,
        route: AppRoutePaths.markets,
      ),
    ];

    return VitPageSection(
      label: 'Công cụ thị trường',
      accentColor: _marketPrimary,
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(child: tools[0]),
                const SizedBox(
                  width: MarketsSpacingTokens.marketAnalyticsCompactGap,
                ),
                Expanded(child: tools[1]),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Row(
              children: [
                Expanded(child: tools[2]),
                const SizedBox(
                  width: MarketsSpacingTokens.marketAnalyticsCompactGap,
                ),
                Expanded(child: tools[3]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MarketTool extends StatelessWidget {
  const _MarketTool({
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  }) : super(key: buttonKey);

  final Key buttonKey;
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      onTap: () => context.go(route),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: MarketsSpacingTokens.marketOverviewToolIcon,
          ),
          const SizedBox(width: MarketsSpacingTokens.marketAnalyticsGap),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontWeight: AppTextStyles.bold,
                height: AppTextStyles.numericMicro.height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniHeader extends StatelessWidget {
  const _MiniHeader({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: MarketsSpacingTokens.marketOverviewMiniHeaderIcon,
        ),
        const SizedBox(width: MarketsSpacingTokens.marketOverviewMiniHeaderGap),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.badge.height,
            ),
          ),
        ),
      ],
    );
  }
}

Color _fearGreedColor(int value) {
  if (value <= 25) return AppColors.sell;
  if (value <= 45) return AppColors.primarySoft;
  if (value <= 55) return AppAssetColors.neutralChain;
  if (value <= 75) return AppColors.buy;
  return AppColors.buyDark;
}

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
