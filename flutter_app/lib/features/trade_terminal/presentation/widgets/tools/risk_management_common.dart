part of '../../phone/pages/tools/risk_management_demo_page.dart';

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.variant,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VitCtaButtonVariant variant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: variant,
      height: _riskControlExtent,
      density: VitDensity.tool,
      leading: Icon(icon),
      child: Text(label),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.ghost,
      width: size,
      height: size,
      alignment: Alignment.center,
      radius: VitCardRadius.tight,
      borderColor: color.withValues(alpha: .24),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

class _OcoSheet extends StatelessWidget {
  const _OcoSheet();

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'OCO Order Form',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _riskSheetRow(label: 'Cặp', value: 'BTC/USDT'),
          _riskSheetRow(label: 'Side', value: 'Buy'),
          _riskSheetRow(label: 'Limit', value: '\$69,000'),
          _riskSheetRow(label: 'Take Profit', value: '\$72,000'),
          _riskSheetRow(label: 'Stop Loss', value: '\$66,000'),
          const SizedBox(height: _riskCardSpace),
          _GradientButton(
            key: RiskManagementDemoPage.ocoSubmitKey,
            label: 'Đặt lệnh OCO',
            icon: Icons.check_rounded,
            variant: VitCtaButtonVariant.success,
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _CalculatorSheet extends StatelessWidget {
  const _CalculatorSheet({required this.result});

  final TradePositionSizeResult result;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'Position Sizing Calculator',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _riskSheetRow(
            label: 'Risk amount',
            value: '\$${_formatMoney(result.riskAmount)}',
          ),
          _riskSheetRow(
            label: 'Per-unit risk',
            value: '\$${_formatMoney(result.perUnitRisk)}',
          ),
          _riskSheetRow(
            label: 'Suggested amount',
            value: '${result.suggestedAmount.toStringAsFixed(6)} BTC',
          ),
          _riskSheetRow(
            label: 'Notional',
            value: '\$${_formatMoney(result.notional)}',
          ),
          const SizedBox(height: _riskCardSpace),
          _GradientButton(
            key: RiskManagementDemoPage.calculatorApplyKey,
            label: 'Áp dụng khối lượng',
            icon: Icons.check_rounded,
            variant: VitCtaButtonVariant.auth,
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

Widget _riskSheetRow({required String label, required String value}) {
  return VitKeyValueRow(
    label: label,
    value: value,
    padding: TradeSpacingTokens.tradeToolSheetRowPadding,
    valueStyle: AppTextStyles.caption.copyWith(
      fontWeight: AppTextStyles.bold,
      fontFeatures: AppTextStyles.tabularFigures,
    ),
  );
}

String _formatSignedMoney(double value) => formatTradeSignedMoney(value);

String _formatMoney(double value) => formatTradeMoney(value);
