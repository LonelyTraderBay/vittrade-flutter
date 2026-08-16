part of '../../phone/pages/portfolio/dca_performance_compare_page.dart';

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text2,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: DcaSpacingTokens.dcaPerformanceCompareLegendDot,
          height: DcaSpacingTokens.dcaPerformanceCompareLegendDot,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color,
              shape: const CircleBorder(),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(label, style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }
}

// Delegates to the shared formatter in dca_currency_formatters.dart (see
// that file's doc comment — was a byte-for-byte duplicate of the _formatUsd
// in dca_multi_asset_page_part_03.dart).
String _formatUsd(num value) => formatUsd(value);

String _formatSignedPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
