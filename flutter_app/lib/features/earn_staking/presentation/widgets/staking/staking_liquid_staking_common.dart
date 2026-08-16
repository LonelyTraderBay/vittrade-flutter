part of '../../phone/pages/staking/staking_liquid_staking_page.dart';

class _LiquidTabs extends StatelessWidget {
  const _LiquidTabs({required this.active, required this.onChanged});

  final _LiquidTab active;
  final ValueChanged<_LiquidTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: StakingLiquidStakingPage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(_LiquidTab.values.byName(key)),
      tabs: [
        for (final tab in _LiquidTab.values)
          VitTabItem(
            key: tab.name,
            label: _tabLabel(tab),
            widgetKey: StakingLiquidStakingPage.tabKey(tab.name),
          ),
      ],
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.zeroInsets.copyWith(
        top: AppSpacing.x2,
        bottom: AppSpacing.x2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _tabLabel(_LiquidTab tab) {
  return switch (tab) {
    _LiquidTab.stake => 'Stake',
    _LiquidTab.swap => 'Swap',
    _LiquidTab.holdings => 'Holdings',
  };
}

String _formatUsd(double value) {
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(1)}B';
  }
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(1)}M';
  }
  return '\$${value.toStringAsFixed(value == 0 ? 0 : 2)}';
}

String _formatBillions(double value) {
  return '\$${(value / 1000000000).toStringAsFixed(1)}B';
}

String _formatMillions(double value) {
  return '${(value / 1000000).toStringAsFixed(1)}M';
}

String _formatAmount(double value) {
  if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}

extension on StakingLiquidStakingSnapshot {
  StakingLiquidTokenDraft? tokenBySymbol(String symbol) {
    for (final token in tokens) {
      if (token.symbol == symbol) return token;
    }
    return null;
  }
}
