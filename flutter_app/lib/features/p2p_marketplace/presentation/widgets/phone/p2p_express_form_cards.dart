part of '../../phone/pages/hub/p2p_express_page.dart';

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.controller,
    required this.tradeType,
    required this.amount,
    required this.bestAd,
    required this.cryptoAmount,
    required this.quickAmounts,
    required this.onChanged,
    required this.onQuickAmount,
  });

  final TextEditingController controller;
  final P2PTradeType tradeType;
  final int amount;
  final P2PAdDraft? bestAd;
  final double cryptoAmount;
  final List<int> quickAmounts;
  final VoidCallback onChanged;
  final ValueChanged<int> onQuickAmount;

  @override
  Widget build(BuildContext context) {
    final color = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    return VitCard(
      padding: P2PSpacingTokens.p2pExpressCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số tiền (VND)',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              if (amount > 0 && bestAd != null)
                Text(
                  '≈ ${_formatAmount(cryptoAmount)} ${bestAd!.asset}',
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Material(
            color: AppColors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(
                color: amount > 0 && bestAd == null
                    ? AppColors.sell20
                    : amount > 0
                    ? color.withValues(alpha: .45)
                    : AppColors.borderSolid,
                width: P2PSpacingTokens.p2pExpressAmountBorderWidth,
              ),
            ),
            child: SizedBox(
              height: _p2pExpressAmountHeight,
              child: Row(
                children: [
                  const SizedBox(width: AppSpacing.x4),
                  Text(
                    '₫',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: VitInput(
                      fieldKey: P2PExpressPage.amountFieldKey,
                      controller: controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => onChanged(),
                      semanticLabel: 'Số tiền P2P Express VND',
                      hintText: 'Nhập số tiền...',
                      textStyle: AppTextStyles.sectionTitle.copyWith(
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Text(
                    'VND',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitPresetChipRow<int>(
            items: [
              for (final quickAmount in quickAmounts)
                VitPresetChipItem<int>(
                  key: P2PExpressPage.quickAmountKey(quickAmount),
                  value: quickAmount,
                  label: _formatVnd(quickAmount),
                  semanticLabel: 'Số tiền nhanh ${_formatVnd(quickAmount)} VND',
                ),
            ],
            onTap: onQuickAmount,
            selectedValue: amount > 0 ? amount : null,
            accentColor: color,
            height: AppSpacing.buttonCompact,
            padding: P2PSpacingTokens.p2pExpressChoiceChipPadding,
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.selectedPayment,
    required this.paymentMethods,
    required this.onChanged,
  });

  final String selectedPayment;
  final List<P2PPaymentMethodDraft> paymentMethods;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pExpressCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.credit_card_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Thanh toán qua',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final method in paymentMethods.take(3))
                _PaymentChip(
                  method: method,
                  selected: selectedPayment == method.bankName,
                  onPressed: () => onChanged(method.bankName),
                ),
              if (paymentMethods.length > 3)
                _SmallTextChip('+${paymentMethods.length - 3} phương thức'),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  'Phương thức đã xác minh của bạn',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestOfferCard extends StatelessWidget {
  const _BestOfferCard({
    required this.tradeType,
    required this.ad,
    required this.topOfferCount,
    required this.marketPrice,
    required this.cryptoAmount,
    required this.onMerchant,
    required this.onMarketplace,
  });

  final P2PTradeType tradeType;
  final P2PAdDraft ad;
  final int topOfferCount;
  final int marketPrice;
  final double cryptoAmount;
  final VoidCallback onMerchant;
  final VoidCallback onMarketplace;

  @override
  Widget build(BuildContext context) {
    final color = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    final priceDiff = ((ad.price - marketPrice) / marketPrice) * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          borderColor: color.withValues(alpha: .35),
          padding: P2PSpacingTokens.p2pExpressCompactCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox.square(
                    dimension: _p2pExpressIconBox,
                    child: Material(
                      color: color,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: const Icon(
                        Icons.bolt_outlined,
                        color: AppColors.onAccent,
                        size: AppSpacing.iconSm,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      'Offer tốt nhất được tìm thấy',
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  VitStatusPill(
                    label: 'Auto-Match',
                    status: tradeType == P2PTradeType.buy
                        ? VitStatusPillStatus.success
                        : VitStatusPillStatus.error,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _MerchantOfferRow(ad: ad, onMerchant: onMerchant),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  Expanded(
                    child: _OfferMetric(
                      label: 'Giá/${ad.asset}',
                      value: _formatVnd(ad.price),
                      caption:
                          '${priceDiff >= 0 ? '+' : ''}${priceDiff.toStringAsFixed(2)}% vs thị trường',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _OfferMetric(
                      label: tradeType == P2PTradeType.buy
                          ? 'Bạn sẽ nhận'
                          : 'Bạn sẽ bán',
                      value: _formatAmount(cryptoAmount),
                      caption: ad.asset,
                      valueColor: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x2,
                children: [
                  const _SmallTextChip('Chấp nhận:'),
                  for (final method in ad.paymentMethods)
                    _SmallTextChip(method),
                ],
              ),
            ],
          ),
        ),
        if (topOfferCount > 1) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            onTap: onMarketplace,
            padding: P2PSpacingTokens.p2pExpressTightCardPadding,
            child: Row(
              children: [
                const Icon(
                  Icons.repeat_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    '${topOfferCount - 1} offer khác khả dụng',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
                Text(
                  'Xem marketplace',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.x1),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.primary,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _EscrowCard extends StatelessWidget {
  const _EscrowCard({required this.title, required this.note});

  final String title;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.buy10,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: AppColors.buy20),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pExpressEscrowPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.lock_outline,
              color: AppColors.buy,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    note,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.steps});

  final List<P2PExpressStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pExpressCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Express hoạt động thế nào?',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final step in steps)
            Padding(
              padding: P2PSpacingTokens.p2pExpressHowStepPadding,
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: _p2pExpressIconBox,
                    child: Material(
                      color: AppColors.primary12,
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: Icon(
                        _stepIcon(step.iconKey),
                        color: AppColors.primary,
                        size: AppSpacing.iconSm,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      step.title,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _NoOfferCard extends StatelessWidget {
  const _NoOfferCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.sell20,
      padding: P2PSpacingTokens.p2pExpressTightCardPadding,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_outlined,
            color: AppColors.sell,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Không tìm thấy offer phù hợp. Thử thay đổi số tiền hoặc loại coin.',
              style: AppTextStyles.micro.copyWith(color: AppColors.sell),
            ),
          ),
        ],
      ),
    );
  }
}
