part of '../../phone/pages/studio/arena_smart_rule_builder_page.dart';

class _ConditionBuilder extends StatelessWidget {
  const _ConditionBuilder({
    required this.subject,
    required this.action,
    required this.metric,
    required this.winType,
    required this.deadlineContext,
    required this.customWinController,
    required this.onSubject,
    required this.onAction,
    required this.onMetric,
    required this.onWinType,
    required this.onDeadlineContext,
    required this.onCustomWinChanged,
  });

  final String subject;
  final String action;
  final String metric;
  final String winType;
  final String deadlineContext;
  final TextEditingController customWinController;
  final VoidCallback onSubject;
  final VoidCallback onAction;
  final VoidCallback onMetric;
  final VoidCallback onWinType;
  final VoidCallback onDeadlineContext;
  final ValueChanged<String> onCustomWinChanged;

  @override
  Widget build(BuildContext context) {
    final preview = [
      if (subject.isNotEmpty) subject,
      if (action.isNotEmpty) action,
      if (metric.isNotEmpty) metric,
      if (deadlineContext.isNotEmpty) deadlineContext,
      if (winType.isNotEmpty) winType,
    ].join(' ');

    return _FieldBlock(
      label: 'Điều kiện thắng',
      required: true,
      hint: 'Chọn hoặc tự nhập',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            padding: ArenaSpacingTokens.arenaSmartRuleCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.track_changes_rounded,
                      color: AppColors.accent,
                      size: ArenaSpacingTokens.arenaSmartRuleIcon,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        'Builder điều kiện thắng',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x3,
                  children: [
                    _BuilderBox(
                      key: ArenaSmartRuleBuilderPage.subjectKey,
                      label: 'A. Chủ thể',
                      value: subject,
                      onTap: onSubject,
                    ),
                    _BuilderBox(
                      key: ArenaSmartRuleBuilderPage.actionKey,
                      label: 'B. Hành động',
                      value: action,
                      onTap: onAction,
                    ),
                    _BuilderBox(
                      key: ArenaSmartRuleBuilderPage.metricKey,
                      label: 'C. Chỉ số / đối tượng',
                      value: metric,
                      onTap: onMetric,
                    ),
                    _BuilderBox(
                      key: ArenaSmartRuleBuilderPage.winTypeKey,
                      label: 'D. Kiểu thắng',
                      value: winType,
                      onTap: onWinType,
                    ),
                    _BuilderBox(
                      key: ArenaSmartRuleBuilderPage.deadlineContextKey,
                      wide: true,
                      label: 'E. Thời điểm / hạn kết quả',
                      value: deadlineContext,
                      onTap: onDeadlineContext,
                    ),
                  ],
                ),
                if (preview.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  VitCard(
                    variant: VitCardVariant.inner,
                    borderColor: AppColors.accent20,
                    padding: ArenaSpacingTokens.arenaSmartRuleInnerPadding,
                    child: Text(
                      '"$preview."',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: _smartRuleBodyLineRatio,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Hoặc tự nhập điều kiện thắng:',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitInput(
            controller: customWinController,
            semanticLabel: 'Điều kiện thắng tùy chỉnh Arena',
            hintText:
                'VD: Nguoi doan gan nhat voi gia ETH vao 25/03/2026 luc 10:00 se thang.',
            onChanged: onCustomWinChanged,
          ),
        ],
      ),
    );
  }
}

class _BuilderBox extends StatelessWidget {
  const _BuilderBox({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.wide = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide
          ? double.infinity
          : ArenaSpacingTokens.arenaSmartRuleOptionWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: value.isEmpty
                ? AppColors.borderSolid
                : AppColors.accent20,
            padding: ArenaSpacingTokens.arenaSmartRuleCompactSelectorPadding,
            onTap: () {
              unawaited(HapticFeedback.selectionClick());
              onTap();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? 'Chọn...' : value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: value.isEmpty ? AppColors.text3 : AppColors.text1,
                      fontWeight: value.isEmpty
                          ? AppTextStyles.normal
                          : AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: ArenaSpacingTokens.arenaSmartRuleIcon,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Mô tả ngắn',
      hint: 'Tùy chọn',
      child: VitInput(
        controller: controller,
        semanticLabel: 'Mô tả luật Arena',
        hintText: 'Mo ta boi canh neu can. Khong can lap lai luat choi.',
        onChanged: onChanged,
      ),
    );
  }
}

class _QuickSuggestions extends StatelessWidget {
  const _QuickSuggestions({required this.suggestions, required this.onTap});

