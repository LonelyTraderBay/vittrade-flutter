part of 'my_arena_page.dart';

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.tab,
    required this.snapshot,
    required this.onChallenge,
    required this.onMode,
    required this.onStudio,
    required this.onDiscover,
  });

  final _MyArenaTab tab;
  final MyArenaSnapshot snapshot;
  final ValueChanged<String> onChallenge;
  final ValueChanged<String> onMode;
  final VoidCallback onStudio;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    return switch (tab) {
      _MyArenaTab.myRooms => _ChallengeListCard(
        challenges: snapshot.myRooms,
        emptyTitle: 'Chưa có phòng đang mở',
        emptyActionLabel: 'Tạo challenge',
        onEmptyAction: onStudio,
        onChallenge: onChallenge,
      ),
      _MyArenaTab.joined => _ChallengeListCard(
        challenges: snapshot.joinedChallenges,
        emptyTitle: 'Chưa tham gia challenge',
        emptyActionLabel: 'Khám phá Arena',
        onEmptyAction: onDiscover,
        onChallenge: onChallenge,
      ),
      _MyArenaTab.savedModes => _SavedModesList(
        modes: snapshot.savedModes,
        onMode: onMode,
        onDiscover: onDiscover,
      ),
      _MyArenaTab.drafts => _DraftList(
        drafts: snapshot.drafts,
        onStudio: onStudio,
      ),
      _MyArenaTab.history => _ChallengeListCard(
        challenges: snapshot.history,
        emptyTitle: 'Chưa có lịch sử',
        emptyActionLabel: 'Khám phá Arena',
        onEmptyAction: onDiscover,
        onChallenge: onChallenge,
      ),
    };
  }
}

class _ChallengeListCard extends StatelessWidget {
  const _ChallengeListCard({
    required this.challenges,
    required this.emptyTitle,
    required this.emptyActionLabel,
    required this.onEmptyAction,
    required this.onChallenge,
  });

