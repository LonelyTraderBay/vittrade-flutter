part of '../../phone/pages/staking/staking_community_governance_page.dart';

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.title, required this.stats});

  final String title;
  final List<StakingGovernanceStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingCommunityGovernancePage.overviewKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: EarnSpacingTokens.stakingGovernanceGridColumns,
              crossAxisSpacing: AppSpacing.x3,
              mainAxisSpacing: AppSpacing.x3,
              childAspectRatio: EarnSpacingTokens.stakingGovernanceGridAspect,
            ),
            itemBuilder: (context, index) {
              return _StatTile(stat: stats[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingGovernanceStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    final icon = _statIcon(stat.label);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: _toneBorder(stat.tone),
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            stat.value,
            style: AppTextStyles.amountXs.copyWith(
              color: stat.tone == 'neutral' ? AppColors.text1 : color,
            ),
          ),
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ActiveProposal extends StatelessWidget {
  const _ActiveProposal({required this.proposal, required this.onTap});

  final StakingGovernanceActiveProposalDraft proposal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingCommunityGovernancePage.activeProposalKey,
      label: 'Active Proposals',
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      proposal.title,
                      style: AppTextStyles.baseMedium,
                    ),
                  ),
                  _Pill(
                    label: proposal.badge,
                    color: AppModuleAccents.earn,
                    emphasis: true,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                proposal.body,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentDecisions extends StatelessWidget {
  const _RecentDecisions({required this.decisions});

  final List<StakingGovernanceDecisionDraft> decisions;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingCommunityGovernancePage.decisionsKey,
      label: 'Recent Decisions',
      children: [
        for (final decision in decisions) _DecisionCard(decision: decision),
      ],
    );
  }
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({required this.decision});

  final StakingGovernanceDecisionDraft decision;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  decision.proposal,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${decision.votes} votes - ${decision.dateLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _Pill(label: decision.status, color: AppColors.buy, emphasis: true),
        ],
      ),
    );
  }
}

class _GovernanceSteps extends StatelessWidget {
  const _GovernanceSteps({required this.steps});

  final List<StakingGovernanceStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingCommunityGovernancePage.stepsKey,
      label: 'How Governance Works',
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: VitStepList(
            steps: [
              for (final step in steps)
                VitStepItem(
                  title: step.title,
                  description: step.description,
                  stepNumber: step.step,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
