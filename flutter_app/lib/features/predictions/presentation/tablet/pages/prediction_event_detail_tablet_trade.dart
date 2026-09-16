part of 'prediction_event_detail_tablet_page.dart';

// ---------------------------------------------------------------------------
// Khối đặt lệnh — cùng máy trạng thái ERR-36 với phone; khác phone ở bước
// xác nhận: CTA mở bottom sheet tổng hợp phí/rủi ro (Financial Safety)
// trước khi gọi submit.
// ---------------------------------------------------------------------------

class _Sc211TradeSection extends StatelessWidget {
  const _Sc211TradeSection({
    required this.event,
    required this.preview,
    required this.selectedOutcome,
    required this.isBuy,
    required this.isMarket,
    required this.amount,
    required this.submitting,
    required this.errorMessage,
    required this.onSubmit,
    required this.onSideChanged,
    required this.onOrderTypeChanged,
    required this.onAmountChanged,
    required this.onOutcomeChanged,
  });

  final PredictionEventDraft event;
  final PredictionOrderPreview preview;
  final String selectedOutcome;
  final bool isBuy;
  final bool isMarket;
  final String amount;

  /// Máy trạng thái ERR-36 đang confirming/submitting — CTA khóa + spinner.
  final bool submitting;

  /// Lỗi từ lượt submit trước (error/offline/validation) — banner dưới CTA.
  final String? errorMessage;
  final VoidCallback onSubmit;
  final ValueChanged<bool> onSideChanged;
  final ValueChanged<bool> onOrderTypeChanged;
  final ValueChanged<String> onAmountChanged;
  final ValueChanged<String> onOutcomeChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Đặt lệnh',
      innerGap: TabletSpacingTokens.x4,
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VitSegmentedChoice<bool>(
                selected: isBuy,
                onChanged: onSideChanged,
                options: const [
                  VitSegmentedChoiceOption(
                    value: true,
                    label: 'Mua',
                    accentColor: AppColors.buy,
                  ),
                  VitSegmentedChoiceOption(
                    value: false,
                    label: 'Bán',
                    accentColor: AppColors.sell,
                  ),
                ],
              ),
              if (event.outcomes.length > 2) ...[
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  'Kết quả',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: TabletSpacingTokens.x3),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final option in event.outcomes)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: TabletSpacingTokens.x1,
                          ),
                          child: VitChoicePill(
                            label: option.label,
                            selected: option.label == selectedOutcome,
                            onTap: () => onOutcomeChanged(option.label),
                            accentColor: option.tone.resolve(),
                            padding:
                                TabletSpacingTokens.vitChoicePillCompactPadding,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(
                'Loại lệnh',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              VitSegmentedChoice<bool>(
                selected: isMarket,
                onChanged: onOrderTypeChanged,
                options: const [
                  VitSegmentedChoiceOption(
                    value: true,
                    label: 'Thị trường',
                    accentColor: AppColors.primary,
                  ),
                  VitSegmentedChoiceOption(
                    value: false,
                    label: 'Giới hạn',
                    accentColor: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              Text(
                isMarket
                    ? 'Khớp ngay tại giá tốt hiện có'
                    : 'Tự đặt giá vào mong muốn',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(
                'Số tiền',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              _Sc211TradeAmountInput(
                amount: amount,
                onChanged: onAmountChanged,
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              VitPresetChipRow<String>(
                selectedValue: amount,
                onTap: onAmountChanged,
                accentColor: AppColors.primary,
                height: VitDensity.compact.controlHeight,
                padding: TabletSpacingTokens.zeroInsets,
                gap: TabletSpacingTokens.vitPresetChipRowGap,
                items: const [
                  VitPresetChipItem(value: '10', label: r'$10'),
                  VitPresetChipItem(value: '25', label: r'$25'),
                  VitPresetChipItem(value: '50', label: r'$50'),
                  VitPresetChipItem(value: '100', label: r'$100'),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              PredictionOrderPreviewCard(preview: preview),
              const SizedBox(height: TabletSpacingTokens.x3),
              Text(
                'Đây không phải lời khuyên đầu tư. Xác suất không phải sự chắc chắn.',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              if (errorMessage != null) ...[
                VitBanner(
                  variant: VitBannerVariant.error,
                  title: 'Gửi lệnh thất bại',
                  message: errorMessage!,
                ),
                const SizedBox(height: TabletSpacingTokens.x3),
              ],
              VitCtaButton(
                key: PredictionEventDetailTabletPage.submitKey,
                density: VitDensity.compact,
                variant: isBuy
                    ? VitCtaButtonVariant.success
                    : VitCtaButtonVariant.danger,
                onPressed: preview.canSubmit && !submitting ? onSubmit : null,
                loading: submitting,
                child: Text(
                  submitting ? 'Đang gửi lệnh…' : 'Xem trước & xác nhận',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Sc211TradeAmountInput extends StatefulWidget {
  const _Sc211TradeAmountInput({required this.amount, required this.onChanged});

  final String amount;
  final ValueChanged<String> onChanged;

  @override
  State<_Sc211TradeAmountInput> createState() => _Sc211TradeAmountInputState();
}

class _Sc211TradeAmountInputState extends State<_Sc211TradeAmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amount);
  }

  @override
  void didUpdateWidget(covariant _Sc211TradeAmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amount != widget.amount &&
        _controller.text != widget.amount) {
      _controller.value = TextEditingValue(
        text: widget.amount,
        selection: TextSelection.collapsed(offset: widget.amount.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VitInput(
      controller: _controller,
      keyboardType: TextInputType.number,
      onChanged: widget.onChanged,
      semanticLabel: 'Số tiền đặt lệnh dự đoán',
      hintText: '0.00',
      textStyle: AppTextStyles.body.copyWith(
        fontFeatures: AppTextStyles.tabularFigures,
      ),
      suffix: const _Sc211TinyBadge(
        label: 'USDT',
        color: AppColors.text2,
        background: AppColors.surface3,
      ),
    );
  }
}
