part of '../../phone/pages/governance/arena_governance_gate_page.dart';

class _SuggestedFallbackCard extends StatelessWidget {
  const _SuggestedFallbackCard({
    required this.suggestions,
    required this.onTap,
  });

  final List<ArenaGovernanceSuggestionDraft> suggestions;
  final ValueChanged<ArenaGovernanceSuggestionDraft> onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaGovernanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MiniHeader(
            icon: Icons.lightbulb_outline_rounded,
            label: 'Gợi ý cải thiện',
            pill: 'SMART',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final item in suggestions)
            Padding(
              padding: ArenaSpacingTokens.arenaGovernanceListItemPadding,
              child: VitCard(
                variant: VitCardVariant.inner,
                padding: ArenaSpacingTokens.arenaGovernanceInnerPadding,
                onTap: () => onTap(item),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high_rounded,
                      color: _arenaAccent,
                      size: ArenaSpacingTokens.arenaGovernanceIcon,
                    ),
                    const SizedBox(width: AppSpacing.x2),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.text3,
                      size: ArenaSpacingTokens.arenaGovernanceIcon,
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

class _EligibilityPanel extends StatelessWidget {
  const _EligibilityPanel({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(result.tier);
    return VitCard(
      borderColor: _tierBorder(result.tier),
      padding: ArenaSpacingTokens.arenaGovernanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _tierIcon(result.tier),
                color: color,
                size: ArenaSpacingTokens.arenaGovernanceIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  _tierLabel(result.tier),
                  style: AppTextStyles.base.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _StatusPill(label: 'Clarity: ${result.clarity}', color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final check in result.checks)
            Padding(
              padding: ArenaSpacingTokens.arenaGovernanceListItemPadding,
              child: Row(
                children: [
                  Icon(
                    check.passed
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: check.passed ? AppColors.buy : AppColors.text3,
                    size: ArenaSpacingTokens.arenaGovernanceLargeIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      check.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: check.passed
                            ? AppTextStyles.bold
                            : AppTextStyles.medium,
                      ),
                    ),
                  ),
                  if (!check.passed)
                    const _RequiredPill(text: 'PUBLIC', compact: true),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
