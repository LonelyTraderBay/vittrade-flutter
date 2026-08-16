part of '../../phone/pages/hub/orders_history_page.dart';

class _OrderTopTabs extends StatelessWidget {
  const _OrderTopTabs({
    required this.active,
    required this.openCount,
    required this.historyCount,
    required this.onChanged,
  });

  final String active;
  final int openCount;
  final int historyCount;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        VitTabItem(
          key: 'open',
          label: 'Lệnh mở ($openCount)',
          widgetKey: OrdersHistoryPage.openTabKey,
        ),
        VitTabItem(
          key: 'history',
          label: 'Lịch sử ($historyCount)',
          widgetKey: OrdersHistoryPage.historyTabKey,
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.active, required this.onChanged});

  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<String>(
      selected: active,
      onChanged: onChanged,
      options: [
        VitSegmentedChoiceOption(
          key: OrdersHistoryPage.filterKey('all'),
          value: 'all',
          label: 'Tất cả',
          accentColor: _tradePrimary,
        ),
        VitSegmentedChoiceOption(
          key: OrdersHistoryPage.filterKey('buy'),
          value: 'buy',
          label: 'MUA',
          accentColor: AppColors.buy,
        ),
        VitSegmentedChoiceOption(
          key: OrdersHistoryPage.filterKey('sell'),
          value: 'sell',
          label: 'BÁN',
          accentColor: AppColors.sell,
        ),
      ],
    );
  }
}

class _OrderHistoryTile extends StatelessWidget {
  const _OrderHistoryTile({
    super.key,
    required this.order,
    required this.onCancel,
    this.actionKey,
    this.grouped = false,
  });

  final TradeHistoryOrder order;
  final VoidCallback onCancel;
  final Key? actionKey;
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    return grouped
        ? Padding(
            padding: SharedSpacingTokens.tradeOrderRowPadding,
            child: content,
          )
        : VitCard(
            radius: VitCardRadius.tight,
            padding: VitDensity.tool.cardPadding,
            borderColor: AppColors.divider,
            child: content,
          );
  }

  Widget get content {
    final status = _statusPresentation(order.status);
    final isBuy = order.side == TradeOrderSide.buy;
    final fillPercent = order.amount == 0 ? 0.0 : order.filled / order.amount;
    final actionable =
        order.status == TradeOrderStatus.open ||
        order.status == TradeOrderStatus.partial;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      order.symbol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  _SmallBadge(
                    label: isBuy ? 'MUA' : 'BÁN',
                    color: isBuy ? AppColors.buy : AppColors.sell,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  _TypeBadge(type: order.type),
                ],
              ),
            ),
            SizedBox(
              width: _ordersStatusExtent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    status.icon,
                    color: status.color,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Flexible(
                    child: Text(
                      status.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: status.color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _InfoColumn(
                label: 'Giá',
                value: '\$${_formatMoney(order.price)}',
              ),
            ),
            Expanded(
              child: _InfoColumn(
                label: 'Số lượng',
                value: order.amount.toStringAsFixed(4),
              ),
            ),
          ],
        ),
        if (order.status == TradeOrderStatus.partial || order.fee > 0) ...[
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              Expanded(
                child: order.status == TradeOrderStatus.partial
                    ? _InfoColumn(
                        label: 'Đã khớp',
                        value:
                            '${order.filled.toStringAsFixed(4)}  (${(fillPercent * 100).toStringAsFixed(0)}%)',
                        valueColor: AppColors.buy,
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: order.fee > 0
                    ? _InfoColumn(
                        label: 'Phí',
                        value: '\$${order.fee.toStringAsFixed(2)}',
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.x1),
        _InfoColumn(label: 'Thời gian', value: order.createdAt),
        if (order.status == TradeOrderStatus.partial) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              value: fillPercent,
              minHeight: AppSpacing.x1,
              color: AppColors.buy,
              backgroundColor: AppColors.surface3,
            ),
          ),
        ],
        if (actionable) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            key: actionKey,
            onPressed: onCancel,
            variant: VitCtaButtonVariant.danger,
            density: VitDensity.tool,
            height: VitDensity.tool.controlHeight,
            child: const Text('Hủy lệnh'),
          ),
        ],
      ],
    );
  }
}
