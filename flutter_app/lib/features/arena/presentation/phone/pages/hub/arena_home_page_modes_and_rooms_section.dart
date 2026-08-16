part of 'arena_home_page.dart';

class _FeaturedModesSection extends StatelessWidget {
  const _FeaturedModesSection({
    required this.modes,
    required this.onViewAll,
    required this.onMode,
  });

  final List<ArenaModeDraft> modes;
  final VoidCallback onViewAll;
  final ValueChanged<String> onMode;

  @override
  Widget build(BuildContext context) {
    if (modes.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitModuleSectionHeader(
            title: 'Mode nổi bật',
            accentColor: AppColors.primary,
            actionLabel: 'Xem tất cả',
            onAction: onViewAll,
            density: VitDensity.compact,
            bottomGap: 0,
          ),
          const VitEmptyState(
            icon: Icons.bookmark_border_rounded,
            title: 'Chưa có chế độ nổi bật',
            message: 'Các chế độ được cộng đồng yêu thích sẽ hiển thị tại đây.',
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitModuleSectionHeader(
              title: 'Mode nổi bật',
              accentColor: AppColors.primary,
              actionLabel: 'Xem tất cả',
              onAction: onViewAll,
              density: VitDensity.compact,
              bottomGap: 0,
            ),
            Text(
              'Được cộng đồng yêu thích',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final item in modes) ...[
                SizedBox(
                  width: ArenaSpacingTokens.arenaHomeModeCardWidth,
                  child: _ModeCard(mode: item, onTap: () => onMode(item.id)),
                ),
                if (item != modes.last) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode, required this.onTap});

  final ArenaModeDraft mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tags = mode.tags.take(2).join(' · ');
    return VitCard(
      key: ArenaHomePage.modeKey(mode.id),
      onTap: onTap,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ActionIcon(
                icon: _templateIcon(_kindForMode(mode.templateId)),
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  mode.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                    height: _arenaHomeModeTitleLineHeight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            mode.creatorName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              _MetaText('${mode.cloneCount} clone'),
              const _MetaDot(),
              _MetaText('${mode.completionRate}%'),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              if (mode.fairPlay)
                const VitStatusPill(
                  label: 'Fair Play',
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
              if (mode.fairPlay && tags.isNotEmpty)
                const SizedBox(width: AppSpacing.x2),
              if (tags.isNotEmpty)
                Expanded(
                  child: Text(
                    tags,
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
        ],
      ),
    );
  }
}

class _LiveRoomsSection extends StatelessWidget {
  const _LiveRoomsSection({
    required this.rooms,
    required this.onRoom,
    required this.onGuide,
  });

  final List<ArenaChallengeDraft> rooms;
  final ValueChanged<String> onRoom;
  final VoidCallback onGuide;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitModuleSectionHeader(
            title: 'Phòng đang mở',
            accentColor: AppColors.warn,
            density: VitDensity.compact,
          ),
          VitEmptyState(
            title: 'Chưa có phòng mở',
            message: 'Tạo thử thách mới hoặc tham gia mode nổi bật bên dưới.',
            icon: Icons.groups_2_outlined,
            actionLabel: 'Xem hướng dẫn',
            onAction: onGuide,
          ),
        ],
      );
    }

    final activeCount = rooms
        .where((item) => item.state != ArenaChallengeState.resolved)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: VitModuleSectionHeader(
                title: 'Phòng đang mở',
                accentColor: AppColors.warn,
                density: VitDensity.compact,
                bottomGap: 0,
              ),
            ),
            VitStatusPill(
              label: '$activeCount live',
              status: VitStatusPillStatus.success,
              size: VitStatusPillSize.sm,
              pulse: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Tham gia ngay hoặc xem',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          clip: true,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (var i = 0; i < rooms.length; i++) ...[
                _RoomRow(room: rooms[i], onTap: () => onRoom(rooms[i].id)),
                if (i < rooms.length - 1)
                  const Divider(
                    height: AppSpacing.x1,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomRow extends StatelessWidget {
  const _RoomRow({required this.room, required this.onTap});

  final ArenaChallengeDraft room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = room.slotsTotal == 0
        ? 0.0
        : (room.slotsFilled / room.slotsTotal).clamp(0.0, 1.0).toDouble();
    final color = _challengeStateColor(room.state);

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: ArenaHomePage.roomKey(room.id),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Row(
                          children: [
                            Flexible(child: _MetaText(room.format)),
                            const _MetaDot(),
                            const _MetaText('Công khai'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _challengeStateLabel(room.state),
                        style: AppTextStyles.micro.copyWith(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '${room.entryPoints} pts',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: AppRadii.xsRadius,
                      child: LinearProgressIndicator(
                        minHeight: _arenaHomeRoomProgressHeight,
                        value: progress,
                        backgroundColor: AppColors.surface3,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Text(
                    '${room.slotsFilled}/${room.slotsTotal}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreatorSpotlightSection extends StatelessWidget {
  const _CreatorSpotlightSection({
    required this.creators,
    required this.onCreator,
  });

  final List<ArenaCreatorDraft> creators;
  final ValueChanged<String> onCreator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Creator nổi bật',
          accentColor: AppColors.buy,
          density: VitDensity.compact,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              for (final creator in creators) ...[
                SizedBox(
                  width: ArenaSpacingTokens.arenaHomeCreatorCardWidth,
                  child: _CreatorCard(
                    creator: creator,
                    onTap: () => onCreator(creator.id),
                  ),
                ),
                if (creator != creators.last)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CreatorCard extends StatelessWidget {
  const _CreatorCard({required this.creator, required this.onTap});

  final ArenaCreatorDraft creator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaHomePage.creatorKey(creator.id),
      onTap: onTap,
      density: VitDensity.compact,
      child: Column(
        children: [
          const SizedBox(
            width: ArenaSpacingTokens.arenaHomeCreatorAvatar,
            height: ArenaSpacingTokens.arenaHomeCreatorAvatar,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardRadius,
                  side: BorderSide(color: AppColors.cardBorder),
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                color: AppColors.warn,
                size: ArenaSpacingTokens.arenaHomeCreatorIcon,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            creator.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${creator.modesCreated} modes · ${creator.totalChallenges} challenges',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.x1,
            runSpacing: AppSpacing.x1,
            children: [
              if (creator.fairPlay)
                const VitStatusPill(
                  label: 'Fair Play',
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
              VitStatusPill(
                label: '${creator.trustScore}% Trust',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PredictionBridge extends StatelessWidget {
  const _PredictionBridge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      borderColor: AppColors.accent20,
      density: VitDensity.compact,
      child: Row(
        children: [
          const _ActionIcon(
            icon: Icons.track_changes_rounded,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MARKET CONTEXT ONLY',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bối cảnh thị trường',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const VitStatusPill(
                      label: 'Prediction Market',
                      status: VitStatusPillStatus.purple,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Theo dõi các prediction events liên quan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  'Xem Prediction Markets',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.accent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.accent,
            size: ArenaSpacingTokens.arenaHomeBridgeChevron,
          ),
        ],
      ),
    );
  }
}
