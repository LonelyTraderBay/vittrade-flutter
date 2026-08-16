part of '../../phone/pages/hub/p2p_home_page.dart';

class _HubStat extends StatelessWidget {
  const _HubStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.color = AppColors.warn});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

class _PaymentPill extends StatelessWidget {
  const _PaymentPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
      ),
    );
  }
}

String _formatVnd(num value) => formatP2PVnd(value);

String _compactVnd(int value) {
  if (value >= 1000000000) {
    return '₫${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) return '₫${(value / 1000000).toStringAsFixed(2)}M';
  return '₫${_formatVnd(value)}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return _formatVnd(value.round());
  }
  return value.toStringAsFixed(4);
}
