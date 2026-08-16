part of 'arena_home_page.dart';

class _VerifiedTeaser extends StatelessWidget {
  const _VerifiedTeaser({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .72,
      child: VitCard(
        key: ArenaHomePage.verifiedTeaserKey,
        onTap: onTap,
        density: VitDensity.compact,
        child: Row(
          children: [
            const _ActionIcon(
              icon: Icons.lock_outline_rounded,
              color: AppColors.accent,
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Verified Challenges',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      const VitStatusPill(
                        label: 'Future',
                        status: VitStatusPillStatus.purple,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    'Sẽ mở trong tương lai cho challenge xác thực cao hơn',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: _arenaHomeVerifiedLineHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArenaFooter extends StatelessWidget {
  const _ArenaFooter({required this.onRules});

  final VoidCallback onRules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCommunityRulesLink(onTap: onRules),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          density: VitDensity.compact,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.accent,
                size: ArenaSpacingTokens.arenaHomeFooterShieldIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính. Không thỏa thuận giao dịch ngoài nền tảng.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _arenaHomeFooterLineHeight,
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

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.query,
    required this.snapshot,
    required this.onMode,
    required this.onRoom,
    required this.onCreator,
  });

  final String query;
  final ArenaHomeSnapshot snapshot;
  final ValueChanged<String> onMode;
  final ValueChanged<String> onRoom;
  final ValueChanged<String> onCreator;

  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final modes = snapshot.featuredModes
        .where(
          (item) =>
              item.title.toLowerCase().contains(normalized) ||
              item.creatorName.toLowerCase().contains(normalized) ||
              item.tags.any((tag) => tag.toLowerCase().contains(normalized)),
        )
        .toList();
    final rooms = snapshot.liveRooms
        .where(
          (item) =>
              item.title.toLowerCase().contains(normalized) ||
              item.format.toLowerCase().contains(normalized),
        )
        .toList();
    final creators = snapshot.creators
        .where((item) => item.name.toLowerCase().contains(normalized))
        .toList();
    final total = modes.length + rooms.length + creators.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          total == 0
              ? 'Không tìm thấy kết quả cho "$query"'
              : '$total kết quả cho "$query"',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        if (modes.isNotEmpty) ...[
          VitModuleSectionHeader(
            title: 'Modes (${modes.length})',
            accentColor: AppColors.primary,
            density: VitDensity.compact,
          ),
          for (final mode in modes) ...[
            _SearchRow(
              icon: _templateIcon(_kindForMode(mode.templateId)),
              title: mode.title,
              subtitle: '${mode.creatorName} · ${mode.cloneCount} clone',
              color: AppColors.primary,
              onTap: () => onMode(mode.id),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
        if (rooms.isNotEmpty) ...[
          VitModuleSectionHeader(
            title: 'Phòng (${rooms.length})',
            accentColor: AppColors.warn,
            density: VitDensity.compact,
          ),
          for (final room in rooms) ...[
            _SearchRow(
              icon: Icons.groups_2_outlined,
              title: room.title,
              subtitle:
                  '${room.format} · ${room.slotsFilled}/${room.slotsTotal}',
              color: _challengeStateColor(room.state),
              onTap: () => onRoom(room.id),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
        if (creators.isNotEmpty) ...[
          VitModuleSectionHeader(
            title: 'Creators (${creators.length})',
            accentColor: AppColors.buy,
            density: VitDensity.compact,
          ),
          for (final creator in creators) ...[
            _SearchRow(
              icon: Icons.person_rounded,
              title: creator.name,
              subtitle:
                  '${creator.modesCreated} modes · ${creator.trustScore}% trust',
              color: AppColors.buy,
              onTap: () => onCreator(creator.id),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
        if (total == 0)
          const VitEmptyState(
            title: 'Không tìm thấy kết quả',
            message: 'Thử tìm với từ khóa khác hoặc xóa bộ lọc',
            icon: Icons.search_rounded,
          ),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      onTap: onTap,
      density: VitDensity.compact,
      child: Row(
        children: [
          _ActionIcon(icon: icon, color: color),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: ArenaSpacingTokens.arenaHomeSearchChevron,
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ArenaSpacingTokens.arenaHomeActionIconBox,
      height: ArenaSpacingTokens.arenaHomeActionIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.mdRadius,
            side: BorderSide(color: color.withValues(alpha: .18)),
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: ArenaSpacingTokens.arenaHomeActionIcon,
        ),
      ),
    );
  }
}

class _MiniCountBadge extends StatelessWidget {
  const _MiniCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: ArenaSpacingTokens.arenaHomeCountBadgeMinWidth,
      ),
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.sell,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
        ),
        child: Padding(
          padding: ArenaSpacingTokens.arenaHomeCountBadgePadding,
          child: Center(
            child: Text(
              count > 99 ? '99+' : '$count',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
                height: _arenaHomeCountBadgeLineHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

class _MetaDot extends StatelessWidget {
  const _MetaDot();

  @override
  Widget build(BuildContext context) {
    return Text(
      '·',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}

IconData _templateIcon(ArenaTemplateKind kind) {
  return switch (kind) {
    ArenaTemplateKind.prediction => Icons.track_changes_rounded,
    ArenaTemplateKind.closestGuess => Icons.pin_outlined,
    ArenaTemplateKind.teamBattle => Icons.sports_mma_rounded,
    ArenaTemplateKind.bracket => Icons.emoji_events_outlined,
    ArenaTemplateKind.vote => Icons.how_to_vote_outlined,
    ArenaTemplateKind.proof => Icons.verified_user_outlined,
  };
}

int _countActiveArenaChallenges(List<ArenaChallengeDraft> rooms) {
  return rooms
      .where(
        (room) =>
            room.state != ArenaChallengeState.resolved &&
            room.state != ArenaChallengeState.canceled,
      )
      .length;
}

Color _templateColor(ArenaTemplateKind kind) {
  return switch (kind) {
    ArenaTemplateKind.prediction => AppColors.sell,
    ArenaTemplateKind.closestGuess => AppColors.primary,
    ArenaTemplateKind.teamBattle => AppColors.accent,
    ArenaTemplateKind.bracket => AppColors.warn,
    ArenaTemplateKind.vote => AppColors.buy,
    ArenaTemplateKind.proof => AppColors.text2,
  };
}

ArenaTemplateKind _kindForMode(String templateId) {
  return switch (templateId) {
    'team_battle' => ArenaTemplateKind.teamBattle,
    'community_vote' => ArenaTemplateKind.vote,
    _ => ArenaTemplateKind.closestGuess,
  };
}

String _challengeStateLabel(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => 'Chờ tham gia',
    ArenaChallengeState.full => 'Đã đầy',
    ArenaChallengeState.live => 'Đang diễn ra',
    ArenaChallengeState.pendingResult => 'Chờ kết quả',
    ArenaChallengeState.resolved => 'Hoàn tất',
    ArenaChallengeState.canceled => 'Đã hủy',
  };
}

Color _challengeStateColor(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.open => AppColors.primary,
    ArenaChallengeState.full => AppColors.warn,
    ArenaChallengeState.live => AppColors.warn,
    ArenaChallengeState.pendingResult => AppColors.accent,
    ArenaChallengeState.resolved => AppColors.buy,
    ArenaChallengeState.canceled => AppColors.sell,
  };
}
