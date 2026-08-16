part of '../../phone/pages/tools/market_screener_page.dart';

class _ScreenerEmptyState extends StatelessWidget {
  const _ScreenerEmptyState({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          const Icon(
            Icons.filter_alt_off_rounded,
            color: AppColors.text3,
            size: _emptyIconSize,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Không tìm thấy kết quả phù hợp',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            onPressed: onReset,
            variant: VitCtaButtonVariant.ghost,
            fullWidth: false,
            density: VitDensity.compact,
            height: VitDensity.compact.controlHeight,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x3,
            ),
            child: const Text('Đặt lại bộ lọc'),
          ),
        ],
      ),
    );
  }
}

String _formatCompactUsd(double value) {
  if (value >= 1000000000000) {
    return '\$${(value / 1000000000000).toStringAsFixed(2)}T';
  }
  if (value >= 1000000000) {
    return '\$${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  return '\$${value.toStringAsFixed(0)}';
}
