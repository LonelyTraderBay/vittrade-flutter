import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Copy Trading (SC-063): banner metrics + bảng trader
/// độ dày tablet (tên · win rate · PnL · AUM · copiers · rủi ro).
class CopyTradingTabletPage extends ConsumerStatefulWidget {
  const CopyTradingTabletPage({super.key});

  static const contentKey = Key('sc063_tablet_content');

  @override
  ConsumerState<CopyTradingTabletPage> createState() =>
      _CopyTradingTabletPageState();
}

List<TradeCopyTrader> _sortCopyTraders(
  List<TradeCopyTrader> traders,
  String sortBy,
) {
  final sorted = [...traders];
  if (sortBy == 'Ổn định nhất') {
    sorted.sort((a, b) => b.sharpeRatio.compareTo(a.sharpeRatio));
  } else if (sortBy == 'Nhiều copier') {
    sorted.sort((a, b) => b.copiers.compareTo(a.copiers));
  } else if (sortBy == 'AUM cao') {
    sorted.sort((a, b) => b.aum.compareTo(a.aum));
  } else {
    sorted.sort((a, b) => b.totalPnlPct.compareTo(a.totalPnlPct));
  }
  return sorted;
}

class _CopyTradingTabletPageState extends ConsumerState<CopyTradingTabletPage> {
  String _sortBy = 'Top ROI';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeCopyTradingProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Sao chép giao dịch – sao chép chiến lược có kiểm soát',
      semanticIdentifier: 'SC-063',
      child: Column(
        children: [
          VitHeader(
            title: 'Sao chép giao dịch',
            subtitle: 'Sao chép chiến lược có kiểm soát',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.trade,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được sao chép giao dịch',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(tradeCopyTradingProvider),
                ),
              ),
              data: (snapshot) {
                final traders = _sortCopyTraders(snapshot.traders, _sortBy);
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeCopyTradingProvider);
                    await ref.read(tradeCopyTradingProvider.future);
                  },
                  banner: VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tổng AUM',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                              Text(
                                formatTradeUsdWhole(snapshot.totalAum),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Copiers',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                              Text(
                                formatTradeInt(snapshot.totalCopiers),
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  primaryChildren: [
                    Wrap(
                      spacing: TabletSpacingTokens.x3,
                      runSpacing: TabletSpacingTokens.x2,
                      children: [
                        for (final option in snapshot.sortOptions)
                          VitFilterChip(
                            label: option,
                            active: _sortBy == option,
                            onTap: () => setState(() => _sortBy = option),
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                    VitCard(
                      key: CopyTradingTabletPage.contentKey,
                      radius: VitCardRadius.tight,
                      padding: TabletSpacingTokens.zeroInsets,
                      clip: true,
                      child: Column(
                        children: [
                          for (var i = 0; i < traders.length; i++) ...[
                            _TraderRow(trader: traders[i]),
                            if (i < traders.length - 1)
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
                  secondaryChildren: [
                    VitCard(
                      radius: VitCardRadius.tight,
                      padding: TabletSpacingTokens.cardPaddingCompact,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.riskWarningTitle,
                            style: AppTextStyles.control.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x1),
                          Text(
                            snapshot.riskWarningText,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TraderRow extends StatelessWidget {
  const _TraderRow({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    final pnlColor = trader.totalPnl >= 0 ? AppColors.buy : AppColors.sell;
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingTall,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trader.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
                Text(
                  '${trader.copiers}/${trader.maxCopiers} copiers · ${trader.tags.take(2).join(" · ")}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Win ${trader.winRate.toStringAsFixed(1)}%',
              style: AppTextStyles.caption.copyWith(
                color: trader.winRate >= 50 ? AppColors.buy : AppColors.sell,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatTradeSignedUsdRounded(trader.totalPnl),
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
              formatTradeUsdWhole(trader.aum),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rủi ro ${trader.riskLevel.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
