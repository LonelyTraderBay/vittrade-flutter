part of '../../phone/pages/challenge/arena_leaderboard_page.dart';

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.entry,
    required this.rising,
    this.onTap,
  });

  final ArenaLeaderboardEntryDraft entry;
  final bool rising;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: rising
          ? ArenaLeaderboardPage.risingCreatorKey
          : ArenaLeaderboardPage.creatorRowKey,
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      child: Padding(
        padding: _leaderboardRowPadding,
        child: Row(
          children: [
            if (!rising) ...[
              SizedBox(
                width: _leaderboardRowRankWidth,
                child: Text(
                  '${entry.rank}',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
            ],
            SizedBox(
              width: _leaderboardRowAvatar,
              height: _leaderboardRowAvatar,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: (rising ? AppColors.warn : _arenaAccent).withValues(
                    alpha: .14,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _leaderboardIcon(entry.icon),
                    color: rising ? AppColors.warn : _arenaAccent,
                    size: _leaderboardRowIcon,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                  if (entry.subtitle.isNotEmpty)
                    Row(
                      children: [
                        if (entry.fairPlay) ...[
                          const Icon(
                            Icons.shield_outlined,
                            color: AppColors.buy,
                            size: _leaderboardFairPlayIcon,
                          ),
                          const SizedBox(width: AppSpacing.x1),
                        ],
                        Flexible(
                          child: Text(
                            entry.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: entry.fairPlay
                                  ? AppColors.buy
                                  : AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            if (rising)
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_outlined,
                    color: AppColors.warn,
                    size: _leaderboardRisingIcon,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    entry.value,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              )
            else
              Text(
                entry.value,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CompactLeaderboardState extends StatelessWidget {
  const _CompactLeaderboardState({required this.activeTab});

  final _LeaderboardTab activeTab;

  @override
  Widget build(BuildContext context) {
    final label = activeTab == _LeaderboardTab.players ? 'Players' : 'Teams';
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          Icon(
            activeTab == _LeaderboardTab.players
                ? Icons.groups_rounded
                : Icons.diversity_3_rounded,
            color: AppColors.text3,
            size: _leaderboardCompactIcon,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            label,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Bảng xếp hạng đang dùng cùng bộ lọc Fair Play và mùa.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ArenaFooter extends StatelessWidget {
  const _ArenaFooter({required this.disclaimer, required this.onRules});

  final String disclaimer;
  final VoidCallback onRules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCommunityRulesLink(
          key: ArenaLeaderboardPage.rulesKey,
          onTap: onRules,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          density: VitDensity.compact,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _arenaAccent,
                size: _leaderboardFooterShieldIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  disclaimer,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _leaderboardFooterLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Color _rankColor(int rank) {
  return switch (rank) {
    1 => AppColors.warn,
    2 => AppColors.text2,
    3 => AppColors.primaryDark,
    _ => AppColors.text3,
  };
}

IconData _leaderboardIcon(ArenaLeaderboardIconKind icon) {
  return switch (icon) {
    ArenaLeaderboardIconKind.trophy => Icons.emoji_events_outlined,
    ArenaLeaderboardIconKind.shield => Icons.shield_outlined,
    ArenaLeaderboardIconKind.trending => Icons.trending_up_rounded,
    ArenaLeaderboardIconKind.winRate => Icons.workspace_premium_outlined,
    ArenaLeaderboardIconKind.activity => Icons.bolt_rounded,
    ArenaLeaderboardIconKind.completion => Icons.verified_outlined,
    ArenaLeaderboardIconKind.target => Icons.gps_fixed_rounded,
    ArenaLeaderboardIconKind.game => Icons.videogame_asset_rounded,
    ArenaLeaderboardIconKind.magic => Icons.auto_fix_high_rounded,
    ArenaLeaderboardIconKind.crown => Icons.workspace_premium_rounded,
    ArenaLeaderboardIconKind.player => Icons.person_rounded,
    ArenaLeaderboardIconKind.team => Icons.groups_rounded,
  };
}
