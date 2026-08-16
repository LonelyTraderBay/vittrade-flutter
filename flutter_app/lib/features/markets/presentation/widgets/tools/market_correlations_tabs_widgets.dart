part of '../../phone/pages/tools/market_correlations_page.dart';

class _CorrelationTabs extends StatelessWidget {
  const _CorrelationTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: MarketsSpacingTokens.marketDepthTabsHeight,
        child: Column(
          children: [
            Expanded(
              child: VitTabBar(
                activeKey: activeTab,
                variant: VitTabBarVariant.underline,
                onChanged: onChanged,
                tabs: const [
                  VitTabItem(
                    key: 'matrix',
                    label: 'Ma trận',
                    widgetKey: MarketCorrelationsPage.matrixTabKey,
                  ),
                  VitTabItem(
                    key: 'pairs',
                    label: 'Cặp tương quan',
                    widgetKey: MarketCorrelationsPage.pairsTabKey,
                  ),
                  VitTabItem(
                    key: 'diversify',
                    label: 'Đa dạng hóa',
                    widgetKey: MarketCorrelationsPage.diversifyTabKey,
                  ),
                ],
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeframeChips extends StatelessWidget {
  const _TimeframeChips({required this.timeframe, required this.onSelected});

  final MarketCorrelationTimeframe timeframe;
  final ValueChanged<MarketCorrelationTimeframe> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitPresetChipRow<MarketCorrelationTimeframe>(
      selectedValue: timeframe,
      onTap: onSelected,
      accentColor: _marketPrimary,
      height: _corrTimeframeChipHeight,
      padding: MarketsSpacingTokens.marketCorrelationsTimeframeChipPadding,
      gap: _corrChipGap,
      items: const [
        VitPresetChipItem(
          key: MarketCorrelationsPage.timeframe7dKey,
          value: MarketCorrelationTimeframe.d7,
          label: '7d',
        ),
        VitPresetChipItem(
          key: MarketCorrelationsPage.timeframe30dKey,
          value: MarketCorrelationTimeframe.d30,
          label: '30d',
        ),
        VitPresetChipItem(
          key: MarketCorrelationsPage.timeframe90dKey,
          value: MarketCorrelationTimeframe.d90,
          label: '90d',
        ),
      ],
    );
  }
}