  final List<ArenaChallengeDraft> challenges;
  final String emptyTitle;
  final String emptyActionLabel;
  final VoidCallback onEmptyAction;
  final ValueChanged<String> onChallenge;

  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return _EmptyCard(
        icon: Icons.auto_awesome_rounded,
        title: emptyTitle,
        actionLabel: emptyActionLabel,
        onAction: onEmptyAction,
      );
    }

    return VitCard(
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          for (var i = 0; i < challenges.length; i++)
            _ChallengeRow(
              challenge: challenges[i],
              showDivider: i < challenges.length - 1,
              onTap: () => onChallenge(challenges[i].id),
            ),
        ],
      ),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  const _ChallengeRow({
    required this.challenge,
    required this.showDivider,
    required this.onTap,
  });

  final ArenaChallengeDraft challenge;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _stateColor(challenge.state);
    return Material(
      key: MyArenaPage.challengeKey(challenge.id),
      type: MaterialType.transparency,
      child: VitCard(
        onTap: onTap,
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        child: Column(
          children: [
            Padding(
              padding: ArenaSpacingTokens.arenaProductionRegistryRowPadding,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(
                          height: AppSpacing.pageRhythmCompactInnerGap,
                        ),
                        Wrap(
                          spacing: AppSpacing.x2,
                          runSpacing: AppSpacing.x1,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _MetaText(challenge.format),
                            const _MetaDot(),
                            _MetaText(
                              '${challenge.slotsFilled}/${challenge.slotsTotal}',
                            ),
                            const _MetaDot(),
                            Text(
                              '${formatArenaPoints(challenge.entryPoints)} pts',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.warn,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ArenaStatusPill(
                        label: _stateLabel(challenge.state),
                        color: statusColor,
                      ),
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      Text(
                        'Xem',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (showDivider)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ),
      ),
    );
  }
}

class _SavedModesList extends StatelessWidget {
  const _SavedModesList({
    required this.modes,
    required this.onMode,
    required this.onDiscover,
  });

  final List<ArenaModeDraft> modes;
  final ValueChanged<String> onMode;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    if (modes.isEmpty) {
      return _EmptyCard(
        icon: Icons.bookmark_border_rounded,
        title: 'Chưa lưu mode nào',
        actionLabel: 'Khám phá mode',
        onAction: onDiscover,
      );
    }

    return VitCard(
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          for (var i = 0; i < modes.length; i++)
            Material(
              key: MyArenaPage.modeKey(modes[i].id),
              type: MaterialType.transparency,
              child: VitCard(
                onTap: () => onMode(modes[i].id),
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          ArenaSpacingTokens.arenaProductionRegistryRowPadding,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  modes[i].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: AppSpacing.pageRhythmCompactInnerGap,
                                ),
                                Wrap(
                                  spacing: AppSpacing.x2,
                                  runSpacing: AppSpacing.x1,
                                  children: [
                                    _MetaText(modes[i].creatorName),
                                    const _MetaDot(),
                                    _MetaText('${modes[i].cloneCount} clone'),
                                    const _MetaDot(),
                                    _MetaText(
                                      '${modes[i].activeChallenges} active',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x3),
                          if (modes[i].fairPlay)
                            const _ArenaStatusPill(
                              label: 'Fair play',
                              color: AppColors.buy,
                            ),
                        ],
                      ),
                    ),
                    if (i < modes.length - 1)
                      const Divider(
                        height: AppSpacing.dividerHairline,
                        color: AppColors.divider,
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

class _DraftList extends StatelessWidget {
  const _DraftList({required this.drafts, required this.onStudio});

  final List<ArenaDraftChallenge> drafts;
  final VoidCallback onStudio;

  @override
  Widget build(BuildContext context) {
    if (drafts.isEmpty) {
      return _EmptyCard(
        icon: Icons.edit_note_rounded,
        title: 'Không có bản nháp',
        actionLabel: 'Tạo mới',
        onAction: onStudio,
      );
    }

    return VitCard(
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          for (var i = 0; i < drafts.length; i++)
            Material(
              type: MaterialType.transparency,
              child: VitCard(
                onTap: onStudio,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          ArenaSpacingTokens.arenaProductionRegistryRowPadding,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: ArenaSpacingTokens.myArenaDraftIconBox,
                            height: ArenaSpacingTokens.myArenaDraftIconBox,
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                color: AppColors.surface2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadii.mdRadius,
                                ),
                              ),
                              child: Icon(
                                Icons.edit_note_rounded,
                                color: AppColors.text2,
                                size: ArenaSpacingTokens.myArenaDraftIcon,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  drafts[i].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: AppSpacing.pageRhythmCompactInnerGap,
                                ),
                                Row(
                                  children: [
                                    _MetaText(drafts[i].format),
                                    const _MetaDot(),
                                    _MetaText(drafts[i].updatedAt),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x3),
                          Text(
                            '${formatArenaPoints(drafts[i].entryPoints)} pts',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.warn,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < drafts.length - 1)
                      const Divider(
                        height: AppSpacing.dividerHairline,
                        color: AppColors.divider,
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

class _CreatedModesSection extends StatelessWidget {
  const _CreatedModesSection({required this.snapshot, required this.onTap});

  final MyArenaSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      density: VitDensity.compact,
      children: [
        VitModuleSectionHeader(
          title: 'Mode đã tạo (${snapshot.stats.modesCreated})',
          accentColor: AppColors.accent,
          density: VitDensity.compact,
        ),
        VitCard(
          onTap: onTap,
          density: VitDensity.compact,
          child: Row(
            children: [
              const _ActionIcon(
                icon: Icons.bar_chart_rounded,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${snapshot.stats.modesCreated} mode đã tạo',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      'Quản lý modes và xem thống kê',
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
                size: ArenaSpacingTokens.myArenaSectionChevron,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
