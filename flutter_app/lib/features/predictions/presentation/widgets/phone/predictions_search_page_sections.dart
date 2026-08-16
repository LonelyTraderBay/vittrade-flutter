part of '../../phone/pages/hub/predictions_search_page.dart';

class _SearchControl extends StatelessWidget {
  const _SearchControl({
    required this.controller,
    required this.showFilters,
    required this.onChanged,
    required this.onClear,
    required this.onToggleFilters,
  });

  final TextEditingController controller;
  final bool showFilters;
  final VoidCallback onChanged;
  final VoidCallback onClear;
  final VoidCallback onToggleFilters;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      key: PredictionsSearchPage.searchFieldKey,
      controller: controller,
      placeholder: 'Tìm theo tiêu đề, thẻ, danh mục...',
      autofocus: true,
      filterKey: PredictionsSearchPage.filtersToggleKey,
      filterActive: showFilters,
      filterInline: true,
      onChanged: (_) => onChanged(),
      onClear: onClear,
      onFilterTap: onToggleFilters,
    );
  }
}

class _SearchFilterSection extends StatelessWidget {
  const _SearchFilterSection({
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
        const _FilterLabel('Sắp xếp'),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: VitTabBar(
            variant: VitTabBarVariant.pill,
            activeKey: sort.name,
            onChanged: (key) =>
                onSortSelected(PredictionSearchSort.values.byName(key)),
            tabs: [
              VitTabItem(
                key: PredictionSearchSort.trending.name,
                label: 'Xu hướng',
                icon: Icons.trending_up_outlined,
                widgetKey: PredictionsSearchPage.sortTrendingKey,
              ),
              VitTabItem(
                key: PredictionSearchSort.liquidity.name,
                label: 'Thanh khoản',
                icon: Icons.bar_chart_outlined,
                widgetKey: PredictionsSearchPage.sortLiquidityKey,
              ),
              VitTabItem(
                key: PredictionSearchSort.volume.name,
                label: 'Khối lượng',
                icon: Icons.show_chart_outlined,
                widgetKey: const Key('sc028_sort_volume'),
              ),
              VitTabItem(
                key: PredictionSearchSort.newest.name,
                label: 'Mới nhất',
                icon: Icons.fiber_new_outlined,
                widgetKey: const Key('sc028_sort_newest'),
              ),
              VitTabItem(
                key: PredictionSearchSort.ending.name,
                label: 'Sắp đóng',
                icon: Icons.schedule_outlined,
                widgetKey: const Key('sc028_sort_ending'),
              ),
              VitTabItem(
                key: PredictionSearchSort.competitive.name,
                label: 'Cạnh tranh',
                icon: Icons.track_changes_outlined,
                widgetKey: const Key('sc028_sort_competitive'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const _FilterLabel('Trạng thái'),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitSegmentedChoice<PredictionStatusFilter>(
          selected: status,
          onChanged: onStatusSelected,
          options: const [
            VitSegmentedChoiceOption(
              value: PredictionStatusFilter.active,
              label: 'Đang mở',
              key: PredictionsSearchPage.statusActiveKey,
            ),
            VitSegmentedChoiceOption(
              value: PredictionStatusFilter.resolved,
              label: 'Đã kết thúc',
              key: PredictionsSearchPage.statusResolvedKey,
            ),
            VitSegmentedChoiceOption(
              value: PredictionStatusFilter.all,
              label: 'Tất cả',
              key: PredictionsSearchPage.statusAllKey,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const _FilterLabel('Danh mục'),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var index = 0; index < categories.length; index += 1) ...[
                VitFilterChip(
                  key: categories[index] == 'Live Crypto'
                      ? PredictionsSearchPage.categoryLiveCryptoKey
                      : Key('sc028_category_${categories[index]}'),
                  label: categories[index],
                  active: selectedCategory == categories[index],
                  onTap: () => onCategorySelected(
                    selectedCategory == categories[index]
                        ? null
                        : categories[index],
                  ),
                  color: _predictionPrimary,
                  padding:
                      PredictionsSpacingTokens.predictionHomeCategoryPadding,
                ),
                if (index != categories.length - 1)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
        ),
        if (hasActiveFilters) ...[
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCtaButton(
            key: PredictionsSearchPage.clearFiltersKey,
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

class _FilterLabel extends StatelessWidget {
  const _FilterLabel(this.label);

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
