part of 'arena_tablet_pages.dart';

/// SC-184: Hub Open Arena — composition tablet 2 cột (mockup chốt
/// 2026-09-09, tham chiếu phone arena home): cột chính = hero KPI + phòng
/// đang mở (progress slot, trạng thái live) + chế độ nổi bật (grid 2 cột);
/// cột phụ = tìm kiếm live, quick actions, sân chơi của tôi, creator nổi
/// bật, cầu nối Prediction, thử thách đã xác thực. Copy giữ biên
/// points-only của Arena.
class ArenaHomeTabletPage extends ConsumerStatefulWidget {
  const ArenaHomeTabletPage({super.key});

  static const contentKey = Key('sc184_tablet_content');
  static const searchKey = Key('sc184_tablet_search');
  static const createChallengeKey = Key('sc184_tablet_create_challenge');
  static const exploreModesKey = Key('sc184_tablet_explore_modes');
  static const myArenaActionKey = Key('sc184_tablet_my_arena_action');
  static const toolsActionKey = Key('sc184_tablet_tools_action');

  static Key roomKey(String id) => Key('sc184_tablet_room_$id');
  static Key modeKey(String id) => Key('sc184_tablet_mode_$id');
  static Key creatorKey(String id) => Key('sc184_tablet_creator_$id');

  @override
  ConsumerState<ArenaHomeTabletPage> createState() =>
      _ArenaHomeTabletPageState();
}

class _ArenaHomeTabletPageState extends ConsumerState<ArenaHomeTabletPage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _modesAnchorKey = GlobalKey();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaHomeSnapshotProvider);
    // Provider phụ (không chặn trang): đọc `.value` lười như phone home —
    // ẩn số dư điểm khi chưa resolve thay vì lồng thêm tầng `.when()`.
    final pointsBalance =
        ref.watch(arenaPointsSnapshotProvider).value?.summary.currentBalance ??
        0;
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Đấu trường mở',
      semanticIdentifier: 'SC-184',
      child: Column(
        children: [
          VitHeader(
            title: 'Open Arena',
            subtitle: 'Điểm Arena · thách đấu · hoàn thành',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.home,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            actions: [
              VitHeaderActionItem(
                key: ArenaHomeTabletPage.myArenaActionKey,
                type: VitHeaderActionType.portfolio,
                tooltip: 'Sân chơi của tôi',
                onPressed: () => context.push(AppRoutePaths.arenaMy),
              ),
              VitHeaderActionItem(
                key: ArenaHomeTabletPage.toolsActionKey,
                type: VitHeaderActionType.more,
                tooltip: 'Công cụ',
                onPressed: _showToolsSheet,
              ),
            ],
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 8)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: _ardError(
                  'Không tải được Open Arena',
                  () => ref.invalidate(arenaHomeSnapshotProvider),
                ),
              ),
              data: (snapshot) =>
                  _buildDashboard(snapshot, pointsBalance: pointsBalance),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(
    ArenaHomeSnapshot snapshot, {
    required int pointsBalance,
  }) {
    final query = _query.trim().toLowerCase();
    final hasQuery = query.length >= 2;

    Iterable<ArenaChallengeDraft> rooms = snapshot.liveRooms;
    Iterable<ArenaModeDraft> modes = snapshot.featuredModes;
    Iterable<ArenaCreatorDraft> creators = snapshot.creators;
    if (hasQuery) {
      rooms = rooms.where(
        (room) =>
            room.title.toLowerCase().contains(query) ||
            room.format.toLowerCase().contains(query),
      );
      modes = modes.where(
        (mode) =>
            mode.title.toLowerCase().contains(query) ||
            mode.creatorName.toLowerCase().contains(query),
      );
      creators = creators.where(
        (creator) => creator.name.toLowerCase().contains(query),
      );
    }

    return VitTwoColumnTabletDashboard(
      primaryChildren: [
        _ArenaHeroCard(
          pointsBalance: pointsBalance,
          activeChallenges: _countActiveChallenges(snapshot.liveRooms),
          onCreate: () => context.push(AppRoutePaths.arenaStudio),
          onExplore: _scrollToModes,
        ),
        _ArenaLiveRoomsSection(
          rooms: rooms.toList(),
          hasQuery: hasQuery,
          onRoom: (id) => context.push(AppRoutePaths.arenaChallenge(id)),
          onGuide: () => context.push(AppRoutePaths.arenaGuide),
        ),
        _ArenaFeaturedModesSection(
          modes: modes.toList(),
          anchorKey: _modesAnchorKey,
          onMode: (id) => context.push(AppRoutePaths.arenaMode(id)),
          onViewAll: () => context.push(AppRoutePaths.arenaLeaderboard),
        ),
      ],
      secondaryChildren: [
        _ArenaSideSearch(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          onClear: () => setState(() => _query = ''),
        ),
        _ArenaQuickActions(
          pendingNotifications: snapshot.pendingNotifications,
          onNavigate: (path) => context.push(path),
        ),
        _ArenaMyArenaPanel(
          pointsBalance: pointsBalance,
          pendingNotifications: snapshot.pendingNotifications,
          onOpen: () => context.push(AppRoutePaths.arenaMy),
        ),
        if (creators.isNotEmpty)
          _ArenaCreatorSpotlight(
            creators: creators.take(3).toList(),
            onCreator: (id) => context.push(AppRoutePaths.arenaCreator(id)),
          ),
        const _ArenaPredictionBridgeCard(),
        const _ArenaVerifiedTeaserCard(),
        const _ArenaRulesFooterCard(),
      ],
    );
  }

  int _countActiveChallenges(List<ArenaChallengeDraft> rooms) {
    return rooms
        .where((room) => room.state != ArenaChallengeState.resolved)
        .length;
  }

  void _scrollToModes() {
    final anchorContext = _modesAnchorKey.currentContext;
    if (anchorContext == null) return;
    unawaited(
      Scrollable.ensureVisible(
        anchorContext,
        duration: AppMotion.surface,
        curve: AppMotion.enter,
      ),
    );
  }

  void _showToolsSheet() {
    final rootContext = context;
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        builder: (sheetContext) {
          return _ArenaToolsSheet(
            onNavigate: (route) {
              Navigator.of(sheetContext).pop();
              rootContext.go(route);
            },
          );
        },
      ),
    );
  }
}

