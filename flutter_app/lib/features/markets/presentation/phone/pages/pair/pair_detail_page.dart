import 'dart:math' as math;

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
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';

part '../../../widgets/pair/pair_detail_header_widgets.dart';
part '../../../widgets/pair/pair_detail_chart_widgets.dart';
part '../../../widgets/pair/pair_detail_order_widgets.dart';
part '../../../widgets/pair/pair_detail_painter_widgets.dart';

const _marketPrimary = AppColors.primary;
const double _pairFramedScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _pairNativeScrollClearance =
    AppSpacing.buttonStandard + AppSpacing.x5;
const double _pairChartExtent = AppSpacing.buttonStandard * 3 + AppSpacing.x7;

enum _PairView { chart, orderBook, trades }

class PairDetailPage extends ConsumerStatefulWidget {
  const PairDetailPage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc044_pair_detail_content');
  static const chartTabKey = Key('sc044_view_chart');
  static const chartContentKey = Key('sc044_pair_chart');
  static const orderBookTabKey = Key('sc044_view_orderbook');
  static const tradesTabKey = Key('sc044_view_trades');
  static const infoButtonKey = Key('sc044_token_info');
  static const depthButtonKey = Key('sc044_market_depth');
  static const dcaButtonKey = Key('sc044_dca_button');
  static const buyButtonKey = Key('sc044_buy');
  static const sellButtonKey = Key('sc044_sell');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PairDetailPage> createState() => _PairDetailPageState();
}

class _PairDetailPageState extends ConsumerState<PairDetailPage> {
  _PairView _activeView = _PairView.chart;
  String _timeframe = '1H';
  final Set<String> _indicators = {'MA', 'Vol'};
  late bool _favorite;

  @override
  void initState() {
    super.initState();
    _favorite = true;
  }

  @override
  Widget build(BuildContext context) {
    final pairDetailAsync = ref.watch(
      marketPairDetailSnapshotProvider(widget.pairId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _pairFramedScrollClearance
            : _pairNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    // GD4-F3 (mục 5, biến thể 2): _PairHeader cần cả MarketPair (không chỉ
    // tiêu đề chuỗi) nên bọc toàn bộ return trong .when() — loading/error
    // dùng VitHeader tối giản với fallback từ pairId route param.
    return pairDetailAsync.when(
      loading: () => _PairDetailFallbackScaffold(pairId: widget.pairId),
      error: (error, stackTrace) => _PairDetailFallbackScaffold(
        pairId: widget.pairId,
        error: true,
        onRetry: () =>
            ref.invalidate(marketPairDetailSnapshotProvider(widget.pairId)),
      ),
      data: (snapshot) =>
          _buildContent(context, snapshot, mode, scrollEndClearance),
    );
  }

  Widget _buildContent(
    BuildContext context,
    MarketPairDetailSnapshot snapshot,
    ShellRenderMode mode,
    double scrollEndClearance,
  ) {
    final pair = snapshot.pair;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết cặp giao dịch',
      semanticIdentifier: 'SC-044',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            _PairHeader(
              pair: pair,
              favorite: _favorite,
              onBack: () => goBackOrFallback(
                context,
                fallbackPath: AppRoutePaths.markets,
                mode: BackNavigationMode.historyThenFallback,
              ),
              onPairTap: () => context.go(AppRoutePaths.markets),
              onFavorite: () => setState(() => _favorite = !_favorite),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: VitInsetScrollView(
                  key: PairDetailPage.contentKey,
                  bottomInset: scrollEndClearance,
                  child: VitPageContent(
                    rhythm: VitPageRhythm.compact,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    children: [
                      _PriceOverview(pair: pair),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ViewTabs(
                            activeView: _activeView,
                            onChanged: (view) =>
                                setState(() => _activeView = view),
                          ),
                          if (_activeView == _PairView.chart) ...[
                            _TimeframeRow(
                              active: _timeframe,
                              onChanged: (value) =>
                                  setState(() => _timeframe = value),
                            ),
                            _IndicatorRow(
                              active: _indicators,
                              onToggle: (value) => setState(() {
                                if (_indicators.contains(value)) {
                                  _indicators.remove(value);
                                } else {
                                  _indicators.add(value);
                                }
                              }),
                              onAdvanced: () => context.go(
                                AppRoutePaths.tradeAdvancedChart(pair.id),
                              ),
                            ),
                            _PairChart(series: snapshot.activeChartSeries),
                          ] else if (_activeView == _PairView.orderBook) ...[
                            _OrderBookPanel(snapshot: snapshot),
                          ] else ...[
                            _TradesPanel(trades: snapshot.recentTrades),
                          ],
                        ],
                      ),
                      const _RiskWarning(),
                      VitPageSection(
                        children: [
                          _LinkCard(
                            key: PairDetailPage.dcaButtonKey,
                            icon: Icons.repeat_rounded,
                            iconColor: AppColors.accent,
                            title: 'Mua định kỳ BTC',
                            subtitle:
                                'Tự động mua theo lịch · Giảm rủi ro biến động',
                            onTap: () => context.go(AppRoutePaths.dca),
                          ),
                          _LinkCard(
                            key: PairDetailPage.infoButtonKey,
                            icon: Icons.info_outline_rounded,
                            iconColor: _marketPrimary,
                            title: 'Thông tin ${pair.baseAsset}',
                            subtitle: 'Tokenomics · On-chain · Dự án',
                            onTap: () =>
                                context.go(AppRoutePaths.pairInfo(pair.id)),
                          ),
                          _LinkCard(
                            key: PairDetailPage.depthButtonKey,
                            icon: Icons.layers_rounded,
                            iconColor: AppAssetColors.cyanChain,
                            title: 'Độ sâu thị trường',
                            subtitle:
                                'Biểu đồ depth · Cảnh báo cá voi · Sổ lệnh',
                            onTap: () =>
                                context.go(AppRoutePaths.pairDepth(pair.id)),
                          ),
                        ],
                      ),
                      _TradeCtas(pairId: pair.id),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Khung tối giản cho nhánh `loading:`/`error:` của [PairDetailPage] — tiêu
/// đề thật (`pair.symbol`) chỉ có sau khi snapshot resolve, nên dùng
/// [VitHeader] với fallback từ `pairId` route param thay vì [_PairHeader]
/// (đòi hỏi [MarketPair] đầy đủ). Mục 5, biến thể 2 của GD4-Async-Playbook.
class _PairDetailFallbackScaffold extends StatelessWidget {
  const _PairDetailFallbackScaffold({
    required this.pairId,
    this.error = false,
    this.onRetry,
  });

  final String pairId;
  final bool error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết cặp giao dịch',
      semanticIdentifier: 'SC-044',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: pairId.toUpperCase(),
              showBack: true,
              onBack: () => goBackOrFallback(
                context,
                fallbackPath: AppRoutePaths.markets,
                mode: BackNavigationMode.historyThenFallback,
              ),
            ),
            Expanded(
              child: VitPageContent(
                rhythm: VitPageRhythm.compact,
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                children: error
                    ? [
                        VitErrorState(
                          title: 'Không tải được cặp giao dịch',
                          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                          actionLabel: 'Thử lại',
                          onAction: onRetry,
                        ),
                      ]
                    : const [VitSkeletonList()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
