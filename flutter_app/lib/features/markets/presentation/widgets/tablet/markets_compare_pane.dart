import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/comparison_tool_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/comparison_tool_content.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/comparison_tool_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của So sánh token (SC-016) — picker + metric + distribution
/// dùng lại widget public của trang phone; selectedIds sống ở
/// [marketComparisonStateControllerProvider] (một nguồn sự thật, STATE-S23).
class MarketsComparePane extends ConsumerStatefulWidget {
  const MarketsComparePane({super.key});

  static const contentKey = Key('sc016_tablet_content');

  @override
  ConsumerState<MarketsComparePane> createState() => _MarketsComparePaneState();
}

class _MarketsComparePaneState extends ConsumerState<MarketsComparePane> {
  final TextEditingController _pickerSearchController = TextEditingController();
  bool _showPicker = false;

  @override
  void dispose() {
    _pickerSearchController.dispose();
    super.dispose();
  }

  void _addToken(String id) {
    final added = ref
        .read(marketComparisonStateControllerProvider.notifier)
        .addToken(id);
    if (!added) return;
    setState(() {
      _showPicker = false;
      _pickerSearchController.clear();
    });
  }

  void _removeToken(String id) {
    ref.read(marketComparisonStateControllerProvider.notifier).removeToken(id);
  }

  @override
  Widget build(BuildContext context) {
    final comparisonAsync = ref.watch(marketComparisonSnapshotProvider);
    final viewState = ref.watch(marketComparisonStateControllerProvider);
    final snapshot = viewState.snapshot;
    final selectedIds = viewState.selectedIds;
    final selectedPairs = [
      for (final id in selectedIds)
        if (comparisonFindPair(snapshot.marketPairs, id) != null)
          comparisonFindPair(snapshot.marketPairs, id)!,
    ];

    return MarketsPaneScaffold(
      title: 'So sánh token',
      subtitle: 'So sánh · Markets',
      scrollKey: MarketsComparePane.contentKey,
      children: comparisonAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được công cụ so sánh',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(marketComparisonSnapshotProvider),
          ),
        ],
        data: (_) => [
          ComparisonSelectedTokensStrip(
            selectedPairs: selectedPairs,
            canAdd: selectedIds.length < comparisonToolMaxCompare,
            canRemove: selectedIds.length > 2,
            onAdd: () => setState(() => _showPicker = true),
            onRemove: _removeToken,
          ),
          if (_showPicker)
            ComparisonTokenPickerCard(
              snapshot: snapshot,
              selectedIds: selectedIds,
              controller: _pickerSearchController,
              onChanged: () => setState(() {}),
              onClose: () => setState(() {
                _showPicker = false;
                _pickerSearchController.clear();
              }),
              onTokenSelected: _addToken,
            ),
          if (selectedPairs.length >= 2)
            ComparisonSparklineCard(pairs: selectedPairs),
          if (selectedPairs.length >= 2)
            ComparisonMetricSection(
              pairs: selectedPairs,
              metrics: snapshot.metrics,
            ),
          if (selectedPairs.length >= 2)
            ComparisonVolumeDistributionCard(pairs: selectedPairs),
          if (selectedPairs.length >= 2)
            ComparisonMarketCapDistributionCard(pairs: selectedPairs),
          if (selectedPairs.length < 2) const ComparisonNeedMoreTokensCard(),
        ],
      ),
    );
  }
}
