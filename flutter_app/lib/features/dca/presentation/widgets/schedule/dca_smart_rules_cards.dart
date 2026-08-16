part of '../../phone/pages/schedule/dca_smart_rules_page.dart';

class _RuleCard extends StatelessWidget {
  const _RuleCard({super.key, required this.rule, required this.onDelete});

  final DcaSmartRule rule;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _typeIcon(rule.type),
                color: AppColors.text3,
                size: DcaSpacingTokens.dcaSmartInlineIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          rule.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _StatusBadge(status: rule.status),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardInnerGap,
                    ),
                    _TypeBadge(type: rule.type),
                  ],
                ),
              ),
              DcaDeleteButton(onPressed: onDelete),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _RuleText(label: 'Condition', value: rule.condition),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _RuleText(label: 'Action', value: rule.action),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Triggered',
                  value: '${rule.triggeredCount} times',
                ),
              ),
              if (rule.lastTriggeredLabel != null)
                Expanded(
                  child: _StatValue(
                    label: 'Last Trigger',
                    value: rule.lastTriggeredLabel!,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemplateGroup extends StatelessWidget {
  const _TemplateGroup({
    required this.category,
    required this.templates,
    required this.onUse,
  });

  final String category;
  final List<DcaRuleTemplate> templates;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '$category Rules',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final template in templates) ...[
          _TemplateCard(template: template, onUse: onUse),
          if (template != templates.last)
            const SizedBox(height: AppSpacing.rowGap),
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.onUse});

  final DcaRuleTemplate template;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.name,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            template.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface2,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            child: Padding(
              padding: DcaSpacingTokens.dcaPaddingX3,
              child: Column(
                children: [
                  _CodeRow(label: 'Condition', value: template.condition),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  _CodeRow(
                    label: 'Action',
                    value: template.action,
                    color: AppColors.buy,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              const Icon(
                Icons.show_chart_rounded,
                color: AppColors.text3,
                size: DcaSpacingTokens.dcaSmartButtonIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '${template.popularityPercent}% users',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              SizedBox(
                height: DcaSpacingTokens.dcaSmartButtonHeight,
                child: VitCtaButton(
                  onPressed: onUse,
                  fullWidth: false,
                  height: DcaSpacingTokens.dcaSmartButtonHeight,
                  padding: DcaSpacingTokens.dcaHorizontalPaddingX3,
                  leading: const Icon(
                    Icons.copy_rounded,
                    size: DcaSpacingTokens.dcaSmartButtonIcon,
                  ),
                  child: const Text('Use'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.entry});

  final DcaRuleHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          entry.ruleName,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _ResultBadge(result: entry.result),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.text3,
                          size: DcaSpacingTokens.dcaSmartTinyIcon,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          entry.triggeredAtLabel,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface2,
              shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
            ),
            child: Padding(
              padding: DcaSpacingTokens.dcaPaddingX3,
              child: Column(
                children: [
                  _CodeRow(label: 'Condition Met', value: entry.condition),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  _CodeRow(
                    label: 'Action Taken',
                    value: entry.action,
                    color: AppColors.buy,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
