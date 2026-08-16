part of '../../phone/pages/hub/position_dashboard_page.dart';

class _PositionList extends StatelessWidget {
  const _PositionList({required this.positions});

  final List<TradeDashboardPosition> positions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        children: [
          for (var i = 0; i < positions.length; i++) ...[
            Padding(
              padding: VitDensity.tool.cardPadding,
              child: _PositionTile(position: positions[i]),
            ),
            if (i < positions.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.positions});

  final List<TradeDashboardPosition> positions;

  @override
  Widget build(BuildContext context) {
    final totalPnl = positions.fold<double>(0, (sum, item) => sum + item.pnl);
    final totalValue = positions.fold<double>(
      0,
      (sum, item) => sum + item.notional,
    );
    final totalMargin = positions.fold<double>(
      0,
      (sum, item) => sum + (item.margin ?? 0),
    );

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      padding: VitDensity.tool.cardPadding,
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Tổng P/L',
              value: _formatSignedMoney(totalPnl),
              color: totalPnl >= 0 ? AppColors.buy : AppColors.sell,
              large: true,
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Tổng giá trị',
              value: _formatCompactMoney(totalValue),
            ),
          ),
          Expanded(
            child: _SummaryMetric(
              label: 'Ký quỹ đang dùng',
              value: '\$${_formatMoney(totalMargin)}',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.large = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: TradeSpacingTokens.positionDashboardLabelLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (large ? AppTextStyles.baseMedium : AppTextStyles.numericCode)
              .copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                height: TradeSpacingTokens.positionDashboardTightLineHeight,
              ),
        ),
      ],
    );
  }
}

class _TypeTabs extends StatelessWidget {
  const _TypeTabs({
    required this.active,
    required this.positions,
    required this.onChanged,
  });

  final String active;
  final List<TradeDashboardPosition> positions;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('all', 'Tất cả (${positions.length})'),
      ('spot', 'Spot (${_count(TradePositionType.spot)})'),
      ('futures', 'Futures (${_count(TradePositionType.futures)})'),
      ('margin', 'Margin (${_count(TradePositionType.margin)})'),
    ];

    return VitSegmentedTabBar(
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: PositionDashboardPage.tabKey(tab.$1),
          ),
      ],
    );
  }

  int _count(TradePositionType type) {
    return positions.where((position) => position.type == type).length;
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final sorts = const [
      ('pnl', 'P/L'),
      ('pnlPct', '%P/L'),
      ('size', 'Kích thước'),
    ];

    return VitSortRail<String>(
      selected: active,
      onChanged: onChanged,
      accentColor: AppColors.primary,
      optionHeight: AppSpacing.buttonCompact,
      optionPadding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowPy,
        right: AppSpacing.rowPy,
      ),
      optionGap: AppSpacing.x3,
      iconSize: TradeSpacingTokens.tradeQuickChipIcon,
      options: [
        for (final sort in sorts)
          VitSortRailOption(
            key: PositionDashboardPage.sortKey(sort.$1),
            value: sort.$1,
            label: sort.$2,
          ),
      ],
    );
  }
}
