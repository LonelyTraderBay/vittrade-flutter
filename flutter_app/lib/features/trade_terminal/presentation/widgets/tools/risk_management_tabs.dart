part of '../../phone/pages/tools/risk_management_demo_page.dart';

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({required this.active, required this.onChanged});

  final _RiskTab active;
  final ValueChanged<_RiskTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      VitTabItem(
        key: _RiskTab.oco.name,
        label: 'OCO Orders',
        widgetKey: RiskManagementDemoPage.tabKey(_RiskTab.oco.name),
      ),
      VitTabItem(
        key: _RiskTab.positions.name,
        label: 'Positions',
        widgetKey: RiskManagementDemoPage.tabKey(_RiskTab.positions.name),
      ),
      VitTabItem(
        key: _RiskTab.calculator.name,
        label: 'Calculator',
        widgetKey: RiskManagementDemoPage.tabKey(_RiskTab.calculator.name),
      ),
    ];
    return SizedBox(
      height: _riskTabExtent,
      child: VitSegmentedTabBar(
        tabs: tabs,
        activeKey: active.name,
        onChanged: (id) => onChanged(_RiskTab.values.byName(id)),
      ),
    );
  }
}

class _OcoTab extends StatelessWidget {
  const _OcoTab({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhấn nút bên dưới để mở form đặt lệnh OCO',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: _riskSpace),
        _GradientButton(
          key: RiskManagementDemoPage.ocoButtonKey,
          label: 'Mở OCO Order Form',
          icon: Icons.trending_up_rounded,
          variant: VitCtaButtonVariant.success,
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _CalculatorTab extends StatelessWidget {
  const _CalculatorTab({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhấn nút bên dưới để mở calculator',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: _riskSpace),
        _GradientButton(
          key: RiskManagementDemoPage.calculatorButtonKey,
          label: 'Mở Position Sizing Calculator',
          icon: Icons.calculate_rounded,
          variant: VitCtaButtonVariant.auth,
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.positions});

  final List<TradeRiskPosition> positions;

  @override
  Widget build(BuildContext context) {
    final total = positions.fold<double>(0, (sum, item) => sum + item.pnl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          padding: TradeSpacingTokens.tradeToolCardPadding,
          radius: VitCardRadius.tight,
          child: Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Tổng P&L',
                  value: _formatSignedMoney(total),
                  color: total >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Vị thế',
                  value: '${positions.length}',
                ),
              ),
              const Expanded(
                child: _MiniMetric(label: 'Risk mode', value: 'Active'),
              ),
            ],
          ),
        ),
        const SizedBox(height: _riskSpace),
        for (final position in positions) ...[
          _PositionTile(position: position),
          const SizedBox(height: _riskSpace),
        ],
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: _riskTinySpace),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _PositionTile extends StatelessWidget {
  const _PositionTile({required this.position});

  final TradeRiskPosition position;

  @override
  Widget build(BuildContext context) {
    final color = Color(position.logoColorHex);
    final pnlColor = position.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: TradeSpacingTokens.tradeToolCardPadding,
      radius: VitCardRadius.tight,
      child: Row(
        children: [
          _IconTile(
            icon: position.side == TradeRiskPositionSide.long
                ? Icons.north_east_rounded
                : Icons.south_east_rounded,
            color: color,
            size: TradeSpacingTokens.tradeToolIconTileSm,
          ),
          const SizedBox(width: _riskCardSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        position.symbol,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      _formatSignedMoney(position.pnl),
                      style: AppTextStyles.caption.copyWith(
                        color: pnlColor,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _riskTinySpace),
                Text(
                  '${position.side.name.toUpperCase()} · ${position.amount.toStringAsFixed(position.amount >= 10 ? 0 : 2)} ${position.baseAsset} · Entry ${_formatMoney(position.entryPrice)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
