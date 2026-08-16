part of '../../phone/pages/hub/trading_bots_page.dart';

class _HubMetricsStrip extends StatelessWidget {
  const _HubMetricsStrip({
    required this.investment,
    required this.botCount,
    required this.tradeCount,
  });

  final double investment;
  final int botCount;
  final int tradeCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
            variant: VitCardVariant.inner,
            child: _MetricCell(
              label: 'Vốn đang quản lý',
              value: '\$${_formatWholeNumber(investment)}',
            ),
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.tradeBotMetricGap),
        Expanded(
          child: VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
            variant: VitCardVariant.inner,
            child: _MetricCell(label: 'Tổng bot', value: '$botCount'),
          ),
        ),
        const SizedBox(width: TradeSpacingTokens.tradeBotMetricGap),
        Expanded(
          child: VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            padding: TradeSpacingTokens.tradeBotMetricBoxPadding,
            variant: VitCardVariant.inner,
            child: _MetricCell(label: 'Số lệnh', value: '$tradeCount'),
          ),
        ),
      ],
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _QuickToolItem {
  const _QuickToolItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.path,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String path;
}

const _quickTools = [
  _QuickToolItem(
    id: 'risk',
    label: 'Rủi ro',
    icon: Icons.shield_outlined,
    color: AppColors.warn,
    path: AppRoutePaths.tradeBotRiskDashboard,
  ),
  _QuickToolItem(
    id: 'analytics',
    label: 'Hiệu suất',
    icon: Icons.show_chart_rounded,
    color: AppColors.buy,
    path: AppRoutePaths.tradeBotPerformanceAnalytics,
  ),
  _QuickToolItem(
    id: 'history',
    label: 'Lịch sử',
    icon: Icons.history_rounded,
    color: AppColors.primary,
    path: AppRoutePaths.tradeBotHistory,
  ),
  _QuickToolItem(
    id: 'help',
    label: 'Trợ giúp',
    icon: Icons.menu_book_outlined,
    color: AppColors.text2,
    path: AppRoutePaths.tradeBotGuide,
  ),
];

class _QuickToolsStrip extends StatelessWidget {
  const _QuickToolsStrip({
    required this.showEmergency,
    required this.onOpen,
    required this.onExplore,
  });

  final bool showEmergency;
  final ValueChanged<String> onOpen;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return VitTradeSection(
      title: 'Công cụ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KeyedSubtree(
            key: TradingBotsPage.toolsKey,
            child: VitActionTileGrid(
              itemCount: _quickTools.length,
              crossAxisCount: AppSpacing.serviceTileCrossAxisCount,
              density: VitDensity.tool,
              itemBuilder: (context, index, density) {
                final tool = _quickTools[index];
                return VitServiceTile(
                  key: TradingBotsPage.toolKey(tool.id),
                  icon: tool.icon,
                  label: tool.label,
                  accentColor: tool.color,
                  density: density,
                  onTap: () => onOpen(tool.path),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: TradingBotsPage.addBotKey,
            onPressed: onExplore,
            density: VitDensity.tool,
            height: TradeSpacingTokens.tradeBotSheetActionHeight,
            leading: const Icon(Icons.add_rounded),
            child: const Text('Khám phá chiến lược'),
          ),
          if (showEmergency) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitCtaButton(
              key: TradingBotsPage.emergencyStopKey,
              onPressed: () => onOpen(AppRoutePaths.tradeBotEmergencyStop),
              density: VitDensity.tool,
              height: TradeSpacingTokens.tradeBotFooterButtonHeight,
              variant: VitCtaButtonVariant.destructive,
              leading: const Icon(Icons.stop_circle_outlined),
              child: const Text('Dừng khẩn cấp'),
            ),
          ],
        ],
      ),
    );
  }
}
