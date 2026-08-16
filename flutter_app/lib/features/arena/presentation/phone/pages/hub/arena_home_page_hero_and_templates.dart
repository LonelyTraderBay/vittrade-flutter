part of 'arena_home_page.dart';

class _ArenaHomePageState extends ConsumerState<ArenaHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _templatesAnchorKey = GlobalKey();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaHomeSnapshotProvider);
    // Provider phụ (không chặn trang): đọc `.value` lười, ẩn số dư nếu
    // chưa resolve thay vì lồng thêm 1 tầng `.when()` (GD4-Async-Playbook.md
    // mục 5, bẫy 4).
    final pointsBalance =
        ref.watch(arenaPointsSnapshotProvider).value?.summary.currentBalance ??
        0;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    final hasSearch = _query.trim().length >= 2;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Trang chủ Open Arena - khám phá và tham gia thử thách công bằng',
      semanticIdentifier: 'SC-184',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Open Arena',
            subtitle: 'Điểm Arena · thách đấu · hoàn thành',
            showBack: true,
            onBack: _close,
            actions: [
              VitHeaderActionItem(
                key: ArenaHomePage.myArenaHeaderKey,
                type: VitHeaderActionType.portfolio,
                tooltip: 'Của tôi',
                onPressed: () => context.goHaptic(AppRoutePaths.arenaMy),
              ),
              VitHeaderActionItem(
                key: ArenaHomePage.toolsActionKey,
                type: VitHeaderActionType.more,
                tooltip: 'Công cụ',
                onPressed: _showToolsSheet,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ArenaHomePage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Open Arena',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(arenaHomeSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) {
                          final activeChallenges = _countActiveArenaChallenges(
                            snapshot.liveRooms,
                          );
                          return [
                            if (hasSearch)
                              _IntroBlock(
                                controller: _searchController,
                                query: _query,
                                pendingNotifications:
                                    snapshot.pendingNotifications,
                                onChanged: (value) =>
                                    setState(() => _query = value),
                                onClear: () => setState(() => _query = ''),
                                onGuide: () =>
                                    context.goHaptic(AppRoutePaths.arenaGuide),
                                onRewards: () => context.goHaptic(
                                  '${AppRoutePaths.rewards}?tab=arena',
                                ),
                                onLeaderboard: () => context.goHaptic(
                                  AppRoutePaths.arenaLeaderboard,
                                ),
                                onMyArena: () =>
                                    context.goHaptic(AppRoutePaths.arenaMy),
                              )
                            else ...[
                              _HeroCard(
                                pointsBalance: pointsBalance,
                                activeChallenges: activeChallenges,
                                onCreate: () =>
                                    context.goHaptic(AppRoutePaths.arenaStudio),
                                onExplore: _scrollToTemplates,
                              ),
                              _IntroBlock(
                                controller: _searchController,
                                query: _query,
                                pendingNotifications:
                                    snapshot.pendingNotifications,
                                onChanged: (value) =>
                                    setState(() => _query = value),
                                onClear: () => setState(() => _query = ''),
                                onGuide: () =>
                                    context.goHaptic(AppRoutePaths.arenaGuide),
                                onRewards: () => context.goHaptic(
                                  '${AppRoutePaths.rewards}?tab=arena',
                                ),
                                onLeaderboard: () => context.goHaptic(
                                  AppRoutePaths.arenaLeaderboard,
                                ),
                                onMyArena: () =>
                                    context.goHaptic(AppRoutePaths.arenaMy),
                              ),
                            ],
                            if (hasSearch)
                              _SearchResults(
                                query: _query,
                                snapshot: snapshot,
                                onMode: (id) => context.goHaptic(
                                  AppRoutePaths.arenaMode(id),
                                ),
                                onRoom: (id) => context.goHaptic(
                                  AppRoutePaths.arenaChallenge(id),
                                ),
                                onCreator: (id) => context.goHaptic(
                                  AppRoutePaths.arenaCreator(id),
                                ),
                              )
                            else ...[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _TemplateSection(
                                    anchorKey: _templatesAnchorKey,
                                    templates: snapshot.templates,
                                    onTap: (_) => context.goHaptic(
                                      AppRoutePaths.arenaStudio,
                                    ),
                                  ),
                                  const SizedBox(
                                    height:
                                        AppSpacing.pageRhythmCompactInnerGap,
                                  ),
                                  _FeaturedModesSection(
                                    modes: snapshot.featuredModes,
                                    onViewAll: () => context.goHaptic(
                                      AppRoutePaths.arenaLeaderboard,
                                    ),
                                    onMode: (id) => context.goHaptic(
                                      AppRoutePaths.arenaMode(id),
                                    ),
                                  ),
                                ],
                              ),
                              _LiveRoomsSection(
                                rooms: snapshot.liveRooms,
                                onRoom: (id) => context.goHaptic(
                                  AppRoutePaths.arenaChallenge(id),
                                ),
                                onGuide: () =>
                                    context.goHaptic(AppRoutePaths.arenaGuide),
                              ),
                              _CreatorSpotlightSection(
                                creators: snapshot.creators,
                                onCreator: (id) => context.goHaptic(
                                  AppRoutePaths.arenaCreator(id),
                                ),
                              ),
                              _PredictionBridge(
                                onTap: () => context.goHaptic(
                                  AppRoutePaths.marketsPredictions,
                                ),
                              ),
                              _VerifiedTeaser(
                                onTap: () => context.goHaptic(
                                  AppRoutePaths.arenaVerified,
                                ),
                              ),
                            ],
                            _ArenaFooter(
                              onRules: () =>
                                  context.goHaptic(AppRoutePaths.arenaSafety),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.home,
      mode: BackNavigationMode.historyThenFallback,
    );
  }

  void _scrollToTemplates() {
    final context = _templatesAnchorKey.currentContext;
    if (context == null) return;
    unawaited(
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
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
              rootContext.goHaptic(route);
            },
          );
        },
      ),
    );
  }
}

