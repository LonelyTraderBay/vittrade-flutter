part of '../../phone/pages/portfolio/dca_portfolio_optimizer_page.dart';

class _OptimizerTabs extends StatelessWidget {
  const _OptimizerTabs({required this.activeTab, required this.onChanged});

  final _OptimizerTab activeTab;
  final ValueChanged<_OptimizerTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: activeTab.name,
      onChanged: (key) => onChanged(_OptimizerTab.values.byName(key)),
      tabs: [
        for (final tab in _OptimizerTab.values)
          VitTabItem(
            key: tab.name,
            label: _tabLabel(tab),
            icon: _tabIcon(tab),
            widgetKey: DCAPortfolioOptimizerPage.tabKey(tab.name),
          ),
      ],
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.activeTab,
    required this.snapshot,
    required this.showSuggestions,
    required this.showCompareHint,
    required this.onToggleSuggestions,
    required this.onCompare,
  });

  final _OptimizerTab activeTab;
  final DcaPortfolioOptimizerSnapshot snapshot;
  final bool showSuggestions;
  final bool showCompareHint;
  final VoidCallback onToggleSuggestions;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    return switch (activeTab) {
      _OptimizerTab.frontier => _FrontierContent(
        snapshot: snapshot,
        showSuggestions: showSuggestions,
        showCompareHint: showCompareHint,
        onToggleSuggestions: onToggleSuggestions,
        onCompare: onCompare,
      ),
      _OptimizerTab.correlation => const _CorrelationContent(),
      _OptimizerTab.backtest => const _BacktestContent(),
      _OptimizerTab.risk => _RiskContent(snapshot: snapshot),
    };
  }
}
