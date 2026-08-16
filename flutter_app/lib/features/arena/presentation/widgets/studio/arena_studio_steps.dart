part of '../../phone/pages/studio/arena_studio_page.dart';

class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.step,
    required this.snapshot,
    required this.selectedTemplateId,
    required this.onTemplateSelected,
    required this.onOpenSmartRules,
  });

  final int step;
  final ArenaStudioSnapshot snapshot;
  final String? selectedTemplateId;
  final ValueChanged<String> onTemplateSelected;
  final VoidCallback onOpenSmartRules;

  @override
  Widget build(BuildContext context) {
    final (title, description) = step == 1 ? ('', '') : _stepCopy(step);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (step == 1)
          _TemplateStep(
            templates: snapshot.templates,
            selectedTemplateId: selectedTemplateId,
            onTemplateSelected: onTemplateSelected,
          )
        else ...[
          VitModuleSectionHeader(title: title, accentColor: _arenaAccent),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            padding: ArenaSpacingTokens.arenaStudioCardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: ArenaSpacingTokens.arenaStudioStepIconBox,
                  height: ArenaSpacingTokens.arenaStudioStepIconBox,
                  child: DecoratedBox(
                    decoration: const ShapeDecoration(
                      color: AppColors.warn10,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadii.mdRadius,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _stepIcon(step),
                        color: _arenaAccent,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        description,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: _studioDescriptionLineRatio,
                        ),
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                      Wrap(
                        spacing: AppSpacing.x2,
                        runSpacing: AppSpacing.x2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const VitStatusPill(
                            label: 'Mock data',
                            status: VitStatusPillStatus.neutral,
                            size: VitStatusPillSize.sm,
                          ),
                          if (step == 3)
                            VitStatusPill(
                              label: 'Smart Builder',
                              status: VitStatusPillStatus.orange,
                              icon: Icons.rule_folder_outlined,
                              size: VitStatusPillSize.sm,
                              onTap: onOpenSmartRules,
                            ),
                        ],
                      ),
                      if (step == 3) ...[
                        const SizedBox(
                          height: AppSpacing.pageRhythmStandardInnerGap,
                        ),
                        VitCtaButton(
                          key: ArenaStudioPage.smartRuleBuilderKey,
                          onPressed: onOpenSmartRules,
                          variant: VitCtaButtonVariant.secondary,
                          leading: const Icon(Icons.rule_folder_outlined),
                          child: const Text('Mở Smart Rule Builder'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCommunityRulesLink(
          onTap: () => context.go(AppRoutePaths.arenaSafety),
        ),
        const SizedBox(height: AppSpacing.x1),
        VitCard(
          variant: VitCardVariant.inner,
          padding: ArenaSpacingTokens.arenaPaddingX3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _arenaAccent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính. Không thỏa thuận giao dịch ngoài nền tàng.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _studioTemplateLineRatio,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          alignment: WrapAlignment.start,
          children: [
            for (final signal in snapshot.trustSignals)
              VitStatusPill(
                label: signal.value,
                status: VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
              ),
          ],
        ),
      ],
    );
  }

  (String, String) _stepCopy(int step) {
    final title = switch (step) {
      2 => 'Cấu trúc trận đấu',
      3 => 'Luật chơi',
      4 => 'Kết quả',
      5 => 'Points',
      _ => 'Review',
    };
    final description = switch (step) {
      2 => 'Chọn format, số slot tối đa và kiểu tham gia trước khi mở room.',
      3 => 'Viết tiêu đề, mô tả, điều kiện thắng và quy tắc xử lý hòa.',
      4 => 'Chọn nguồn kết quả, referee hoặc cơ chế xác nhận cộng đồng.',
      5 => 'Thiết lập entry points, bonus pool và cách chia thưởng.',
      _ => 'Kiểm tra lại phí, luật chơi và boundary Points-only trước khi gửi.',
    };
    return (title, description);
  }

  IconData _stepIcon(int step) {
    return switch (step) {
      2 => Icons.account_tree_outlined,
      3 => Icons.rule_folder_outlined,
      4 => Icons.fact_check_outlined,
      5 => Icons.toll_outlined,
      _ => Icons.checklist_rtl_rounded,
    };
  }
}

class _TemplateStep extends StatelessWidget {
  const _TemplateStep({
    required this.templates,
    required this.selectedTemplateId,
    required this.onTemplateSelected,
  });

  final List<ArenaStudioTemplateDraft> templates;
  final String? selectedTemplateId;
  final ValueChanged<String> onTemplateSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Chọn template',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final template in templates) ...[
          _TemplateCard(
            template: template,
            selected: selectedTemplateId == template.id,
            onTap: () => onTemplateSelected(template.id),
          ),
          if (template != templates.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  final ArenaStudioTemplateDraft template;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaStudioPage.templateKey(template.id),
      borderColor: selected ? _arenaAccent : null,
      radius: VitCardRadius.standard,
      padding: ArenaSpacingTokens.arenaPaddingX3,
      onTap: template.verifiedOnly ? null : onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ArenaSpacingTokens.arenaBridgeIconBox,
            height: ArenaSpacingTokens.arenaBridgeIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: _templateAccent(template.kind).withValues(alpha: .14),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.mdRadius,
                ),
              ),
              child: Center(
                child: Icon(
                  _templateIcon(template.kind),
                  color: _templateAccent(template.kind),
                  size: ArenaSpacingTokens.arenaStudioTemplateGlyph,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        template.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.base.copyWith(
                          color: selected ? _arenaAccent : AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: _arenaAccent,
                        size: ArenaSpacingTokens.arenaStudioSelectedIcon,
                      )
                    else if (template.verifiedOnly)
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.text3,
                        size: ArenaSpacingTokens.arenaStudioLockIcon,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  template.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _studioTemplateLineRatio,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final tag in template.formatTags)
                      VitStatusPill(
                        label: tag,
                        status: VitStatusPillStatus.neutral,
                        size: VitStatusPillSize.sm,
                      ),
                    VitStatusPill(
                      label: template.complexity,
                      status: template.complexity == 'Nâng cao'
                          ? VitStatusPillStatus.error
                          : template.complexity == 'Dễ'
                          ? VitStatusPillStatus.success
                          : VitStatusPillStatus.orange,
                      size: VitStatusPillSize.sm,
                    ),
                    const VitStatusPill(
                      label: 'Points-only',
                      status: VitStatusPillStatus.orange,
                      size: VitStatusPillSize.sm,
                    ),
                    if (template.verifiedOnly)
                      const VitStatusPill(
                        label: 'Verified only',
                        status: VitStatusPillStatus.purple,
                        icon: Icons.lock_outline_rounded,
                        size: VitStatusPillSize.sm,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _templateIcon(ArenaTemplateKind kind) {
    return switch (kind) {
      ArenaTemplateKind.prediction => Icons.track_changes_rounded,
      ArenaTemplateKind.closestGuess => Icons.looks_one_outlined,
      ArenaTemplateKind.teamBattle => Icons.groups_2_outlined,
      ArenaTemplateKind.bracket => Icons.emoji_events_outlined,
      ArenaTemplateKind.vote => Icons.how_to_vote_outlined,
      ArenaTemplateKind.proof => Icons.photo_camera_outlined,
    };
  }

  Color _templateAccent(ArenaTemplateKind kind) {
    return switch (kind) {
      ArenaTemplateKind.prediction => AppColors.accent,
      ArenaTemplateKind.closestGuess => AppColors.primarySoft,
      ArenaTemplateKind.teamBattle => AppColors.sell,
      ArenaTemplateKind.bracket => _arenaAccent,
      ArenaTemplateKind.vote => AppColors.buy,
      ArenaTemplateKind.proof => AppColors.primary,
    };
  }
}
