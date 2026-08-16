import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_time_remaining.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_outcome_widgets.dart';

part '../../../widgets/phone/predictions_home_filters.dart';
part '../../../widgets/phone/predictions_home_highlights.dart';
part '../../../widgets/phone/predictions_home_events.dart';

const _marketPrimary = AppColors.primary;

class PredictionsHomePage extends ConsumerStatefulWidget {
  const PredictionsHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc027_predictions_home_scroll_content');
  static const searchActionKey = Key('sc027_search_action');
  static const searchFieldKey = Key('sc027_search_field');
  static const trendingFilterKey = Key('sc027_filter_trending');
  static const newFilterKey = Key('sc027_filter_new');
  static const categoryAllKey = Key('sc027_category_all');
  static const categoryLiveCryptoKey = Key('sc027_category_live_crypto');
  static const myPredictionsKey = Key('sc027_my_predictions');
  static const portfolioHeaderKey = Key('sc027_portfolio_header');
  static const toolsSectionKey = Key('sc027_prediction_tools');
  static const breakingMoversKey = Key('sc027_breaking_movers');
  static const arenaBridgeKey = Key('sc027_arena_bridge');

  static Key eventCardKey(String id) => Key('sc027_event_$id');
  static Key toolKey(String id) => Key('sc027_tool_$id');
  static const viewAllEventsKey = Key('sc027_view_all_events');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsHomePage> createState() =>
      _PredictionsHomePageState();
}

class _PredictionsHomePageState extends ConsumerState<PredictionsHomePage> {
  final _searchController = TextEditingController();
  PredictionFilterTab _filter = PredictionFilterTab.trending;
  String? _category;
  String _searchQuery = '';

