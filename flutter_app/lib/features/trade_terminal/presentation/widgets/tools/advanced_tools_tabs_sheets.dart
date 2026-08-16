part of '../../phone/pages/tools/advanced_tools_demo_page.dart';

class _ToolsTabs extends StatelessWidget {
  const _ToolsTabs({required this.active, required this.onChanged});

  final _ToolsTab active;
  final ValueChanged<_ToolsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(_ToolsTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: _ToolsTab.ladder.name,
          label: 'Ladder',
          widgetKey: AdvancedToolsDemoPage.tabKey(_ToolsTab.ladder.name),
        ),
        VitTabItem(
          key: _ToolsTab.bulk.name,
          label: 'Bulk Ops',
          widgetKey: AdvancedToolsDemoPage.tabKey(_ToolsTab.bulk.name),
        ),
        VitTabItem(
          key: _ToolsTab.shortcuts.name,
          label: 'Shortcuts',
          widgetKey: AdvancedToolsDemoPage.tabKey(_ToolsTab.shortcuts.name),
        ),
      ],
    );
  }
}

class _ActionTab extends StatelessWidget {
  const _ActionTab({
    required this.description,
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onOpen,
  });

  final String description;
  final Key buttonKey;
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          description,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: _toolsSpace),
        _GradientButton(
          key: buttonKey,
          label: label,
          icon: icon,
          colors: colors,
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _LadderSheet extends StatelessWidget {
  const _LadderSheet({required this.orders});

  final List<TradeLadderOrder> orders;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Ladder Trading',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'BTC/USDT DOM · click price level to place instant order.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _toolsSpace),
          for (final offset in const [150, 100, 50, 0, -50, -100]) ...[
            _LadderLevel(price: 69000 + offset),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          const SizedBox(height: _toolsSpace),
          for (final order in orders) ...[
            _toolsSheetRow(
              label: '${order.side.name.toUpperCase()} ${order.id}',
              value:
                  '${order.amount.toStringAsFixed(1)} BTC @ \$${_formatMoney(order.price)}',
            ),
          ],
          const SizedBox(height: _toolsCardSpace),
          _GradientButton(
            key: AdvancedToolsDemoPage.ladderSubmitKey,
            label: 'Place Buy Order',
            icon: Icons.check_rounded,
            colors: const [AppColors.buy, AppColors.buyDark],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _BulkSheet extends StatelessWidget {
  const _BulkSheet({required this.orders});

  final List<TradeBulkOrder> orders;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Bulk Operations',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${orders.length} open orders selected for batch action.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _toolsSpace),
          for (final order in orders) ...[
            _toolsSheetRow(
              label: '${order.symbol} ${order.side.name.toUpperCase()}',
              value:
                  '${order.remaining.toStringAsFixed(1)} @ \$${_formatMoney(order.price)}',
            ),
          ],
          const SizedBox(height: _toolsCardSpace),
          _GradientButton(
            key: AdvancedToolsDemoPage.bulkCancelKey,
            label: 'Cancel Selected Orders',
            icon: Icons.close_rounded,
            colors: const [AppColors.caution, AppColors.medalBronzeMuted],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _ShortcutsSheet extends StatelessWidget {
  const _ShortcutsSheet({required this.shortcuts});

  final List<TradeShortcut> shortcuts;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Keyboard Shortcuts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final shortcut in shortcuts) ...[
            _toolsSheetRow(label: shortcut.keys, value: shortcut.label),
          ],
          const SizedBox(height: _toolsCardSpace),
          _GradientButton(
            key: AdvancedToolsDemoPage.shortcutTriggerKey,
            label: 'Trigger Quick Buy',
            icon: Icons.keyboard_rounded,
            colors: const [AppColors.accent, AppColors.accentDark],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _LadderLevel extends StatelessWidget {
  const _LadderLevel({required this.price});

  final int price;

  @override
  Widget build(BuildContext context) {
    final isAsk = price > 69000;
    final color = isAsk ? AppColors.sell : AppColors.buy;
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      height: AppSpacing.buttonCompact,
      padding: TradeSpacingTokens.tradeToolMetricRowPadding,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: color.withValues(alpha: .35),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isAsk ? 'SELL' : 'BUY',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '\$${_formatMoney(price.toDouble())}',
            style: AppTextStyles.caption.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
