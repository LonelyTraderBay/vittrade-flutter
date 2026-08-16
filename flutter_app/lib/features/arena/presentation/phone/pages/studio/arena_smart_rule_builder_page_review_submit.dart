part of 'arena_smart_rule_builder_page.dart';

class _RuleSummaryCard extends StatelessWidget {
  const _RuleSummaryCard({
    required this.domain,
    required this.challengeType,
    required this.winCondition,
    required this.endDate,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
  });

  final String? domain;
  final String? challengeType;
  final String winCondition;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.accent20,
      padding: ArenaSpacingTokens.arenaSmartRuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.summarize_outlined,
                color: AppColors.accent,
                size: ArenaSpacingTokens.arenaSmartRuleIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tóm tắt luật chơi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const VitStatusPill(
                label: 'Tự sinh',
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _SummaryRow(label: 'Lĩnh vực', value: domain ?? '-'),
          _SummaryRow(label: 'Loại challenge', value: challengeType ?? '-'),
          _SummaryRow(label: 'Điều kiện thắng', value: winCondition),
          _SummaryRow(label: 'Kết thúc', value: endDate),
          _SummaryRow(
            label: 'Luật hòa',
            value: tieRule.isEmpty ? '-' : tieRule,
          ),
          _SummaryRow(
            label: 'Luật hủy bỏ',
            value: voidRule.isEmpty ? '-' : voidRule,
          ),
          _SummaryRow(
            label: 'Hạn chốt kết quả',
            value: resultDeadline.isEmpty ? '-' : resultDeadline,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaSmartRuleSummaryRowPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ArenaSpacingTokens.arenaSmartRuleSummaryLabelWidth,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: value == '-' ? AppColors.text3 : AppColors.text1,
                fontWeight: value == '-'
                    ? AppTextStyles.normal
                    : AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModerationNote extends StatelessWidget {
  const _ModerationNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: ArenaSpacingTokens.arenaSmartRuleInnerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: ArenaSpacingTokens.arenaSmartRuleIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Challenge sẽ được kiểm duyệt tự động. Nội dung vi phạm sẽ bị ẩn. Arena Points không phải tài sản tài chính.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _smartRuleBodyLineRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackendPayloadPreviewCard extends StatelessWidget {
  const _BackendPayloadPreviewCard({
    required this.creationState,
    required this.draft,
  });

  final ArenaCreationViewState creationState;
  final ArenaCreateChallengeDraft draft;

  @override
  Widget build(BuildContext context) {
    final activeDraft = creationState.previewDraft ?? draft;
    final ready = activeDraft.hasRequiredShape;
    final statusLabel =
        creationState.statusLabel ??
        (ready ? 'Sẵn sàng preview payload' : 'Hoàn thiện rule để preview');

    return VitCard(
      padding: ArenaSpacingTokens.arenaSmartRuleCardPadding,
      borderColor: ready ? AppColors.buy20 : AppColors.borderSolid,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                ready ? Icons.cloud_done_outlined : Icons.cloud_queue_outlined,
                color: ready ? AppColors.buy : AppColors.text3,
                size: ArenaSpacingTokens.arenaSmartRuleIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Backend handoff',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitStatusPill(
                label: ready ? 'Contract-ready' : 'Draft',
                status: ready
                    ? VitStatusPillStatus.success
                    : VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            statusLabel,
            style: AppTextStyles.caption.copyWith(
              color: ready ? AppColors.buy : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final row in activeDraft.backendPayloadRows())
                VitStatusPill(
                  label: row,
                  status: row == ArenaCreateChallengeDraft.endpoint
                      ? VitStatusPillStatus.orange
                      : VitStatusPillStatus.neutral,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          if (creationState.errorMessage != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              creationState.errorMessage!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.sell,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CreationSafetyChecklist extends StatelessWidget {
  const _CreationSafetyChecklist({
    required this.ruleReviewAccepted,
    required this.pointsBoundaryAccepted,
    required this.moderationAccepted,
    required this.onRuleReview,
    required this.onPointsBoundary,
    required this.onModeration,
  });

  final bool ruleReviewAccepted;
  final bool pointsBoundaryAccepted;
  final bool moderationAccepted;
  final VoidCallback onRuleReview;
  final VoidCallback onPointsBoundary;
  final VoidCallback onModeration;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: ArenaSpacingTokens.arenaSmartRuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: AppColors.primary,
                size: ArenaSpacingTokens.arenaSmartRuleIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Xác nhận trước khi gửi',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          _ChecklistRow(
            key: ArenaSmartRuleBuilderPage.rulesAckKey,
            value: ruleReviewAccepted,
            title: 'Luật chơi đã rõ',
            description:
                'Có điều kiện thắng, luật hòa/hủy và hạn chốt kết quả.',
            onTap: onRuleReview,
          ),
          _ChecklistRow(
            key: ArenaSmartRuleBuilderPage.pointsAckKey,
            value: pointsBoundaryAccepted,
            title: 'Arena Points only',
            description:
                'Không dùng ví, giá trị tiền, lợi nhuận hoặc cam kết hoàn điểm.',
            onTap: onPointsBoundary,
          ),
          _ChecklistRow(
            key: ArenaSmartRuleBuilderPage.moderationAckKey,
            value: moderationAccepted,
            title: 'Sẵn sàng moderation',
            description: 'Challenge có thể bị ẩn nếu vi phạm fair-play/safety.',
            onTap: onModeration,
          ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    super.key,
    required this.value,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final bool value;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: ArenaSpacingTokens.arenaSmartRuleSwitchRowPadding,
      onTap: onTap,
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: _arenaAccent,
            onChanged: (_) => onTap(),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
        ],
      ),
    );
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.canProceed,
    required this.canSubmit,
    required this.clarityScore,
    required this.onBack,
    required this.onContinue,
    required this.onPreview,
    required this.onSave,
    required this.onSubmit,
    required this.onReset,
    this.statusLabel,
    this.commandStatusLabel,
  });

  final bool canProceed;
  final bool canSubmit;
  final int clarityScore;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final VoidCallback onPreview;
  final VoidCallback onSave;
  final VoidCallback onSubmit;
  final VoidCallback onReset;
  final String? statusLabel;
  final String? commandStatusLabel;

  @override
  Widget build(BuildContext context) {
    final footerLabel = statusLabel ?? commandStatusLabel;
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: _smartRuleActionExtent,
              height: _smartRuleActionExtent,
              child: VitCtaButton(
                onPressed: onBack,
                variant: VitCtaButtonVariant.secondary,
                fullWidth: false,
                padding: AppSpacing.zeroInsets,
                child: const Icon(Icons.chevron_left_rounded),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: ArenaSmartRuleBuilderPage.continueKey,
                onPressed: onContinue,
                variant: canProceed
                    ? VitCtaButtonVariant.primary
                    : VitCtaButtonVariant.secondary,
                trailing: const Icon(Icons.chevron_right_rounded),
                child: Text(canProceed ? 'Tiếp tục' : 'Kiểm tra thiếu'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: ArenaSmartRuleBuilderPage.previewKey,
                onPressed: onPreview,
                variant: VitCtaButtonVariant.secondary,
                leading: const Icon(Icons.visibility_outlined),
                child: const Text('Xem payload'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: ArenaSmartRuleBuilderPage.submitKey,
                onPressed: onSubmit,
                variant: canSubmit
                    ? VitCtaButtonVariant.primary
                    : VitCtaButtonVariant.secondary,
                leading: const Icon(Icons.send_outlined),
                child: const Text('Gửi duyệt'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            VitCtaButton(
              key: ArenaSmartRuleBuilderPage.saveKey,
              onPressed: onSave,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              leading: const Icon(
                Icons.save_outlined,
                size: ArenaSpacingTokens.arenaSmartRuleTinyIcon,
              ),
              child: const Text('Lưu nháp'),
            ),
            VitCtaButton(
              key: ArenaSmartRuleBuilderPage.resetKey,
              onPressed: onReset,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              leading: const Icon(
                Icons.refresh_rounded,
                size: ArenaSpacingTokens.arenaSmartRuleTinyIcon,
              ),
              child: const Text('Làm mới'),
            ),
            VitStatusPill(
              label: 'Clarity: $clarityScore',
              status: clarityScore >= 35
                  ? VitStatusPillStatus.orange
                  : VitStatusPillStatus.error,
              size: VitStatusPillSize.sm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Bước 3 / 6',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        if (footerLabel != null && footerLabel.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            footerLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.buy),
          ),
        ],
      ],
    );
  }
}

class _SmartOptionSheet extends StatelessWidget {
  const _SmartOptionSheet({
    required this.title,
    required this.options,
    required this.selectedId,
  });

  final String title;
  final List<ArenaSmartOptionDraft> options;
  final String selectedId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .78,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: ArenaSpacingTokens.arenaSmartRuleCardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OptionSheetHeader(title: title),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                for (final option in options) ...[
                  _OptionTile(
                    title: option.label,
                    description: option.description,
                    selected: selectedId == option.id,
                    onTap: () => Navigator.of(context).pop(option),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextOptionSheet extends StatelessWidget {
  const _TextOptionSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
  });

  final String title;
  final List<String> options;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .78,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: ArenaSpacingTokens.arenaSmartRuleCardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OptionSheetHeader(title: title),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                for (final option in options) ...[
                  _OptionTile(
                    title: option,
                    selected: selectedValue == option,
                    onTap: () => Navigator.of(context).pop(option),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionSheetHeader extends StatelessWidget {
  const _OptionSheetHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.tune_rounded,
          color: _arenaAccent,
          size: ArenaSpacingTokens.arenaSmartRuleIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
    this.description,
  });

  final String title;
  final String? description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: selected ? AppColors.accent20 : AppColors.borderSolid,
      padding: ArenaSpacingTokens.arenaSmartRuleSelectorPadding,
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.buy : AppColors.text3,
            size: ArenaSpacingTokens.arenaSmartRuleIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    description!,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: _smartRuleBodyLineRatio,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitChallengeSheet extends StatelessWidget {
  const _SubmitChallengeSheet({required this.draft});

  final ArenaCreateChallengeDraft draft;

  @override
  Widget build(BuildContext context) {
    final padding = ArenaSpacingTokens.arenaSmartRuleCardPadding;
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .86,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: padding.copyWith(bottom: padding.bottom + AppSpacing.x3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.outbox_outlined,
                      color: _arenaAccent,
                      size: ArenaSpacingTokens.arenaSmartRuleIcon,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        'Xác nhận gửi challenge',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  draft.normalizedTitle,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Challenge sẽ được gửi theo contract POST /arena/challenges. Bản demo lưu local để kiểm thử UI, sau này thay bằng remote repository.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _smartRuleBodyLineRatio,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    VitStatusPill(
                      label: '${draft.entryPoints} pts entry',
                      status: VitStatusPillStatus.orange,
                      size: VitStatusPillSize.sm,
                    ),
                    VitStatusPill(
                      label: '${draft.slotsTotal} slots',
                      status: VitStatusPillStatus.neutral,
                      size: VitStatusPillSize.sm,
                    ),
                    VitStatusPill(
                      label: 'Clarity ${draft.clarityScore}',
                      status: VitStatusPillStatus.success,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
                Row(
                  children: [
                    Expanded(
                      child: VitCtaButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        variant: VitCtaButtonVariant.secondary,
                        child: const Text('Kiểm tra lại'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: VitCtaButton(
                        key: ArenaSmartRuleBuilderPage.confirmSubmitKey,
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Xác nhận gửi'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.child,
    this.required = false,
    this.hint,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.x1,
          runSpacing: AppSpacing.x1,
          children: [
            Text(
              label,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            if (required) ...[
              Text(
                '*',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
            if (hint != null) ...[
              Text(
                hint!,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        child,
      ],
    );
  }
}
