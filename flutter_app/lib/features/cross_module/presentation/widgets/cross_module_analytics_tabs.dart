part of '../phone/pages/cross_module_analytics_page.dart';

class _AnalyticsTabs extends StatelessWidget {
  const _AnalyticsTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<CrossModuleAnalyticsTabDraft> tabs;
  final CrossModuleAnalyticsTab active;
  final ValueChanged<CrossModuleAnalyticsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabItems = [
      for (final tab in tabs)
        VitTabItem(
          key: tab.tab.name,
          label: tab.label,
          widgetKey: CrossModuleAnalyticsPage.tabKey(tab.tab),
        ),
    ];

    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface,
        shape: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: CrossModuleSpacingTokens.crossModuleTabBarPadding,
        child: VitSegmentedTabBar(
          tabs: tabItems,
          activeKey: active.name,
          onChanged: (key) {
            final selected = tabs.firstWhere((tab) => tab.tab.name == key);
            onChanged(selected.tab);
          },
        ),
      ),
    );
  }
}

class _PerformanceTab extends StatelessWidget {
  const _PerformanceTab({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryGrid(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _HighlightCards(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ChartCard(
          title: 'ROI by Module',
          child: CustomPaint(
            painter: _RoiBarPainter(modules: snapshot.modules),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ChartCard(
          title: 'Monthly ROI Trends',
          child: CustomPaint(
            painter: _MonthlyLinePainter(points: snapshot.monthlyPerformance),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class _MetricsTab extends StatelessWidget {
  const _MetricsTab({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChartCard(
          title: 'Multi-Metric Comparison',
          child: CustomPaint(
            painter: _RadarMetricPainter(modules: snapshot.modules),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Chi tiet chi so',
          children: [
            for (final module in snapshot.modules)
              _MetricDetailCard(module: module),
          ],
        ),
      ],
    );
  }
}

class _ComparisonTab extends StatelessWidget {
  const _ComparisonTab({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final ranked = [...snapshot.modules]
      ..sort((a, b) => _efficiency(b).compareTo(_efficiency(a)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChartCard(
          title: 'Risk vs Return Analysis',
          child: CustomPaint(
            painter: _RiskReturnPainter(modules: snapshot.modules),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Efficiency Comparison',
          children: [
            for (var i = 0; i < ranked.length; i++)
              _EfficiencyRow(rank: i + 1, module: ranked[i]),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _ArenaAnalyticsDisclosure(),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _AnalyticsInfoCard(),
      ],
    );
  }
}