/// Hero module: 2 KPI (điểm Arena · thử thách đang chạy) + 2 CTA —
/// thừa hưởng composition `_HeroCard` phone, tái compose bằng ladder tablet.
class _ArenaHeroCard extends StatelessWidget {
  const _ArenaHeroCard({
    required this.pointsBalance,
    required this.activeChallenges,
    required this.onCreate,
    required this.onExplore,
  });

  final int pointsBalance;
  final int activeChallenges;
  final VoidCallback onCreate;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppModuleAccents.arena,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Thử thách cộng đồng',
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
          const SizedBox(height: TabletSpacingTokens.x4),
          Row(
            children: [
              Expanded(
                child: _ArenaHeroKpi(
                  label: 'Điểm Arena',
                  value: formatArenaPoints(pointsBalance),
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
                    label: 'Thử thách đang chạy',
                    value: '$activeChallenges',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: ArenaHomeTabletPage.createChallengeKey,
                  variant: VitCtaButtonVariant.secondary,
                  leading: const Icon(Icons.add_rounded),
                  onPressed: onCreate,
                  child: const Text('Tạo thử thách'),
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: VitCtaButton(
                  key: ArenaHomeTabletPage.exploreModesKey,
                  variant: VitCtaButtonVariant.ghost,
                  leading: const Icon(Icons.explore_outlined),
                  onPressed: onExplore,
                  child: const Text('Khám phá mode'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArenaHeroKpi extends StatelessWidget {
  const _ArenaHeroKpi({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.heroNumber.copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}

/// Phòng đang mở: hàng dữ liệu đầy đủ (format, trạng thái, slot progress,
/// điểm vào/giải) — thay danh sách chữ trần của bản GĐ5.
class _ArenaLiveRoomsSection extends StatelessWidget {
  const _ArenaLiveRoomsSection({
    required this.rooms,
    required this.hasQuery,
    required this.onRoom,
    required this.onGuide,
  });

  final List<ArenaChallengeDraft> rooms;
  final bool hasQuery;
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
            bottomGap: TabletSpacingTokens.x4,
          ),
          VitEmptyState(
            title: hasQuery
                ? 'Không có phòng khớp tìm kiếm'
                : 'Chưa có phòng mở',
            message: hasQuery
                ? 'Thử từ khoá khác hoặc tạo thử thách mới trong Studio.'
                : 'Tạo thử thách mới hoặc tham gia chế độ nổi bật bên dưới.',
            icon: Icons.groups_2_outlined,
            actionLabel: 'Xem hướng dẫn',
            onAction: onGuide,
          ),
        ],
      );
    }

    final liveCount = rooms
        .where((room) => room.state == ArenaChallengeState.live)
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
                bottomGap: TabletSpacingTokens.x4,
              ),
            ),
            if (liveCount > 0)
              VitStatusPill(
                label: '$liveCount live',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
                pulse: true,
              ),
          ],
        ),
        VitCard(
          radius: VitCardRadius.tight,
          padding: TabletSpacingTokens.zeroInsets,
          clip: true,
          child: Column(
            children: [
              for (var i = 0; i < rooms.length; i++) ...[
                _ArenaRoomTile(
                  room: rooms[i],
                  onTap: () => onRoom(rooms[i].id),
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
      ],
    );
  }
}

class _ArenaRoomTile extends StatelessWidget {
  const _ArenaRoomTile({required this.room, required this.onTap});

  final ArenaChallengeDraft room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = room.slotsTotal == 0
        ? 0.0
        : (room.slotsFilled / room.slotsTotal).clamp(0.0, 1.0).toDouble();

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: ArenaHomeTabletPage.roomKey(room.id),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: TabletSpacingTokens.x4,
            vertical: TabletSpacingTokens.x3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Wrap(
                          spacing: TabletSpacingTokens.x2,
                          runSpacing: TabletSpacingTokens.x2,
                          children: [
                            VitStatusPill(
                              label: room.format,
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            ),
                            VitStatusPill(
                              label: room.state.viLabel,
                              status: _statePillStatus(room.state),
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Vào ${formatArenaPoints(room.entryPoints)} điểm',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x1),
                      Text(
                        'Tổng giải ${formatArenaPoints(room.prizePool)} điểm',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x2),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      minHeight: TabletSpacingTokens.x2,
                      value: progress,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.x3),
                  Text(
                    '${room.slotsFilled}/${room.slotsTotal} slot',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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

VitStatusPillStatus _statePillStatus(ArenaChallengeState state) {
  return switch (state) {
    ArenaChallengeState.live => VitStatusPillStatus.success,
    ArenaChallengeState.open => VitStatusPillStatus.info,
    ArenaChallengeState.full => VitStatusPillStatus.warning,
    ArenaChallengeState.pendingResult => VitStatusPillStatus.purple,
    ArenaChallengeState.resolved ||
    ArenaChallengeState.canceled => VitStatusPillStatus.neutral,
  };
}

/// Chế độ nổi bật: grid 2 cột tile (tên · creator · clone · hoàn thành) —
/// thay 3 dòng chữ trần của bản GĐ5.
class _ArenaFeaturedModesSection extends StatelessWidget {
  const _ArenaFeaturedModesSection({
    required this.modes,
    required this.anchorKey,
    required this.onMode,
    required this.onViewAll,
  });

  final List<ArenaModeDraft> modes;
  final Key anchorKey;
  final ValueChanged<String> onMode;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    if (modes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      key: anchorKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitModuleSectionHeader(
          title: 'Chế độ nổi bật',
          accentColor: AppModuleAccents.arena,
          density: VitDensity.compact,
          actionLabel: 'Xem tất cả',
          onAction: onViewAll,
          bottomGap: TabletSpacingTokens.x4,
        ),
        for (var i = 0; i < modes.length; i += 2)
          Padding(
            padding: EdgeInsetsDirectional.only(
              bottom: i + 2 < modes.length ? TabletSpacingTokens.cardGap : 0,
            ),
            // IntrinsicHeight để 2 tile ngang cao bằng nhau — Row stretch
            // trong scroll (chiều cao không giới hạn) gây constraint vô hạn.
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _ArenaModeTile(
                      mode: modes[i],
                      onTap: () => onMode(modes[i].id),
                    ),
                  ),
                  const SizedBox(width: TabletSpacingTokens.cardGap),
                  if (i + 1 < modes.length)
                    Expanded(
                      child: _ArenaModeTile(
                        mode: modes[i + 1],
                        onTap: () => onMode(modes[i + 1].id),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ArenaModeTile extends StatelessWidget {
  const _ArenaModeTile({required this.mode, required this.onTap});

  final ArenaModeDraft mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaHomeTabletPage.modeKey(mode.id),
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mode.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            'bởi ${mode.creatorName} · ${mode.cloneCount} lượt dùng',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          // Wrap spaceBetween: tile hẹp (2 cột ở single-column fallback) tự
          // xuống dòng thay vì RenderFlex overflow như Row + Spacer.
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              if (mode.fairPlay)
                const VitStatusPill(
                  label: 'Fair-play',
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
              Text(
                'Hoàn thành ${mode.completionRate}%',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Cột phụ: tìm kiếm live lọc cả 2 cột theo query.
class _ArenaSideSearch extends StatelessWidget {
  const _ArenaSideSearch({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: VitSearchBar(
        key: ArenaHomeTabletPage.searchKey,
        controller: controller,
        placeholder: 'Tìm mode, creator hoặc thử thách',
        variant: VitSearchBarVariant.compact,
        onChanged: onChanged,
        onClear: onClear,
      ),
    );
  }
}

class _ArenaQuickActions extends StatelessWidget {
  const _ArenaQuickActions({
    required this.pendingNotifications,
    required this.onNavigate,
    this.overrides = const [],
  });

  final int pendingNotifications;
  final ValueChanged<String> onNavigate;

  /// Hàng thay thế bộ mặc định — hub con dùng lối tắt liên quan tới chính nó.
  final List<({IconData icon, String label, String path})> overrides;

  @override
  Widget build(BuildContext context) {
    final rows = overrides.isNotEmpty
        ? [
            for (final item in overrides)
              _ArenaQuickActionRow(
                icon: item.icon,
                label: item.label,
                onTap: () => onNavigate(item.path),
              ),
          ]
        : [
            _ArenaQuickActionRow(
              icon: Icons.menu_book_outlined,
              label: 'Hướng dẫn',
              onTap: () => onNavigate(AppRoutePaths.arenaGuide),
            ),
            _ArenaQuickActionRow(
              icon: Icons.emoji_events_outlined,
              label: 'Bảng xếp hạng',
              onTap: () => onNavigate(AppRoutePaths.arenaLeaderboard),
            ),
            _ArenaQuickActionRow(
              icon: Icons.card_giftcard_rounded,
              label: 'Phần thưởng',
              onTap: () => onNavigate('${AppRoutePaths.rewards}?tab=arena'),
            ),
            _ArenaQuickActionRow(
              icon: Icons.stars_outlined,
              label: 'Điểm Arena',
              onTap: () => onNavigate(AppRoutePaths.arenaPoints),
            ),
            _ArenaQuickActionRow(
              icon: Icons.star_border_rounded,
              label: 'Sân chơi của tôi',
              badgeCount: pendingNotifications,
              onTap: () => onNavigate(AppRoutePaths.arenaMy),
            ),
          ];
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(children: rows),
    );
  }
}

class _ArenaQuickActionRow extends StatelessWidget {
  const _ArenaQuickActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: TabletSpacingTokens.x4,
            vertical: TabletSpacingTokens.x3,
          ),
          child: Row(
            children: [
              VitAccentIconBox(icon: icon, color: AppModuleAccents.arena),
              const SizedBox(width: TabletSpacingTokens.x3),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.control.copyWith(color: AppColors.text1),
                ),
              ),
              if (badgeCount > 0)
                VitStatusPill(
                  label: '$badgeCount',
                  status: VitStatusPillStatus.orange,
                  size: VitStatusPillSize.sm,
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  size: TabletSpacingTokens.iconMd,
                  color: AppColors.text3,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tổng quan sân chơi của tôi: điểm + thông báo chờ + lối vào.
class _ArenaMyArenaPanel extends StatelessWidget {
  const _ArenaMyArenaPanel({
    required this.pointsBalance,
    required this.pendingNotifications,
    required this.onOpen,
  });

  final int pointsBalance;
  final int pendingNotifications;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Sân chơi của tôi',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          VitInfoRow(
            label: 'Điểm Arena',
            value: formatArenaPoints(pointsBalance),
            density: VitDensity.compact,
          ),
          VitInfoRow(
            label: 'Thông báo chờ xử lý',
            value: '$pendingNotifications',
            density: VitDensity.compact,
            showDivider: false,
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.star_border_rounded),
            onPressed: onOpen,
            child: const Text('Mở Sân chơi của tôi'),
          ),
        ],
      ),
    );
  }
}

/// Creator nổi bật: độ tin cậy + cam kết fair-play.
class _ArenaCreatorSpotlight extends StatelessWidget {
  const _ArenaCreatorSpotlight({
    required this.creators,
    required this.onCreator,
  });

  final List<ArenaCreatorDraft> creators;
  final ValueChanged<String> onCreator;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Creator nổi bật',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (var i = 0; i < creators.length; i++) ...[
            _ArenaCreatorRow(
              creator: creators[i],
              onTap: () => onCreator(creators[i].id),
            ),
            if (i < creators.length - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _ArenaCreatorRow extends StatelessWidget {
  const _ArenaCreatorRow({required this.creator, required this.onTap});

  final ArenaCreatorDraft creator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        key: ArenaHomeTabletPage.creatorKey(creator.id),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: TabletSpacingTokens.x3,
          ),
          child: Row(
            children: [
              const VitAccentIconBox(
                icon: Icons.person_outline_rounded,
                color: AppModuleAccents.arena,
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creator.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      'Độ tin cậy ${creator.trustScore} · '
                      '${creator.totalChallenges} thử thách',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              if (creator.fairPlay)
                const VitStatusPill(
                  label: 'Fair-play',
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cầu nối Prediction — bridge hợp lệ: chỉ chủ đề/sự kiện dùng chung.
class _ArenaPredictionBridgeCard extends StatelessWidget {
  const _ArenaPredictionBridgeCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      onTap: () => context.push(AppRoutePaths.marketsPredictions),
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.swap_horiz_rounded,
            color: AppModuleAccents.arena,
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cầu nối Prediction Markets',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  'Chủ đề và sự kiện dùng chung giữa hai sản phẩm.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: TabletSpacingTokens.iconMd,
            color: AppColors.text3,
          ),
        ],
      ),
    );
  }
}

class _ArenaVerifiedTeaserCard extends StatelessWidget {
  const _ArenaVerifiedTeaserCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      onTap: () => context.push(AppRoutePaths.arenaVerified),
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.verified_outlined,
            color: AppColors.successAccentBright,
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thử thách đã xác thực',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  'Thử thách có chứng cứ được kiểm duyệt.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: TabletSpacingTokens.iconMd,
            color: AppColors.text3,
          ),
        ],
      ),
    );
  }
}

class _ArenaRulesFooterCard extends StatelessWidget {
  const _ArenaRulesFooterCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      variant: VitCardVariant.ghost,
      onTap: () => context.push(AppRoutePaths.arenaSafety),
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.shield_outlined,
            color: AppColors.text3,
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Text(
              'Luật fair-play và an toàn đấu trường',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: TabletSpacingTokens.iconMd,
            color: AppColors.text3,
          ),
        ],
      ),
    );
  }
}

