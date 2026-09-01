import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/ads/p2p_order_book_selector_ticker.dart';
part '../../../widgets/ads/p2p_order_book_cards_lists.dart';
part '../../../widgets/ads/p2p_order_book_painter.dart';

const double _p2pOrderBookVisualClearance = AppSpacing.x3;
const double _p2pOrderBookNativeClearance = AppSpacing.x2;
const double _p2pOrderBookSectionGap = AppSpacing.x2;
const double _p2pOrderBookRefreshExtent = AppSpacing.buttonCompact;
const double _p2pOrderBookAssetChipMinWidth = 96;
const double _p2pOrderBookDepthChartExtent = 112;
const double _p2pOrderBookOrderRowExtent = AppSpacing.x5 - AppSpacing.x1;
const double _p2pOrderBookLegendDot = AppSpacing.x3;
const double _p2pOrderBookSmallIcon = AppSpacing.iconSm;

class P2POrderBookPage extends ConsumerStatefulWidget {
  const P2POrderBookPage({super.key, this.shellRenderMode});

  static const assetRailKey = Key('sc273_p2p_order_book_assets');
  static const tickerKey = Key('sc273_p2p_order_book_ticker');
  static const refreshKey = Key('sc273_p2p_order_book_refresh');
  static const depthChartKey = Key('sc273_p2p_order_book_depth_chart');
  static const bestPricesKey = Key('sc273_p2p_order_book_best_prices');
  static const orderListsKey = Key('sc273_p2p_order_book_lists');

  static Key assetKey(String asset) => Key('sc273_p2p_order_book_asset_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderBookPage> createState() => _P2POrderBookPageState();
}

class _P2POrderBookPageState extends ConsumerState<P2POrderBookPage> {
  String _selectedAsset = 'USDT';
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pOrderBookProvider(_selectedAsset));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + _p2pOrderBookVisualClearance
            : DeviceMetrics.nativeBottomChrome + _p2pOrderBookNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Sổ lệnh P2P',
      semanticIdentifier: 'SC-273',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(p2pOrderBookProvider(_selectedAsset)),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
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
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pOrderBookScrollPadding(
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _AssetSelector(
                            snapshot: snapshot,
                            selectedAsset: _selectedAsset,
                            onChanged: (asset) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _selectedAsset = asset);
                            },
                          ),
                          _MarketTicker(
                            snapshot: snapshot,
                            isRefreshing: _isRefreshing,
                            onRefresh: _refresh,
                          ),
                          _DepthChartCard(snapshot: snapshot),
                          _BestPriceCards(snapshot: snapshot),
                          _OrderBookLists(snapshot: snapshot),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại thanh khoản sổ lệnh',
                            message:
                                'Tài sản, làm mới dữ liệu, biểu đồ độ sâu, giá bid/ask tốt nhất và rủi ro thanh khoản được xem lại trước khi khớp lệnh P2P.',
                            contractId: 'p2p-order-book-review',
                          ),
                          Text(
                            snapshot.contractNotes,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    if (_isRefreshing) return;
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _isRefreshing = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _isRefreshing = false);
  }
}
