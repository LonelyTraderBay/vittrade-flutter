part of 'advanced_charts_page.dart';

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({
    super.key,
    required this.indicator,
    required this.category,
    required this.active,
    required this.expanded,
    required this.onToggleActive,
    required this.onToggleExpanded,
  });

  final TechnicalIndicator indicator;
  final AdvancedChartCategory? category;
  final bool active;
  final bool expanded;
  final VoidCallback onToggleActive;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              onTap: onToggleExpanded,
              child: Padding(
                padding: _advancedIndicatorHeaderPadding,
                child: Row(
                  children: [
                    Material(
                      color: indicator.color.resolve().withValues(alpha: .08),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.smRadius,
                      ),
                      child: SizedBox.square(
                        dimension: _advancedIndicatorAvatar,
                        child: Center(
                          child: Text(
                            indicator.shortName.length <= 3
                                ? indicator.shortName
                                : indicator.shortName.substring(0, 3),
                            style: AppTextStyles.micro.copyWith(
                              color: indicator.color.resolve(),
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: _advancedGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                indicator.shortName,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(width: _advancedCompactGap),
                              _CategoryBadge(category: category),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.dividerHairline),
                          Text(
                            indicator.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: _advancedGap),
                    _IndicatorToggle(
                      key: AdvancedChartsPage.indicatorToggleKey(indicator.id),
                      active: active,
                      color: indicator.color.resolve(),
                      onTap: onToggleActive,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (expanded) _IndicatorDetails(indicator: indicator),
        ],
      ),
    );
  }
}

class _IndicatorList extends StatelessWidget {
  const _IndicatorList({
    required this.indicators,
    required this.categories,
    required this.activeIndicatorIds,
    required this.expandedIndicatorId,
    required this.onToggleActive,
    required this.onToggleExpanded,
  });

  final List<TechnicalIndicator> indicators;
  final List<AdvancedChartCategory> categories;
  final Set<String> activeIndicatorIds;
  final String? expandedIndicatorId;
  final ValueChanged<String> onToggleActive;
  final ValueChanged<TechnicalIndicator> onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final indicator in indicators) ...[
          _IndicatorCard(
            key: AdvancedChartsPage.indicatorKey(indicator.id),
            indicator: indicator,
            category: _categoryFor(categories, indicator.categoryId),
            active: activeIndicatorIds.contains(indicator.id),
            expanded: expandedIndicatorId == indicator.id,
            onToggleActive: () => onToggleActive(indicator.id),
            onToggleExpanded: () => onToggleExpanded(indicator),
          ),
          if (indicator != indicators.last)
            const SizedBox(height: _advancedMicroGap),
        ],
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final AdvancedChartCategory? category;

  @override
  Widget build(BuildContext context) {
    final color = category?.color.resolve() ?? AppColors.text3;
    return Material(
      color: color.withValues(alpha: .08),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      child: Padding(
        padding: _advancedCategoryBadgePadding,
        child: Text(
          category?.label ?? 'Khác',
          style: AppTextStyles.micro.copyWith(
            color: color,
            height: _advancedLineHeightCaption,
          ),
        ),
      ),
    );
  }
}

class _IndicatorToggle extends StatelessWidget {
  const _IndicatorToggle({
    super.key,
    required this.active,
    required this.color,
    required this.onTap,
  });

  final bool active;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: active ? 'Tắt chỉ báo' : 'Bật chỉ báo',
      // card-tile: allow-start — fixed surface, not horizontal strip tile
      child: VitCard(
        variant: VitCardVariant.ghost,
        radius: VitCardRadius.standard,
        width: _advancedToggleSize,
        height: _advancedToggleSize,
        borderColor: active ? color : AppColors.borderSolid,
        background: ColoredBox(
          color: active ? color.withValues(alpha: .08) : AppColors.surface2,
        ),
        clip: true,
        onTap: onTap,
        child: Center(
          child: active
              ? Icon(
                  Icons.check_rounded,
                  size: _advancedToggleIcon,
                  color: color,
                )
              : Text(
                  '+',
                  style: AppTextStyles.body.copyWith(color: AppColors.text3),
                ),
        ),
      ),
    );
  }
}

class _IndicatorDetails extends StatelessWidget {
  const _IndicatorDetails({required this.indicator});

  final TechnicalIndicator indicator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: AppSpacing.dividerHairline),
        Padding(
          padding: _advancedDetailsPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                indicator.description,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              if (indicator.params.isNotEmpty) ...[
                const SizedBox(height: _advancedCompactGap),
                Wrap(
                  spacing: _advancedCompactGap,
                  runSpacing: _advancedCompactGap,
                  children: [
                    for (final param in indicator.params)
                      Material(
                        color: AppColors.surface2,
                        shape: const RoundedRectangleBorder(
                          borderRadius: AppRadii.smRadius,
                        ),
                        child: Padding(
                          padding: _advancedParamPadding,
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.micro,
                              children: [
                                TextSpan(
                                  text: '${param.label}: ',
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                  ),
                                ),
                                TextSpan(
                                  text: '${param.value}',
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DrawingInfoCard extends StatelessWidget {
  const _DrawingInfoCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _marketPrimary.withValues(alpha: .15),
      padding: _advancedCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.edit_rounded,
            size: _advancedInfoIcon,
            color: _marketPrimary,
          ),
          const SizedBox(width: _advancedGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bộ công cụ vẽ chuyên nghiệp',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _advancedTinyGap),
                Text(
                  'Chọn công cụ bên dưới để vẽ trên biểu đồ. Hỗ trợ đường xu hướng, kênh giá, Fibonacci và đo lường.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: _advancedLineHeightReadable,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawingToolsGrid extends StatelessWidget {
  const _DrawingToolsGrid({required this.tools, required this.categories});

  final List<AdvancedDrawingTool> tools;
  final List<AdvancedChartCategory> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _advancedGridColumns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: _advancedCompactGap,
      crossAxisSpacing: _advancedCompactGap,
      childAspectRatio: _advancedGridAspectRatio,
      children: [
        for (final tool in tools)
          VitCard(
            key: AdvancedChartsPage.drawingToolKey(tool.id),
            padding: _advancedCardPaddingCompact,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MarketIconTokens.icon(tool.icon),
                  size: _advancedToolIcon,
                  color: AppColors.text1,
                ),
                const SizedBox(height: _advancedMiniHeaderGap),
                Text(
                  tool.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: _advancedLineHeightCaption,
                  ),
                ),
                const SizedBox(height: _advancedTinyGap),
                Text(
                  _categoryFor(categories, tool.categoryId)?.label ?? '',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  static const _tips = [
    (Icons.timeline_rounded, 'Nhấn giữ để vẽ đường xu hướng trên chart'),
    (Icons.format_list_numbered_rounded, 'Double-tap để đặt điểm Fibonacci'),
    (Icons.zoom_in_rounded, 'Kéo 2 ngón để zoom in/out biểu đồ'),
    (Icons.swipe_rounded, 'Vuốt ngang để di chuyển timeline'),
  ];

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _advancedCardPadding,
      child: Column(
        children: [
          for (var index = 0; index < _tips.length; index += 1) ...[
            Row(
              children: [
                Icon(
                  _tips[index].$1,
                  size: _advancedTipIcon,
                  color: AppColors.text2,
                ),
                const SizedBox(width: _advancedGap),
                Expanded(
                  child: Text(
                    _tips[index].$2,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            if (index != _tips.length - 1) const SizedBox(height: _advancedGap),
          ],
        ],
      ),
    );
  }
}
