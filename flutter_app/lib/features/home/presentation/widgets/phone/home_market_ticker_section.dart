// Phone-specific home market section.
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/phone/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

const double _assetAvatarExtent = AppSpacing.iconMd + AppSpacing.x1;

class HomeMarketTickerSection extends StatelessWidget {
  const HomeMarketTickerSection({
    super.key,
    required this.pairs,
    required this.onNavigate,
    this.adaptive = false,
    this.itemGap,
  });

  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onNavigate;
  final bool adaptive;
  final double? itemGap;

  @override
  Widget build(BuildContext context) {
    final items = [
      for (final pair in pairs)
        VitMarketTickerData(
          leading: VitAssetAvatar(
            label: pair.baseAsset,
            accentColor: AppAssetColors.forSymbol(pair.baseAsset),
            size: _assetAvatarExtent,
          ),
          title: pair.symbol,
          price: formatUsd(pair.price),
          changeLabel: formatPct(pair.change24h),
          trend: pair.change24h >= 0
              ? VitTrendDirection.positive
              : VitTrendDirection.negative,
          onTap: () => onNavigate('/pair/${pair.id}'),
        ),
    ];

    if (!adaptive) {
      return VitMarketTickerStrip(
        key: HomePage.marketTickerKey,
        items: items,
        itemGap: itemGap,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = itemGap ?? SharedSpacingTokens.homeMarketTickerStripGap;
        final itemWidth = items.isEmpty
            ? null
            : (constraints.maxWidth - (gap * (items.length - 1))) /
                  items.length;
        return VitMarketTickerStrip(
          key: HomePage.marketTickerKey,
          items: items,
          cardWidth: itemWidth != null && itemWidth > 0 ? itemWidth : null,
          itemGap: itemGap,
        );
      },
    );
  }
}
