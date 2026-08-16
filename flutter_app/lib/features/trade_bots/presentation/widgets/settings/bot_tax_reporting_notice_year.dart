part of '../../phone/pages/settings/bot_tax_reporting_page.dart';

class _TaxNotice extends StatelessWidget {
  const _TaxNotice();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: _taxAmber.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _taxAmber,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotNarrowIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông báo báo cáo thuế',
                  style: AppTextStyles.caption.copyWith(
                    color: _taxAmber,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Giao dịch tiền mã hoá phải chịu thuế ở hầu hết các quốc '
                  'gia. Giao dịch của Bot giao dịch được tính là các giao '
                  'dịch riêng lẻ. Chúng tôi cung cấp báo cáo để tiện theo '
                  'dõi, nhưng bạn nên tham khảo chuyên gia thuế để khai báo '
                  'chính xác.',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _YearPicker extends StatelessWidget {
  const _YearPicker({
    required this.years,
    required this.selectedYear,
    required this.onChanged,
  });

  final List<String> years;
  final String selectedYear;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < years.length; i++) ...[
          Expanded(
            child: VitCtaButton(
              key: BotTaxReportingPage.yearKey(years[i]),
              onPressed: () => onChanged(years[i]),
              density: VitDensity.tool,
              variant: selectedYear == years[i]
                  ? VitCtaButtonVariant.primary
                  : VitCtaButtonVariant.ghost,
              padding: AppSpacing.zeroInsets,
              child: Text(
                years[i],
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
          if (i != years.length - 1)
            const SizedBox(width: TradeSpacingTokens.tradeBotRowGap),
        ],
      ],
    );
  }
}
