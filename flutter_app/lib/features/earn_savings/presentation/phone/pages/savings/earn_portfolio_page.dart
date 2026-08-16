part of 'savings_portfolio_page.dart';

class _SavingsPortfolioPageState extends ConsumerState<SavingsPortfolioPage> {
  _PortfolioTab _tab = _PortfolioTab.overview;
  PositionFilter _filter = PositionFilter.all;
  bool _hideBalance = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsPortfolioSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Danh mục tiết kiệm',
      semanticIdentifier: 'SC-333',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(savingsPortfolioSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollEndPadding =
                (mode.usesVisualQaFrame
                    ? SharedSpacingTokens.bottomNavVisualClearance
                    : SharedSpacingTokens.bottomNavNativeClearance) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: VitInsetScrollView(
                  physics: const ClampingScrollPhysics(),
                  bottomInset: scrollEndPadding,
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      VitSegmentedTabBar(
                        activeKey: _tab.name,
                        onChanged: (key) {
                          unawaited(HapticFeedback.selectionClick());
                          setState(
                            () => _tab = _PortfolioTab.values.byName(key),
                          );
                        },
                        tabs: const [
                          VitTabItem(key: 'overview', label: 'Tổng quan'),
                          VitTabItem(
                            key: 'positions',
                            label: 'Vị thế',
                            widgetKey: SavingsPortfolioPage.positionsTabKey,
                          ),
                          VitTabItem(key: 'earnings', label: 'Thu nhập'),
                        ],
                      ),
                      if (_tab == _PortfolioTab.overview)
                        OverviewTab(
                          snapshot: snapshot,
                          hideBalance: _hideBalance,
                          onToggleBalance: () {
                            unawaited(HapticFeedback.selectionClick());
                            setState(() => _hideBalance = !_hideBalance);
                          },
                        )
                      else if (_tab == _PortfolioTab.positions)
                        PositionsTab(
                          snapshot: snapshot,
                          activeFilter: _filter,
                          onFilterChanged: (filter) {
                            unawaited(HapticFeedback.selectionClick());
                            setState(() => _filter = filter);
                          },
                        )
                      else
                        EarningsTab(
                          snapshot: snapshot,
                          hideBalance: _hideBalance,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
