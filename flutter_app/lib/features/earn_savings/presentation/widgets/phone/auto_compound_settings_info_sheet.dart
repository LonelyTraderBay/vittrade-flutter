part of '../../phone/pages/savings/auto_compound_settings_page.dart';

class _InfoSheet extends StatelessWidget {
  const _InfoSheet({required this.snapshot});

  final AutoCompoundSettingsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: AutoCompoundSettingsPage.infoSheetKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Lãi kép là gì?', style: AppTextStyles.sectionTitle),
            ),
            VitIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Đóng',
              onPressed: () => Navigator.of(context).pop(),
              variant: VitIconButtonVariant.transparent,
              size: VitIconButtonSize.md,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Column(
            children: [
              const Icon(
                Icons.autorenew_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const Text('Auto-Compound', style: AppTextStyles.baseMedium),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Lãi kép tự động cộng phần lãi kiếm được vào số gốc, giúp bạn kiếm lãi trên cả lãi theo thời gian.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final item in snapshot.infoItems) ...[
          _InfoItem(item: item),
          if (item != snapshot.infoItems.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
        const SizedBox(height: AppSpacing.rowGap),
        _NoteCard(text: snapshot.note),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.item});

  final AutoCompoundInfoDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(item.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: color.withValues(alpha: 0.12),
          borderRadius: AppRadii.mdRadius,
          child: SizedBox(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            child: Icon(
              Icons.check_rounded,
              color: color,
              size: AppSpacing.iconSm,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                item.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
