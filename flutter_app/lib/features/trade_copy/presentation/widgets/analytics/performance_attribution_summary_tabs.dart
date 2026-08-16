part of '../../phone/pages/analytics/performance_attribution_page.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: TradeSpacingTokens.tradeBotGridColumns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.x3,
      crossAxisSpacing: AppSpacing.x3,
      childAspectRatio: TradeSpacingTokens.tradeBotAttributionMetricAspectRatio,
      children: [
        _MetricTile(
          label: 'Total Return',
          value: '+${snapshot.totalReturnPct.toStringAsFixed(1)}%',
          caption: '30 ngày',
          valueColor: _attributionGreen,
        ),
        _MetricTile(
          label: 'Alpha (Skill)',
          value:
              '${snapshot.alphaPct >= 0 ? '+' : ''}${snapshot.alphaPct.toStringAsFixed(1)}%',
          caption: 'vs market',
          valueColor: snapshot.alphaPct >= 0
              ? _attributionGreen
              : _attributionRed,
        ),
        _MetricTile(
          label: 'Beta (Market)',
          value: snapshot.beta.toStringAsFixed(2),
          caption: 'sensitivity',
          valueColor: AppColors.text1,
        ),
        _MetricTile(
          label: 'R² (Fit)',
          value: '${(snapshot.rSquared * 100).toStringAsFixed(0)}%',
          caption: 'explained',
          valueColor: AppColors.text1,
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.caption,
    required this.valueColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.extraBold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            caption,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _AttributionTabs extends StatelessWidget {
  const _AttributionTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('attribution', 'Attribution'),
      ('drawdown', 'Drawdown'),
      ('projection', 'Projection'),
      ('correlation', 'Correlation'),
    ];

    return VitSegmentedTabBar(
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: PerformanceAttributionPage.tabKey(tab.$1),
          ),
      ],
      activeKey: activeTab,
      onChanged: onChanged,
    );
  }
}

class _AttributionTab extends StatelessWidget {
  const _AttributionTab({required this.snapshot});

  final TradePerformanceAttributionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Returns Decomposition',
          titleColor: AppColors.text2,
          titleFontWeight: AppTextStyles.extraBold,
          titleLetterSpacing: .2,
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
        ),
        SizedBox(
          height: _attributionLargeChartHeight,
          child: CustomPaint(
            painter: _ReturnDecompositionPainter(snapshot.returns),
            child: const SizedBox.expand(),
          ),
        ),
        const _LegendRow(
          items: [
            _LegendItem('Market (Beta)', _attributionGray),
            _LegendItem('Alpha (Skill)', _attributionPurple),
          ],
        ),
        _InfoPanel(snapshot: snapshot),
        _ContributionBar(
          label: 'Market contribution (Beta)',
          value: snapshot.marketContributionPct,
          color: _attributionGray,
          ratio: .92,
        ),
        _ContributionBar(
          label: 'Skill contribution (Alpha)',
          value: snapshot.skillContributionPct,
          color: _attributionPurple,
          ratio: .45,
        ),
      ],
    );
  }
}
