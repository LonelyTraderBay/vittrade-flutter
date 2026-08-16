part of '../../phone/pages/portfolio/dca_performance_compare_page.dart';

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _CompareTab activeTab;
  final ValueChanged<_CompareTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitScrollableTabHeader.surfaceDivider(
      tabBar: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_CompareTab.values.byName(key)),
        tabs: [
          VitTabItem(
            key: _CompareTab.compare.name,
            label: 'So sánh',
            widgetKey: DCAPerformanceComparePage.tabKey(
              _CompareTab.compare.name,
            ),
          ),
          VitTabItem(
            key: _CompareTab.scenarios.name,
            label: 'Kịch bản',
            widgetKey: DCAPerformanceComparePage.tabKey(
              _CompareTab.scenarios.name,
            ),
          ),
          VitTabItem(
            key: _CompareTab.analysis.name,
            label: 'Phân tích',
            widgetKey: DCAPerformanceComparePage.tabKey(
              _CompareTab.analysis.name,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.title,
    required this.value,
    required this.invested,
    required this.returnPercent,
    required this.color,
  });

  final String title;
  final String value;
  final String invested;
  final double returnPercent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: 0.28),
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _SmallMetric(label: 'Invested', value: invested),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _SmallMetric(
            label: 'Return',
            value: _formatSignedPercent(returnPercent),
            valueColor: color,
          ),
        ],
      ),
    );
  }
}

class _WinnerBanner extends StatelessWidget {
  const _WinnerBanner({required this.snapshot});

  final DcaPerformanceCompareSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final dcaWins = snapshot.winner == DcaPerformanceWinner.dca;
    final color = dcaWins ? AppColors.buy : AppColors.primary;
    return VitCard(
      borderColor: color.withValues(alpha: 0.28),
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.bolt_rounded, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dcaWins ? 'DCA Strategy Wins' : 'Lump Sum Wins',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text.rich(
                  TextSpan(
                    text: 'Outperformed by ',
                    children: [
                      TextSpan(
                        text:
                            '${snapshot.advantagePercent.abs().toStringAsFixed(2)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const TextSpan(text: ' in this period'),
                    ],
                  ),
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
