part of '../../phone/pages/orders/p2p_order_rate_page.dart';

class _MerchantSummary extends StatelessWidget {
  const _MerchantSummary({required this.order});

  final P2POrderRateDraft order;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pOrderRateCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VitAssetAvatar(
            label: order.merchant,
            accentColor: AppColors.primary,
            size: AppSpacing.inputHeight,
            radius: AppRadii.avatarRadius,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.merchant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  [
                    order.typeLabel,
                    _formatAmount(order.amount),
                    order.asset,
                    '-',
                    _formatVnd(order.totalVnd),
                  ].join(' '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({required this.rating, required this.onRating});

  final int rating;
  final ValueChanged<int> onRating;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pOrderRateCardPadding,
      child: Column(
        children: [
          Text(
            'Bạn đánh giá merchant này thế nào?',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var value = 1; value <= 5; value++)
                _StarButton(
                  rating: value,
                  selected: value <= rating,
                  onPressed: () => onRating(value),
                ),
            ],
          ),
          if (rating > 0) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              _ratingLabel(rating),
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StarButton extends StatelessWidget {
  const _StarButton({
    required this.rating,
    required this.selected,
    required this.onPressed,
  });

  final int rating;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: P2POrderRatePage.starKey(rating),
      label: '',
      selected: selected,
      onTap: onPressed,
      height: AppSpacing.buttonCompact + AppSpacing.x3,
      padding: P2PSpacingTokens.p2pOrderRateStarChipPadding,
      accentColor: AppColors.warn,
      leading: Icon(selected ? Icons.star_rounded : Icons.star_border_rounded),
      semanticLabel: '$rating ngôi sao',
    );
  }
}

class _QuickTags extends StatelessWidget {
  const _QuickTags({
    required this.tags,
    required this.selectedTags,
    required this.onToggle,
  });

  final List<P2POrderRateTagDraft> tags;
  final Set<String> selectedTags;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhận xét nhanh',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final tag in tags) ...[
                _TagChip(
                  tag: tag,
                  selected: selectedTags.contains(tag.label),
                  onPressed: () => onToggle(tag.label),
                ),
                const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
    required this.selected,
    required this.onPressed,
  });

  final P2POrderRateTagDraft tag;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: P2POrderRatePage.tagKey(tag.label),
      label: tag.label,
      selected: selected,
      onTap: onPressed,
      height: AppSpacing.buttonCompact,
      padding: P2PSpacingTokens.p2pOrderRateTagChipPadding,
      accentColor: AppColors.warn,
      leading: Icon(_tagIcon(tag.iconKey)),
    );
  }
}

class _ReviewBox extends StatelessWidget {
  const _ReviewBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nhận xét chi tiết (tùy chọn)',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        VitInput(
          fieldKey: P2POrderRatePage.reviewKey,
          controller: controller,
          semanticLabel: 'Nhận xét đơn hàng P2P',
          hintText: 'Chia sẻ trải nghiệm giao dịch...',
          textStyle: AppTextStyles.caption.copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.enabled,
    required this.loading,
    required this.onSkip,
    required this.onSubmit,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback onSkip;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2POrderRatePage.skipKey,
            onPressed: onSkip,
            variant: VitCtaButtonVariant.secondary,
            child: const Text('Bỏ qua'),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: VitCtaButton(
            key: P2POrderRatePage.submitKey,
            onPressed: enabled ? onSubmit : null,
            loading: loading,
            variant: VitCtaButtonVariant.warning,
            leading: const Icon(Icons.send_outlined),
            child: const Text('Gửi đánh giá'),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.title,
    required this.message,
    required this.onBackToP2P,
  });

  final String title;
  final String message;
  final VoidCallback onBackToP2P;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VitCard(
        radius: VitCardRadius.large,
        padding: P2PSpacingTokens.p2pOrderLifecycleSuccessPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Material(
              color: AppColors.buy15,
              borderRadius: AppRadii.cardLargeRadius,
              child: SizedBox(
                width: P2PSpacingTokens.p2pOrderRatingSuccessIconBox,
                height: P2PSpacingTokens.p2pOrderRatingSuccessIconBox,
                child: Center(
                  child: Icon(
                    Icons.check_circle_outline,
                    color: AppColors.buy,
                    size: AppSpacing.iconLg,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            VitCtaButton(
              key: P2POrderRatePage.backToP2PKey,
              onPressed: onBackToP2P,
              variant: VitCtaButtonVariant.success,
              child: const Text('Quay lại P2P'),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _tagIcon(String iconKey) {
  return switch (iconKey) {
    'speed' => Icons.bolt_outlined,
    'positive' => Icons.thumb_up_alt_outlined,
    'trust' => Icons.shield_outlined,
    'price' => Icons.payments_outlined,
    'slow' => Icons.schedule_outlined,
    'improve' => Icons.edit_note_outlined,
    _ => Icons.label_outline,
  };
}

String _ratingLabel(int rating) {
  return switch (rating) {
    5 => 'Xuất sắc!',
    4 => 'Rất tốt',
    3 => 'Tốt',
    2 => 'Tạm được',
    _ => 'Không hài lòng',
  };
}

String _formatAmount(double value) {
  return value.toStringAsFixed(4);
}

String _formatVnd(int value) => formatP2PVnd(value);
