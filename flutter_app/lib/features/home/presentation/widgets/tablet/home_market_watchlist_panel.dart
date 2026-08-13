import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet main-column equivalent of Home's private phone market section.
/// It keeps the same market data and routes while making the watchlist a
/// persistent dashboard panel.
class HomeMarketWatchlistPanel extends StatelessWidget {
  const HomeMarketWatchlistPanel({
    super.key,
    required this.activeTab,
    required this.pairs,
    required this.onTabChanged,
    required this.onNavigate,
  });

  final String activeTab;
  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'Thị trường',
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
          actionLabel: 'Xem tất cả',
          actionSemanticLabel: 'Xem tất cả thị trường',
          onAction: () => onNavigate('/markets'),
        ),
        VitTabBar(
          activeKey: activeTab,
          onChanged: onTabChanged,
          tabs: const [
            VitTabItem(
              key: 'hot',
              label: 'Hot',
              icon: Icons.local_fire_department_rounded,
            ),
            VitTabItem(
              key: 'gainers',
              label: 'Tăng',
              icon: Icons.trending_up_rounded,
            ),
            VitTabItem(
              key: 'losers',
              label: 'Giảm',
              icon: Icons.trending_down_rounded,
            ),
            VitTabItem(key: 'new', label: 'Mới', icon: Icons.fiber_new_rounded),
          ],
        ),
        const SizedBox(height: SharedSpacingTokens.homeSectionInnerGap),
        if (pairs.isEmpty)
          const VitEmptyState(
            title: 'Chưa có cặp nào trong mục này',
            message: 'Thử chọn tab khác để xem thêm thị trường.',
            icon: Icons.candlestick_chart_rounded,
          )
        else
          VitCard(
            clip: true,
            child: Column(
              children: [
                for (var i = 0; i < pairs.length; i++) ...[
                  _WatchlistRow(
                    pair: pairs[i],
                    onTap: () => onNavigate('/pair/${pairs[i].id}'),
                  ),
                  if (i < pairs.length - 1)
                    const Divider(
                      height: AppSpacing.dividerHairline,
                      thickness: AppSpacing.dividerHairline,
                      color: AppColors.divider,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _WatchlistRow extends StatelessWidget {
  const _WatchlistRow({required this.pair, required this.onTap});

  final HomeCryptoPair pair;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final trend = pair.change24h >= 0
        ? VitTrendDirection.positive
        : VitTrendDirection.negative;

    return VitMarketPairRow(
      leading: VitAssetAvatar(
        label: pair.baseAsset,
        accentColor: AppAssetColors.forSymbol(pair.baseAsset),
      ),
      title: pair.symbol,
      subtitle: 'Vol \$${(pair.volume24h / 1e9).toStringAsFixed(2)}B',
      price: formatUsd(pair.price),
      changeLabel: formatPct(pair.change24h),
      trend: trend,
      sparkline: pair.sparkline,
      showSparkline: true,
      onTap: onTap,
    );
  }
}
