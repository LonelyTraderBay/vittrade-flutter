part of '../../phone/pages/tools/market_screener_page.dart';

class _PresetScroller extends StatelessWidget {
  const _PresetScroller({
    required this.presets,
    required this.activePresetId,
    required this.onPresetSelected,
  });

  final List<MarketScreenerPreset> presets;
  final String? activePresetId;
  final ValueChanged<MarketScreenerPreset> onPresetSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _presetHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: presets.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x1),
        itemBuilder: (context, index) {
          final preset = presets[index];
          final active = preset.id == activePresetId;
          final chipWidth = switch (preset.id) {
            'high-volume' => 124.0,
            'gainers' => 116.0,
            'bargains' => 104.0,
            _ => 106.0,
          };
          return VitCard(
            key: MarketScreenerPage.presetKey(preset.id),
            onTap: () => onPresetSelected(preset),
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.large,
            padding: EdgeInsets.zero,
            width: chipWidth,
            height: _presetHeight,
            contentAlign: VitCardContentAlign.center,
            borderColor: AppColors.transparent,
            clip: true,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: active
                    ? _marketPrimary.withValues(alpha: .15)
                    : AppColors.surface3,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.lgRadius,
                  side: BorderSide(
                    color: active
                        ? _marketPrimary.withValues(alpha: .38)
                        : AppColors.transparent,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x2,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        MarketIconTokens.icon(preset.icon),
                        size: _presetIconSize,
                        color: active ? _marketPrimary : AppColors.text2,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        preset.name,
                        style: AppTextStyles.caption.copyWith(
                          color: active ? _marketPrimary : AppColors.text2,
                          fontWeight: AppTextStyles.medium,
                          height: AppTextStyles.caption.height,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AdvancedFiltersCard extends StatelessWidget {
  const _AdvancedFiltersCard({
    required this.query,
    required this.categories,
    required this.onCategorySelected,
    required this.onRangeChanged,
    required this.onReset,
  });

  final MarketScreenerQuery query;
  final List<String> categories;
  final ValueChanged<String> onCategorySelected;
  final void Function({
    double? minPrice,
    double? maxPrice,
    double? minVolume24h,
    double? minChange24h,
    double? maxChange24h,
    bool clearMinPrice,
    bool clearMaxPrice,
    bool clearMinVolume24h,
    bool clearMinChange24h,
    bool clearMaxChange24h,
  })
  onRangeChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: MarketScreenerPage.advancedFiltersKey,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bộ lọc nâng cao',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitCtaButton(
                key: MarketScreenerPage.resetFiltersKey,
                onPressed: onReset,
                variant: VitCtaButtonVariant.ghost,
                fullWidth: false,
                height: _resetMinHeight,
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x2,
                ),
                leading: const Icon(
                  Icons.refresh_rounded,
                  size: _resetIconSize,
                ),
                child: const Text('Đặt lại'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Danh mục',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Wrap(
            spacing: AppSpacing.x1,
            runSpacing: AppSpacing.x1,
            children: [
              for (final category in categories)
                VitFilterChip(
                  key: MarketScreenerPage.categoryKey(category),
                  label: category,
                  active: category == 'Tất cả'
                      ? query.categories.isEmpty
                      : query.categories.contains(category),
                  onTap: () => onCategorySelected(category),
                  color: _marketPrimary,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.x2,
                  ),
                  semanticLabel: category,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _RangeInput(
                  label: 'Giá min',
                  value: query.minPrice,
                  onChanged: (value, clear) =>
                      onRangeChanged(minPrice: value, clearMinPrice: clear),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _RangeInput(
                  label: 'Giá max',
                  value: query.maxPrice,
                  onChanged: (value, clear) =>
                      onRangeChanged(maxPrice: value, clearMaxPrice: clear),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: _RangeInput(
                  label: 'KL 24h min',
                  value: query.minVolume24h,
                  onChanged: (value, clear) => onRangeChanged(
                    minVolume24h: value,
                    clearMinVolume24h: clear,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _RangeInput(
                  label: '% đổi min',
                  value: query.minChange24h,
                  onChanged: (value, clear) => onRangeChanged(
                    minChange24h: value,
                    clearMinChange24h: clear,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RangeInput extends StatelessWidget {
  const _RangeInput({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final double? value;
  final void Function(double? value, bool clear) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-${value ?? 'empty'}'),
      initialValue: value == null ? '' : value!.toStringAsFixed(0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (raw) {
        final normalized = raw.trim();
        if (normalized.isEmpty) {
          onChanged(null, true);
          return;
        }
        onChanged(double.tryParse(normalized), false);
      },
      cursorColor: _marketPrimary,
      style: AppTextStyles.caption,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
        filled: true,
        fillColor: AppColors.surface2,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.x3,
          vertical: _rangeInputVerticalPadding,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.borderSolid),
          borderRadius: AppRadii.smRadius,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: _marketPrimary),
          borderRadius: AppRadii.smRadius,
        ),
      ),
    );
  }
}

class _SortScroller extends StatelessWidget {
  const _SortScroller({
    required this.query,
    required this.resultCount,
    required this.onSortSelected,
  });

  final MarketScreenerQuery query;
  final int resultCount;
  final ValueChanged<MarketScreenerSort> onSortSelected;

  @override
  Widget build(BuildContext context) {
    final options = [
      (MarketScreenerSort.marketCap, 'Vốn hóa'),
      (MarketScreenerSort.volume, 'Khối lượng'),
      (MarketScreenerSort.change24h, 'Thay đổi 24h'),
      (MarketScreenerSort.price, 'Giá'),
    ];

    return SizedBox(
      height: _sortHeight,
      child: Row(
        children: [
          for (var index = 0; index < options.length; index++) ...[
            Expanded(
              flex: switch (options[index].$1) {
                MarketScreenerSort.marketCap => 18,
                MarketScreenerSort.volume => 24,
                MarketScreenerSort.change24h => 28,
                MarketScreenerSort.price => 13,
              },
              child: _SortHeaderChip(
                sort: options[index].$1,
                label: options[index].$2,
                active: query.sortBy == options[index].$1,
                direction: query.sortDirection,
                onTap: () => onSortSelected(options[index].$1),
              ),
            ),
            if (index != options.length - 1)
              const SizedBox(width: AppSpacing.x1),
          ],
          const SizedBox(width: AppSpacing.x1),
          SizedBox(
            width: _sortResultWidth,
            child: Text(
              '$resultCount kết quả',
              maxLines: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: AppTextStyles.caption.height,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortHeaderChip extends StatelessWidget {
  const _SortHeaderChip({
    required this.sort,
    required this.label,
    required this.active,
    required this.direction,
    required this.onTap,
  });

  final MarketScreenerSort sort;
  final String label;
  final bool active;
  final MarketSortDirection direction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = direction == MarketSortDirection.desc
        ? Icons.keyboard_arrow_down_rounded
        : Icons.keyboard_arrow_up_rounded;

    return VitCard(
      key: MarketScreenerPage.sortKey(sort),
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.large,
      padding: EdgeInsets.zero,
      borderColor: AppColors.transparent,
      clip: true,
      child: Material(
        color: active
            ? _marketPrimary.withValues(alpha: .10)
            : AppColors.transparent,
        borderRadius: AppRadii.lgRadius,
        child: SizedBox(
          height: _sortChipHeight,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.x1,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: active ? _marketPrimary : AppColors.text3,
                        fontWeight: active
                            ? AppTextStyles.bold
                            : AppTextStyles.medium,
                        height: AppTextStyles.caption.height,
                      ),
                    ),
                    if (active) ...[
                      const SizedBox(width: AppSpacing.x1),
                      Icon(icon, color: _marketPrimary, size: _sortIconSize),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
