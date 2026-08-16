import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/market_icon_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_formatters.dart';
part '../../../widgets/tools/market_screener_filters.dart';
part '../../../widgets/tools/market_screener_results.dart';
part '../../../widgets/tools/market_screener_row_common.dart';

const _marketPrimary = AppColors.primary;
const _visualNavClearance = 90.0;
const _nativeNavClearance = 72.0;
const _screenerVisualNavExtra = 54.0;
const _presetHeight = 32.0;
const _presetIconSize = 14.0;
const _resetIconSize = 14.0;
const _resetMinHeight = 30.0;
const _rangeInputVerticalPadding = 8.0;
const _sortHeight = 34.0;
const _sortChipHeight = 32.0;
const _sortIconSize = 15.0;
const _sortResultWidth = 58.0;
const _rowHeight = 54.0;
const _rowRankWidth = 20.0;
const _rowAvatarSize = 28.0;
const _sparklineWidth = 52.0;
const _sparklineHeight = 20.0;
const _sparklineStroke = 1.6;
const _valueWidth = 76.0;
const _trendIconSize = 12.0;
const _emptyIconSize = 32.0;

class MarketScreenerPage extends ConsumerStatefulWidget {
  const MarketScreenerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc015_market_screener_scroll_content');
  static const searchKey = Key('sc015_search');
  static const advancedFiltersKey = Key('sc015_advanced_filters');
  static const resetFiltersKey = Key('sc015_reset_filters');

  static Key presetKey(String id) => Key('sc015_preset_$id');

  static Key sortKey(MarketScreenerSort sort) => Key('sc015_sort_$sort');

  static Key rowKey(String id) => Key('sc015_row_$id');

  static Key categoryKey(String category) => Key('sc015_category_$category');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketScreenerPage> createState() => _MarketScreenerPageState();
}

class _MarketScreenerPageState extends ConsumerState<MarketScreenerPage> {
  final TextEditingController _searchController = TextEditingController();
  MarketScreenerQuery _query = MarketScreenerQuery.defaults;
  String? _activePresetId;
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasActiveFilters {
    return _activePresetId != null ||
        _query.categories.isNotEmpty ||
        _query.minPrice != null ||
        _query.maxPrice != null ||
        _query.minMarketCap != null ||
        _query.maxMarketCap != null ||
        _query.minVolume24h != null ||
        _query.maxVolume24h != null ||
        _query.minChange24h != null ||
        _query.maxChange24h != null ||
        _searchController.text.isNotEmpty;
  }

  void _applyPreset(MarketScreenerPreset preset) {
    setState(() {
      _activePresetId = preset.id;
      _query = preset.query.copyWith(searchQuery: _searchController.text);
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _query = MarketScreenerQuery.defaults;
      _activePresetId = null;
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (category == 'Tất cả') {
        _query = _query.copyWith(categories: const []);
      } else {
        final categories = [..._query.categories];
        if (categories.contains(category)) {
          categories.remove(category);
        } else {
          categories.add(category);
        }
        _query = _query.copyWith(categories: categories);
      }
      _activePresetId = null;
    });
  }

  void _toggleSort(MarketScreenerSort sort) {
    setState(() {
      final direction =
          _query.sortBy == sort &&
              _query.sortDirection == MarketSortDirection.desc
          ? MarketSortDirection.asc
          : MarketSortDirection.desc;
      _query = _query.copyWith(sortBy: sort, sortDirection: direction);
      _activePresetId = null;
    });
  }

  void _updateRange({
    double? minPrice,
    double? maxPrice,
    double? minVolume24h,
    double? minChange24h,
    double? maxChange24h,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearMinVolume24h = false,
    bool clearMinChange24h = false,
    bool clearMaxChange24h = false,
  }) {
    setState(() {
      _query = _query.copyWith(
        minPrice: minPrice,
        maxPrice: maxPrice,
        minVolume24h: minVolume24h,
        minChange24h: minChange24h,
        maxChange24h: maxChange24h,
        clearMinPrice: clearMinPrice,
        clearMaxPrice: clearMaxPrice,
        clearMinVolume24h: clearMinVolume24h,
        clearMinChange24h: clearMinChange24h,
        clearMaxChange24h: clearMaxChange24h,
      );
      _activePresetId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // GD4-F3: `presets`/`screenFilters` không đổi theo query (const trong
    // mock) — chỉ cần 1 provider theo appliedQuery, không cần gọi
    // getMarketScreener() không tham số riêng (khác social_signals/
    // token_unlocks vì screener KHÔNG có field nào phụ thuộc toàn tập).
    final appliedQuery = _query.copyWith(searchQuery: _searchController.text);
    final screenerAsync = ref.watch(
      marketScreenerSnapshotProvider(appliedQuery),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _visualNavClearance
        : _nativeNavClearance;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _screenerVisualNavExtra
            : AppSpacing.contentPad);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Bộ lọc thị trường',
      semanticIdentifier: 'SC-015',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Bộ lọc thị trường',
            subtitle: 'Lọc token · Markets',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.markets),
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
                    key: MarketScreenerPage.contentKey,
                    padding: MarketsSpacingTokens.marketScreenerScrollPadding(
                      scrollEndPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      density: VitDensity.compact,
                      children: screenerAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được bộ lọc thị trường',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              marketScreenerSnapshotProvider(appliedQuery),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          VitSearchBar(
                            key: MarketScreenerPage.searchKey,
                            controller: _searchController,
                            placeholder: 'Tìm kiếm token...',
                            filterInline: true,
                            filterActive: _hasActiveFilters,
                            onChanged: (_) => setState(() {}),
                            onClear: () => setState(() {}),
                            onFilterTap: () {
                              setState(() => _showFilters = !_showFilters);
                            },
                          ),
                          _PresetScroller(
                            presets: snapshot.presets,
                            activePresetId: _activePresetId,
                            onPresetSelected: _applyPreset,
                          ),
                          if (_showFilters)
                            _AdvancedFiltersCard(
                              query: _query,
                              categories: snapshot.screenFilters.categories,
                              onCategorySelected: _toggleCategory,
                              onRangeChanged: _updateRange,
                              onReset: _resetFilters,
                            ),
                          _SortScroller(
                            query: _query,
                            resultCount: snapshot.marketPairs.length,
                            onSortSelected: _toggleSort,
                          ),
                          if (snapshot.marketPairs.isEmpty)
                            _ScreenerEmptyState(onReset: _resetFilters)
                          else
                            _ScreenerResults(
                              pairs: snapshot.marketPairs,
                              onPairTap: (pair) =>
                                  context.go(AppRoutePaths.pairDetail(pair.id)),
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
}
