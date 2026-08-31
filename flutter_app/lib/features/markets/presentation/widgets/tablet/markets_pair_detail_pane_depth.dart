part of 'markets_pair_detail_pane.dart';

/// Khung nhìn "Độ sâu" của pane chi tiết cặp (P1 2026-08-29): tái dùng
/// thẳng các view CÔNG KHAI của pane độ sâu (R2 reuse-public) —
/// `MarketDepthChartView` (mini-stats + chart depth + tỷ lệ tường) và
/// `MarketDepthWhaleAlertsView` (lệnh cá voi) — cùng provider
/// `marketDepthSnapshotProvider` family theo (pairId, levels), để phân tích
/// một coin gom hết trong MỘT pane thay vì trang riêng.
class _PairDepthWorkspace extends ConsumerStatefulWidget {
  const _PairDepthWorkspace({required this.pairId});

  final String pairId;

  @override
  ConsumerState<_PairDepthWorkspace> createState() =>
      _PairDepthWorkspaceState();
}

class _PairDepthWorkspaceState extends ConsumerState<_PairDepthWorkspace> {
  int _levels = 25;

  @override
  Widget build(BuildContext context) {
    final query = (pairId: widget.pairId, levels: _levels);
    final depthAsync = ref.watch(marketDepthSnapshotProvider(query));
    return depthAsync.when(
      loading: () => const Padding(
        padding: EdgeInsetsDirectional.all(TabletSpacingTokens.x4),
        child: VitSkeletonList(),
      ),
      error: (error, stackTrace) => Padding(
        // S7/P2: chỉ inset ngang contentPad, bỏ token Phone lệch lề 24.
        padding: MarketsSpacingTokens.pairPaneChildFlushPadding,
        child: VitErrorState(
          title: 'Không tải được độ sâu thị trường',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(marketDepthSnapshotProvider(query)),
        ),
      ),
      data: (snapshot) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MarketDepthChartView(
            snapshot: snapshot,
            levels: _levels,
            onLevelSelected: (level) => setState(() => _levels = level),
          ),
          const SizedBox(
            height: TabletSpacingTokens.pageRhythmStandardSectionGap,
          ),
          MarketDepthWhaleAlertsView(snapshot: snapshot),
        ],
      ),
    );
  }
}
