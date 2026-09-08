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
