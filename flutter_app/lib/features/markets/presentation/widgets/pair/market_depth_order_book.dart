import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/controllers/market_controller.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketDepthOrderBookView extends StatelessWidget {
  const MarketDepthOrderBookView({required this.snapshot, super.key});

  final MarketDepthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OrderBookHeader(pair: snapshot.pair),
        SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        const MarketDepthSectionHeader(
          label: 'Lệnh bán (Ask)',
          accentColor: AppColors.sell,
        ),
        SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        _OrderBookRows(
          levels: snapshot.depth.asks.take(15).toList().reversed,
          side: MarketOrderSide.sell,
        ),
        SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        _MidPriceStrip(depth: snapshot.depth),
        SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        const MarketDepthSectionHeader(
          label: 'Lệnh mua (Bid)',
          accentColor: AppColors.buy,
        ),
        SizedBox(height: AppSurfaceSpacing.pageRhythmFormSectionGap),
        _OrderBookRows(
          levels: snapshot.depth.bids.take(15).toList(),
          side: MarketOrderSide.buy,
        ),
      ],
    );
  }
}

class _OrderBookHeader extends StatelessWidget {
  const _OrderBookHeader({required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      child: Padding(
        padding: MarketsSpacingTokens.marketDepthHeaderPadding,
        child: Row(
          children: [
            _HeaderCell('Giá (${pair.quoteAsset})'),
            _HeaderCell('Số lượng (${pair.baseAsset})', alignRight: true),
            const _HeaderCell('Tích lũy', alignRight: true),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text, {this.alignRight = false});

  final String text;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
          height: MarketsSpacingTokens.marketLineHeightTight,
        ),
      ),
    );
  }
}

class _OrderBookRows extends StatelessWidget {
  const _OrderBookRows({required this.levels, required this.side});

  final Iterable<MarketDepthLevel> levels;
  final MarketOrderSide side;

  @override
  Widget build(BuildContext context) {
    final list = levels.toList();
    final maxCumulative = list.fold<double>(
      0,
      (maxValue, level) => math.max(maxValue, level.cumulative),
    );
    final color = side == MarketOrderSide.buy ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: AppSurfaceSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (final level in list)
            _OrderBookRow(
              level: level,
              maxCumulative: maxCumulative,
              color: color,
            ),
        ],
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({
    required this.level,
    required this.maxCumulative,
    required this.color,
  });

  final MarketDepthLevel level;
  final double maxCumulative;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final barPct = maxCumulative == 0 ? 0.0 : level.cumulative / maxCumulative;
    return SizedBox(
      height: MarketsSpacingTokens.marketDepthOrderRowHeight,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: barPct.clamp(0.0, 1.0),
              heightFactor: 1,
              child: ColoredBox(color: color.withValues(alpha: .08)),
            ),
          ),
          Padding(
            padding: MarketsSpacingTokens.marketDepthOrderRowPadding,
            child: Row(
              children: [
                _BookCell(formatMarketDepthPrice(level.price), color: color),
                _BookCell(
                  formatMarketDepthQuantity(level.quantity),
                  alignRight: true,
                ),
                _BookCell(
                  formatMarketDepthQuantity(level.cumulative),
                  alignRight: true,
                  color: AppColors.text3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCell extends StatelessWidget {
  const _BookCell(this.text, {this.color, this.alignRight = false});

  final String text;
  final Color? color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.caption.copyWith(
          color: color ?? AppColors.text1,
          fontFeatures: AppTextStyles.tabularFigures,
          height: MarketsSpacingTokens.marketLineHeightTight,
        ),
      ),
    );
  }
}

class _MidPriceStrip extends StatelessWidget {
  const _MidPriceStrip({required this.depth});

  final MarketDepthData depth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      child: Padding(
        padding: MarketsSpacingTokens.marketDepthMidPricePadding,
        child: Center(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.caption,
              children: [
                TextSpan(
                  text: '\$${formatMarketDepthPrice(depth.midPrice)}',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: MarketsSpacingTokens.marketLineHeightCaption,
                  ),
                ),
                TextSpan(
                  text: '   Chênh lệch: ${depth.spreadPct.toStringAsFixed(4)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                    height: MarketsSpacingTokens.marketLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
