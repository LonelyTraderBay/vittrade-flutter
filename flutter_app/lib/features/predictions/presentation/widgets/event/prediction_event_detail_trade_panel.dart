part of '../../phone/pages/event/prediction_event_detail_page.dart';

class _TradeSection extends StatelessWidget {
  const _TradeSection({
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
    final outcome = event.outcomes.firstWhere(
      (item) => item.label == selectedOutcome,
      orElse: () => event.outcomes.first,
    );
    final price = outcome.chance / 100;
    return VitPageSection(
      label: 'Trade',
      accentColor: _predictionPrimary,
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
                    label: 'Buy',
                    accentColor: AppColors.buy,
                  ),
                  VitSegmentedChoiceOption(
                    value: false,
                    label: 'Sell',
                    accentColor: AppColors.sell,
                  ),
                ],
              ),
              if (event.outcomes.length > 2) ...[
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  'Outcome',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final option in event.outcomes)
                        Padding(
                          padding: PredictionsSpacingTokens
                              .predictionDetailTradeOutcomeChipPadding,
                          child: VitChoicePill(
                            label: option.label,
                            selected: option.label == selectedOutcome,
                            onTap: () => onOutcomeChanged(option.label),
                            accentColor: option.tone.resolve(),
                            padding: PredictionsSpacingTokens
                                .predictionDetailToggleChipPadding,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                'Order Type',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              VitSegmentedChoice<bool>(
                selected: isMarket,
                onChanged: onOrderTypeChanged,
                options: const [
                  VitSegmentedChoiceOption(
                    value: true,
                    label: 'Market',
                    accentColor: _predictionPrimary,
                  ),
                  VitSegmentedChoiceOption(
                    value: false,
                    label: 'Limit',
                    accentColor: _predictionPrimary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                isMarket
                    ? 'Execute at current best available price'
                    : 'Set your desired entry price',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Text(
                'Amount',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              _TradeAmountInput(amount: amount, onChanged: onAmountChanged),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              VitPresetChipRow<String>(
                selectedValue: amount,
                onTap: onAmountChanged,
                accentColor: _predictionPrimary,
                height: VitDensity.compact.controlHeight,
                padding: AppSpacing.zeroInsets,
                gap: PredictionsSpacingTokens.predictionDetailTradePresetGap,
                items: const [
                  VitPresetChipItem(value: '10', label: r'$10'),
                  VitPresetChipItem(value: '25', label: r'$25'),
                  VitPresetChipItem(value: '50', label: r'$50'),
                  VitPresetChipItem(value: '100', label: r'$100'),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              PredictionOrderPreviewCard(preview: preview),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Đây không phải lời khuyên đầu tư. Xác suất không phải sự chắc chắn.',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              if (errorMessage != null) ...[
                VitBanner(
                  variant: VitBannerVariant.error,
                  title: 'Gửi lệnh thất bại',
                  message: errorMessage!,
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
              VitCtaButton(
                density: VitDensity.compact,
                variant: isBuy
                    ? VitCtaButtonVariant.success
                    : VitCtaButtonVariant.danger,
                onPressed: preview.canSubmit && !submitting ? onSubmit : null,
                loading: submitting,
                child: Text(
                  submitting
                      ? 'Đang gửi lệnh…'
                      : '${isBuy ? 'Buy' : 'Sell'} $selectedOutcome @ '
                            '${_formatPrice(price)}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TradeAmountInput extends StatefulWidget {
  const _TradeAmountInput({required this.amount, required this.onChanged});

  final String amount;
  final ValueChanged<String> onChanged;

  @override
  State<_TradeAmountInput> createState() => _TradeAmountInputState();
}

class _TradeAmountInputState extends State<_TradeAmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.amount);
  }

  @override
  void didUpdateWidget(covariant _TradeAmountInput oldWidget) {
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
      suffix: const _TinyBadge(
        label: 'USDT',
        color: AppColors.text2,
        background: AppColors.surface3,
      ),
    );
  }
}
