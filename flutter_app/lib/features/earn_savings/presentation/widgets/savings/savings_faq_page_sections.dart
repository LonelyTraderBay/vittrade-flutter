part of '../../phone/pages/savings/savings_faq_page.dart';

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final SavingsFAQSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.heroSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.placeholder, required this.onChanged});

  final String placeholder;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      fieldKey: SavingsFAQPage.searchFieldKey,
      placeholder: placeholder,
      variant: VitSearchBarVariant.compact,
      onChanged: onChanged,
    );
  }
}

class _CategoryScroller extends StatelessWidget {
  const _CategoryScroller({
    required this.categories,
    required this.activeId,
    required this.counts,
    required this.onChanged,
  });

  final List<SavingsFAQCategoryDraft> categories;
  final String activeId;
  final Map<String, int> counts;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final category in categories) ...[
            VitChoicePill(
              key: SavingsFAQPage.categoryKey(category.id),
              label: '${category.label} ${counts[category.id] ?? 0}',
              selected: category.id == activeId,
              onTap: () => onChanged(category.id),
              fullWidth: false,
              height: AppSpacing.vitPresetChipRowHeight,
            ),
            if (category != categories.last)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _FAQList extends StatelessWidget {
  const _FAQList({
    required this.items,
    required this.expandedIds,
    required this.onToggle,
  });

  final List<SavingsFAQItemDraft> items;
  final Set<String> expandedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsFAQPage.faqListKey,
      children: [
        for (final item in items) ...[
          _FAQCard(
            key: item == items.first ? SavingsFAQPage.firstFaqKey : null,
            item: item,
            expanded: expandedIds.contains(item.id),
            onTap: () => onToggle(item.id),
          ),
          if (item != items.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _FAQCard extends StatelessWidget {
  const _FAQCard({
    super.key,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final SavingsFAQItemDraft item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(item.category);
    return VitCard(
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EarnSpacingTokens.earnPillPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuestionIcon(color: color),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item.question,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      height:
                          EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: EarnSpacingTokens.earnDisclosureDetailsPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.answer,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height:
                          EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  const Divider(
                    color: AppColors.divider,
                    height: AppSpacing.dividerHairline,
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Row(
                    children: [
                      Text(
                        'Hữu ích?',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      const _FeedbackPill(
                        icon: Icons.thumb_up_alt_outlined,
                        label: 'Có',
                        color: AppColors.buy,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      const _FeedbackPill(
                        icon: Icons.thumb_down_alt_outlined,
                        label: 'Không',
                        color: AppColors.sell,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _QuestionIcon extends StatelessWidget {
  const _QuestionIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(
          Icons.help_outline_rounded,
          color: color,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}