/// Sheet công cụ — cùng 5 lối như phone (`_ArenaHomeTools`).
class _ArenaToolsSheet extends StatelessWidget {
  const _ArenaToolsSheet({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  static const _tools = <({String label, IconData icon, String route})>[
    (
      label: 'Hướng dẫn',
      icon: Icons.menu_book_outlined,
      route: AppRoutePaths.arenaGuide,
    ),
    (
      label: 'Bảng xếp hạng',
      icon: Icons.emoji_events_outlined,
      route: AppRoutePaths.arenaLeaderboard,
    ),
    (
      label: 'Studio',
      icon: Icons.auto_awesome_rounded,
      route: AppRoutePaths.arenaStudio,
    ),
    (
      label: 'Thư viện preset',
      icon: Icons.dashboard_customize_outlined,
      route: AppRoutePaths.arenaStudioPresets,
    ),
    (
      label: 'Luật thông minh',
      icon: Icons.rule_folder_outlined,
      route: AppRoutePaths.arenaStudioSmartRules,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(TabletSpacingTokens.x5),
            child: Text(
              'Công cụ Open Arena',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.text1,
              ),
            ),
          ),
          for (final tool in _tools)
            Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () => onNavigate(tool.route),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: TabletSpacingTokens.x5,
                    vertical: TabletSpacingTokens.x3,
                  ),
                  child: Row(
                    children: [
                      VitAccentIconBox(
                        icon: tool.icon,
                        color: AppModuleAccents.arena,
                      ),
                      const SizedBox(width: TabletSpacingTokens.x3),
                      Expanded(
                        child: Text(
                          tool.label,
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: TabletSpacingTokens.x4),
        ],
      ),
    );
  }
}
