import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_chart.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_order_book.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_tabs.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_whale_alerts.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Độ sâu thị trường (SC-019) — 3 tab depth/sổ lệnh/cá voi
/// dùng lại widget public của trang phone, kèm lớp realtime đè snapshot
/// (cùng idiom GD4 Cụm F7 của trang phone).
class MarketsDepthPane extends ConsumerStatefulWidget {
  const MarketsDepthPane({super.key, this.pairId = 'btcusdt'});

  static const contentKey = Key('sc019_tablet_content');

  final String pairId;

  @override
  ConsumerState<MarketsDepthPane> createState() => _MarketsDepthPaneState();
}

class _MarketsDepthPaneState extends ConsumerState<MarketsDepthPane> {
  String _tab = 'depth';
  int _levels = 25;

  @override
  Widget build(BuildContext context) {
    final depthQuery = (pairId: widget.pairId, levels: _levels);
    final depthAsync = ref.watch(marketDepthSnapshotProvider(depthQuery));
    final liveDepth = ref.watch(marketDepthStreamProvider(depthQuery)).value;

    return MarketsPaneScaffold(
      title: 'Độ sâu thị trường',
      subtitle: 'Sổ lệnh · Cá voi',
      scrollKey: MarketsDepthPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketDepthSnapshotProvider(depthQuery));
        await ref.read(marketDepthSnapshotProvider(depthQuery).future);
      },
      children: depthAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được độ sâu thị trường',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(marketDepthSnapshotProvider(depthQuery)),
          ),
        ],
        data: (snapshot) {
          final effective =
              (liveDepth != null &&
                  liveDepth.depth.bids.length == snapshot.depth.bids.length)
              ? liveDepth
              : snapshot;
          return [
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
              message: 'Dữ liệu depth chỉ mang tính tham khảo',
              detail:
                  'Không phải tín hiệu giao dịch. Giá và sổ lệnh có thể trễ so với thị trường thực.',
            ),
          ];
        },
      ),
    );
  }
}
