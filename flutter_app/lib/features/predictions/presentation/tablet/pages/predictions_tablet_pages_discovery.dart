part of 'predictions_tablet_pages.dart';

// ---------------------------------------------------------------------------
// SC-209: Tìm kiếm sự kiện dự đoán — search live + bộ lọc gập (sort/trạng
// thái/danh mục) + đếm kết quả + empty state, state cục bộ như phone SC-028.
// ---------------------------------------------------------------------------

class PredictionsSearchTabletPage extends ConsumerStatefulWidget {
  const PredictionsSearchTabletPage({super.key});

  static const contentKey = Key('sc209_tablet_content');
  static const filterPaneKey = Key('sc209_tablet_filter_pane');
  static const searchFieldKey = Key('sc209_search_field');
  static const filtersToggleKey = Key('sc209_filters_toggle');
  static const clearFiltersKey = Key('sc209_clear_filters');
  static const statusActiveKey = Key('sc209_status_active');
  static const statusResolvedKey = Key('sc209_status_resolved');
  static const statusAllKey = Key('sc209_status_all');

  @override
  ConsumerState<PredictionsSearchTabletPage> createState() =>
      _PredictionsSearchTabletPageState();
}

class _PredictionsSearchTabletPageState
    extends ConsumerState<PredictionsSearchTabletPage> {
  final _searchController = TextEditingController();
  PredictionSearchSort _sort = PredictionSearchSort.trending;
  PredictionStatusFilter _status = PredictionStatusFilter.active;
  String? _category;
  bool _showFilters = true;

  bool get _hasActiveFilters =>
      _sort != PredictionSearchSort.trending ||
      _status != PredictionStatusFilter.active ||
      _category != null ||
      _searchController.text.isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = (
      sort: _sort,
      status: _status,
      category: _category,
      searchQuery: _searchController.text,
    );
    final searchAsync = ref.watch(
      predictionsSearchSnapshotProvider(searchQuery),
    );

    return searchAsync.when(
      loading: () => _frame(
        context,
        body: _pdmStatusBody(PredictionsSearchTabletPage.contentKey, const [
          VitSkeletonList(rows: 6),
        ]),
      ),
      error: (error, stackTrace) => _frame(
        context,
        body: _pdmStatusBody(PredictionsSearchTabletPage.contentKey, [
          _pdmError(
            'Không tải được tìm kiếm',
            () =>
                ref.invalidate(predictionsSearchSnapshotProvider(searchQuery)),
          ),
        ]),
      ),
      data: (snapshot) {
        // Các khối dựng một lần — tham chiếu ở cả tầng workspace lẫn hẹp.
        final filterSection = _Sc209SearchFilterSection(
          sort: _sort,
          status: _status,
          categories: snapshot.categories,
          selectedCategory: _category,
          hasActiveFilters: _hasActiveFilters,
          onSortSelected: (value) => setState(() {
            _sort = value;
          }),
          onStatusSelected: (value) => setState(() {
            _status = value;
          }),
          onCategorySelected: (value) => setState(() {
            _category = value;
          }),
          onClear: _clearFilters,
        );
        final resultCount = Text(
          'Tìm thấy ${snapshot.results.length} sự kiện',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        );
        final resultsGrid = PredictionTabletCardGrid(
          children: [
            for (final event in snapshot.results)
              PredictionEventCardTablet(
                event: event,
                onTap: () => context.push(
                  AppRoutePaths.marketsPredictionEvent(event.id),
                ),
              ),
          ],
        );
        final emptyState = _Sc209SearchEmptyState(
          hasActiveFilters: _hasActiveFilters,
          onClearFilters: _clearFilters,
          onBreaking: () =>
              context.push(AppRoutePaths.marketsPredictionsBreaking),
        );
        final footer = _pdmBody('Cập nhật ${snapshot.lastUpdatedLabel}');
        return _frame(
          context,
          subtitle: '${snapshot.results.length} kết quả',
          body: VitTabletPaneWorkspace(
            contentKey: PredictionsSearchTabletPage.contentKey,
            secondaryContentKey: PredictionsSearchTabletPage.filterPaneKey,
            // Workspace: bộ lọc LUÔN mở trong panel — hết nhu cầu gập.
            secondaryChildren: [
              VitSearchBar(
                key: PredictionsSearchTabletPage.searchFieldKey,
                controller: _searchController,
                placeholder: 'Tìm theo tiêu đề, thẻ, danh mục…',
                onChanged: (_) => setState(() {}),
                onClear: () => setState(_searchController.clear),
              ),
              filterSection,
            ],
            primaryChildren: [
              if (snapshot.results.isEmpty)
                emptyState
              else ...[
                resultCount,
                resultsGrid,
              ],
              footer,
            ],
            narrowChildren: [
              VitSearchBar(
                key: PredictionsSearchTabletPage.searchFieldKey,
                controller: _searchController,
                placeholder: 'Tìm theo tiêu đề, thẻ, danh mục…',
                filterKey: PredictionsSearchTabletPage.filtersToggleKey,
                filterActive: _showFilters,
                filterInline: true,
                onChanged: (_) => setState(() {}),
                onClear: () => setState(_searchController.clear),
                onFilterTap: () => setState(() {
                  _showFilters = !_showFilters;
                }),
              ),
              if (_showFilters) filterSection,
              resultCount,
              if (snapshot.results.isEmpty) emptyState else resultsGrid,
              footer,
            ],
          ),
        );
      },
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _sort = PredictionSearchSort.trending;
      _status = PredictionStatusFilter.active;
      _category = null;
    });
  }

  Widget _frame(
    BuildContext context, {
    required Widget body,
    String? subtitle,
  }) {
    final showBack = context.canPop();
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tìm kiếm prediction',
      semanticIdentifier: 'SC-209',
      child: Column(
        children: [
          VitHeader(
            title: 'Tìm sự kiện',
            subtitle: subtitle ?? 'Lọc theo chủ đề · xác suất',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.marketsPredictions,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _Sc209SearchFilterSection extends StatelessWidget {
  const _Sc209SearchFilterSection({
    required this.sort,
    required this.status,
    required this.categories,
    required this.selectedCategory,
    required this.hasActiveFilters,
    required this.onSortSelected,
    required this.onStatusSelected,
    required this.onCategorySelected,
    required this.onClear,
  });

  final PredictionSearchSort sort;
  final PredictionStatusFilter status;
  final List<String> categories;
  final String? selectedCategory;
  final bool hasActiveFilters;
  final ValueChanged<PredictionSearchSort> onSortSelected;
  final ValueChanged<PredictionStatusFilter> onStatusSelected;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Sc209FilterLabel('Sắp xếp'),
        const SizedBox(height: TabletSpacingTokens.x3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: VitTabBar(
            variant: VitTabBarVariant.pill,
            activeKey: _sc209SortKey(sort),
            onChanged: (key) =>
                onSortSelected(PredictionSearchSort.values.byName(key)),
            tabs: const [
              VitTabItem(
                key: 'trending',
                label: 'Xu hướng',
                icon: Icons.trending_up_outlined,
              ),
              VitTabItem(
                key: 'liquidity',
                label: 'Thanh khoản',
                icon: Icons.bar_chart_outlined,
              ),
              VitTabItem(
                key: 'volume',
                label: 'Khối lượng',
                icon: Icons.show_chart_outlined,
              ),
              VitTabItem(
                key: 'newest',
                label: 'Mới nhất',
                icon: Icons.fiber_new_outlined,
              ),
              VitTabItem(
                key: 'ending',
                label: 'Sắp đóng',
                icon: Icons.schedule_outlined,
              ),
              VitTabItem(
                key: 'competitive',
                label: 'Cạnh tranh',
                icon: Icons.track_changes_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        const _Sc209FilterLabel('Trạng thái'),
        const SizedBox(height: TabletSpacingTokens.x3),
        VitSegmentedChoice<PredictionStatusFilter>(
          selected: status,
          onChanged: onStatusSelected,
          options: const [
            VitSegmentedChoiceOption(
              value: PredictionStatusFilter.active,
              label: 'Đang mở',
              key: PredictionsSearchTabletPage.statusActiveKey,
            ),
            VitSegmentedChoiceOption(
              value: PredictionStatusFilter.resolved,
              label: 'Đã kết thúc',
              key: PredictionsSearchTabletPage.statusResolvedKey,
            ),
            VitSegmentedChoiceOption(
              value: PredictionStatusFilter.all,
              label: 'Tất cả',
              key: PredictionsSearchTabletPage.statusAllKey,
            ),
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        const _Sc209FilterLabel('Danh mục'),
        const SizedBox(height: TabletSpacingTokens.x3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < categories.length; index += 1) ...[
                VitFilterChip(
                  key: Key('sc209_category_${categories[index]}'),
                  label: categories[index],
                  active: selectedCategory == categories[index],
                  onTap: () => onCategorySelected(
                    selectedCategory == categories[index]
                        ? null
                        : categories[index],
                  ),
                  color: AppColors.primary,
                ),
                if (index != categories.length - 1)
                  const SizedBox(width: TabletSpacingTokens.x2),
              ],
            ],
          ),
        ),
        if (hasActiveFilters) ...[
          const SizedBox(height: TabletSpacingTokens.x4),
          VitCtaButton(
            key: PredictionsSearchTabletPage.clearFiltersKey,
            onPressed: onClear,
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.close_rounded),
            child: const Text('Xóa bộ lọc'),
          ),
        ],
      ],
    );
  }
}

String _sc209SortKey(PredictionSearchSort sort) {
  return switch (sort) {
    PredictionSearchSort.trending => 'trending',
    PredictionSearchSort.liquidity => 'liquidity',
    PredictionSearchSort.volume => 'volume',
    PredictionSearchSort.newest => 'newest',
    PredictionSearchSort.ending => 'ending',
    PredictionSearchSort.competitive => 'competitive',
  };
}

class _Sc209FilterLabel extends StatelessWidget {
  const _Sc209FilterLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _Sc209SearchEmptyState extends StatelessWidget {
  const _Sc209SearchEmptyState({
    required this.hasActiveFilters,
    required this.onClearFilters,
    required this.onBreaking,
  });

  final bool hasActiveFilters;
  final VoidCallback onClearFilters;
  final VoidCallback onBreaking;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            color: AppColors.text3.withValues(alpha: .40),
            size: TabletSpacingTokens.iconLg,
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Text(
            'Không tìm thấy sự kiện',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            'Thử điều chỉnh bộ lọc hoặc xem sự kiện biến động',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              onPressed: onClearFilters,
              child: const Text('Xóa bộ lọc'),
            ),
          ],
          const SizedBox(height: TabletSpacingTokens.x3),
          TextButton(
            onPressed: onBreaking,
            child: Text(
              'Xem Biến động',
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
