part of '../../phone/pages/margin/margin_trading_page.dart';

class _MarginSimpleForm extends StatefulWidget {
  const _MarginSimpleForm({
    required this.snapshot,
    required this.side,
    required this.leverage,
    required this.amount,
    required this.onSideChanged,
    required this.onMaxAmount,
    required this.onAmountChanged,
  });

  final TradeMarginTradingSnapshot snapshot;
  final String side;
  final int leverage;
  final String amount;
  final ValueChanged<String> onSideChanged;
  final VoidCallback onMaxAmount;
  final ValueChanged<String> onAmountChanged;

  @override
  State<_MarginSimpleForm> createState() => _MarginSimpleFormState();
}

class _MarginSimpleFormState extends State<_MarginSimpleForm> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.amount == '0.00' ? '' : widget.amount,
    );
  }

  @override
  void didUpdateWidget(covariant _MarginSimpleForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount &&
        widget.amount != _amountController.text) {
      _amountController.text = widget.amount == '0.00' ? '' : widget.amount;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _openConfirm(BuildContext context) async {
    final amount = widget.amount;
    if (amount == '0.00' || amount.isEmpty) return;
    final sideLabel = widget.side == 'long' ? 'Giá tăng' : 'Giá giảm';
    final confirmed = await showVitTradeConfirmSheet(
      context: context,
      title: 'Xem lại lệnh ký quỹ',
      lines: [
        VitTradeConfirmLine(label: 'Cặp', value: widget.snapshot.pair.symbol),
        VitTradeConfirmLine(label: 'Hướng', value: sideLabel),
        const VitTradeConfirmLine(label: 'Chế độ', value: 'Cross'),
        VitTradeConfirmLine(label: 'Đòn bẩy', value: '${widget.leverage}x'),
        VitTradeConfirmLine(label: 'Số lượng', value: amount),
        VitTradeConfirmLine(
          label: 'Giá thanh lý ước tính',
          value: widget.snapshot.orderDraft.liquidationPriceLabel,
        ),
      ],
    );
    if (confirmed && context.mounted) {
      await showVitNoticeSheet(
        context: context,
        title: 'Đã gửi lệnh',
        message: 'Đã gửi lệnh ký quỹ (mock)',
        variant: VitBannerVariant.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = widget.amount != '0.00' && widget.amount.isNotEmpty;
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Bước 1 · Chọn hướng',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitSegmentedChoice<String>(
            selected: widget.side,
            onChanged: widget.onSideChanged,
            options: [
              VitSegmentedChoiceOption(
                key: MarginTradingPage.sideKey('long'),
                value: 'long',
                label: 'Giá tăng',
                accentColor: AppColors.buy,
                leading: const Icon(Icons.trending_up_rounded),
              ),
              VitSegmentedChoiceOption(
                key: MarginTradingPage.sideKey('short'),
                value: 'short',
                label: 'Giá giảm',
                accentColor: AppColors.sell,
                leading: const Icon(Icons.trending_down_rounded),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Đòn bẩy ${widget.leverage}x · Chỉnh trong Chế độ Pro',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Bước 2 · Số lượng',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: VitInput(
                  controller: _amountController,
                  label: 'Bạn muốn giao dịch bao nhiêu?',
                  onChanged: widget.onAmountChanged,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                key: MarginTradingPage.maxAmountKey,
                label: 'Tối đa',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
                onTap: widget.onMaxAmount,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _OrderSummary(
            available: widget.snapshot.account.availableMargin,
            liquidationPrice: widget.snapshot.orderDraft.liquidationPriceLabel,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: MarginTradingPage.submitKey,
            density: VitDensity.tool,
            onPressed: canSubmit ? () => _openConfirm(context) : null,
            variant: widget.side == 'long'
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger,
            child: Text(
              canSubmit ? 'Xem lại & xác nhận' : 'Nhập số lượng để tiếp tục',
            ),
          ),
        ],
      ),
    );
  }
}
