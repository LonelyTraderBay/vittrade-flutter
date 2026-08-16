part of '../../phone/pages/futures/futures_page.dart';

class _MarginInput extends StatelessWidget {
  const _MarginInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: controller,
      fieldKey: FuturesPage.marginFieldKey,
      label: 'Ký quỹ (USDT)',
      semanticLabel: 'Ký quỹ futures bằng USDT',
      hintText: 'Nhập số tiền ký quỹ',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
      ],
      textStyle: AppTextStyles.base.copyWith(
        color: AppColors.text1,
        fontFeatures: AppTextStyles.tabularFigures,
      ),
      suffix: Text(
        'USDT',
        style: AppTextStyles.caption.copyWith(color: AppColors.text3),
      ),
      onChanged: (_) => onChanged(),
    );
  }
}

class _PercentRow extends StatelessWidget {
  const _PercentRow({required this.onPercent});

  final ValueChanged<int> onPercent;

  @override
  Widget build(BuildContext context) {
    return VitPresetChipRow<int>(
      onTap: onPercent,
      gap: AppSpacing.x2,
      height: WalletSpacingTokens.walletTransactionStepLineHeight,
      padding: AppSpacing.zeroInsets,
      tone: VitChoicePillTone.neutral,
      items: [
        for (final pct in const [25, 50, 75, 100])
          VitPresetChipItem(
            key: FuturesPage.pctKey(pct),
            value: pct,
            label: '$pct%',
            semanticLabel: 'Dùng $pct phần trăm ký quỹ',
          ),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.pair, required this.preview});

  final TradePair pair;
  final TradeFuturesPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitFinancialSafetySummary(
      title: 'Xem trước lệnh Futures',
      contractId: 'SC-057 Futures preview',
      density: VitDensity.tool,
      footer:
          'Xem lại đòn bẩy, ký quỹ, giá thanh lý, phí, TP/SL và chiều lệnh trước khi mở vị thế Futures.',
      items: [
        VitFinancialSafetyItem(
          label: 'Giá trị hợp đồng',
          value: formatTradeMoney(preview.positionSize),
          leading: const Icon(Icons.stacked_line_chart_rounded),
        ),
        VitFinancialSafetyItem(
          label: 'Số lượng hợp đồng',
          value: '${preview.contractQty.toStringAsFixed(4)} ${pair.baseAsset}',
          leading: const Icon(Icons.format_list_numbered_rounded),
        ),
        VitFinancialSafetyItem(
          label: 'Ước tính giá thanh lý',
          value: formatTradeMoney(preview.liquidationPrice),
          leading: const Icon(Icons.warning_amber_rounded),
          valueColor: _futuresRed,
        ),
        VitFinancialSafetyItem(
          label: 'Phí mở lệnh',
          value: formatTradeMoney(preview.openFee),
          leading: const Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.primary,
        ),
        const VitFinancialSafetyItem(
          label: 'Kiểm tra rủi ro',
          value: 'Xác nhận trước khi gửi lệnh',
          leading: Icon(Icons.verified_user_outlined),
          valueColor: AppColors.warn,
        ),
      ],
    );
  }
}
