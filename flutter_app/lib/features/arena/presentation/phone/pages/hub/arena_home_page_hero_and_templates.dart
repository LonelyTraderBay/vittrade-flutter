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
