import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

const double _marketMoverStripHeight = TabletSpacingTokens.buttonCompact;
const EdgeInsets _marketMoverStripPadding =
    MarketsSpacingTokens.marketListMoverCompactPadding;

class MarketListTopMovers extends StatelessWidget {
  const MarketListTopMovers({super.key, required this.pairs});

  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    final gainers = pairs.where((pair) => pair.change24h > 0).toList()
      ..sort((a, b) => b.change24h.compareTo(a.change24h));
    final losers = pairs.where((pair) => pair.change24h < 0).toList()
      ..sort((a, b) => a.change24h.compareTo(b.change24h));

    // card-tile: allow-start — fixed surface, not horizontal strip tile.
    // Bar cao control (34dp) — radius theo role là tight 8, không phải
    // standard 16: 16/34 ≈ pill tròn mắt trong khi card nội dung cao hơn
    // cùng 16 trông vuông hơn (Chuẩn Card-Border, role control surface).
    return VitCard(
      height: _marketMoverStripHeight,
      radius: VitCardRadius.tight,
      padding: _marketMoverStripPadding,
      child: Row(
        children: [
          Expanded(
            child: _MoverStripSection(
              title: 'Tăng mạnh',
              icon: Icons.trending_up_rounded,
              color: AppColors.buy,
              pairs: gainers.take(2).toList(),
            ),
          ),
          const SizedBox(
            width: TabletSpacingTokens.dividerHairline,
            height: TabletSpacingTokens.x5,
            child: VerticalDivider(
              color: AppColors.divider,
              width: TabletSpacingTokens.dividerHairline,
            ),
          ),
          Expanded(
            child: _MoverStripSection(
              title: 'Giảm mạnh',
              icon: Icons.trending_down_rounded,
              color: AppColors.sell,
              pairs: losers.take(2).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoverStripSection extends StatelessWidget {
  const _MoverStripSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.pairs,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<MarketPair> pairs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: MarketsSpacingTokens.marketMoverIcon),
        const SizedBox(width: TabletSpacingTokens.x4),
        Flexible(
          flex: 0,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.badge.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x4),
        for (var i = 0; i < pairs.length; i++) ...[
          if (i > 0) const SizedBox(width: TabletSpacingTokens.x4),
          Flexible(
            child: Text(
              '${pairs[i].baseAsset} ${marketListFormatPct(pairs[i].change24h)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.badge.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
