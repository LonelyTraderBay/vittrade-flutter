part of '../../phone/pages/ads/p2p_create_ad_page.dart';

class _TradeTypePicker extends StatelessWidget {
  const _TradeTypePicker({required this.value, required this.onChanged});

  final P2PTradeType value;
  final ValueChanged<P2PTradeType> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<P2PTradeType>(
      selected: value,
      onChanged: onChanged,
      height: _p2pCreateSegmentHeight,
      options: [
        VitSegmentedChoiceOption(
          key: P2PCreateAdPage.adTypeKey(P2PTradeType.buy),
          value: P2PTradeType.buy,
          label: 'Tôi muốn MUA',
          accentColor: AppColors.buy,
        ),
        VitSegmentedChoiceOption(
          key: P2PCreateAdPage.adTypeKey(P2PTradeType.sell),
          value: P2PTradeType.sell,
          label: 'Tôi muốn BÁN',
          accentColor: AppColors.sell,
        ),
      ],
    );
  }
}

class _PriceTypePicker extends StatelessWidget {
  const _PriceTypePicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<String>(
      selected: value,
      onChanged: onChanged,
      height: _p2pCreateSegmentHeight,
      options: [
        VitSegmentedChoiceOption(
          key: P2PCreateAdPage.priceTypeKey('fixed'),
          value: 'fixed',
          label: 'Cố định',
          accentColor: AppColors.primary,
        ),
        VitSegmentedChoiceOption(
          key: P2PCreateAdPage.priceTypeKey('floating'),
          value: 'floating',
          label: 'Thả nổi %',
          accentColor: AppColors.accent,
        ),
      ],
    );
  }
}

class _PublishReadinessPanel extends StatelessWidget {
  const _PublishReadinessPanel({required this.blockers});

  final List<String> blockers;

  @override
  Widget build(BuildContext context) {
    final visibleBlockers = blockers.take(3).join(', ');
    final extraCount = blockers.length - 3;
    final message = extraCount > 0
        ? '$visibleBlockers, +$extraCount'
        : visibleBlockers;

    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: AppColors.warningBorder,
      background: const ColoredBox(color: AppColors.warn10),
      padding: P2PSpacingTokens.p2pMerchantCommerceWarningPadding,
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Can bo sung: $message',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.label,
    required this.values,
    required this.selected,
    required this.keyBuilder,
    required this.onSelected,
  });

  final String label;
  final List<String> values;
  final String selected;
  final Key Function(String value) keyBuilder;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitSectionHeader(
          title: label,
          titleColor: AppColors.text2,
          titleFontWeight: AppTextStyles.normal,
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
        ),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final value in values)
              VitChoicePill(
                key: keyBuilder(value),
                label: value,
                selected: selected == value,
                onTap: () => onSelected(value),
                padding: P2PSpacingTokens.p2pMerchantCommerceWideChipPadding,
              ),
          ],
        ),
      ],
    );
  }
}

class _InputBlock extends StatelessWidget {
  const _InputBlock({required this.label, required this.child, this.hint});

  final String label;
  final Widget child;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pMerchantCommerceSectionLabelPadding,
          child: VitSectionHeader(
            title: label,
            titleColor: AppColors.text2,
            titleFontWeight: AppTextStyles.normal,
          ),
        ),
        child,
        if (hint != null) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            hint!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ],
    );
  }
}
