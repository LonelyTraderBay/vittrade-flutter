part of '../../phone/pages/studio/arena_smart_rule_builder_page.dart';

class _ClarityResult {
  const _ClarityResult(this.score);

  final int score;

  String get label {
    if (score >= 85) return 'Public-ready';
    if (score >= 60) return 'Cao';
    if (score >= 35) return 'Trung bình';
    return 'Thấp';
  }

  Color get color {
    if (score >= 85) return AppColors.accent;
    if (score >= 60) return AppColors.buy;
    if (score >= 35) return AppColors.warn;
    return AppColors.sell;
  }

  Color get softColor {
    if (score >= 85) return AppColors.accent12;
    if (score >= 60) return AppColors.buy15;
    if (score >= 35) return AppColors.warn15;
    return AppColors.sell15;
  }
}

class _IntroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Luật chơi — Smart Builder',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Chọn rule có cấu trúc để room dễ hiểu và dễ được tin tưởng hơn',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: _smartRuleSubtitleLineRatio,
          ),
        ),
      ],
    );
  }
}

class _ClarityScoreCard extends StatelessWidget {
  const _ClarityScoreCard({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final result = _ClarityResult(score);
    return VitCard(
      padding: ArenaSpacingTokens.arenaSmartRuleCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: result.color,
                size: ArenaSpacingTokens.arenaSmartRuleIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Rule Clarity Score',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '$score',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: result.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: result.label,
                status: score >= 35
                    ? VitStatusPillStatus.orange
                    : VitStatusPillStatus.error,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: ArenaSpacingTokens.arenaSmartRuleProgressHeight,
              color: result.color,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            score >= 35
                ? 'Rule đã ổn, thêm edge rules sẽ rõ ràng hơn'
                : 'Cần bổ sung thêm thông tin để room dễ hiểu',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Chọn rule có cấu trúc để room dễ hiểu và dễ được tin tưởng hơn',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidanceLink extends StatelessWidget {
  const _GuidanceLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaSmartRuleBuilderPage.guidanceKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: ArenaSpacingTokens.arenaSmartRuleLinkPadding,
      onTap: onTap,
      child: Row(
        children: [
          const Icon(
            Icons.help_outline_rounded,
            color: AppColors.primary,
            size: ArenaSpacingTokens.arenaSmartRuleIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Public vs Private — Room cần rule gì?',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primary,
            size: ArenaSpacingTokens.arenaSmartRuleIcon,
          ),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.controller,
    required this.suggestions,
    required this.onChanged,
    required this.onSuggestion,
  });

  final TextEditingController controller;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Tên challenge',
      required: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VitInput(
            fieldKey: ArenaSmartRuleBuilderPage.titleKey,
            controller: controller,
            semanticLabel: 'Tiêu đề thử thách Arena',
            hintText: 'VD: BTC Weekly Predict - Tuan 10',
            onChanged: onChanged,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x5,
            runSpacing: AppSpacing.x3,
            children: [
              for (final suggestion in suggestions)
                VitCard(
                  variant: VitCardVariant.ghost,
                  radius: VitCardRadius.standard,
                  padding: AppSpacing.zeroInsets,
                  onTap: () => onSuggestion(suggestion),
                  child: Text(
                    '"$suggestion"',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DomainField extends StatelessWidget {
  const _DomainField({required this.domain, required this.onTap});

  final ArenaSmartOptionDraft? domain;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Lĩnh vực',
      required: true,
      child: VitCard(
        key: ArenaSmartRuleBuilderPage.domainKey,
        variant: VitCardVariant.inner,
        borderColor: domain == null
            ? AppColors.borderSolid
            : AppColors.accent20,
        padding: ArenaSpacingTokens.arenaSmartRuleSelectorPadding,
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                domain?.label ?? 'Chọn lĩnh vực...',
                style: AppTextStyles.base.copyWith(
                  color: domain == null ? AppColors.text3 : AppColors.text1,
                  fontWeight: domain == null
                      ? AppTextStyles.normal
                      : AppTextStyles.bold,
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
    );
  }
}

class _ChallengeTypeGrid extends StatelessWidget {
  const _ChallengeTypeGrid({
    required this.types,
    required this.selectedId,
    required this.onSelected,
  });

  final List<ArenaSmartOptionDraft> types;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Loại challenge',
      required: true,
      child: Wrap(
        runSpacing: AppSpacing.x3,
        children: [
          for (final type in types)
            SizedBox(
              width: ArenaSpacingTokens.arenaSmartRuleChallengeTypeWidth,
              child: _ChallengeTypeTile(
                key: ArenaSmartRuleBuilderPage.challengeTypeKey(type.id),
                type: type,
                selected: selectedId == type.id,
                onTap: () => onSelected(type.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChallengeTypeTile extends StatelessWidget {
  const _ChallengeTypeTile({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final ArenaSmartOptionDraft type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: ArenaSpacingTokens.arenaSmartRuleTilePadding,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        onTap();
      },
      child: Row(
        children: [
          Icon(
            _challengeTypeIcon(type.id),
            color: selected ? AppColors.buy : _challengeTypeColor(type.id),
            size: ArenaSpacingTokens.arenaSmartRuleTinyIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? AppColors.buy : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  type.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _challengeTypeIcon(String id) {
    return switch (id) {
      'yes_no' => Icons.check_box_rounded,
      'multi_choice' => Icons.fact_check_outlined,
      'closest_guess' => Icons.track_changes_rounded,
      'highest_wins' => Icons.bar_chart_rounded,
      'lowest_wins' => Icons.show_chart_rounded,
      'first_to_finish' => Icons.flag_outlined,
      'team_score' => Icons.groups_2_outlined,
      'referee_decision' => Icons.gavel_outlined,
      'community_vote' => Icons.how_to_vote_outlined,
      _ => Icons.photo_camera_outlined,
    };
  }

  Color _challengeTypeColor(String id) {
    return switch (id) {
      'yes_no' => AppColors.buy,
      'multi_choice' => AppColors.primary,
      'closest_guess' => AppColors.accent,
      'highest_wins' => AppColors.buy,
      'lowest_wins' => AppColors.sell,
      'first_to_finish' => AppColors.text2,
      'team_score' => AppColors.accent,
      'referee_decision' => AppColors.primarySoft,
      'community_vote' => AppColors.text2,
      _ => AppColors.primarySoft,
    };
  }
}
