part of 'arena_universal_preset_library_page.dart';

class _DemoFlowCard extends StatelessWidget {
  const _DemoFlowCard({required this.flow});

  final ArenaPresetDemoFlowDraft flow;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.buy20,
      padding: ArenaSpacingTokens.arenaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _DomainIcon(id: flow.domainId),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${flow.domainLabel} + ${flow.typeLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Demo mapping flow',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _DemoStep(step: '1', label: 'Domain', value: flow.domainLabel),
          _DemoStep(step: '2', label: 'Type', value: flow.typeLabel),
          _DemoSuggestions(values: flow.suggestions),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.buy20,
            padding: ArenaSpacingTokens.arenaPaddingX3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  color: AppColors.buy,
                  size: ArenaSpacingTokens.arenaPresetSmallIcon,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    flow.generatedRule,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      height: _presetCheckLineRatio,
                      fontWeight: AppTextStyles.bold,
                    ),
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

class _DemoStep extends StatelessWidget {
  const _DemoStep({
    required this.step,
    required this.label,
    required this.value,
  });

  final String step;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaBottomPaddingX2,
      child: Material(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
        child: Padding(
          padding: ArenaSpacingTokens.arenaPaddingX3,
          child: Row(
            children: [
              _StepDot(step: step, color: AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              SizedBox(
                width: ArenaSpacingTokens.arenaPresetProcessLabelWidth,
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.check_rounded,
                color: AppColors.buy,
                size: ArenaSpacingTokens.arenaPresetSmallIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoSuggestions extends StatelessWidget {
  const _DemoSuggestions({required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: ArenaSpacingTokens.arenaPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _StepDot(step: '3', color: AppColors.buy),
                const SizedBox(width: AppSpacing.x3),
                Text(
                  'Suggestion chips',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                for (final value in values)
                  _SmallPill(label: value, accentColor: AppColors.buy),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoSummaryRow extends StatelessWidget {
  const _DemoSummaryRow({
    required this.flow,
    required this.selected,
    required this.onTap,
  });

  final ArenaPresetDemoFlowDraft flow;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaBottomPaddingX2,
      child: VitCard(
        variant: VitCardVariant.inner,
        borderColor: selected ? AppColors.buy20 : null,
        padding: ArenaSpacingTokens.arenaPaddingX3,
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              _domainIcon(flow.domainId),
              color: selected ? AppColors.buy : AppColors.text3,
              size: ArenaSpacingTokens.arenaPresetInlineIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                '${flow.domainLabel} + ${flow.typeLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: ArenaSpacingTokens.arenaPresetInlineIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleChip extends StatelessWidget {
  const _TitleChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: selected ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: selected ? AppColors.sell20 : AppColors.borderSolid,
      radius: VitCardRadius.standard,
      padding: ArenaSpacingTokens.arenaPresetChipPadding,
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: ArenaSpacingTokens.arenaPresetTitleMaxWidth,
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: selected ? AppColors.sell : AppColors.text2,
            fontWeight: selected ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ),
    );
  }
}

class _ProcessRow extends StatelessWidget {
  const _ProcessRow({required this.step, required this.text});

  final String step;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaBottomPaddingX2,
      child: Material(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
        child: Padding(
          padding: ArenaSpacingTokens.arenaPaddingX3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StepDot(step: step, color: AppColors.sell),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _presetBodyLineRatio,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetEngineNote extends StatelessWidget {
  const _PresetEngineNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: ArenaSpacingTokens.arenaPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: ArenaSpacingTokens.arenaPresetInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Hệ preset dùng 1 rule engine chung. Tất cả domains tái sử dụng cùng challenge types, dropdowns và suggestion pipeline.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _presetNoticeLineRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniHeader extends StatelessWidget {
  const _MiniHeader({required this.icon, required this.label, this.count});

  final IconData icon;
  final String label;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: _arenaAccent,
          size: ArenaSpacingTokens.arenaPresetHeaderIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (count != null)
          _SmallPill(label: '$count', accentColor: _arenaAccent),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.step, required this.color});

  final String step;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ArenaSpacingTokens.arenaPresetStepDot,
      height: ArenaSpacingTokens.arenaPresetStepDot,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        child: Center(
          child: Text(
            step,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

IconData _sectionIcon(String id) {
  switch (id) {
    case 'domains':
      return Icons.layers_outlined;
    case 'suggestions':
      return Icons.auto_awesome_rounded;
    case 'dropdowns':
      return Icons.list_rounded;
    case 'demo_flows':
      return Icons.play_arrow_rounded;
    case 'titles':
      return Icons.tag_rounded;
    default:
      return Icons.extension_outlined;
  }
}

IconData _domainIcon(String id) {
  switch (id) {
    case 'sports':
      return Icons.sports_soccer_rounded;
    case 'esports':
      return Icons.sports_esports_rounded;
    case 'crypto':
      return Icons.show_chart_rounded;
    case 'tech':
      return Icons.smart_toy_outlined;
    case 'science':
      return Icons.science_outlined;
    case 'health':
      return Icons.fitness_center_rounded;
    case 'entertainment':
      return Icons.movie_outlined;
    case 'work':
      return Icons.business_center_outlined;
    case 'community':
      return Icons.groups_2_outlined;
    default:
      return Icons.category_outlined;
  }
}

IconData _challengeIcon(String type) {
  if (type.contains('Closest')) return Icons.adjust_rounded;
  if (type.contains('Highest')) return Icons.bar_chart_rounded;
  if (type.contains('Vote')) return Icons.how_to_vote_outlined;
  if (type.contains('Proof')) return Icons.verified_outlined;
  return Icons.check_box_outlined;
}
