part of '../../phone/pages/savings/savings_goal_page.dart';

class _CreateGoalSheet extends StatelessWidget {
  const _CreateGoalSheet({
    required this.snapshot,
    required this.selectedTemplateId,
    required this.onTemplate,
  });

  final SavingsGoalsSnapshot snapshot;
  final String selectedTemplateId;
  final ValueChanged<String> onTemplate;

  @override
  Widget build(BuildContext context) {
    final selected = snapshot.templates.firstWhere(
      (template) => template.id == selectedTemplateId,
      orElse: () => snapshot.templates.first,
    );

    return Column(
      key: SavingsGoalPage.createSheetKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Tạo mục tiêu mới',
                style: AppTextStyles.sectionTitle,
              ),
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
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          'Chọn mẫu mục tiêu để thiết lập nhanh số tiền, thời hạn và milestone rewards.',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        for (final template in snapshot.templates) ...[
          _TemplateTile(
            template: template,
            selected: template.id == selected.id,
            onTap: () => onTemplate(template.id),
          ),
          if (template != snapshot.templates.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SheetMetric(label: 'Mẫu đã chọn', value: selected.name),
              _SheetMetric(
                label: 'Mục tiêu gợi ý',
                value: EarnFormatters.usd(selected.suggestedTarget),
              ),
              _SheetMetric(
                label: 'Thời gian',
                value: '${selected.suggestedMonths} tháng',
              ),
              const _SheetMetric(
                label: 'Sản phẩm liên kết',
                value: 'USDT Linh hoạt',
              ),
              const _SheetMetric(
                label: 'Milestone rewards',
                value: '4 mốc',
                color: AppColors.warn,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          variant: VitCtaButtonVariant.success,
          leading: const Icon(Icons.flag_outlined),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tạo mục tiêu'),
        ),
      ],
    );
  }
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  final SavingsGoalTemplateDraft template;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _templateColor(template.iconKey);
    return VitCard(
      key: SavingsGoalPage.templateKey(template.id),
      variant: VitCardVariant.inner,
      borderColor: selected ? color : null,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      onTap: onTap,
      child: Row(
        children: [
          _GoalIcon(iconKey: template.iconKey, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  template.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  template.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                EarnFormatters.usd(template.suggestedTarget),
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                '${template.suggestedMonths} tháng',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
