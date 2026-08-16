part of '../../phone/pages/settings/bot_tax_reporting_page.dart';

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      width: TradeSpacingTokens.tradeBotCheckbox,
      height: TradeSpacingTokens.tradeBotCheckbox,
      alignment: Alignment.center,
      borderColor: selected ? _taxPrimary : _taxOptionBorder,
      child: selected
          ? const Icon(Icons.check_circle_rounded, color: _taxPrimary, size: 16)
          : const SizedBox.shrink(),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.color,
    required this.background,
  });

  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: text,
      status: color == AppColors.buy
          ? VitStatusPillStatus.success
          : VitStatusPillStatus.warning,
      size: VitStatusPillSize.sm,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: child,
    );
  }
}

String _formatInt(int value) => formatTradeInt(value);

String _formatUsd(double value) => '\$${value.abs().toStringAsFixed(2)}';

String _formatSignedUsd(double value) {
  final sign = value < 0 ? '\$-' : '\$';
  return '$sign${value.abs().toStringAsFixed(2)}';
}
