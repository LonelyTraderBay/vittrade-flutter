part of 'advanced_charts_page.dart';

class _AdvancedChartsPageState extends ConsumerState<AdvancedChartsPage> {
  String _tab = 'indicators';
  String _indicatorCategory = 'all';
  String _drawingCategory = 'all';
  final Set<String> _activeIndicatorIds = {'sma', 'rsi'};
  String? _expandedIndicatorId;

  @override
  Widget build(BuildContext context) {
    final chartsAsync = ref.watch(
      marketAdvancedChartsSnapshotProvider((
        indicatorCategory: _indicatorCategory,
        drawingCategory: _drawingCategory,
      )),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _advancedVisualScrollClearance
            : _advancedNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích kỹ thuật',
      semanticIdentifier: 'SC-023',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Phân tích kỹ thuật',
            subtitle: 'Biểu đồ · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AdvancedChartsTabs(
                activeTab: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: AdvancedChartsPage.contentKey,
                    padding: MarketsSpacingTokens.marketScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.flush,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
                      children: chartsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được phân tích kỹ thuật',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketAdvancedChartsSnapshotProvider((
                                indicatorCategory: _indicatorCategory,
                                drawingCategory: _drawingCategory,
                              )),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          if (_tab == 'indicators') ...[
                            _ActiveIndicatorSummary(
                              activeCount: _activeIndicatorIds.length,
                              onClearAll: _activeIndicatorIds.isEmpty
                                  ? null
                                  : () => setState(_activeIndicatorIds.clear),
                            ),
                            if (_activeIndicatorIds.isNotEmpty)
                              _ActiveIndicatorChips(
                                indicators: _activeIndicators(snapshot),
                                onRemove: _toggleIndicator,
                              ),
                            _IndicatorCategoryFilter(
                              categories: snapshot.indicatorCategories,
                              activeCategory: _indicatorCategory,
                              onSelected: (value) => setState(() {
                                _indicatorCategory = value;
                              }),
                            ),
                            _IndicatorList(
                              indicators: snapshot.indicators,
                              categories: snapshot.indicatorCategories,
                              activeIndicatorIds: _activeIndicatorIds,
                              expandedIndicatorId: _expandedIndicatorId,
                              onToggleActive: _toggleIndicator,
                              onToggleExpanded: (indicator) => setState(() {
                                _expandedIndicatorId =
                                    _expandedIndicatorId == indicator.id
                                    ? null
                                    : indicator.id;
                              }),
                            ),
                          ] else if (_tab == 'drawing') ...[
                            const _DrawingInfoCard(),
                            _DrawingCategoryFilter(
                              categories: snapshot.drawingCategories,
                              activeCategory: _drawingCategory,
                              onSelected: (value) => setState(() {
                                _drawingCategory = value;
                              }),
                            ),
                            _DrawingToolsGrid(
                              tools: snapshot.drawingTools,
                              categories: snapshot.drawingCategories,
                            ),
                            const VitSectionHeader(
                              title: 'Mẹo sử dụng',
                              accentColor: AppColors.warn,
                              bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                              variant: VitSectionHeaderVariant.accentBar,
                            ),
                            const _TipsCard(),
                          ] else ...[
                            for (final signal in snapshot.signalSummaries)
                              _SignalSummaryCard(signal: signal),
                          ],
                          const VitBanner(
                            variant: VitBannerVariant.info,
                            icon: Icons.info_outline_rounded,
                            message:
                                'Tín hiệu kỹ thuật chỉ mang tính tham khảo. Không phải khuyến nghị đầu tư.',
                            detail:
                                'Chỉ báo và công cụ vẽ hỗ trợ phân tích — không thay thế quyết định giao dịch.',
                          ),
                        ],
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

  List<TechnicalIndicator> _activeIndicators(
    MarketAdvancedChartsSnapshot snapshot,
  ) {
    // Bẫy mới (GD4-F3): cần danh sách KHÔNG lọc theo category để tra cứu
    // active-indicator chip dù đang lọc category khác — đọc qua provider
    // "phụ" .value + fallback snapshot đã lọc (mục 5, "2 async song song").
    final all = ref
        .watch(
          marketAdvancedChartsSnapshotProvider((
            indicatorCategory: 'all',
            drawingCategory: 'all',
          )),
        )
        .value;
    final indicators = all?.indicators ?? snapshot.indicators;
    return [
      for (final id in _activeIndicatorIds)
        indicators.firstWhere(
          (indicator) => indicator.id == id,
          orElse: () => snapshot.indicators.first,
        ),
    ];
  }

  void _toggleIndicator(String id) {
    setState(() {
      if (_activeIndicatorIds.contains(id)) {
        _activeIndicatorIds.remove(id);
      } else {
        _activeIndicatorIds.add(id);
      }
    });
  }
}

