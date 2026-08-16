part of '../../phone/pages/tools/advanced_trading_demo_page.dart';

class _PositionModeCard extends StatelessWidget {
  const _PositionModeCard({required this.activeMode, required this.onChanged});

  final String activeMode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: TradeSpacingTokens.tradeToolRiskIntroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.settings_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: _advancedSpace),
              Text(
                'Chế độ vị thế',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text3,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: _advancedSpace),
          VitSegmentedChoice<String>(
            selected: activeMode,
            onChanged: onChanged,
            options: [
              VitSegmentedChoiceOption(
                key: AdvancedTradingDemoPage.modeKey('one-way'),
                value: 'one-way',
                label: 'Một chiều',
                accentColor: AppColors.primary,
              ),
              VitSegmentedChoiceOption(
                key: AdvancedTradingDemoPage.modeKey('hedge'),
                value: 'hedge',
                label: 'Phòng hộ',
                accentColor: AppColors.caution,
              ),
            ],
          ),
          const SizedBox(height: _advancedSpace),
          Text(
            activeMode == 'one-way'
                ? 'Chỉ được giữ Long HOẶC Short cho mỗi cặp. Đơn giản, phù hợp người mới.'
                : 'Có thể giữ đồng thời Long VÀ Short cho cùng một cặp. Phù hợp chiến lược phòng hộ.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _advancedLineBody,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('position', 'Vị thế'),
    ('orders', 'Loại lệnh'),
    ('analytics', 'PnL'),
  ];

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.underline,
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in _tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: AdvancedTradingDemoPage.tabKey(tab.$1),
          ),
      ],
    );
  }
}

class _PositionTab extends StatelessWidget {
  const _PositionTab({required this.snapshot, required this.onAction});

  final TradeAdvancedTradingDemoSnapshot snapshot;
  final ValueChanged<TradeAdvancedDemoAction> onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Panel(
          padding: TradeSpacingTokens.tradeToolRiskIntroPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Quản lý vị thế',
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: _advancedTinySpace),
              Text(
                'Professional tools để quản lý vị thế hiệu quả',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: _advancedLineBody,
                ),
              ),
              const SizedBox(height: _advancedSpace),
              for (final action in snapshot.positionActions) ...[
                _ActionButton(action: action, onTap: () => onAction(action)),
                if (action != snapshot.positionActions.last)
                  const SizedBox(height: _advancedTinySpace),
              ],
            ],
          ),
        ),
        const SizedBox(height: _advancedSpace),
        _MockPositionCard(position: snapshot.position),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.action, required this.onTap});

  final TradeAdvancedDemoAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: AdvancedTradingDemoPage.actionKey(action.id),
      onTap: onTap,
      constraints: const BoxConstraints(minHeight: _advancedActionMinExtent),
      alignment: Alignment.center,
      padding: TradeSpacingTokens.tradeToolMetricRowPadding,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: AppColors.borderSolid,
      child: Text(
        action.label,
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _MockPositionCard extends StatelessWidget {
  const _MockPositionCard({required this.position});

  final TradeAdvancedDemoPosition position;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      padding: TradeSpacingTokens.tradeToolRiskIntroPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mock Position (Demo)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _advancedSpace),
          _advancedValueRow(
            label: 'Pair',
            value: '${position.pair} · ${position.side.toUpperCase()}',
          ),
          const SizedBox(height: _advancedTinySpace),
          _advancedValueRow(
            label: 'Size',
            value: '${position.currentSize.toStringAsFixed(1)} BTC',
          ),
          const SizedBox(height: _advancedTinySpace),
          _advancedValueRow(
            label: 'Unrealized PnL',
            value: '+\$${position.currentPnl.toStringAsFixed(2)}',
            tone: TradeAdvancedMetricTone.positive,
          ),
        ],
      ),
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.snapshot});

  final TradeAdvancedTradingDemoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Panel(
          padding: TradeSpacingTokens.tradeToolRiskIntroPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Loại lệnh',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: _advancedSpace),
              Wrap(
                spacing: _advancedSpace,
                runSpacing: _advancedSpace,
                children: [
                  for (final type in snapshot.orderTypes)
                    _ChoiceChip(label: type.label, active: type.id == 'limit'),
                ],
              ),
              const SizedBox(height: _advancedSpace),
              Text(
                'Time In Force',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: _advancedSpace),
              Wrap(
                spacing: _advancedSpace,
                runSpacing: _advancedSpace,
                children: [
                  for (final tif in snapshot.timeInForce)
                    _ChoiceChip(label: tif.label, active: tif.id == 'GTC'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: _advancedSpace),
        _MetricsCard(title: 'Order Summary', metrics: snapshot.orderSummary),
      ],
    );
  }
}