  final List<String> suggestions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: _arenaAccent,
              size: ArenaSpacingTokens.arenaSmartRuleSmallIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Gợi ý nhanh',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x3,
          children: [
            for (final suggestion in suggestions)
              VitStatusPill(
                label: suggestion,
                status: VitStatusPillStatus.neutral,
                icon: Icons.auto_awesome_outlined,
                size: VitStatusPillSize.sm,
                onTap: () => onTap(suggestion),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimingRulesCard extends StatelessWidget {
  const _TimingRulesCard({
    required this.snapshot,
    required this.endDateController,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
    required this.rematchEnabled,
    required this.saveAsMode,
    required this.onDate,
    required this.onTieRule,
    required this.onVoidRule,
    required this.onResultDeadline,
    required this.onRematch,
    required this.onSaveAsMode,
  });

  final ArenaSmartRulesSnapshot snapshot;
  final TextEditingController endDateController;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;
  final bool rematchEnabled;
  final bool saveAsMode;
  final ValueChanged<String> onDate;
  final VoidCallback onTieRule;
  final VoidCallback onVoidRule;
  final VoidCallback onResultDeadline;
  final VoidCallback onRematch;
  final VoidCallback onSaveAsMode;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaSmartRuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                color: AppColors.buy,
                size: ArenaSpacingTokens.arenaSmartRuleIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Timing & Edge Rules',
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _FieldBlock(
            label: 'Thời hạn kết thúc',
            required: true,
            child: VitInput(
              controller: endDateController,
              semanticLabel: 'Ngày kết thúc Arena',
              hintText: '03/15/2026',
              suffix: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: ArenaSpacingTokens.arenaSmartRuleIcon,
              ),
              onChanged: (value) => onDate(normalizeArenaDateInput(value)),
            ),
          ),
          _EdgeRuleField(
            fieldKey: ArenaSmartRuleBuilderPage.tieRuleKey,
            label: 'Luật hòa (Tie rule)',
            value: tieRule,
            onTap: onTieRule,
          ),
          _EdgeRuleField(
            fieldKey: ArenaSmartRuleBuilderPage.voidRuleKey,
            label: 'Luật hủy bỏ (Void rule)',
            value: voidRule,
            onTap: onVoidRule,
          ),
          _EdgeRuleField(
            fieldKey: ArenaSmartRuleBuilderPage.resultDeadlineKey,
            label: 'Hạn chốt kết quả (Result deadline)',
            value: resultDeadline,
            onTap: onResultDeadline,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _SwitchRow(
            label: 'Cho phép rematch',
            description: 'Người chơi có thể yêu cầu chơi lại',
            value: rematchEnabled,
            onTap: onRematch,
          ),
          _SwitchRow(
            label: 'Lưu thành reusable mode',
            description: 'Người khác có thể clone luật chơi này',
            value: saveAsMode,
            onTap: onSaveAsMode,
          ),
        ],
      ),
    );
  }
}

class _EdgeRuleField extends StatelessWidget {
  const _EdgeRuleField({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final Key fieldKey;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaSmartRuleEdgeFieldPadding,
      child: _FieldBlock(
        label: label,
        hint: 'Nên có',
        child: VitCard(
          key: fieldKey,
          variant: VitCardVariant.inner,
          borderColor: value.isEmpty ? AppColors.borderSolid : AppColors.buy20,
          padding: ArenaSpacingTokens.arenaSmartRuleSelectorPadding,
          onTap: () {
            unawaited(HapticFeedback.selectionClick());
            onTap();
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isEmpty ? 'Chọn ${label.toLowerCase()}...' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: value.isEmpty ? AppColors.text3 : AppColors.text1,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: ArenaSpacingTokens.arenaSmartRuleSwitchRowPadding,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        onTap();
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: _arenaAccent,
            activeTrackColor: AppColors.warn15,
            inactiveThumbColor: AppColors.text1,
            inactiveTrackColor: AppColors.surface3,
            onChanged: (_) => onTap(),
          ),
        ],
      ),
    );
  }
}
