part of 'arena_smart_rule_builder_page.dart';

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
