import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Portfolio Tracker (SC-021): hero tổng giá trị + thống kê
/// 24h + bảng holdings độ dày tablet, sort theo value/pnl/change như phone.
class MarketsPortfolioPane extends ConsumerStatefulWidget {
  const MarketsPortfolioPane({super.key});

  static const contentKey = Key('sc021_tablet_content');

  @override
  ConsumerState<MarketsPortfolioPane> createState() =>
      _MarketsPortfolioPaneState();
}

class _MarketsPortfolioPaneState extends ConsumerState<MarketsPortfolioPane> {
  MarketPortfolioSort _sortBy = MarketPortfolioSort.value;

  @override
  Widget build(BuildContext context) {
    final portfolioAsync = ref.watch(marketPortfolioSnapshotProvider(_sortBy));

    return MarketsPaneScaffold(
      title: 'Portfolio Tracker',
      subtitle: 'Danh mục · Markets',
      scrollKey: MarketsPortfolioPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketPortfolioSnapshotProvider(_sortBy));
        await ref.read(marketPortfolioSnapshotProvider(_sortBy).future);
      },
      children: [
        Wrap(
          spacing: TabletSpacingTokens.x3,
          children: [
            for (final (sort, label) in [
              (MarketPortfolioSort.value, 'Theo giá trị'),
              (MarketPortfolioSort.pnl, 'Theo PnL'),
              (MarketPortfolioSort.change, 'Theo biến động'),
            ])
              VitFilterChip(
                label: label,
                active: _sortBy == sort,
                onTap: () => setState(() => _sortBy = sort),
                color: AppColors.primary,
              ),
          ],
        ),
        portfolioAsync.when(
          loading: () => const Column(children: [VitSkeletonList()]),
          error: (error, stackTrace) => Column(
            children: [
              VitErrorState(
                title: 'Không tải được danh mục',
                message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                actionLabel: 'Thử lại',
                onAction: () =>
                    ref.invalidate(marketPortfolioSnapshotProvider(_sortBy)),
              ),
            ],
          ),
          data: (snapshot) => Column(
            children: [
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng giá trị',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            formatMarketCompact(
                              snapshot.stats.totalValue,
                              prefix: '\$',
                            ),
                            style: AppTextStyles.control.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng PnL',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            '${snapshot.stats.totalPnl >= 0 ? '+' : ''}'
                            '${formatMarketCompact(snapshot.stats.totalPnl, prefix: '\$')} '
                            '(${snapshot.stats.totalPnlPct.toStringAsFixed(1)}%)',
                            style: AppTextStyles.caption.copyWith(
                              color: snapshot.stats.totalPnl >= 0
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tốt nhất 24h',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                          Text(
                            '${snapshot.stats.best24hSymbol} '
                            '+${snapshot.stats.best24hChange.toStringAsFixed(1)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.buy,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.zeroInsets,
                clip: true,
                child: Column(
                  children: [
                    for (var i = 0; i < snapshot.holdings.length; i++) ...[
                      _HoldingRow(holding: snapshot.holdings[i]),
                      if (i < snapshot.holdings.length - 1)
                        const Divider(
                          height: TabletSpacingTokens.dividerHairline,
                          thickness: TabletSpacingTokens.dividerHairline,
                          color: AppColors.divider,
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HoldingRow extends StatelessWidget {
  const _HoldingRow({required this.holding});

  final PortfolioHolding holding;

  @override
  Widget build(BuildContext context) {
    final pnlColor = holding.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: TabletSpacingTokens.tableCellPadding,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${holding.symbol} · ${holding.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${holding.quantity.toStringAsFixed(3)} @ '
              '${formatMarketPriceAdaptive(holding.avgBuyPrice)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatMarketCompact(holding.value, prefix: '\$'),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${holding.pnl >= 0 ? '+' : ''}'
              '${formatMarketCompact(holding.pnl, prefix: '\$')} '
              '(${holding.pnlPct.toStringAsFixed(1)}%)',
              style: AppTextStyles.caption.copyWith(
                color: pnlColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Tỷ trọng ${holding.allocation.toStringAsFixed(1)}%',
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
