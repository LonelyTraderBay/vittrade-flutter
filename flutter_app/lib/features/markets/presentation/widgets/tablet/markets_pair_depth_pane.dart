import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_chart.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_order_book.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_tabs.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_whale_alerts.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_navigation.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Detail pane độ sâu thị trường (SC-046) của Markets terminal master-detail:
/// tái dùng trực tiếp các view PUBLIC của trang Phone (`MarketDepthPairSummary`,
/// `MarketDepthChartView`, `MarketDepthOrderBookView`,
/// `MarketDepthWhaleAlertsView`, `MarketDepthTabs` — R2 reuse-public) cùng
/// provider depth snapshot + lớp realtime đè của GD4-F7. Chỉ phần khung
/// (pane scaffold + tabs + banner tham khảo) là của tablet.
class MarketsPairDepthPane extends ConsumerStatefulWidget {
  const MarketsPairDepthPane({super.key, required this.pairId});

  final String pairId;

  @override
  ConsumerState<MarketsPairDepthPane> createState() =>
      _MarketsPairDepthPaneState();
}

class _MarketsPairDepthPaneState extends ConsumerState<MarketsPairDepthPane> {
  String _tab = 'depth';
  int _levels = 25;

  @override
  Widget build(BuildContext context) {
    final depthQuery = (pairId: widget.pairId, levels: _levels);
    final depthAsync = ref.watch(marketDepthSnapshotProvider(depthQuery));
    // GD4 Cụm F7 (REALTIME): lớp cập-nhật-đè — chỉ dùng khi tick đầu tiên
    // đã tới; nếu chưa, `data:` vẫn hiển thị snapshot Future (seed từ
    // Future snapshot, stream chỉ đè lên).
    final liveDepth = ref.watch(marketDepthStreamProvider(depthQuery)).value;
    final fallbackTitle = 'Độ sâu ${widget.pairId.toUpperCase()}';

    VoidCallback back() {
      return () => openMarketsDetailRoute(
        context,
        AppRoutePaths.pairDetail(widget.pairId),
      );
    }

    Future<void> refresh() async {
      ref.invalidate(marketDepthSnapshotProvider(depthQuery));
      await ref.read(marketDepthSnapshotProvider(depthQuery).future);
    }

    return depthAsync.when(
      loading: () => MarketsPaneScaffold(
        title: fallbackTitle,
        subtitle: 'Sổ lệnh · Markets',
        onBack: back,
        rhythm: VitPageRhythm.flush,
        scrollKey: MarketsTabletKeys.depthPaneContent,
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => MarketsPaneScaffold(
        title: fallbackTitle,
        subtitle: 'Sổ lệnh · Markets',
        onBack: back,
        rhythm: VitPageRhythm.flush,
        scrollKey: MarketsTabletKeys.depthPaneContent,
        children: [
          VitErrorState(
            title: 'Không tải được độ sâu thị trường',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: refresh,
          ),
        ],
      ),
      data: (snapshot) {
        // GD4 Cụm F7 (REALTIME): stream đè lên snapshot Future khi đã có
        // tick — guard tường minh theo số levels để không đè nhầm dữ liệu
        // levels cũ trong khung hình chuyển tiếp.
        final effective =
            (liveDepth != null &&
                liveDepth.depth.bids.length == snapshot.depth.bids.length)
            ? liveDepth
            : snapshot;
        return MarketsPaneScaffold(
          title: 'Độ sâu ${effective.pair.baseAsset}',
          subtitle: 'Sổ lệnh · Markets',
          onBack: back,
          onRefresh: refresh,
          rhythm: VitPageRhythm.flush,
          scrollKey: MarketsTabletKeys.depthPaneContent,
          children: [
            MarketDepthPairSummary(pair: effective.pair),
            MarketDepthTabs(
              activeTab: _tab,
              onChanged: (value) => setState(() => _tab = value),
            ),
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
              message: 'Dữ liệu sổ lệnh chỉ mang tính tham khảo',
              detail:
                  'Không phải tín hiệu giao dịch. Giá và sổ lệnh có thể trễ so với thị trường thực.',
            ),
          ],
        );
      },
    );
  }
}
