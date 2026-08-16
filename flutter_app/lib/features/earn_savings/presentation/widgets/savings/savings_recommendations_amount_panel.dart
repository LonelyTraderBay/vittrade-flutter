part of '../../phone/pages/savings/savings_recommendations_page.dart';

class _AmountSimulator extends StatelessWidget {
  const _AmountSimulator({
    required this.controller,
    required this.amountText,
    required this.onAmountChanged,
    required this.onQuickAmount,
  });

  final TextEditingController controller;
  final String amountText;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<int> onQuickAmount;

  @override
  Widget build(BuildContext context) {
    const amounts = [1000, 5000, 10000, 50000];
    final activeAmount = int.tryParse(amountText);
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Mô phỏng với số tiền khác',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitInput(
            fieldKey: SavingsRecommendationsPage.amountFieldKey,
            controller: controller,
            keyboardType: TextInputType.number,
            semanticLabel: 'Số tiền mô phỏng gợi ý tiết kiệm',
            onChanged: onAmountChanged,
            textStyle: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitPresetChipRow<int>(
            accentColor: AppModuleAccents.earn,
            selectedValue: activeAmount,
            onTap: onQuickAmount,
            items: [
              for (final amount in amounts)
                VitPresetChipItem(
                  value: amount,
                  label: amount >= 1000 ? '\$${amount ~/ 1000}K' : '\$$amount',
                  key: SavingsRecommendationsPage.amountChipKey(amount),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompareButton extends StatelessWidget {
  const _CompareButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: SavingsRecommendationsPage.compareButtonKey,
      variant: VitCtaButtonVariant.ghost,
      height: AppSpacing.buttonCompact,
      leading: const Icon(Icons.bar_chart_rounded),
      onPressed: onTap,
      child: const Text('So sánh tất cả chiến lược'),
    );
  }
}
