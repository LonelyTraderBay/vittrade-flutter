part of '../../phone/pages/tools/launchpad_staking_page.dart';

class _PoolsTab extends StatelessWidget {
  const _PoolsTab({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pool in snapshot.pools) ...[
          _PoolCard(pool: pool, detailRoute: snapshot.detailRoute),
          if (pool != snapshot.pools.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        ],
      ],
    );
  }
}

class _PoolCard extends StatelessWidget {
  const _PoolCard({required this.pool, required this.detailRoute});

  final LaunchpoolPoolDraft pool;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    final currentTier = _currentTier(pool.tiers, pool.userStaked);
    return VitCard(
      key: LaunchpadStakingPage.poolKey(pool.id),
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX5,
      onTap: () => context.go(detailRoute),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LogoBadge(
                label: pool.projectLogo,
                color: pool.accent.resolve(),
                size: AppSpacing.x7,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pool.projectName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.extraBold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        const VitStatusPill(
                          label: 'Launchpool',
                          status: VitStatusPillStatus.success,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    Text(
                      'Stake ${pool.stakeToken} · Earn ${pool.rewardToken}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatApy(pool.effectiveApy)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: pool.accent.resolve(),
                      fontWeight: AppTextStyles.extraBold,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Tổng stake',
                  value: pool.totalStakedDisplay,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'Lock',
                  value: '${pool.lockPeriodDays} ngày',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(label: 'Chain', value: pool.chain),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _CapacityBar(pool: pool),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              for (final tier in pool.tiers) ...[
                Expanded(
                  child: _TierChip(
                    tier: tier,
                    selected: currentTier?.label == tier.label,
                  ),
                ),
                if (tier != pool.tiers.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
          if (pool.userStaked > 0) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            _UserStakeSummary(pool: pool),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _TimelineStatus(status: pool.status),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _PoolAction(pool: pool),
        ],
      ),
    );
  }
}
