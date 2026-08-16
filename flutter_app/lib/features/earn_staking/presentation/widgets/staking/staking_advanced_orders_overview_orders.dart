part of '../../phone/pages/staking/staking_advanced_orders_page.dart';

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitStatsGrid(
      key: StakingAdvancedOrdersPage.statsKey,
      padding: EarnSpacingTokens.earnPaddingX4,
      cells: [
        for (final stat in snapshot.statCards)
          VitStatCell(
            label: stat.label,
            value: stat.value,
            valueColor: stat.tone == 'success' ? AppModuleAccents.earn : null,
          ),
      ],
    );
  }
}

class _OrderTabs extends StatelessWidget {
  const _OrderTabs({required this.active, required this.onChanged});

  final _AdvancedOrderTab active;
  final ValueChanged<_AdvancedOrderTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: StakingAdvancedOrdersPage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(_AdvancedOrderTab.values.byName(key)),
      tabs: [
        for (final tab in _AdvancedOrderTab.values)
          VitTabItem(
            key: tab.name,
            label: _tabLabel(tab),
            widgetKey: StakingAdvancedOrdersPage.tabKey(tab.name),
          ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final StakingAdvancedOrderDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAdvancedOrdersPage.orderKey(order.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _orderIcon(order.type),
                color: _orderTone(order.type),
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _orderTypeLabel(order.type),
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${order.asset} · Trigger: ${order.trigger.toStringAsFixed(order.trigger == 0.90 ? 1 : 2)} ETH',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatAmount(order.amount)} ${order.asset}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  VitStatusPill(
                    label: _statusLabel(order.status),
                    status: switch (order.status) {
                      StakingAdvancedOrderStatus.active =>
                        VitStatusPillStatus.success,
                      StakingAdvancedOrderStatus.triggered =>
                        VitStatusPillStatus.info,
                      StakingAdvancedOrderStatus.cancelled =>
                        VitStatusPillStatus.neutral,
                    },
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            height: EarnSpacingTokens.stakingProductDividerHeight,
            color: AppColors.borderSolid,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Created: ${_formatDate(order.created)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (order.status == StakingAdvancedOrderStatus.active)
                Text(
                  'Cancel',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
