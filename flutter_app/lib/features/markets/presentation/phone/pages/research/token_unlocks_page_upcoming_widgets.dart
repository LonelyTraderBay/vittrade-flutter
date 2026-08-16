part of 'token_unlocks_page.dart';

class _TokenUnlocksPageState extends ConsumerState<TokenUnlocksPage> {
  String _tab = 'upcoming';
  MarketUnlockSort _sortBy = MarketUnlockSort.nearest;
  MarketUnlockImpact? _impactFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    // GD4-F3: getTokenUnlocks gọi 2 lần với filter khác nhau — chính =
    // unfiltered (hero/phân tích/lịch trình dùng chung — impactConfigs/
    // categoryConfigs giống hệt bản lọc vì là config tĩnh), phụ = filtered
    // đọc qua .value (mục 5, "2 async song song trên 1 trang").
    final allAsync = ref.watch(
      marketTokenUnlocksSnapshotProvider((
        sortBy: MarketUnlockSort.nearest,
        impactFilter: null,
      )),
    );
    final filteredUnlocks = ref
        .watch(
          marketTokenUnlocksSnapshotProvider((
            sortBy: _sortBy,
            impactFilter: _impactFilter,
          )),
        )
        .value
        ?.unlocks;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _unlockVisualScrollClearance
            : _unlockNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Mở khóa token',
      semanticIdentifier: 'SC-024',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Mở khóa token',
            subtitle: 'Lịch unlock · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _UnlockTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: TokenUnlocksPage.contentKey,
                    padding: MarketsSpacingTokens.marketScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
                      children: allAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được mở khóa token',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketTokenUnlocksSnapshotProvider((
                                sortBy: MarketUnlockSort.nearest,
                                impactFilter: null,
                              )),
                            ),
                          ),
                        ],
                        data: (allSnapshot) {
                          final unlocks =
                              filteredUnlocks ?? const <TokenUnlockDraft>[];
                          return [
                            if (_tab == 'upcoming') ...[
                              _UnlockHero(snapshot: allSnapshot),
                              _UnlockFilters(
                                sortBy: _sortBy,
                                impactFilter: _impactFilter,
                                impactConfigs: allSnapshot.impactConfigs,
                                onSortSelected: (value) =>
                                    setState(() => _sortBy = value),
                                onImpactSelected: (value) => setState(() {
                                  _impactFilter = _impactFilter == value
                                      ? null
                                      : value;
                                }),
                                onAllImpacts: () => setState(() {
                                  _impactFilter = null;
                                }),
                              ),
                              if (unlocks.isEmpty)
                                VitEmptyState(
                                  title: 'Không có unlock phù hợp',
                                  message:
                                      'Thử xóa bộ lọc tác động hoặc đổi cách sắp xếp',
                                  icon: Icons.lock_outline_rounded,
                                  actionLabel: 'Xóa bộ lọc',
                                  onAction: () => setState(() {
                                    _impactFilter = null;
                                    _sortBy = MarketUnlockSort.nearest;
                                  }),
                                )
                              else
                                _UnlockList(
                                  unlocks: unlocks,
                                  impactConfigs: allSnapshot.impactConfigs,
                                  categoryConfigs: allSnapshot.categoryConfigs,
                                  expandedId: _expandedId,
                                  onToggleExpanded: (unlock) => setState(() {
                                    _expandedId = _expandedId == unlock.id
                                        ? null
                                        : unlock.id;
                                  }),
                                ),
                            ] else if (_tab == 'analysis') ...[
                              _ImpactOverview(snapshot: allSnapshot),
                              const VitSectionHeader(
                                title: 'Theo loại',
                                accentColor: AppColors.accent,
                                bottomGap:
                                    AppSpacing.pageRhythmStandardInnerGap,
                                variant: VitSectionHeaderVariant.accentBar,
                              ),
                              _CategoryBreakdown(snapshot: allSnapshot),
                              const VitSectionHeader(
                                title: 'Rủi ro pha loãng cao nhất',
                                accentColor: AppColors.sell,
                                bottomGap:
                                    AppSpacing.pageRhythmStandardInnerGap,
                                variant: VitSectionHeaderVariant.accentBar,
                              ),
                              _DilutionRanking(snapshot: allSnapshot),
                              const _UnlockWarningCard(),
                            ] else ...[
                              _ScheduleList(snapshot: allSnapshot),
                            ],
                            const VitBanner(
                              variant: VitBannerVariant.info,
                              icon: Icons.info_outline_rounded,
                              message: 'Dữ liệu unlock chỉ mang tính tham khảo',
                              detail:
                                  'Unlock lớn có thể tạo áp lực bán tiềm ẩn. Không phải khuyến nghị đầu tư.',
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
}

class _UnlockTabs extends StatelessWidget {
  const _UnlockTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: MarketsSpacingTokens.marketDepthTabsHeight,
        child: Column(
          children: [
            Expanded(
              child: VitTabBar(
                activeKey: activeTab,
                variant: VitTabBarVariant.underline,
                onChanged: onChanged,
                tabs: const [
                  VitTabItem(
                    key: 'upcoming',
                    label: 'Sắp mở khóa',
                    widgetKey: TokenUnlocksPage.upcomingTabKey,
                  ),
                  VitTabItem(
                    key: 'analysis',
                    label: 'Phân tích',
                    widgetKey: TokenUnlocksPage.analysisTabKey,
                  ),
                  VitTabItem(
                    key: 'schedule',
                    label: 'Lịch trình',
                    widgetKey: TokenUnlocksPage.scheduleTabKey,
                  ),
                ],
              ),
            ),
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

class _UnlockHero extends StatelessWidget {
  const _UnlockHero({required this.snapshot});

  final MarketTokenUnlocksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: double.infinity,
      padding: MarketsSpacingTokens.tokenUnlocksHeroPadding,
      borderColor: _marketPrimary.withValues(alpha: .18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng giá trị mở khóa sắp tới',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: _unlockHeroLabelGap),
          Text(
            _formatCompactUsd(snapshot.totalValueNext30d),
            style: AppTextStyles.amountMd.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: _unlockHeroValueGap),
          Row(
            children: [
              Text(
                '${snapshot.highImpactCount} tác động cao',
                style: AppTextStyles.micro.copyWith(color: AppColors.sell),
              ),
              const SizedBox(
                width: MarketsSpacingTokens.tokenUnlocksHeroMetaGap,
              ),
              Text(
                'TB dilution: ${snapshot.avgDilution.toStringAsFixed(1)}%',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnlockFilters extends StatelessWidget {
  const _UnlockFilters({
    required this.sortBy,
    required this.impactFilter,
    required this.impactConfigs,
    required this.onSortSelected,
    required this.onImpactSelected,
    required this.onAllImpacts,
  });

  final MarketUnlockSort sortBy;
  final MarketUnlockImpact? impactFilter;
  final Map<MarketUnlockImpact, UnlockImpactConfig> impactConfigs;
  final ValueChanged<MarketUnlockSort> onSortSelected;
  final ValueChanged<MarketUnlockImpact> onImpactSelected;
  final VoidCallback onAllImpacts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              VitFilterChip(
                label: 'Gần nhất',
                active: sortBy == MarketUnlockSort.nearest,
                color: _marketPrimary,
                onTap: () => onSortSelected(MarketUnlockSort.nearest),
                padding: MarketsSpacingTokens.tokenUnlocksFilterPadding,
              ),
              const SizedBox(width: _unlockFilterGap),
              VitFilterChip(
                key: TokenUnlocksPage.sortValueKey,
                label: 'Giá trị cao',
                active: sortBy == MarketUnlockSort.value,
                color: _marketPrimary,
                onTap: () => onSortSelected(MarketUnlockSort.value),
                padding: MarketsSpacingTokens.tokenUnlocksFilterPadding,
              ),
              const SizedBox(width: _unlockFilterGap),
              VitFilterChip(
                label: 'Tác động',
                active: sortBy == MarketUnlockSort.impact,
                color: _marketPrimary,
                onTap: () => onSortSelected(MarketUnlockSort.impact),
                padding: MarketsSpacingTokens.tokenUnlocksFilterPadding,
              ),
            ],
          ),
        ),
        const SizedBox(height: _unlockFilterGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              VitFilterChip(
                label: 'Tất cả',
                active: impactFilter == null,
                color: AppColors.text3,
                onTap: onAllImpacts,
                padding: MarketsSpacingTokens.tokenUnlocksFilterPadding,
              ),
              const SizedBox(width: _unlockFilterGap),
              for (final entry in impactConfigs.entries) ...[
                VitFilterChip(
                  key: entry.key == MarketUnlockImpact.high
                      ? TokenUnlocksPage.impactHighKey
                      : null,
                  label: entry.value.label,
                  active: impactFilter == entry.key,
                  color: entry.value.color.resolve(),
                  onTap: () => onImpactSelected(entry.key),
                  padding: MarketsSpacingTokens.tokenUnlocksFilterPadding,
                ),
                if (entry.key != impactConfigs.keys.last)
                  const SizedBox(width: _unlockFilterGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _UnlockList extends StatelessWidget {
  const _UnlockList({
    required this.unlocks,
    required this.impactConfigs,
    required this.categoryConfigs,
    required this.expandedId,
    required this.onToggleExpanded,
  });

  final List<TokenUnlockDraft> unlocks;
  final Map<MarketUnlockImpact, UnlockImpactConfig> impactConfigs;
  final Map<MarketUnlockCategory, UnlockCategoryConfig> categoryConfigs;
  final String? expandedId;
  final ValueChanged<TokenUnlockDraft> onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final unlock in unlocks) ...[
          _UnlockCard(
            key: TokenUnlocksPage.unlockCardKey(unlock.id),
            unlock: unlock,
            impactConfig: impactConfigs[unlock.impactLevel]!,
            categoryConfig: categoryConfigs[unlock.category]!,
            expanded: expandedId == unlock.id,
            onToggle: () => onToggleExpanded(unlock),
          ),
          if (unlock != unlocks.last) const SizedBox(height: _unlockListGap),
        ],
      ],
    );
  }
}
