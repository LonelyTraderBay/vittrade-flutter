part of '../../phone/pages/convert/convert_page.dart';

class _ConvertRiskReviewPanel extends StatelessWidget {
  const _ConvertRiskReviewPanel({
    required this.quote,
    required this.fromSymbol,
    required this.toSymbol,
    required this.slippage,
  });

  final TradeConvertQuote quote;
  final String fromSymbol;
  final String toSymbol;
  final double slippage;

  @override
  Widget build(BuildContext context) {
    return VitFinancialSafetySummary(
      title: 'Xem lại báo giá',
      contractId: 'SC-056 Convert preview',
      density: VitDensity.tool,
      footer: quote.canSubmit
          ? 'Xác nhận tỷ giá, phí, giới hạn trượt giá và đường nhận biên lai trước khi gửi.'
          : 'Nhập số lượng để mở xem lại báo giá trước khi gửi.',
      items: [
        VitFinancialSafetyItem(
          label: 'Tỷ giá',
          value: quote.quoteLabel,
          leading: const Icon(Icons.sync_alt_rounded),
        ),
        VitFinancialSafetyItem(
          label: 'Dự kiến nhận',
          value:
              '${formatConvertQuoteAmount(quote.toAmount, toSymbol)} $toSymbol',
          leading: const Icon(Icons.account_balance_wallet_outlined),
          valueColor: quote.canSubmit ? AppColors.buy : AppColors.text3,
        ),
        VitFinancialSafetyItem(
          label: 'Phí',
          value: '\$${quote.feeUsd.toStringAsFixed(quote.feeUsd < 1 ? 4 : 2)}',
          leading: const Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.text2,
        ),
        VitFinancialSafetyItem(
          label: 'Giới hạn trượt',
          value: '${slippage.toStringAsFixed(1)}%',
          leading: const Icon(Icons.speed_outlined),
          valueColor: AppColors.text2,
        ),
        VitFinancialSafetyItem(
          label: 'Kiểm tra rủi ro',
          value: quote.canSubmit ? 'Sẵn sàng gửi' : 'Cần nhập số lượng',
          leading: const Icon(Icons.verified_user_outlined),
          valueColor: quote.canSubmit ? AppColors.warn : AppColors.text3,
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.receipt,
    required this.onPressed,
  });

  final bool enabled;
  final TradeConvertReceipt? receipt;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = receipt == null
        ? (enabled ? 'Chuyển đổi ngay' : 'Nhập số lượng')
        : 'Đã gửi ${receipt!.convertId}';
    return VitCtaButton(
      key: ConvertPage.submitKey,
      onPressed: enabled ? onPressed : null,
      variant: receipt == null
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.success,
      density: VitDensity.tool,
      height: TradeSpacingTokens.convertSubmitHeight,
      leading: Icon(
        receipt == null
            ? Icons.swap_vert_rounded
            : Icons.check_circle_outline_rounded,
      ),
      child: Text(label),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.records});

  final List<TradeConvertHistoryRecord> records;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < records.length; i++)
            ConvertHistoryRow(
              record: records[i],
              showDivider: i != records.length - 1,
            ),
        ],
      ),
    );
  }
}
