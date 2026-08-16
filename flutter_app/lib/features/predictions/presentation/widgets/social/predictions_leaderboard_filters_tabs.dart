part of '../../phone/pages/social/predictions_leaderboard_page.dart';

class _TimeFilters extends StatelessWidget {
  const _TimeFilters({required this.active, required this.onSelected});

  final PredictionLeaderboardTimeFilter active;
  final ValueChanged<PredictionLeaderboardTimeFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: VitTabBar(
        variant: VitTabBarVariant.pill,
        activeKey: active.name,
        onChanged: (key) =>
            onSelected(PredictionLeaderboardTimeFilter.values.byName(key)),
        tabs: [
          VitTabItem(
            key: PredictionLeaderboardTimeFilter.today.name,
            label: 'Today',
            widgetKey: PredictionsLeaderboardPage.todayFilterKey,
          ),
          VitTabItem(
            key: PredictionLeaderboardTimeFilter.weekly.name,
            label: 'Weekly',
            widgetKey: PredictionsLeaderboardPage.weeklyFilterKey,
          ),
          VitTabItem(
            key: PredictionLeaderboardTimeFilter.monthly.name,
            label: 'Monthly',
            widgetKey: PredictionsLeaderboardPage.monthlyFilterKey,
          ),
          VitTabItem(
            key: PredictionLeaderboardTimeFilter.allTime.name,
            label: 'All Time',
            widgetKey: PredictionsLeaderboardPage.allTimeFilterKey,
          ),
        ],
      ),
    );
  }
}

class _MetricTabs extends StatelessWidget {
  const _MetricTabs({
    required this.active,
    required this.onSelected,
    required this.onInfoTap,
  });

  final PredictionLeaderboardMetric active;
  final ValueChanged<PredictionLeaderboardMetric> onSelected;
  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitSegmentedChoice<PredictionLeaderboardMetric>(
            selected: active,
            onChanged: onSelected,
            options: const [
              VitSegmentedChoiceOption(
                value: PredictionLeaderboardMetric.pnl,
                label: 'Profit/Loss',
                key: PredictionsLeaderboardPage.pnlMetricKey,
                leading: Icon(Icons.trending_up_rounded, size: AppSpacing.x3),
              ),
              VitSegmentedChoiceOption(
                value: PredictionLeaderboardMetric.volume,
                label: 'Volume',
                key: PredictionsLeaderboardPage.volumeMetricKey,
                leading: Icon(Icons.bar_chart_rounded, size: AppSpacing.x3),
              ),
            ],
          ),
        ),
        const SizedBox(width: _boardSpace),
        VitIconButton(
          key: PredictionsLeaderboardPage.infoKey,
          icon: Icons.help_outline_rounded,
          tooltip: 'Leaderboard metric info',
          onPressed: onInfoTap,
          variant: VitIconButtonVariant.transparent,
          size: VitIconButtonSize.sm,
        ),
      ],
    );
  }
}
