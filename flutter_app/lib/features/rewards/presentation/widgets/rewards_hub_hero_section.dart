part of '../phone/pages/rewards_hub_page.dart';

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({
    required this.summary,
    required this.claimedAll,
    required this.onClaimAll,
  });

  final RewardSummaryDraft summary;
  final bool claimedAll;
  final VoidCallback onClaimAll;

  @override
  Widget build(BuildContext context) {
    final available = summary.currentPoints - summary.lockedPoints;

    return VitModuleHeroCard(
      accentColor: AppModuleAccents.rewards,
      density: VitDensity.compact,
      padding: ArenaSpacingTokens.arenaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Arena Points',
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontWeight: AppTextStyles.heavy,
                  ),
                ),
              ),
              VitStatusPill(
                label: summary.tierLabel,
                icon: Icons.workspace_premium_outlined,
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Hoàn thành nhiệm vụ · nhận điểm Arena',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _RewardHeroKpi(
                  label: 'Số dư',
                  value: '${_formatRewardPoints(summary.currentPoints)} pts',
                  valueStyle: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.text1,
                    letterSpacing: 0,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: AppSpacing.x6,
                color: AppColors.border,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.x3,
                  ),
                  child: _RewardHeroKpi(
                    label: 'Đã nhận',
                    value: '${summary.bonusPointsClaimed} pts',
                    valueStyle: AppTextStyles.sectionTitle.copyWith(
                      color: AppModuleAccents.rewards,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _TinyStat(
                  icon: Icons.lock_open_outlined,
                  label: 'Khả dụng',
                  value: _formatRewardPoints(available),
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _TinyStat(
                  icon: Icons.lock_outline_rounded,
                  label: 'Đang khóa',
                  value: _formatRewardPoints(summary.lockedPoints),
                  color: AppColors.warn,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _PendingClaimBanner(
            summary: summary,
            claimedAll: claimedAll,
            onTap: onClaimAll,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ExpiringBanner(count: summary.expiringCount),
        ],
      ),
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  const _CategoryProgress({
    required this.categories,
    required this.completionLabel,
  });

  final List<RewardCategoryDraft> categories;
  final String completionLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tiến độ theo danh mục',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              completionLabel,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.buy,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final category in categories) ...[
          _CategoryRow(category: category),
          if (category != categories.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const Row(
          children: [
            VitLegendItem(
              label: 'Đã nhận',
              color: AppColors.buy,
              dotSize: AppSpacing.x2,
            ),
            SizedBox(width: AppSpacing.x3),
            VitLegendItem(
              label: 'Chờ nhận',
              color: AppColors.warn,
              dotSize: AppSpacing.x2,
            ),
            SizedBox(width: AppSpacing.x3),
            VitLegendItem(
              label: 'Đang làm',
              color: AppColors.text3,
              dotSize: AppSpacing.x2,
            ),
          ],
        ),
      ],
    );
  }
}

class _CheckInSection extends StatelessWidget {
  const _CheckInSection({required this.checkIns});

  final List<RewardCheckInDraft> checkIns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: VitSectionHeader(
                title: 'Check-in hằng ngày',
                icon: Icons.calendar_month_outlined,
                iconColor: AppModuleAccents.rewards,
                accentColor: AppModuleAccents.rewards,
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
              ),
            ),
            Text(
              '4/7',
              style: AppTextStyles.micro.copyWith(
                color: AppModuleAccents.rewards,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        VitCard(
          padding: ArenaSpacingTokens.arenaPaddingX3,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: Row(
                  children: [
                    for (final item in checkIns) ...[
                      SizedBox(
                        width: AppSpacing.x7 + AppSpacing.x4,
                        child: _CheckInTile(item: item),
                      ),
                      if (item != checkIns.last)
                        const SizedBox(width: AppSpacing.rowGap),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.text3,
                    size: ArenaSpacingTokens.arenaPointsMicroIcon,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      '7 ngày liên tiếp: +250 Arena Points',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReferralBanner extends StatelessWidget {
  const _ReferralBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      key: RewardsHubPage.referralKey,
      accentColor: AppColors.buy,
      onTap: onTap,
      padding: ArenaSpacingTokens.arenaPaddingX4,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.group_add_outlined,
            color: AppColors.buy,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mời bạn bè, cùng nhận thưởng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '+200 Arena Points mỗi lượt mời',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.buy,
            size: ArenaSpacingTokens.arenaPointsChevron,
          ),
        ],
      ),
    );
  }
}
