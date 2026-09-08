import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Tổng quan thị trường (SC-009): strip thống kê toàn thị
/// trường + breadth + fear/greed + top movers + top ngành — nội dung khóa
/// theo MarketOverviewSnapshot, điều hướng sang các pane công cụ khác.
class MarketsOverviewPane extends ConsumerWidget {
  const MarketsOverviewPane({super.key});

  static const contentKey = Key('sc009_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(marketOverviewSnapshotProvider);

    return MarketsPaneScaffold(
      title: 'Tổng quan thị trường',
      subtitle: 'Thị trường · Markets',
      scrollKey: MarketsOverviewPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketOverviewSnapshotProvider);
        await ref.read(marketOverviewSnapshotProvider.future);
      },
      children: overviewAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được tổng quan thị trường',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(marketOverviewSnapshotProvider),
          ),
        ],
        data: (snapshot) {
          final stats = snapshot.globalStats;
          final breadth = snapshot.marketBreadth;
          final topMovers = [...snapshot.movers]
            ..sort((a, b) => b.change24h.abs().compareTo(a.change24h.abs()));
          final topSectors = [...snapshot.sectors]
            ..sort((a, b) => b.change24h.compareTo(a.change24h));
          return [
            _GlobalStatsStrip(stats: stats, breadth: breadth),
            const SizedBox(height: TabletSpacingTokens.x3),
            _OverviewSectionHeader(
              label: 'Biến động nổi bật 24h',
              onMore: () => context.go(AppRoutePaths.marketsMovers),
            ),
            _MiniMoverList(movers: topMovers.take(6).toList()),
            const SizedBox(height: TabletSpacingTokens.x3),
            _OverviewSectionHeader(
              label: 'Ngành nổi bật',
              onMore: () => context.go(AppRoutePaths.marketsSectors),
            ),
            _MiniSectorList(sectors: topSectors.take(6).toList()),
          ];
        },
      ),
    );
  }
}

class _OverviewSectionHeader extends StatelessWidget {
  const _OverviewSectionHeader({required this.label, this.onMore});

  final String label;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
        ),
        if (onMore != null)
          TextButton(
            onPressed: onMore,
            child: Text(
              'Xem tất cả',
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
          ),
      ],
    );
  }
}

class _GlobalStatsStrip extends StatelessWidget {
  const _GlobalStatsStrip({required this.stats, required this.breadth});

  final GlobalMarketStats stats;
  final MarketBreadth breadth;

  @override
  Widget build(BuildContext context) {
    final capChange = stats.totalMarketCapChange24h;
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vốn hóa toàn thị trường',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Text(
                      formatMarketCompact(stats.totalMarketCap, prefix: '\$'),
                      style: AppTextStyles.control.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      '${capChange >= 0 ? '+' : ''}${capChange.toStringAsFixed(2)}% 24h',
                      style: AppTextStyles.caption.copyWith(
                        color: capChange >= 0 ? AppColors.buy : AppColors.sell,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  VitStatusPill(
                    label:
                        'Sợ hãi & Tham lam: ${stats.fearGreedIndex} '
                        '(${stats.fearGreedLabel})',
                    status: stats.fearGreedIndex >= 60
                        ? VitStatusPillStatus.success
                        : stats.fearGreedIndex >= 40
                        ? VitStatusPillStatus.warning
                        : VitStatusPillStatus.error,
                    size: VitStatusPillSize.sm,
                  ),
                  const SizedBox(height: TabletSpacingTokens.x2),
                  Text(
                    'Tăng ${breadth.advancing} · Giảm ${breadth.declining} · '
                    'Đứng yên ${breadth.unchanged}',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Text(
            'Volume 24h ${formatMarketCompact(stats.total24hVolume, prefix: '\$')} · '
            'BTC ${stats.btcDominance.toStringAsFixed(1)}% · '
            'ETH ${stats.ethDominance.toStringAsFixed(1)}%',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMoverList extends StatelessWidget {
  const _MiniMoverList({required this.movers});

  final List<MarketMover> movers;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < movers.length; i++) ...[
            Padding(
              padding: TabletSpacingTokens.tableCellPadding,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      movers[i].symbol,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      formatMarketPriceAdaptive(movers[i].price),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${movers[i].change24h >= 0 ? '+' : ''}'
                      '${movers[i].change24h.toStringAsFixed(2)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: movers[i].change24h >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < movers.length - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _MiniSectorList extends StatelessWidget {
  const _MiniSectorList({required this.sectors});

  final List<MarketSector> sectors;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < sectors.length; i++) ...[
            Padding(
              padding: TabletSpacingTokens.tableCellPadding,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      sectors[i].nameVi,
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
                      '${sectors[i].coinCount} coin',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${sectors[i].change24h >= 0 ? '+' : ''}'
                      '${sectors[i].change24h.toStringAsFixed(2)}%',
                      style: AppTextStyles.caption.copyWith(
                        color: sectors[i].change24h >= 0
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < sectors.length - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}
