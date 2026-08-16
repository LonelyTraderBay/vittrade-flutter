part of '../phone/pages/rewards_hub_page.dart';

class _RewardHeroKpi extends StatelessWidget {
  const _RewardHeroKpi({
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: valueStyle,
        ),
      ],
    );
  }
}

class _PendingClaimBanner extends StatelessWidget {
  const _PendingClaimBanner({
    required this.summary,
    required this.claimedAll,
    required this.onTap,
  });

  final RewardSummaryDraft summary;
  final bool claimedAll;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: RewardsHubPage.claimAllKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: claimedAll ? AppColors.buy20 : AppColors.warningBorder,
      onTap: claimedAll ? null : onTap,
      padding: ArenaSpacingTokens.arenaPaddingX3,
      child: Row(
        children: [
          VitAccentIconBox(
            icon: claimedAll
                ? Icons.check_circle_outline
                : Icons.inventory_2_outlined,
            color: claimedAll ? AppColors.buy : AppColors.warn,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  claimedAll
                      ? 'Đã nhận hết phần thưởng chờ'
                      : '${summary.pendingCount} phần thưởng đang chờ',
                  style: AppTextStyles.caption.copyWith(
                    color: claimedAll ? AppColors.buy : AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '+${summary.pendingBonusPoints} bonus pts · +${summary.pendingPoints} pts',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          if (!claimedAll)
            const VitStatusPill(
              label: 'Nhận tất cả',
              status: VitStatusPillStatus.orange,
              size: VitStatusPillSize.md,
            ),
        ],
      ),
    );
  }
}

class _ExpiringBanner extends StatelessWidget {
  const _ExpiringBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppColors.sell20,
      padding: ArenaSpacingTokens.arenaPointsExpiringPadding,
      child: Row(
        children: [
          const Icon(
            Icons.timer_outlined,
            color: AppColors.sell,
            size: ArenaSpacingTokens.arenaPointsSmallIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              '$count nhiệm vụ sắp hết hạn · Hoàn thành thêm để giữ điểm',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Xem',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.sell,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final RewardCategoryDraft category;

  @override
  Widget build(BuildContext context) {
    final color = _accentColor(category.kind);
    final value = category.total == 0 ? 0.0 : category.done / category.total;

    return Row(
      children: [
        SizedBox(
          width: AppSpacing.buttonHero,
          child: Row(
            children: [
              SizedBox(
                width: AppSpacing.x2,
                height: AppSpacing.x2,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: color,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  category.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: VitProgressBar(
            progress: value,
            color: color,
            trackColor: AppColors.surface3,
            height: AppSpacing.x3,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          '${category.done}/${category.total}',
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        if (category.pending > 0) ...[
          const SizedBox(width: AppSpacing.x1),
          _MiniBadge(label: '${category.pending}', color: AppColors.warn),
        ],
      ],
    );
  }
}

class _CheckInTile extends StatelessWidget {
  const _CheckInTile({required this.item});

  final RewardCheckInDraft item;

  @override
  Widget build(BuildContext context) {
    final active = item.claimed || item.today;
    final color = item.today ? AppModuleAccents.rewards : AppColors.buy;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: active ? color.withValues(alpha: .13) : AppColors.surface2,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: active ? color.withValues(alpha: .30) : AppColors.cardBorder,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
      ),
      child: Padding(
        padding: ArenaSpacingTokens.arenaPointsCheckInTilePadding,
        child: Column(
          children: [
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: item.today ? AppModuleAccents.rewards : AppColors.text3,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Icon(
              item.claimed ? Icons.check_circle_outline : Icons.circle_outlined,
              color: color,
              size: ArenaSpacingTokens.arenaPointsCheckInIcon,
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              item.reward,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BonusRow extends StatelessWidget {
  const _BonusRow({required this.row});

  final RewardBonusDraft row;

  @override
  Widget build(BuildContext context) {
    final color = _accentColor(row.kind);
    return Padding(
      padding: ArenaSpacingTokens.arenaPaddingX4,
      child: Row(
        children: [
          VitAccentIconBox(icon: _accentIcon(row.kind), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  row.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            row.rewardLabel,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});

  final RewardLeaderboardDraft entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaPointsLeaderboardRowPadding,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.x6,
            child: Text(
              '#${entry.rank}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.name,
              style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            ),
          ),
          Text(
            entry.pointsLabel,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyStat extends StatelessWidget {
  const _TinyStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.alignEnd = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignEnd
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: ArenaSpacingTokens.arenaPointsMicroIcon),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: ArenaSpacingTokens.arenaPointsMiniBadgePadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.bg,
            fontWeight: AppTextStyles.bold,
            height: ArenaSpacingTokens.arenaPointsBadgeLineHeight,
          ),
        ),
      ),
    );
  }
}

Color _accentColor(RewardAccentKind kind) {
  return switch (kind) {
    RewardAccentKind.daily => AppColors.primary,
    RewardAccentKind.weekly => AppModuleAccents.rewards,
    RewardAccentKind.flash => AppColors.sell,
    RewardAccentKind.learn => AppColors.buy,
    RewardAccentKind.achievement => AppColors.warn,
    RewardAccentKind.arena => AppColors.buy,
    RewardAccentKind.p2p => AppColors.primarySoft,
    RewardAccentKind.referral => AppColors.buy,
    RewardAccentKind.neutral => AppColors.text2,
  };
}

IconData _accentIcon(RewardAccentKind kind) {
  return switch (kind) {
    RewardAccentKind.daily => Icons.local_fire_department_outlined,
    RewardAccentKind.weekly => Icons.calendar_view_week_outlined,
    RewardAccentKind.flash => Icons.bolt_outlined,
    RewardAccentKind.learn => Icons.school_outlined,
    RewardAccentKind.achievement => Icons.emoji_events_outlined,
    RewardAccentKind.arena => Icons.shield_outlined,
    RewardAccentKind.p2p => Icons.handshake_outlined,
    RewardAccentKind.referral => Icons.group_add_outlined,
    RewardAccentKind.neutral => Icons.task_alt_outlined,
  };
}

VitTaskCardStatus _vitTaskCardStatus(RewardTaskStatus status) {
  return switch (status) {
    RewardTaskStatus.active => VitTaskCardStatus.active,
    RewardTaskStatus.completed => VitTaskCardStatus.completed,
    RewardTaskStatus.claimed => VitTaskCardStatus.claimed,
  };
}
