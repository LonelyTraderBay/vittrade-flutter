import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_chart.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_order_book.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_tabs.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_whale_alerts.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketDepthPage extends ConsumerStatefulWidget {
  const MarketDepthPage({
    super.key,
    this.pairId = 'btcusdt',
    this.backPath = AppRoutePaths.markets,
    this.shellRenderMode,
  });

  static const contentKey = marketDepthContentKey;
  static const depthChartTabKey = marketDepthChartTabKey;
  static const orderBookTabKey = marketDepthOrderBookTabKey;
  static const whaleAlertTabKey = marketDepthWhaleAlertTabKey;

  static Key levelKey(int level) => marketDepthLevelKey(level);

  final String pairId;
  final String backPath;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketDepthPage> createState() => _MarketDepthPageState();
}

class _MarketDepthPageState extends ConsumerState<MarketDepthPage> {
  String _tab = 'depth';
  int _levels = 25;

  @override
  Widget build(BuildContext context) {
    final depthQuery = (pairId: widget.pairId, levels: _levels);
    final depthAsync = ref.watch(marketDepthSnapshotProvider(depthQuery));
    // GD4 Cụm F7 (REALTIME): lớp cập-nhật-đè — chỉ dùng khi tick đầu tiên
    // đã tới (`.value` khác null); nếu chưa, `data:` bên dưới vẫn hiển thị
    // snapshot Future như cũ (mục 3 GD4-Async-Playbook: "seed từ Future
    // snapshot, stream chỉ đè lên").
    final liveDepth = ref.watch(marketDepthStreamProvider(depthQuery)).value;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;
    final resolvedBackPath = resolveSafeBackPath(
      candidate: widget.backPath,
      fallbackPath: AppRoutePaths.pairDetail(widget.pairId),
      allowedPrefixes: const [
        AppRoutePaths.markets,
        '/pair',
        AppRoutePaths.trade,
      ],
    );

    // GD4-F3 (mục 5, biến thể 2): tiêu đề phụ thuộc snapshot.pair.baseAsset
    // (không suy ra được từ pairId route param) — bọc toàn bộ return trong
    // .when(), fallback title dùng pairId viết hoa cho loading/error.
    return depthAsync.when(
      loading: () => _MarketDepthScaffold(
        title: 'Độ sâu ${widget.pairId.toUpperCase()}',
        onBack: () => goBackOrFallback(context, fallbackPath: resolvedBackPath),
        tab: _tab,
        onTabChanged: (value) => setState(() => _tab = value),
        scrollEndClearance: scrollEndClearance,
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => _MarketDepthScaffold(
        title: 'Độ sâu ${widget.pairId.toUpperCase()}',
        onBack: () => goBackOrFallback(context, fallbackPath: resolvedBackPath),
        tab: _tab,
        onTabChanged: (value) => setState(() => _tab = value),
        scrollEndClearance: scrollEndClearance,
        children: [
          VitErrorState(
            title: 'Không tải được độ sâu thị trường',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(marketDepthSnapshotProvider(depthQuery)),
          ),
        ],
      ),
      data: (snapshot) {
        // GD4 Cụm F7 (REALTIME): stream đè lên snapshot Future khi đã có
        // tick — chỉ áp dụng nếu số levels khớp lựa chọn hiện tại (stream
        // family cùng key `depthQuery` nên luôn khớp, giữ guard tường minh
        // để không đè nhầm dữ liệu levels cũ trong khung hình chuyển tiếp).
        final effective =
            (liveDepth != null &&
                liveDepth.depth.bids.length == snapshot.depth.bids.length)
            ? liveDepth
            : snapshot;
        return _MarketDepthScaffold(
          title: 'Độ sâu ${effective.pair.baseAsset}',
          onBack: () =>
              goBackOrFallback(context, fallbackPath: resolvedBackPath),
          tab: _tab,
          onTabChanged: (value) => setState(() => _tab = value),
          scrollEndClearance: scrollEndClearance,
          children: [
            MarketDepthPairSummary(pair: effective.pair),
            if (_tab == 'depth')
              MarketDepthChartView(
                snapshot: effective,
                levels: _levels,
                onLevelSelected: (level) => setState(() => _levels = level),
              )
            else if (_tab == 'orderBook')
              MarketDepthOrderBookView(snapshot: effective)
            else
              MarketDepthWhaleAlertsView(snapshot: effective),
            const VitBanner(
              variant: VitBannerVariant.info,
              icon: Icons.info_outline_rounded,
              message: 'Dữ liệu depth chỉ mang tính tham khảo',
              detail:
                  'Không phải tín hiệu giao dịch. Giá và sổ lệnh có thể trễ so với thị trường thực.',
            ),
          ],
        );
      },
    );
  }
}

/// Khung trang chung cho 3 nhánh `.when()` của [MarketDepthPage] — tiêu đề
/// phụ thuộc snapshot nên cả 3 nhánh dựng scaffold đầy đủ riêng (mục 5,
/// biến thể 2 của GD4-Async-Playbook).
class _MarketDepthScaffold extends StatelessWidget {
  const _MarketDepthScaffold({
    required this.title,
    required this.onBack,
    required this.tab,
    required this.onTabChanged,
    required this.scrollEndClearance,
    required this.children,
  });

  final String title;
  final VoidCallback onBack;
  final String tab;
  final ValueChanged<String> onTabChanged;
  final double scrollEndClearance;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Độ sâu thị trường',
      semanticIdentifier: 'SC-019',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: 'Sổ lệnh · Markets',
            showBack: true,
            onBack: onBack,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MarketDepthTabs(activeTab: tab, onChanged: onTabChanged),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: MarketDepthPage.contentKey,
                    padding: MarketsSpacingTokens.marketScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.flush,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: children,
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
