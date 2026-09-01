import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_time_remaining.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_outcome_widgets.dart';

part '../../../widgets/phone/predictions_search_page_sections.dart';
part '../../../widgets/phone/predictions_search_page_common.dart';

const _predictionPrimary = AppColors.primary;

class PredictionsSearchPage extends ConsumerStatefulWidget {
  const PredictionsSearchPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc028_predictions_search_content');
  static const searchFieldKey = Key('sc028_search_field');
  static const filtersToggleKey = Key('sc028_filters_toggle');
  static const sortTrendingKey = Key('sc028_sort_trending');
  static const sortLiquidityKey = Key('sc028_sort_liquidity');
  static const statusActiveKey = Key('sc028_status_active');
  static const statusResolvedKey = Key('sc028_status_resolved');
  static const statusAllKey = Key('sc028_status_all');
  static const categoryLiveCryptoKey = Key('sc028_category_live_crypto');
  static const clearFiltersKey = Key('sc028_clear_filters');

  static Key resultKey(String id) => Key('sc028_result_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsSearchPage> createState() =>
      _PredictionsSearchPageState();
}

class _PredictionsSearchPageState extends ConsumerState<PredictionsSearchPage> {
  final TextEditingController _searchController = TextEditingController();

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
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tìm sự kiện dự đoán: lọc theo chủ đề và xác suất',
      semanticIdentifier: 'SC-028',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.detail,
            title: 'Tìm sự kiện',
            subtitle: 'Lọc theo chủ đề · xác suất',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
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
                    key: PredictionsSearchPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionHomeScrollPadding(
                          scrollEndPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      density: VitDensity.compact,
                      children: searchAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được kết quả tìm kiếm',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsSearchSnapshotProvider(searchQuery),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _SearchControl(
                            controller: _searchController,
                            showFilters: _showFilters,
                            onChanged: () => setState(() {}),
                            onClear: () => setState(_searchController.clear),
                            onToggleFilters: () => setState(() {
                              _showFilters = !_showFilters;
                            }),
                          ),
                          if (_showFilters)
                            _SearchFilterSection(
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
                            ),
                          Text(
                            _resultsLabel(snapshot.results.length),
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          if (snapshot.results.isEmpty)
                            _SearchEmptyState(
                              hasActiveFilters: _hasActiveFilters,
                              onClearFilters: _clearFilters,
                              onBreaking: () => context.go(
                                AppRoutePaths.marketsPredictionsBreaking,
                              ),
                            )
                          else
                            for (final event in snapshot.results)
                              _SearchResultCard(
                                key: PredictionsSearchPage.resultKey(event.id),
                                event: event,
                                onTap: () => context.go(
                                  AppRoutePaths.marketsPredictionEvent(
                                    event.id,
                                  ),
                                ),
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

  void _clearFilters() {
    setState(() {
      _sort = PredictionSearchSort.trending;
      _status = PredictionStatusFilter.active;
      _category = null;
      _searchController.clear();
    });
  }
}
