part of '../../phone/pages/savings/auto_compound_settings_page.dart';

class _CalculatorPreview extends StatelessWidget {
  const _CalculatorPreview();

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Mô phỏng hiệu quả',
      accentColor: AppColors.accent,
      children: [
        VitCard(
          key: AutoCompoundSettingsPage.calculatorKey,
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calculate_outlined,
                    color: AppColors.accent,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Ví dụ: 1,000 USDT × 4.5% APY',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const Row(
                children: [
                  Expanded(
                    child: _CalculatorStat(
                      label: 'Không compound',
                      value: '\$45.00',
                      caption: 'sau 1 năm',
                      color: AppColors.text1,
                    ),
                  ),
                  SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _CalculatorStat(
                      label: 'Compound hàng ngày',
                      value: '\$46.03',
                      caption: '+\$1.03 thêm',
                      color: AppColors.buy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalculatorStat extends StatelessWidget {
  const _CalculatorStat({
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
  });

  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Text(label, textAlign: TextAlign.center, style: AppTextStyles.micro),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}
