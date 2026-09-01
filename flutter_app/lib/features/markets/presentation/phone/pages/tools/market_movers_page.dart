import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
part '../../../widgets/tools/market_movers_filters.dart';
part '../../../widgets/tools/market_movers_results.dart';
part '../../../widgets/tools/market_movers_row_common.dart';
part '../../../widgets/tools/market_movers_sparkline.dart';

const _marketPrimary = AppColors.primary;

class MarketMoversPage extends ConsumerStatefulWidget {
  const MarketMoversPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc010_market_movers_scroll_content');
  static const gainersTabKey = Key('sc010_tab_gainers');
  static const losersTabKey = Key('sc010_tab_losers');
  static const activeTabKey = Key('sc010_tab_active');
  static const unusualTabKey = Key('sc010_tab_unusual');
  static const newListingsTabKey = Key('sc010_tab_new_listings');
  static const timeframe24hKey = Key('sc010_timeframe_24h');
  static const categoryDropdownKey = Key('sc010_category_dropdown');
  static const sortChangeKey = Key('sc010_sort_change');
  static const sortVolumeKey = Key('sc010_sort_volume');
  static const sortMarketCapKey = Key('sc010_sort_market_cap');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketMoversPage> createState() => _MarketMoversPageState();
}

class _MarketMoversPageState extends ConsumerState<MarketMoversPage> {
  String _tab = 'Tăng mạnh';
  String _timeframe = '24h';
  String _category = 'Tất cả';
  String _sort = 'change';
  bool _showCategories = false;

  void _setTab(String value) {
    setState(() {
      _tab = value;
      _showCategories = false;
      if (_tab == 'Hoạt động') _sort = 'volume';
      if (_tab == 'Mới niêm yết' || _tab == 'Tăng mạnh') _sort = 'change';
      if (_tab == 'KL bất thường') _sort = 'volume';
    });
  }

  void _setCategory(String value) {
    setState(() {
      _category = value;
      _showCategories = false;
    });
  }

  List<MarketMover> _visibleMovers(MarketMoversSnapshot snapshot) {
    Iterable<MarketMover> movers = snapshot.movers;

    if (_category != 'Tất cả') {
      movers = movers.where((mover) => mover.category == _category);
    }

    switch (_tab) {
      case 'Giảm mạnh':
        movers = movers.where((mover) => _changeFor(mover) < 0);
      case 'Hoạt động':
        movers = movers;
      case 'KL bất thường':
        movers = movers.where((mover) => mover.volumeChange24h > 0);
      case 'Mới niêm yết':
        movers = movers.where((mover) => mover.isNew);
      case 'Tăng mạnh':
      default:
        movers = movers.where((mover) => _changeFor(mover) > 0);
    }

    final sorted = movers.toList();
    switch (_sort) {
      case 'volume':
        if (_tab == 'KL bất thường') {
          sorted.sort((a, b) => b.volumeChange24h.compareTo(a.volumeChange24h));
        } else {
          sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
        }
      case 'market_cap':
        sorted.sort((a, b) => b.marketCap.compareTo(a.marketCap));
      case 'change':
      default:
        if (_tab == 'Giảm mạnh') {
          sorted.sort((a, b) => _changeFor(a).compareTo(_changeFor(b)));
        } else {
          sorted.sort((a, b) => _changeFor(b).compareTo(_changeFor(a)));
        }
    }

    if (_tab == 'Hoạt động' && _sort == 'change') {
      sorted.sort((a, b) => b.volume24h.compareTo(a.volume24h));
    }

    return sorted;
  }

  double _changeFor(MarketMover mover) {
    return switch (_timeframe) {
      '1h' => mover.change1h,
      '7d' => mover.change7d,
      _ => mover.change24h,
    };
  }

  @override
  Widget build(BuildContext context) {
    final moversAsync = ref.watch(marketMoversSnapshotProvider);
    final lastUpdatedLabel = moversAsync.value?.lastUpdatedLabel ?? '...';
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Biến động thị trường',
      semanticIdentifier: 'SC-010',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Biến động thị trường',
            subtitle: 'So sánh nhanh · Cập nhật $lastUpdatedLabel',
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
                    key: MarketMoversPage.contentKey,
                    padding: MarketsSpacingTokens.marketScrollPadding(
                      bottomInset,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.defaultPadding,
                      gap: VitContentGap.tight,
                      children: moversAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được biến động thị trường',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(marketMoversSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) {
                          final movers = _visibleMovers(snapshot);
                          return [
                            _MoverTabs(
                              tabs: snapshot.tabs,
                              activeTab: _tab,
                              onSelected: _setTab,
                            ),
                            if (_tab != 'Mới niêm yết')
                              _TimeframeSelector(
                                timeframes: snapshot.timeframes,
                                activeTimeframe: _timeframe,
                                onSelected: (value) {
                                  setState(() => _timeframe = value);
                                },
                              ),
                            _CategoryDropdown(
                              category: _category,
                              expanded: _showCategories,
                              onTap: () {
                                setState(
                                  () => _showCategories = !_showCategories,
                                );
                              },
                            ),
                            if (_showCategories)
                              _CategoryPicker(
                                categories: snapshot.screenFilters.categories,
                                activeCategory: _category,
                                onSelected: _setCategory,
                              ),
                            _SortSelector(
                              options: snapshot.screenFilters.sortOptions,
                              activeSort: _sort,
                              onSelected: (value) {
                                setState(() {
                                  _sort = value;
                                  _showCategories = false;
                                });
                              },
                            ),
                            _ResultSummary(
                              count: movers.length,
                              sortLabel: _sortLabel,
                              timeframe: _timeframe,
                            ),
                            if (movers.isEmpty)
                              VitEmptyState(
                                icon: Icons.trending_flat_rounded,
                                title: 'Không có kết quả',
                                message:
                                    'Thử đổi tab, danh mục hoặc khung thời gian khác',
                                actionLabel: 'Xóa bộ lọc',
                                onAction: () {
                                  setState(() {
                                    _tab = 'Tăng mạnh';
                                    _timeframe = '24h';
                                    _category = 'Tất cả';
                                    _sort = 'change';
                                    _showCategories = false;
                                  });
                                },
                              )
                            else
                              _MoverListCard(
                                movers: movers,
                                tab: _tab,
                                changeFor: _changeFor,
                                onTap: (mover) => context.go(
                                  AppRoutePaths.pairDetail('${mover.id}usdt'),
                                ),
                              ),
                            const _DataRefreshFooter(),
                          ];
                        },
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

  String get _sortLabel {
    return switch (_sort) {
      'volume' => 'Khối lượng',
      'market_cap' => 'Market Cap',
      _ => '% thay đổi',
    };
  }
}