  bool get _hasActiveFilters =>
      _filter != PredictionFilterTab.trending ||
      _category != null ||
      _searchQuery.isNotEmpty;

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _category = null;
      _filter = PredictionFilterTab.trending;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(
      predictionsHomeSnapshotProvider((
        filter: _filter,
        category: _category,
        searchQuery: _searchQuery,
      )),
    );
    // Phụ (không chặn trang): tổng số sự kiện toàn cục cho hero, độc lập bộ
    // lọc hiện tại — đọc `.value` lười, ẩn hero-count đúng nghĩa nếu chưa
    // resolve (mục 5 GD4-Async-Playbook).
    final hubTotalsValue = ref
        .watch(predictionsHomeSnapshotProvider(predictionsHomeDefaultQuery))
        .value;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);
    final showDiscoveryExtras = _searchQuery.isEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Trang chủ thị trường dự đoán: xác suất và sự kiện đang mở',
      semanticIdentifier: 'SC-027',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Dự đoán thị trường',
            subtitle: 'Xác suất và sự kiện đang mở',
            showBack: true,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.markets,
              mode: BackNavigationMode.historyThenFallback,
            ),
            actions: [
              VitHeaderActionItem(
                key: PredictionsHomePage.searchActionKey,
                type: VitHeaderActionType.search,
                onPressed: () =>
                    context.go(AppRoutePaths.marketsPredictionsSearch),
              ),
              VitHeaderActionItem(
                key: PredictionsHomePage.portfolioHeaderKey,
                type: VitHeaderActionType.portfolio,
                tooltip: 'Danh mục',
                onPressed: () =>
                    context.go(AppRoutePaths.marketsPredictionsPortfolio),
              ),
            ],
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
                    key: PredictionsHomePage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionHomeScrollPadding(
                          scrollEndPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      density: VitDensity.compact,
                      children: homeAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được trang chủ dự đoán',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsHomeSnapshotProvider((
                                filter: _filter,
                                category: _category,
                                searchQuery: _searchQuery,
                              )),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _PredictionsHero(
                            openEventCount:
                                hubTotalsValue?.events.length ??
                                snapshot.events.length,
                            openPositionCount: snapshot.openPositionCount,
                            onPositionsTap: () => context.go(
                              AppRoutePaths.marketsPredictionsPortfolio,
                            ),
                          ),
                          _SearchField(
                            controller: _searchController,
                            onChanged: (value) => setState(() {
                              _searchQuery = value;
                            }),
                            onClear: () => setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            }),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: VitTabBar(
                              variant: VitTabBarVariant.pill,
                              activeKey: _filter.name,
                              onChanged: (key) => setState(
                                () => _filter = PredictionFilterTab.values
                                    .byName(key),
                              ),
                              tabs: const [
                                VitTabItem(
                                  key: 'trending',
                                  label: 'Xu hướng',
                                  icon: Icons.trending_up_outlined,
                                  widgetKey:
                                      PredictionsHomePage.trendingFilterKey,
                                ),
                                VitTabItem(
                                  key: 'newEvents',
                                  label: 'Mới',
                                  icon: Icons.fiber_new_outlined,
                                  widgetKey: PredictionsHomePage.newFilterKey,
                                ),
                                VitTabItem(
                                  key: 'popular',
                                  label: 'Phổ biến',
                                  icon: Icons.group_outlined,
                                  widgetKey: Key('sc027_filter_popular'),
                                ),
                                VitTabItem(
                                  key: 'liquid',
                                  label: 'Thanh khoản',
                                  icon: Icons.bar_chart_outlined,
                                  widgetKey: Key('sc027_filter_liquid'),
                                ),
                                VitTabItem(
                                  key: 'ending',
                                  label: 'Sắp đóng',
                                  icon: Icons.schedule_outlined,
                                  widgetKey: Key('sc027_filter_ending'),
                                ),
                              ],
                            ),
                          ),
                          _CategoryChips(
                            categories: snapshot.categories,
                            activeCategory: _category,
                            onSelected: (value) => setState(() {
                              _category = _category == value ? null : value;
                            }),
                          ),
                          if (showDiscoveryExtras) ...[
                            _BreakingMoversStrip(
                              snapshot: snapshot,
                              onTap: () => context.go(
                                AppRoutePaths.marketsPredictionsBreaking,
                              ),
                            ),
                            _ArenaBridgeCard(
                              onTap: () => context.go(AppRoutePaths.arena),
                            ),
                          ],
                          if (snapshot.highRiskContractId != null)
                            VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Trạng thái thị trường dự đoán',
                              message:
                                  'Thiết lập sự kiện, xem trước rủi ro, xác nhận, biên lai, danh mục và hỗ trợ dùng luồng high-risk chung.',
                              contractId: snapshot.highRiskContractId,
                            ),
                          if (snapshot.events.isEmpty)
                            _PredictionsEmptyState(
                              hasActiveFilters: _hasActiveFilters,
                              onClearFilters: _clearFilters,
                              onBreaking: () => context.go(
                                AppRoutePaths.marketsPredictionsBreaking,
                              ),
                            )
                          else ...[
                            // PERF-HN3: chỉ dựng lát cắt bounded (cap 8) —
                            // phần còn lại đi qua trang tìm kiếm.
                            for (final event in snapshot.visibleEvents)
                              _PredictionEventCard(
                                key: PredictionsHomePage.eventCardKey(event.id),
                                event: event,
                                onTap: () => context.go(
                                  AppRoutePaths.marketsPredictionEvent(
                                    event.id,
                                  ),
                                ),
                              ),
                            if (snapshot.events.length >
                                snapshot.visibleEvents.length)
                              VitCard(
                                key: PredictionsHomePage.viewAllEventsKey,
                                onTap: () => context.go(
                                  AppRoutePaths.marketsPredictionsSearch,
                                ),
                                child: Center(
                                  child: Text(
                                    'Xem tất cả ${snapshot.events.length} sự kiện',
                                    style: AppTextStyles.baseMedium.copyWith(
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                          _PredictionsToolsSection(
                            onNavigate: (route) => context.go(route),
                          ),
                          const _RiskDisclaimer(),
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
