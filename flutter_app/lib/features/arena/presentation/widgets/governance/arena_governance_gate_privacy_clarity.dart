part of '../../phone/pages/governance/arena_governance_gate_page.dart';

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({
    required this.options,
    required this.privacy,
    required this.onSelected,
    required this.onCompare,
  });

  final List<ArenaPrivacyOptionDraft> options;
  final String privacy;
  final ValueChanged<String> onSelected;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaGovernanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quyền riêng tư',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitCard(
                key: ArenaGovernanceGatePage.compareKey,
                variant: VitCardVariant.ghost,
                padding: ArenaSpacingTokens.arenaGovernanceComparePadding,
                onTap: onCompare,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.accent,
                      size: ArenaSpacingTokens.arenaGovernanceSmallIcon,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      'So sánh',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              for (final option in options) ...[
                Expanded(
                  child: _PrivacyChip(
                    option: option,
                    active: privacy == option.id,
                    onTap: () => onSelected(option.id),
                  ),
                ),
                if (option != options.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
          if (privacy == 'public') ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              'Public room yêu cầu tất cả mục rule bắt buộc. Governance Gate sẽ kiểm tra tự động.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _governanceBodyLineRatio,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrivacyChip extends StatelessWidget {
  const _PrivacyChip({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final ArenaPrivacyOptionDraft option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaGovernanceGatePage.privacyKey(option.id),
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: active ? AppColors.accent20 : AppColors.borderSolid,
      radius: VitCardRadius.large,
      padding: ArenaSpacingTokens.arenaGovernancePrivacyChipPadding,
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            _privacyIcon(option.id),
            color: active ? AppColors.accent : AppColors.text3,
            size: ArenaSpacingTokens.arenaGovernanceIcon,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? AppColors.accent : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClarityScoreCard extends StatelessWidget {
  const _ClarityScoreCard({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    final color = result.clarity >= 60 ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: ArenaSpacingTokens.arenaGovernanceCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: color,
                size: ArenaSpacingTokens.arenaGovernanceIcon,
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
                '${result.clarity}',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _StatusPill(label: result.level, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight:
                  ArenaSpacingTokens.arenaGovernanceClarityProgressHeight,
              value: result.clarity / 100,
              backgroundColor: AppColors.surface3,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
