part of '../../phone/pages/margin/margin_trading_page.dart';

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: padding,
      density: padding == null ? VitDensity.tool : null,
      child: child,
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final status = color == _marginGreen
        ? VitStatusPillStatus.success
        : color == _marginRed
        ? VitStatusPillStatus.error
        : color == _marginAmber
        ? VitStatusPillStatus.warning
        : VitStatusPillStatus.info;
    return VitStatusPill(
      label: label,
      status: status,
      size: VitStatusPillSize.sm,
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText(this.label, this.value, this.color);

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

String _formatMoney(double value) => formatTradeUsd(value);

String _signedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatMoney(value.abs())}';
}

String _formatPrice(double value) => formatTradePrice(value);
