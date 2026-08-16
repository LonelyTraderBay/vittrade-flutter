part of '../../phone/pages/margin/margin_trading_page.dart';

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({
    required this.available,
    required this.liquidationPrice,
  });

  final double available;
  final String liquidationPrice;

  @override
  Widget build(BuildContext context) {
    return VitFinancialSafetySummary(
      title: 'Xem trước lệnh ký quỹ',
      contractId: 'SC-085 Margin preview',
      density: VitDensity.tool,
      footer:
          'Xem lại ký quỹ, giá thanh lý, phí, giới hạn đòn bẩy và chiều lệnh trước khi mở vị thế.',
      items: [
        VitFinancialSafetyItem(
          label: 'Ký quỹ khả dụng',
          value: _formatMoney(available),
          leading: const Icon(Icons.account_balance_wallet_outlined),
          valueColor: AppColors.onAccent,
        ),
        VitFinancialSafetyItem(
          label: 'Ước tính giá thanh lý',
          value: liquidationPrice,
          leading: const Icon(Icons.warning_amber_rounded),
          valueColor: _marginRed,
        ),
        const VitFinancialSafetyItem(
          label: 'Phí giao dịch',
          value: '0.05% (ước tính)',
          leading: Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.text2,
        ),
        const VitFinancialSafetyItem(
          label: 'Kiểm tra rủi ro',
          value: 'Xác nhận đòn bẩy trước khi gửi lệnh',
          leading: Icon(Icons.verified_user_outlined),
          valueColor: _marginAmber,
        ),
      ],
    );
  }
}
