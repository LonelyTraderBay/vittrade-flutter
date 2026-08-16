part of 'my_arena_page.dart';

class _PointsHero extends StatelessWidget {
  const _PointsHero({
    required this.stats,
    required this.onDetails,
    required this.onLedger,
    required this.onEarn,
  });

  final MyArenaStats stats;
  final VoidCallback onDetails;
  final VoidCallback onLedger;
  final VoidCallback onEarn;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: ArenaSpacingTokens.arenaPaddingX5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Điểm Arena',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontWeight: AppTextStyles.heavy,
                        ),
                      ),
                    ),
                    const VitStatusPill(
                      label: 'Chỉ điểm Arena',
                      status: VitStatusPillStatus.orange,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatArenaPoints(stats.currentBalance),
                      style: AppTextStyles.heroNumber.copyWith(
                        fontWeight: AppTextStyles.heavy,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Padding(
                      padding: ArenaSpacingTokens.myArenaBalanceSuffixPadding,
                      child: Text(
                        'pts',
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    _TextIconButton(
                      key: MyArenaPage.pointsDetailKey,
                      icon: Icons.visibility_outlined,
                      label: 'Chi tiết',
                      color: AppColors.text3,
                      onTap: onDetails,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _TextIconButton(
                      icon: Icons.receipt_long_outlined,
                      label: 'Sổ điểm',
                      color: AppColors.text3,
                      onTap: onLedger,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          Padding(
            padding: ArenaSpacingTokens.arenaPaddingX5,
            child: Row(
              children: [
                Expanded(
                  child: _PointsDelta(
                    label: 'Đã nhận',
                    value: '+${formatArenaPoints(stats.pointsEarned)}',
                    color: AppColors.buy,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.x6,
                  child: VerticalDivider(
                    width: AppSpacing.x5,
                    color: AppColors.divider,
                  ),
                ),
                Expanded(
                  child: _PointsDelta(
                    label: 'Đang chơi',
                    value: '${stats.activeChallenges}',
                    color: _arenaAccent,
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                VitChoicePill(
                  label: 'Kiếm Points',
                  selected: true,
                  onTap: onEarn,
                  accentColor: AppColors.accent,
                  leading: const Icon(
                    Icons.redeem_rounded,
                    color: AppColors.accent,
                    size: ArenaSpacingTokens.myArenaAccentPillIcon,
                  ),
                  padding: ArenaSpacingTokens.arenaHorizontalPaddingX4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsDelta extends StatelessWidget {
  const _PointsDelta({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: ArenaSpacingTokens.myArenaDeltaDot,
              width: ArenaSpacingTokens.myArenaDeltaDot,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color,
                  shape: const CircleBorder(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          value,
          style: AppTextStyles.base.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final MyArenaStats stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: _InlineStat(
              label: 'Xếp hạng',
              value: '#${stats.rank}',
              color: AppColors.warn,
            ),
          ),
          const SizedBox(
            height: AppSpacing.x6,
            child: VerticalDivider(
              width: AppSpacing.x5,
              color: AppColors.divider,
            ),
          ),
          Expanded(
            child: _InlineStat(
              label: 'Mode đã tạo',
              value: '${stats.modesCreated}',
              color: AppColors.accent,
            ),
          ),
          const SizedBox(
            height: AppSpacing.x6,
            child: VerticalDivider(
              width: AppSpacing.x5,
              color: AppColors.divider,
            ),
          ),
          Expanded(
            child: _InlineStat(
              label: 'Điểm Creator',
              value: '${stats.creatorScore}%',
              color: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  const _InlineStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.sectionTitle.copyWith(
            color: color,
            fontWeight: AppTextStyles.heavy,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks({required this.onLeaderboard, required this.onDiscover});

  final VoidCallback onLeaderboard;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickLinkButton(
            key: MyArenaPage.leaderboardKey,
            icon: Icons.emoji_events_outlined,
            label: 'Bảng xếp hạng',
            onTap: onLeaderboard,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _QuickLinkButton(
            key: MyArenaPage.discoverKey,
            icon: Icons.bolt_rounded,
            label: 'Khám phá',
            onTap: onDiscover,
          ),
        ),
      ],
    );
  }
}

class _QuickLinkButton extends StatelessWidget {
  const _QuickLinkButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: VitCard(
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: VitDensity.compact.controlHeight,
          ),
          child: Material(
            color: AppColors.surface2,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
              side: BorderSide(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: AppColors.text2,
                  size: ArenaSpacingTokens.myArenaQuickLinkIcon,
                ),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArenaTabs extends StatelessWidget {
  const _ArenaTabs({required this.activeTab, required this.onChanged});

  final _MyArenaTab activeTab;
  final ValueChanged<_MyArenaTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: MyArenaPage.tabsScrollKey,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: Row(
        children: [
          for (final tab in _tabConfigs) ...[
            VitChoicePill(
              key: MyArenaPage.tabKey(tab.id),
              label: tab.label,
              selected: tab.tab == activeTab,
              onTap: () => onChanged(tab.tab),
              accentColor: _arenaAccent,
              leading: Icon(tab.icon, size: ArenaSpacingTokens.myArenaTabIcon),
              padding: ArenaSpacingTokens.arenaHorizontalPaddingX4,
            ),
            if (tab != _tabConfigs.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _TabConfig {
  const _TabConfig({
    required this.tab,
    required this.id,
    required this.label,
    required this.icon,
  });

  final _MyArenaTab tab;
  final String id;
  final String label;
  final IconData icon;
}

const _tabConfigs = [
  _TabConfig(
    tab: _MyArenaTab.myRooms,
    id: 'my_rooms',
    label: 'Phòng của tôi',
    icon: Icons.star_border_rounded,
  ),
  _TabConfig(
    tab: _MyArenaTab.joined,
    id: 'joined',
    label: 'Đã tham gia',
    icon: Icons.group_outlined,
  ),
  _TabConfig(
    tab: _MyArenaTab.savedModes,
    id: 'saved_modes',
    label: 'Mode đã lưu',
    icon: Icons.bookmark_border_rounded,
  ),
  _TabConfig(
    tab: _MyArenaTab.drafts,
    id: 'drafts',
    label: 'Bản nháp',
    icon: Icons.edit_note_rounded,
  ),
  _TabConfig(
    tab: _MyArenaTab.history,
    id: 'history',
    label: 'Lịch sử',
    icon: Icons.history_rounded,
  ),
];
