import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_liquidation.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_overview.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_perpetual.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tools/market_derivatives_tabs.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Phái sinh (SC-018) — tabs overview/perpetual/liquidation
/// dùng lại widget public của trang phone.
class MarketsDerivativesPane extends ConsumerStatefulWidget {
  const MarketsDerivativesPane({super.key});

  static const contentKey = Key('sc018_tablet_content');

  @override
  ConsumerState<MarketsDerivativesPane> createState() =>
      _MarketsDerivativesPaneState();
}

class _MarketsDerivativesPaneState
    extends ConsumerState<MarketsDerivativesPane> {
  String _tab = 'overview';
  MarketDerivativesSort _sortBy = MarketDerivativesSort.openInterest;

  @override
  Widget build(BuildContext context) {
    final derivativesAsync = ref.watch(
      marketDerivativesSnapshotProvider(_sortBy),
    );

    return MarketsPaneScaffold(
      title: 'Phái sinh',
      subtitle: 'Dữ liệu phái sinh · Markets',
      scrollKey: MarketsDerivativesPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketDerivativesSnapshotProvider(_sortBy));
        await ref.read(marketDerivativesSnapshotProvider(_sortBy).future);
      },
      children: [
        MarketDerivativesTabs(
          activeTab: _tab,
          onChanged: (value) => setState(() => _tab = value),
        ),
        derivativesAsync.when(
          loading: () => const Column(children: [VitSkeletonList()]),
          error: (error, stackTrace) => Column(
            children: [
              VitErrorState(
                title: 'Không tải được dữ liệu phái sinh',
                message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                actionLabel: 'Thử lại',
                onAction: () =>
                    ref.invalidate(marketDerivativesSnapshotProvider(_sortBy)),
              ),
            ],
          ),
          data: (snapshot) => Column(
            children: [
              if (_tab == 'overview') ...[
                MarketDerivativesOpenInterestHero(stats: snapshot.globalStats),
                MarketDerivativesOverviewStatGrid(stats: snapshot.globalStats),
                const MarketDerivativesSectionHeader(
                  label: 'Thanh lý theo thời gian (24h)',
                  accentColor: AppColors.sell,
                ),
                MarketDerivativesLiquidationTimeline(
                  history: snapshot.liquidationHistory,
                  pairs: snapshot.pairs,
                ),
                const MarketDerivativesSectionHeader(
                  label: 'Top Open Interest',
                  accentColor: marketDerivativesPrimary,
                ),
                MarketDerivativesTopOpenInterestList(
                  pairs: snapshot.pairs.take(5).toList(),
                ),
              ] else if (_tab == 'perpetual') ...[
                MarketDerivativesSortChips(
                  active: _sortBy,
                  onSelected: (value) => setState(() {
                    _sortBy = value;
                  }),
                ),
                for (final pair in snapshot.pairs)
                  MarketDerivativesPerpetualPairCard(pair: pair),
              ] else ...[
                MarketDerivativesLiquidationSummary(
                  stats: snapshot.globalStats,
                ),
                const MarketDerivativesSectionHeader(
                  label: 'Thanh lý theo cặp',
                  accentColor: AppColors.sell,
                ),
                for (final pair
                    in [...snapshot.pairs]..sort(
                      (a, b) => b.totalLiquidations24h.compareTo(
                        a.totalLiquidations24h,
                      ),
                    ))
                  MarketDerivativesLiquidationPairCard(pair: pair),
                const MarketDerivativesRiskWarningCard(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
