part of '../../phone/pages/tools/advanced_tools_demo_page.dart';

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: _ctaVariantFor(colors),
      height: AppSpacing.searchBarCompactHeight,
      density: VitDensity.tool,
      leading: Icon(icon),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.control.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
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
      width: size,
      height: size,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: color.withValues(alpha: .28),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    super.key,
    required this.child,
    this.borderColor = AppColors.cardBorder,
    this.onTap,
  });

  final Widget child;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: AppSpacing.cardPaddingCompact,
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      onTap: onTap,
      child: child,
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: title,
      child: SingleChildScrollView(child: child),
    );
  }
}

Widget _toolsSheetRow({required String label, required String value}) {
  return VitKeyValueRow(
    label: label,
    value: value,
    padding: TradeSpacingTokens.tradeToolSheetRowPadding,
    valueOverflow: TextOverflow.ellipsis,
    valueStyle: AppTextStyles.caption.copyWith(
      fontWeight: AppTextStyles.bold,
      fontFeatures: AppTextStyles.tabularFigures,
    ),
  );
}

VitCtaButtonVariant _ctaVariantFor(List<Color> colors) {
  final first = colors.first;
  if (first == AppColors.buy) return VitCtaButtonVariant.success;
  if (first == AppColors.caution) return VitCtaButtonVariant.warning;
  if (first == AppColors.sell) return VitCtaButtonVariant.danger;
  return VitCtaButtonVariant.primary;
}

String _formatMoney(double value) => formatTradeMoney(value);
