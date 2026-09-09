part of 'arena_tablet_pages.dart';

// Bước 2 (tiếp): Studio, Sân chơi của tôi, Bảng xếp hạng — tách khỏi
// _hubs.dart theo trần file lớn (<1200 dòng, architecture size debt).

/// SC-185: Studio — quy trình + mẫu thử thách (grid 2 cột) ở cột chính;
/// tín hiệu tin cậy + lối công cụ ở cột phụ.
class ArenaStudioTabletPage extends ConsumerWidget {
  const ArenaStudioTabletPage({super.key});

  static const contentKey = Key('sc185_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaStudioSnapshotProvider);

    return _ArenaHubScaffold(
      semanticIdentifier: 'SC-185',
      semanticLabel: 'Studio đấu trường',
      title: 'Studio',
      subtitle: 'Tạo · Mẫu · Quy tắc',
      snapshotAsync: snapshotAsync,
      onRetry: () => ref.invalidate(arenaStudioSnapshotProvider),
      buildDashboard: () {
        final snapshot = snapshotAsync.value as ArenaStudioSnapshot;
        return VitTwoColumnTabletDashboard(
          primaryChildren: [
            VitModuleHeroCard(
              accentColor: AppModuleAccents.arena,
              density: VitDensity.compact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Xưởng tạo thử thách',
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontWeight: AppTextStyles.heavy,
                          ),
                        ),
                      ),
                      VitStatusPill(
                        label: 'Phí nền tảng ${snapshot.platformFeePct}%',
                        status: VitStatusPillStatus.info,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Row(
                    children: [
                      Expanded(
                        child: _ArenaHeroKpi(
                          label: 'Mẫu sẵn có',
                          value: '${snapshot.templates.length}',
                        ),
                      ),
                      const SizedBox(
                        width: TabletSpacingTokens.x4,
                        height: TabletSpacingTokens.x6,
                        child: ColoredBox(color: AppColors.border),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: TabletSpacingTokens.x4,
                          ),
                          child: _ArenaHeroKpi(
                            label: 'Bước quy trình',
                            value: '${snapshot.steps.length}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _ArenaHubSection(
              title: 'Quy trình Studio',
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  children: [
                    for (final step in snapshot.steps)
                      _ArenaStepRow(
                        stepNumber: step.index,
                        title: step.label,
                        description: '',
                      ),
                  ],
                ),
              ),
            ),
            _ArenaHubSection(
              title: 'Mẫu thử thách',
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.templates.length; i += 2)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        bottom: i + 2 < snapshot.templates.length
                            ? TabletSpacingTokens.cardGap
                            : TabletSpacingTokens.zero,
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _ArenaStudioTemplateTile(
                                template: snapshot.templates[i],
                              ),
                            ),
                            const SizedBox(width: TabletSpacingTokens.cardGap),
                            if (i + 1 < snapshot.templates.length)
                              Expanded(
                                child: _ArenaStudioTemplateTile(
                                  template: snapshot.templates[i + 1],
                                ),
                              )
                            else
                              const Expanded(child: SizedBox.shrink()),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          secondaryChildren: [
            _ArenaHubPanel(
              title: 'Tín hiệu tin cậy',
              children: [
                for (final signal in snapshot.trustSignals)
                  VitInfoRow(
                    label: signal.label,
                    value: signal.value,
                    density: VitDensity.compact,
                  ),
              ],
            ),
            _ArenaQuickActions(
              pendingNotifications: 0,
              onNavigate: (path) => context.push(path),
              overrides: const [
                (
                  icon: Icons.dashboard_customize_outlined,
                  label: 'Thư viện preset',
                  path: AppRoutePaths.arenaStudioPresets,
                ),
                (
                  icon: Icons.rule_folder_outlined,
                  label: 'Luật thông minh',
                  path: AppRoutePaths.arenaStudioSmartRules,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ArenaStudioTemplateTile extends StatelessWidget {
  const _ArenaStudioTemplateTile({required this.template});

  final ArenaStudioTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      onTap: () => context.push(AppRoutePaths.arenaStudioPresets),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  template.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              if (template.verifiedOnly)
                const VitStatusPill(
                  label: 'Cần xác thực',
                  status: VitStatusPillStatus.purple,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            template.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Wrap(
            spacing: TabletSpacingTokens.x2,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              VitStatusPill(
                label: template.complexity,
                status: VitStatusPillStatus.neutral,
                size: VitStatusPillSize.sm,
              ),
              for (final tag in template.formatTags.take(2))
                VitStatusPill(
                  label: tag,
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

/// SC-205: Sân chơi của tôi — hero tổng quan + phòng đang tham gia/của tôi
/// ở cột chính; số liệu, mode đã lưu, nháp ở cột phụ.
class MyArenaTabletPage extends ConsumerWidget {
  const MyArenaTabletPage({super.key});

  static const contentKey = Key('sc205_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(myArenaSnapshotProvider);

    return _ArenaHubScaffold(
      semanticIdentifier: 'SC-205',
      semanticLabel: 'Sân chơi của tôi',
      title: 'Sân chơi của tôi',
      subtitle: 'Đang tham gia · Đã lưu · Nháp',
      snapshotAsync: snapshotAsync,
      onRetry: () => ref.invalidate(myArenaSnapshotProvider),
      buildDashboard: () {
        final snapshot = snapshotAsync.value as MyArenaSnapshot;
        final stats = snapshot.stats;
        return VitTwoColumnTabletDashboard(
          primaryChildren: [
            VitModuleHeroCard(
              accentColor: AppModuleAccents.arena,
              density: VitDensity.compact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tổng quan sân chơi',
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontWeight: AppTextStyles.heavy,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Row(
                    children: [
                      Expanded(
                        child: _ArenaHeroKpi(
                          label: 'Điểm hiện có',
                          value: formatArenaPoints(stats.currentBalance),
                        ),
                      ),
                      const SizedBox(
                        width: TabletSpacingTokens.x4,
                        height: TabletSpacingTokens.x6,
                        child: ColoredBox(color: AppColors.border),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: TabletSpacingTokens.x4,
                          ),
                          child: _ArenaHeroKpi(
                            label: 'Đang tham gia',
                            value: '${stats.activeChallenges}',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: TabletSpacingTokens.x4,
                        height: TabletSpacingTokens.x6,
                        child: ColoredBox(color: AppColors.border),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: TabletSpacingTokens.x4,
                          ),
                          child: _ArenaHeroKpi(
                            label: 'Hạng của bạn',
                            value: '#${stats.rank}',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _ArenaChallengeListSection(
              title: 'Đang tham gia',
              rooms: snapshot.joinedChallenges,
            ),
            _ArenaChallengeListSection(
              title: 'Phòng do tôi tạo',
              rooms: snapshot.myRooms,
            ),
          ],
          secondaryChildren: [
            _ArenaHubPanel(
              title: 'Số liệu',
              children: [
                VitInfoRow(
                  label: 'Điểm đã kiếm',
                  value: formatArenaPoints(stats.pointsEarned),
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'Điểm đã dùng',
                  value: formatArenaPoints(stats.pointsSpent),
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'Điểm creator',
                  value: '${stats.creatorScore}',
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'Mode đã tạo',
                  value: '${stats.modesCreated}',
                  density: VitDensity.compact,
                  showDivider: false,
                ),
              ],
            ),
            if (snapshot.savedModes.isNotEmpty)
              _ArenaHubPanel(
                title: 'Mode đã lưu',
                children: [
                  for (final mode in snapshot.savedModes.take(4))
                    _ArenaIconTextRow(
                      icon: Icons.bookmark_border_rounded,
                      color: AppModuleAccents.arena,
                      title: mode.title,
                      subtitle: 'bởi ${mode.creatorName}',
                    ),
                ],
              ),
            if (snapshot.drafts.isNotEmpty)
              _ArenaHubPanel(
                title: 'Nháp thử thách',
                children: [
                  for (final draft in snapshot.drafts.take(4))
                    _ArenaIconTextRow(
                      icon: Icons.edit_note_rounded,
                      color: AppColors.text3,
                      title: draft.title,
                      subtitle: 'Cập nhật ${draft.updatedAt}',
                      trailing: Text(
                        formatArenaPoints(draft.entryPoints),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                ],
              ),
            _ArenaHubPanel(
              title: 'Phần thưởng đã nhận',
              children: [
                VitInfoRow(
                  label: 'Tổng phiếu nhận',
                  value: '${snapshot.rewardHistory.totalReceipts}',
                  density: VitDensity.compact,
                ),
                VitInfoRow(
                  label: 'Phiếu lớn nhất',
                  value: formatArenaPoints(
                    snapshot.rewardHistory.largestReceipt,
                  ),
                  density: VitDensity.compact,
                  showDivider: false,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Danh sách phòng dùng chung cho MyArena (đang tham gia / phòng của tôi).
class _ArenaChallengeListSection extends StatelessWidget {
  const _ArenaChallengeListSection({required this.title, required this.rooms});

  final String title;
  final List<ArenaChallengeDraft> rooms;

  @override
  Widget build(BuildContext context) {
    if (rooms.isEmpty) {
      return const SizedBox.shrink();
    }
    return _ArenaHubSection(
      title: title,
      child: VitCard(
        radius: VitCardRadius.tight,
        padding: TabletSpacingTokens.zeroInsets,
        clip: true,
        child: Column(
          children: [
            for (var i = 0; i < rooms.length; i++) ...[
              _ArenaRoomTile(
                room: rooms[i],
                onTap: () =>
                    context.push(AppRoutePaths.arenaChallenge(rooms[i].id)),
              ),
              if (i < rooms.length - 1)
                const Divider(
                  height: TabletSpacingTokens.dividerHairline,
                  color: AppColors.divider,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// SC-194: Bảng xếp hạng — hạng của bạn + bảng đầy đủ ở cột chính; đang lên
/// mạnh + bộ lọc ở cột phụ.
class ArenaLeaderboardTabletPage extends ConsumerWidget {
  const ArenaLeaderboardTabletPage({super.key});

  static const contentKey = Key('sc194_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaLeaderboardSnapshotProvider);

    return _ArenaHubScaffold(
      semanticIdentifier: 'SC-194',
      semanticLabel: 'Bảng xếp hạng đấu trường',
      title: 'Bảng xếp hạng',
      subtitle: 'Hạng · Điểm · Creator',
      snapshotAsync: snapshotAsync,
      onRetry: () => ref.invalidate(arenaLeaderboardSnapshotProvider),
      buildDashboard: () {
        final snapshot = snapshotAsync.value as ArenaLeaderboardSnapshot;
        final entries = [...snapshot.podium, ...snapshot.topCreators];
        return VitTwoColumnTabletDashboard(
          primaryChildren: [
            VitModuleHeroCard(
              accentColor: AppModuleAccents.arena,
              density: VitDensity.compact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hạng của bạn',
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontWeight: AppTextStyles.heavy,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Row(
                    children: [
                      Expanded(
                        child: _ArenaHeroKpi(
                          label: 'Hạng hiện tại',
                          value: '#${snapshot.myRank.rank}',
                        ),
                      ),
                      const SizedBox(
                        width: TabletSpacingTokens.x4,
                        height: TabletSpacingTokens.x6,
                        child: ColoredBox(color: AppColors.border),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: TabletSpacingTokens.x4,
                          ),
                          child: _ArenaHeroKpi(
                            label: 'Điểm của bạn',
                            value: snapshot.myRank.pointsLabel,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TabletSpacingTokens.x2),
                  Text(
                    snapshot.myRank.summary,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
            _ArenaHubSection(
              title: 'Xếp hạng chung',
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.zeroInsets,
                clip: true,
                child: Column(
                  children: [
                    for (var i = 0; i < entries.length; i++) ...[
                      _ArenaLeaderboardRow(entry: entries[i]),
                      if (i < entries.length - 1)
                        const Divider(
                          height: TabletSpacingTokens.dividerHairline,
                          color: AppColors.divider,
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          secondaryChildren: [
            if (snapshot.risingCreators.isNotEmpty)
              _ArenaHubPanel(
                title: 'Đang lên mạnh',
                children: [
                  for (final entry in snapshot.risingCreators)
                    _ArenaIconTextRow(
                      icon: Icons.trending_up_rounded,
                      color: AppColors.successAccentBright,
                      title: '#${entry.rank} ${entry.name}',
                      subtitle: entry.subtitle,
                      trailing: Text(
                        entry.value,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                ],
              ),
            if (snapshot.seasonFilters.isNotEmpty)
              _ArenaHubPanel(
                title: 'Giai đoạn',
                children: [
                  Wrap(
                    spacing: TabletSpacingTokens.x2,
                    runSpacing: TabletSpacingTokens.x2,
                    children: [
                      for (final filter in snapshot.seasonFilters)
                        VitStatusPill(
                          label: filter.label,
                          status: VitStatusPillStatus.neutral,
                          size: VitStatusPillSize.sm,
                        ),
                    ],
                  ),
                ],
              ),
            if (snapshot.disclaimer.isNotEmpty)
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                variant: VitCardVariant.ghost,
                child: Text(
                  snapshot.disclaimer,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ArenaLeaderboardRow extends StatelessWidget {
  const _ArenaLeaderboardRow({required this.entry});

  final ArenaLeaderboardEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    final isTop3 = entry.rank <= 3;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: TabletSpacingTokens.x4,
        vertical: TabletSpacingTokens.x3,
      ),
      child: Row(
        children: [
          SizedBox(
            width: TabletSpacingTokens.x7,
            child: isTop3
                ? VitAccentIconBox(
                    icon: Icons.emoji_events_rounded,
                    color: entry.rank == 1 ? AppColors.warn : AppColors.text3,
                  )
                : Text(
                    '#${entry.rank}',
                    style: AppTextStyles.control.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
                if (entry.subtitle.isNotEmpty) ...[
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    entry.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            entry.value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
