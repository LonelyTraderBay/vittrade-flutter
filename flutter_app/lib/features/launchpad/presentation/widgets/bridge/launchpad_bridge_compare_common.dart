part of '../../phone/pages/bridge/launchpad_bridge_compare_page.dart';

class _ProviderBadge extends StatelessWidget {
  const _ProviderBadge({
    required this.label,
    required this.accent,
    required this.size,
  });

  final String label;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: accent.withValues(alpha: .16),
          shape: CircleBorder(
            side: BorderSide(color: accent.withValues(alpha: .28)),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: LaunchpadSpacingTokens.launchpadVerticalPaddingX2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: AppSpacing.dividerHairline,
          color: AppColors.divider,
        ),
      ],
    );
  }
}

IconData _sortIcon(String iconKey) {
  return switch (iconKey) {
    'trending' => Icons.trending_up_rounded,
    'fuel' => Icons.local_gas_station_outlined,
    'clock' => Icons.schedule_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.star_border_rounded,
  };
}

String _chainLabel(String chain) {
  if (chain == 'Ethereum') return 'ET';
  if (chain == 'Polygon') return 'PG';
  return chain.length > 2 ? chain.substring(0, 2).toUpperCase() : chain;
}

String _formatNumber(num value) {
  final fixed = value is int || value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1 && parts.last.isNotEmpty) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}

String _trimDouble(double value) {
  if (value == value.roundToDouble()) return value.toInt().toString();
  return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
}
