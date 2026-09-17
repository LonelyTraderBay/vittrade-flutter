import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/predictions/domain/entities/predictions_entities.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/predictions_outcome_widgets.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/tablet/prediction_event_card_tablet.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/tablet/prediction_tablet_card_grid.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_pane_workspace.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'predictions_home_tablet_sections.dart';

/// SC-208: Hub thị trường dự đoán trên tablet — tái composition đầy đủ theo
/// trang phone SC-027: hero số dư mở, tìm kiếm live, 5 tab lọc, chip danh
/// mục, dải movers, cầu nối Arena, thẻ sự kiện (cap + xem tất cả), khối công
/// cụ và disclaimer rủi ro. Filter/tìm kiếm là state cục bộ như phone.
class PredictionsHomeTabletPage extends ConsumerStatefulWidget {
  const PredictionsHomeTabletPage({super.key});

  static const contentKey = Key('sc208_tablet_content');
  static const searchActionKey = Key('sc208_search_action');
  static const portfolioHeaderKey = Key('sc208_portfolio_action');
  static const searchFieldKey = Key('sc208_search_field');
  static const trendingFilterKey = Key('sc208_filter_trending');
  static const newFilterKey = Key('sc208_filter_new');
  static const categoryAllKey = Key('sc208_category_all');
  static const categoryLiveCryptoKey = Key('sc208_category_live_crypto');
  static const myPredictionsKey = Key('sc208_my_predictions');
  static const toolsSectionKey = Key('sc208_tools');
  static const breakingMoversKey = Key('sc208_breaking_movers');
  static const arenaBridgeKey = Key('sc208_arena_bridge');
  static const viewAllEventsKey = Key('sc208_view_all_events');
  static const controlPaneKey = Key('sc208_tablet_control_pane');

  static Key eventCardKey(String id) => Key('sc208_event_$id');
  static Key toolKey(String id) => Key('sc208_tool_$id');

  @override
  ConsumerState<PredictionsHomeTabletPage> createState() =>
      _PredictionsHomeTabletPageState();
}

