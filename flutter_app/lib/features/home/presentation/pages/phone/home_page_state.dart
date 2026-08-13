part of 'home_page.dart';

class _HomePageState extends ConsumerState<HomePage> {
  String _marketTab = 'hot';
  bool _balanceHidden = false;
  final Set<String> _sessionHiddenAnnouncementIds = <String>{};
  final Set<String> _dismissedNextActionIds = <String>{};

  void _setTab(String key) {
    setState(() => _marketTab = key);
  }

  void _toggleBalanceHidden() {
    setState(() => _balanceHidden = !_balanceHidden);
  }

  void _go(String path) {
    unawaited(context.push(path));
  }

  void _showMoreProducts(List<HomeQuickAction> actions, VitDensity density) {
    final rootContext = context;

    if (actions.isEmpty) return;

    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        barrierColor: AppColors.modalScrim,
        builder: (sheetContext) {
          return HomeMoreProductsSheet(
            actions: actions,
            onNavigate: (path) {
              Navigator.of(sheetContext).pop();
              unawaited(rootContext.push(path));
            },
            density: density,
          );
        },
      ),
    );
  }

  void _dismissAnnouncement(HomeAnnouncement announcement) {
    setState(() => _sessionHiddenAnnouncementIds.add(announcement.id));
  }

  bool _handleHomeScrollNotification(
    ScrollNotification notification,
    List<HomeAnnouncement> visibleAnnouncements,
  ) {
    if (notification.metrics.axis != Axis.vertical) return false;
    if (notification.metrics.pixels <
        HomeSpacingTokens.homeAnnouncementAutoHideScrollOffset) {
      return false;
    }

    final campaignIds = visibleAnnouncements
        .where(
          (announcement) => announcement.type == HomeAnnouncementType.campaign,
        )
        .map((announcement) => announcement.id)
        .where((id) => !_sessionHiddenAnnouncementIds.contains(id))
        .toList(growable: false);

    if (campaignIds.isEmpty) return false;

    setState(() => _sessionHiddenAnnouncementIds.addAll(campaignIds));
    return false;
  }

  List<HomeAnnouncement> _visibleAnnouncements(HomeSnapshot snapshot) {
    final announcements = snapshot.announcements
        .where(
          (announcement) =>
              announcement.active &&
              announcement.type.surfacesOnHome &&
              !_sessionHiddenAnnouncementIds.contains(announcement.id),
        )
        .toList(growable: false);
    announcements.sort(
      (a, b) =>
          _announcementSortKey(a.type).compareTo(_announcementSortKey(b.type)),
    );
    return announcements;
  }

  int _announcementSortKey(HomeAnnouncementType type) {
    return switch (type) {
      HomeAnnouncementType.security => 0,
      HomeAnnouncementType.risk => 1,
      HomeAnnouncementType.campaign => 2,
      HomeAnnouncementType.info => 3,
    };
  }

  HomeDensityVariant _homeDensityVariant(double screenWidth) {
    return screenWidth <= HomeSpacingTokens.homeQuickActionDensityBreakpoint
        ? HomeDensityVariant.compact
        : HomeDensityVariant.comfortable;
  }

  VitDensity _tileDensity(HomeDensityVariant variant) {
    return variant == HomeDensityVariant.compact
        ? VitDensity.compact
        : VitDensity.standard;
  }

  void _dismissNextAction(HomeNextAction nextAction) {
    setState(() => _dismissedNextActionIds.add(nextAction.routePath));
  }

  HomeNextAction? _visibleNextAction(HomeNextAction? nextAction) {
    if (nextAction == null) return null;
    if (_dismissedNextActionIds.contains(nextAction.routePath)) return null;
    return nextAction;
  }

  Future<void> _refreshHome() async {
    ref.invalidate(homeSnapshotProvider);
    await ref.read(homeSnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeSnapshotProvider);
    final notificationUnreadCount = ref.watch(notificationUnreadCountProvider);
    final shellRenderMode = widget.shellRenderMode ?? defaultShellRenderMode();
    final nativeShell = !shellRenderMode.usesVisualQaFrame;
    final scrollEndClearance =
        (nativeShell ? _nativeScrollClearance : _framedScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitAutoHidePageScaffold(
      variant: nativeShell ? VitPageVariant.flush : VitPageVariant.defaultPage,
      semanticLabel: 'Trang chủ',
      semanticIdentifier: 'SC-007',
      headerKey: HomePage.headerKey,
      header: HomeHeader(
        notifications: notificationUnreadCount,
        onNavigate: _go,
      ),
      body: homeAsync.when(
        loading: () => HomeScrollShell(
          scrollEndClearance: scrollEndClearance,
          onRefresh: _refreshHome,
          visibleAnnouncements: const [],
          onScrollNotification: _handleHomeScrollNotification,
          child: const HomeLoadingContent(),
        ),
        error: (error, stackTrace) => HomeErrorContent(onRetry: _refreshHome),
        data: (snapshot) {
          final controller = HomeController(
            state: HomeViewState(snapshot: snapshot),
          );
          final screenWidth = MediaQuery.sizeOf(context).width;
          final homeVariant = _homeDensityVariant(screenWidth);
          final homeDensity = _tileDensity(homeVariant);
          final homePrimaryQuickActionCount =
              HomeSpacingTokens.homeQuickActionCompactCount;
          final visibleAnnouncements = _visibleAnnouncements(snapshot);
          final gridQuickActions = snapshot.quickActions;
          final primaryRoutes = gridQuickActions
              .take(homePrimaryQuickActionCount)
              .map((action) => action.routePath)
              .toSet();
          // Flat catalog in «Xem thêm» — no group headers; skip Home tiles.
          final moreCatalogActions = _flatMoreCatalogActions(
            productGroups: snapshot.productGroups,
            excludedRoutes: primaryRoutes,
          );
          final moreActionCount = moreCatalogActions.length;
          final visibleNextAction = _visibleNextAction(snapshot.nextAction);
          final marketTickerPairs = controller.gainers
              .take(3)
              .toList(growable: false);

          return HomeScrollShell(
            scrollEndClearance: scrollEndClearance,
            onRefresh: _refreshHome,
            visibleAnnouncements: visibleAnnouncements,
            onScrollNotification: _handleHomeScrollNotification,
            child: VitPageContent(
              padding: VitContentPadding.compact,
              rhythm: VitPageRhythm.compact,
              children: [
                if (visibleAnnouncements.isNotEmpty)
                  HomeAnnouncementBanner(
                    announcements: visibleAnnouncements,
                    onDismiss: _dismissAnnouncement,
                    onNavigate: _go,
                  ),
                HomePortfolioCard(
                  snapshot: snapshot,
                  balanceHidden: _balanceHidden,
                  onToggleBalance: _toggleBalanceHidden,
                  onNavigate: _go,
                ),
                if (visibleNextAction != null)
                  HomeNextActionSection(
                    nextAction: visibleNextAction,
                    onNavigate: _go,
                    onDismiss: () => _dismissNextAction(visibleNextAction),
                  ),
                // Action-first + lean Home: 6 quick actions on-scroll;
                // catalog opens from «Xem thêm» (no stacked product groups).
                HomeProductsSection(
                  quickActions: gridQuickActions,
                  maxVisibleQuickActions: homePrimaryQuickActionCount,
                  moreActionCount: moreActionCount,
                  onNavigate: _go,
                  onMore: moreActionCount <= 0
                      ? null
                      : () =>
                            _showMoreProducts(moreCatalogActions, homeDensity),
                  density: homeDensity,
                ),
                // Distinct from the Market section below (default tab
                // "Hot"): the ticker previews top movers so the two blocks
                // don't show the exact same three pairs back to back.
                // D4: keep compact ticker on Home.
                if (marketTickerPairs.isNotEmpty)
                  HomeMarketTickerSection(
                    pairs: marketTickerPairs,
                    onNavigate: _go,
                  ),
                _HomeDiscoverySection(onNavigate: _go),
                // D3: «Gần đây» dưới Discovery.
                HomeRecentProductsSection(
                  recentProducts: snapshot.recentProducts,
                  onNavigate: _go,
                  density: homeDensity,
                ),
                _MarketSection(
                  activeTab: _marketTab,
                  pairs: controller.tabPairs(_marketTab),
                  onTabChanged: _setTab,
                  onNavigate: _go,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