class _IntroBlock extends StatelessWidget {
  const _IntroBlock({
    required this.controller,
    required this.query,
    required this.pendingNotifications,
    required this.onChanged,
    required this.onClear,
    required this.onGuide,
    required this.onRewards,
    required this.onLeaderboard,
    required this.onMyArena,
  });

  final TextEditingController controller;
  final String query;
  final int pendingNotifications;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onGuide;
  final VoidCallback onRewards;
  final VoidCallback onLeaderboard;
  final VoidCallback onMyArena;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSearchBar(
          key: ArenaHomePage.searchKey,
          controller: controller,
          placeholder: 'Tìm mode, creator hoặc challenge...',
          variant: VitSearchBarVariant.compact,
          onChanged: onChanged,
          onClear: onClear,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            children: [
              _QuickChip(
                key: ArenaHomePage.quickGuideKey,
                icon: Icons.menu_book_outlined,
                label: 'Hướng dẫn',
                onTap: onGuide,
              ),
              _QuickChip(
                key: ArenaHomePage.quickRewardsKey,
                icon: Icons.card_giftcard_rounded,
                label: 'Phần thưởng',
                onTap: onRewards,
              ),
              _QuickChip(
                key: ArenaHomePage.quickLeaderboardKey,
                icon: Icons.emoji_events_outlined,
                label: 'Bảng xếp hạng',
                onTap: onLeaderboard,
              ),
              _QuickChip(
                key: ArenaHomePage.quickMyArenaKey,
                icon: Icons.star_border_rounded,
                label: 'Sân chơi của tôi',
                count: pendingNotifications,
                onTap: onMyArena,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArenaToolsSheet extends StatelessWidget {
  const _ArenaToolsSheet({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: ArenaHomePage.toolsSheetKey,
      title: 'Công cụ Arena',
      child: VitActionTileGrid(
        density: VitDensity.compact,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        physics: const ClampingScrollPhysics(),
        itemCount: _arenaHomeTools.length,
        itemBuilder: (context, index, density) {
          final tool = _arenaHomeTools[index];
          return VitServiceTile(
            key: ArenaHomePage.toolKey(tool.id),
            density: density,
            icon: tool.icon,
            label: tool.label,
            accentColor: _arenaAccent,
            onTap: () => onNavigate(tool.route),
          );
        },
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.count = 0,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaHomeQuickChipGapPadding,
      child: IntrinsicWidth(
        child: VitCard(
          onTap: onTap,
          variant: VitCardVariant.inner,
          radius: VitCardRadius.standard,
          height: VitDensity.compact.controlHeight,
          contentAlign: VitCardContentAlign.center,
          padding: AppSpacing.cardTilePadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.text2,
                size: ArenaSpacingTokens.arenaHomeQuickChipIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  height: _arenaHomeCountBadgeLineHeight,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: AppSpacing.x2),
                _MiniCountBadge(count: count),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
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
      accentColor: _arenaAccent,
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
                    height: _arenaHomeHeroTitleLineHeight,
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
            children: [
              Expanded(
                child: _ArenaHeroKpi(
                  label: 'Điểm Arena',
                  value: formatArenaPoints(pointsBalance),
                  valueStyle: AppTextStyles.heroNumber.copyWith(
                    color: AppColors.text1,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(
                width: 1,
                height: AppSpacing.x6,
                child: ColoredBox(color: AppColors.border),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.x3,
                  ),
                  child: _ArenaHeroKpi(
                    label: 'Đang mở',
                    value: '$activeChallenges',
                    valueStyle: AppTextStyles.heroNumber.copyWith(
                      color: _arenaAccent,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            key: ArenaHomePage.createChallengeKey,
            onPressed: onCreate,
            density: VitDensity.compact,
            fullWidth: true,
            leading: const Icon(Icons.auto_awesome_rounded),
            child: const Text('Tạo thách đấu'),
          ),
          const SizedBox(height: AppSpacing.x1),
          Align(
            alignment: AlignmentDirectional.center,
            child: TextButton.icon(
              key: ArenaHomePage.exploreModeKey,
              onPressed: onExplore,
              icon: const Icon(Icons.search_rounded, size: AppSpacing.iconSm),
              label: const Text('Khám phá chế độ'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArenaHeroKpi extends StatelessWidget {
  const _ArenaHeroKpi({
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
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _TemplateSection extends StatelessWidget {
  const _TemplateSection({
    required this.anchorKey,
    required this.templates,
    required this.onTap,
  });

  final Key anchorKey;
  final List<ArenaTemplateDraft> templates;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return VitPageSection(
        key: anchorKey,
        label: 'Mẫu thách đấu',
        accentColor: AppColors.accent,
        density: VitDensity.compact,
        children: const [
          VitEmptyState(
            icon: Icons.dashboard_customize_outlined,
            title: 'Chưa có mẫu thách đấu',
            message: 'Mẫu tạo thách đấu mới sẽ hiển thị tại đây.',
          ),
        ],
      );
    }

    return VitPageSection(
      key: anchorKey,
      label: 'Mẫu thách đấu',
      accentColor: AppColors.accent,
      density: VitDensity.compact,
      children: [
        Text(
          'Chọn mẫu để bắt đầu tạo thách đấu',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        GridView.builder(
          padding: const EdgeInsetsDirectional.all(AppSpacing.zero),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: templates.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ArenaSpacingTokens.arenaHomeTemplateColumns,
            crossAxisSpacing: AppSpacing.x2,
            mainAxisSpacing: AppSpacing.x2,
            mainAxisExtent: ArenaSpacingTokens.arenaHomeTemplateExtent,
          ),
          itemBuilder: (context, index) {
            final template = templates[index];
            final accent = _templateColor(template.kind);
            final tags = template.tags.take(2).join(' · ');
            return VitCard(
              key: ArenaHomePage.templateKey(template.id),
              onTap: () => onTap(template.id),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.x3,
                vertical: AppSpacing.x2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _ActionIcon(
                        icon: _templateIcon(template.kind),
                        color: accent,
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Text(
                          template.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                            height: _arenaHomeTemplateTitleLineHeight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    template.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: _arenaHomeTemplateDescriptionLineHeight,
                    ),
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      tags,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