class _PredictionsHomeTabletPageState
    extends ConsumerState<PredictionsHomeTabletPage> {
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
    // Phụ (không chặn trang): tổng số sự kiện toàn cục cho hero, độc lập
    // bộ lọc hiện tại — đọc `.value` lười như phone SC-027.
    final hubTotalsValue = ref
        .watch(predictionsHomeSnapshotProvider(predictionsHomeDefaultQuery))
        .value;
    final showDiscoveryExtras = _searchQuery.isEmpty;

    return homeAsync.when(
      loading: () =>
          _scaffold(body: _statusBody(const [VitSkeletonList(rows: 6)])),
      error: (error, stackTrace) => _scaffold(
        body: _statusBody([
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
        ]),
      ),
      data: (snapshot) {
        // Các khối dựng một lần, tham chiếu ở cả tầng workspace và tầng hẹp —
        // một thời điểm chỉ MỘT danh sách nằm trong cây.
        final hero = _Sc208Hero(
          openEventCount:
              hubTotalsValue?.events.length ?? snapshot.events.length,
          openPositionCount: snapshot.openPositionCount,
          onPositionsTap: () =>
              context.push(AppRoutePaths.marketsPredictionsPortfolio),
        );
        final searchField = VitSearchBar(
          key: PredictionsHomeTabletPage.searchFieldKey,
          controller: _searchController,
          placeholder: 'Tìm sự kiện…',
          onChanged: (value) => setState(() {
            _searchQuery = value;
          }),
          onClear: () => setState(() {
            _searchController.clear();
            _searchQuery = '';
          }),
        );
        final filterTabs = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: VitTabBar(
            variant: VitTabBarVariant.pill,
            activeKey: _sc208FilterKey(_filter),
            onChanged: (key) => setState(
              () => _filter = PredictionFilterTab.values.byName(key),
            ),
            tabs: const [
              VitTabItem(
                key: 'trending',
                label: 'Xu hướng',
                icon: Icons.trending_up_outlined,
                widgetKey: PredictionsHomeTabletPage.trendingFilterKey,
              ),
              VitTabItem(
                key: 'newEvents',
                label: 'Mới',
                icon: Icons.fiber_new_outlined,
                widgetKey: PredictionsHomeTabletPage.newFilterKey,
              ),
              VitTabItem(
                key: 'popular',
                label: 'Phổ biến',
                icon: Icons.group_outlined,
              ),
              VitTabItem(
                key: 'liquid',
                label: 'Thanh khoản',
                icon: Icons.bar_chart_outlined,
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
        );
        final categoryChips = _Sc208CategoryChips(
          categories: snapshot.categories,
          activeCategory: _category,
          onSelected: (value) => setState(() {
            _category = _category == value ? null : value;
          }),
        );
        final highRiskPanel = snapshot.highRiskContractId == null
            ? null
            : VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Trạng thái thị trường dự đoán',
                message:
                    'Thiết lập sự kiện, xem trước rủi ro, xác nhận, biên lai, '
                    'danh mục và hỗ trợ dùng luồng high-risk chung.',
                contractId: snapshot.highRiskContractId,
              );
        // PERF-HN3: chỉ dựng lát cắt bounded (cap 8) — phần còn lại đi
        // qua trang tìm kiếm, như phone SC-027. Grid tự về 1 cột khi hẹp.
        final eventFeed = PredictionTabletCardGrid(
          children: [
            for (final event in snapshot.visibleEvents)
              PredictionEventCardTablet(
                key: PredictionsHomeTabletPage.eventCardKey(event.id),
                event: event,
                onTap: () => context.push(
                  AppRoutePaths.marketsPredictionEvent(event.id),
                ),
              ),
          ],
        );
        final viewAllCard =
            snapshot.events.length > snapshot.visibleEvents.length
            ? VitCard(
                key: PredictionsHomeTabletPage.viewAllEventsKey,
                density: VitDensity.compact,
                onTap: () =>
                    context.push(AppRoutePaths.marketsPredictionsSearch),
                child: Center(
                  child: Text(
                    'Xem tất cả ${VitFormat.count(snapshot.events.length)} '
                    'sự kiện',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              )
            : null;
        final emptyState = _Sc208EmptyState(
          hasActiveFilters: _hasActiveFilters,
          onClearFilters: _clearFilters,
          onBreaking: () =>
              context.push(AppRoutePaths.marketsPredictionsBreaking),
        );
        final tools = _Sc208ToolsSection(
          onNavigate: (route) => context.push(route),
        );
        final disclaimer = const _Sc208RiskDisclaimer();

        return _scaffold(
          body: VitTabletPaneWorkspace(
            contentKey: PredictionsHomeTabletPage.contentKey,
            secondaryContentKey: PredictionsHomeTabletPage.controlPaneKey,
            primaryChildren: [
              hero,
              ?highRiskPanel,
              if (snapshot.events.isEmpty)
                emptyState
              else ...[
                eventFeed,
                ?viewAllCard,
              ],
              tools,
            ],
            secondaryChildren: [
              searchField,
              filterTabs,
              categoryChips,
              if (showDiscoveryExtras) ...[
                _Sc208BreakingMoversStrip(
                  snapshot: snapshot,
                  onTap: () =>
                      context.push(AppRoutePaths.marketsPredictionsBreaking),
                ),
                _Sc208ArenaBridgeCard(
                  onTap: () => context.push(AppRoutePaths.arena),
                ),
              ],
              disclaimer,
            ],
            narrowChildren: [
              hero,
              searchField,
              filterTabs,
              categoryChips,
              if (showDiscoveryExtras) ...[
                _Sc208BreakingMoversStrip(
                  snapshot: snapshot,
                  onTap: () =>
                      context.push(AppRoutePaths.marketsPredictionsBreaking),
                ),
                _Sc208ArenaBridgeCard(
                  onTap: () => context.push(AppRoutePaths.arena),
                ),
              ],
              ?highRiskPanel,
              if (snapshot.events.isEmpty)
                emptyState
              else ...[
                eventFeed,
                ?viewAllCard,
              ],
              tools,
              disclaimer,
            ],
          ),
        );
      },
    );
  }

  /// Thân một cột cho trạng thái loading/error — cùng recipe cột hẹp của
  /// `VitTabletPaneWorkspace`.
  Widget _statusBody(List<Widget> children) {
    return SingleChildScrollView(
      key: PredictionsHomeTabletPage.contentKey,
      padding: const EdgeInsetsDirectional.only(
        bottom: TabletSpacingTokens.pageEndBreathing,
      ),
      child: VitPageContent(
        padding: VitContentPadding.compact,
        fullBleed: true,
        rhythm: VitPageRhythm.standard,
        children: children,
      ),
    );
  }

  Widget _scaffold({required Widget body}) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Trang chủ thị trường dự đoán: xác suất và sự kiện đang mở',
      semanticIdentifier: 'SC-208',
      child: Column(
        children: [
          VitHeader(
            title: 'Dự đoán thị trường',
            subtitle: 'Xác suất và sự kiện đang mở',
            showBack: context.canPop(),
            onBack: context.canPop()
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.markets,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            actions: [
              VitHeaderActionItem(
                key: PredictionsHomeTabletPage.searchActionKey,
                type: VitHeaderActionType.search,
                onPressed: () =>
                    context.push(AppRoutePaths.marketsPredictionsSearch),
              ),
              VitHeaderActionItem(
                key: PredictionsHomeTabletPage.portfolioHeaderKey,
                type: VitHeaderActionType.portfolio,
                tooltip: 'Danh mục',
                onPressed: () =>
                    context.push(AppRoutePaths.marketsPredictionsPortfolio),
              ),
            ],
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}

String _sc208FilterKey(PredictionFilterTab tab) {
  return switch (tab) {
    PredictionFilterTab.trending => 'trending',
    PredictionFilterTab.newEvents => 'newEvents',
    PredictionFilterTab.popular => 'popular',
    PredictionFilterTab.liquid => 'liquid',
    PredictionFilterTab.ending => 'ending',
    PredictionFilterTab.competitive => 'competitive',
  };
}
