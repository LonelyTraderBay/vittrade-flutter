part of '../../phone/pages/futures/leverage_page.dart';

class _RiskMeter extends StatelessWidget {
  const _RiskMeter({required this.preview, required this.riskColor});

  final TradeFuturesLeveragePreview preview;
  final Color riskColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.zeroInsets.copyWith(
        left: _leverageCardSpace,
        top: _leverageCardSpace,
        right: _leverageCardSpace,
        bottom: _leverageCardSpace,
      ),
      borderColor: riskColor.withValues(alpha: .18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mức rủi ro',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              Text(
                preview.riskLabel,
                style: AppTextStyles.caption.copyWith(
                  color: riskColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _leverageSpace),
          Row(
            children: [
              for (var level = 1; level <= 6; level++) ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.xsRadius,
                    child: SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                      child: ColoredBox(
                        color: level <= preview.riskLevel
                            ? _segmentColor(level)
                            : _chipBackground,
                      ),
                    ),
                  ),
                ),
                if (level != 6) const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _segmentColor(int level) {
    if (level <= 2) return AppColors.buy;
    if (level <= 4) return AppColors.caution;
    return AppColors.sell;
  }
}
