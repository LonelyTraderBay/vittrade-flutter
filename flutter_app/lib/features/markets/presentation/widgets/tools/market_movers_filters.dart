part of '../../phone/pages/tools/market_movers_page.dart';

const double _marketMoverFilterMinHeight = 44;

class _MoverTabs extends StatelessWidget {
  const _MoverTabs({
    required this.tabs,
    required this.activeTab,
    required this.onSelected,
  });

  final List<String> tabs;
  final String activeTab;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: VitDensity.compact.controlHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            for (final tab in tabs) ...[
              VitFilterChip(
                key: _tabKey(tab),
                label: tab,
                active: tab == activeTab,
                color: _marketPrimary,
                height: _marketMoverFilterMinHeight,
                padding: MarketsSpacingTokens.marketFilterChipPadding,
                onTap: () => onSelected(tab),
              ),
              if (tab != tabs.last)
                const SizedBox(width: MarketsSpacingTokens.marketFilterGap),
            ],
          ],
        ),
      ),
    );
  }

  Key _tabKey(String tab) {
    return switch (tab) {
      'Giảm mạnh' => MarketMoversPage.losersTabKey,
      'Hoạt động' => MarketMoversPage.activeTabKey,
      'KL bất thường' => MarketMoversPage.unusualTabKey,
      'Mới niêm yết' => MarketMoversPage.newListingsTabKey,
      _ => MarketMoversPage.gainersTabKey,
    };
  }
}

class _TimeframeSelector extends StatelessWidget {
  const _TimeframeSelector({
    required this.timeframes,
    required this.activeTimeframe,
    required this.onSelected,
  });

  final List<String> timeframes;
  final String activeTimeframe;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Khung thời gian:',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketTimeframeLabelGap),
        Expanded(
          child: SizedBox(
            height: VitDensity.compact.controlHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: timeframes.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: MarketsSpacingTokens.marketFilterGap),
              itemBuilder: (context, index) {
                final timeframe = timeframes[index];
                return VitFilterChip(
                  key: timeframe == '24h'
                      ? MarketMoversPage.timeframe24hKey
                      : Key('sc010_timeframe_$timeframe'),
                  label: timeframe,
                  active: timeframe == activeTimeframe,
                  color: _marketPrimary,
                  height: _marketMoverFilterMinHeight,
                  padding: MarketsSpacingTokens.marketFilterChipPadding,
                  onTap: () => onSelected(timeframe),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.category,
    required this.expanded,
    required this.onTap,
  });

  final String category;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.inputRadius,
        side: BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        key: MarketMoversPage.categoryDropdownKey,
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: VitDensity.compact.controlHeight,
          child: Padding(
            padding: MarketsSpacingTokens.marketCategoryDropdownPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh mục: $category',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: MarketsSpacingTokens.marketFilterGap,
      runSpacing: MarketsSpacingTokens.marketFilterGap,
      children: [
        for (final category in categories)
          VitFilterChip(
            key: Key('sc010_category_$category'),
            label: category,
            active: category == activeCategory,
            color: _marketPrimary,
            height: _marketMoverFilterMinHeight,
            padding: MarketsSpacingTokens.marketFilterChipPadding,
            onTap: () => onSelected(category),
          ),
      ],
    );
  }
}

class _SortSelector extends StatelessWidget {
  const _SortSelector({
    required this.options,
    required this.activeSort,
    required this.onSelected,
  });

  final List<MarketSortOption> options;
  final String activeSort;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: MarketsSpacingTokens.marketFilterGap,
      runSpacing: MarketsSpacingTokens.marketFilterGap,
      children: [
        for (final option in options)
          VitFilterChip(
            key: _sortKey(option.id),
            label: option.label,
            active: option.id == activeSort,
            color: _marketPrimary,
            height: _marketMoverFilterMinHeight,
            padding: MarketsSpacingTokens.marketFilterChipPadding,
            onTap: () => onSelected(option.id),
          ),
      ],
    );
  }

  Key _sortKey(String id) {
    return switch (id) {
      'volume' => MarketMoversPage.sortVolumeKey,
      'market_cap' => MarketMoversPage.sortMarketCapKey,
      _ => MarketMoversPage.sortChangeKey,
    };
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({
    required this.count,
    required this.sortLabel,
    required this.timeframe,
  });

  final int count;
  final String sortLabel;
  final String timeframe;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count kết quả',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketFilterGap),
        const VitAccentPill(label: 'LIVE', accentColor: AppColors.buy),
        const Expanded(child: SizedBox.shrink()),
        Flexible(
          child: Text(
            'Sắp xếp theo $sortLabel $timeframe',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
      ],
    );
  }
}