class _AdvancedChartsTabs extends StatelessWidget {
  const _AdvancedChartsTabs({required this.activeTab, required this.onChanged});

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
                    key: 'indicators',
                    label: 'Chỉ báo',
                    widgetKey: AdvancedChartsPage.indicatorsTabKey,
                  ),
                  VitTabItem(
                    key: 'drawing',
                    label: 'Công cụ vẽ',
                    widgetKey: AdvancedChartsPage.drawingTabKey,
                  ),
                  VitTabItem(
                    key: 'signals',
                    label: 'Tín hiệu kỹ thuật',
                    widgetKey: AdvancedChartsPage.signalsTabKey,
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

class _ActiveIndicatorSummary extends StatelessWidget {
  const _ActiveIndicatorSummary({
    required this.activeCount,
    required this.onClearAll,
  });

  final int activeCount;
  final VoidCallback? onClearAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Đang sử dụng: $activeCount chỉ báo',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
        if (onClearAll != null)
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            key: AdvancedChartsPage.clearAllKey,
            onTap: onClearAll,
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.standard,
            padding: _advancedClearButtonPadding,
            constraints: const BoxConstraints(
              minHeight: _advancedActionMinHeight,
            ),
            borderColor: AppColors.transparent,
            child: Text(
              'Xóa tất cả',
              style: AppTextStyles.micro.copyWith(color: AppColors.sell),
            ),
          ),
      ],
    );
  }
}

class _ActiveIndicatorChips extends StatelessWidget {
  const _ActiveIndicatorChips({
    required this.indicators,
    required this.onRemove,
  });

  final List<TechnicalIndicator> indicators;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: _advancedSmallGap,
      runSpacing: _advancedSmallGap,
      children: [
        for (final indicator in indicators)
          Material(
            color: indicator.color.resolve().withValues(alpha: .08),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.smRadius,
              side: BorderSide(
                color: indicator.color.resolve().withValues(alpha: .22),
              ),
            ),
            child: Padding(
              padding: _advancedActiveChipPadding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    indicator.shortName,
                    style: AppTextStyles.micro.copyWith(
                      color: indicator.color.resolve(),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(width: _advancedSmallGap),
                  // card-tile: allow-start — fixed surface, not horizontal strip tile
                  VitCard(
                    onTap: () => onRemove(indicator.id),
                    variant: VitCardVariant.ghost,
                    radius: VitCardRadius.standard,
                    padding: EdgeInsets.zero,
                    width: _advancedChipRemoveIcon,
                    height: _advancedChipRemoveIcon,
                    borderColor: AppColors.transparent,
                    child: Icon(
                      Icons.close_rounded,
                      size: _advancedChipRemoveIcon,
                      color: indicator.color.resolve(),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _IndicatorCategoryFilter extends StatelessWidget {
  const _IndicatorCategoryFilter({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<AdvancedChartCategory> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          VitFilterChip(
            key: AdvancedChartsPage.categoryAllKey,
            label: 'Tất cả',
            active: activeCategory == 'all',
            color: _marketPrimary,
            onTap: () => onSelected('all'),
            padding: _advancedFilterChipPadding,
          ),
          const SizedBox(width: _advancedCompactGap),
          for (final category in categories) ...[
            VitFilterChip(
              key: category.id == 'trend'
                  ? AdvancedChartsPage.categoryTrendKey
                  : null,
              label: category.label,
              active: activeCategory == category.id,
              color: category.color.resolve(),
              onTap: () => onSelected(category.id),
              padding: _advancedFilterChipPadding,
            ),
            if (category != categories.last)
              const SizedBox(width: _advancedCompactGap),
          ],
        ],
      ),
    );
  }
}

class _DrawingCategoryFilter extends StatelessWidget {
  const _DrawingCategoryFilter({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<AdvancedChartCategory> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          VitFilterChip(
            label: 'Tất cả',
            active: activeCategory == 'all',
            color: _marketPrimary,
            onTap: () => onSelected('all'),
            padding: _advancedFilterChipPadding,
          ),
          const SizedBox(width: _advancedCompactGap),
          for (final category in categories) ...[
            VitFilterChip(
              key: category.id == 'line'
                  ? AdvancedChartsPage.drawingLineKey
                  : null,
              label: category.label,
              active: activeCategory == category.id,
              color: _marketPrimary,
              onTap: () => onSelected(category.id),
              padding: _advancedFilterChipPadding,
            ),
            if (category != categories.last)
              const SizedBox(width: _advancedCompactGap),
          ],
        ],
      ),
    );
  }
}
