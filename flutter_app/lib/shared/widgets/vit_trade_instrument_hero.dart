import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_hero_glow.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_metric_delta_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sparkline.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Sizing density of a [VitTradeInstrumentHero]: full hero surface or a
/// compact standard-card variant.
enum VitTradeInstrumentHeroDensity { standard, compact }

/// Hero card for a trade instrument: symbol, large price, change-delta
/// pill, optional trend [sparklineValues], and optional high/low/volume
/// metric cells.
class VitTradeInstrumentHero extends StatelessWidget {
  const VitTradeInstrumentHero({
    super.key,
    required this.symbol,
    required this.priceLabel,
    required this.changePct,
    this.sparklineValues,
    this.highLabel,
    this.lowLabel,
    this.volumeLabel,
    this.density = VitTradeInstrumentHeroDensity.standard,
  });

  final String symbol;
  final String priceLabel;
  final double changePct;

  /// Recent price series for the mini trend chart. Renders nothing when
  /// null or shorter than 2 points.
  final List<double>? sparklineValues;
  final String? highLabel;
  final String? lowLabel;
  final String? volumeLabel;
  final VitTradeInstrumentHeroDensity density;

  bool get _compact => density == VitTradeInstrumentHeroDensity.compact;

  VitMetricDeltaTone get _deltaTone {
    if (changePct > 0) return VitMetricDeltaTone.positive;
    if (changePct < 0) return VitMetricDeltaTone.negative;
    return VitMetricDeltaTone.neutral;
  }

  Color get _priceColor {
    if (changePct > 0) return AppColors.buy;
    if (changePct < 0) return AppColors.sell;
    return AppColors.text1;
  }

  @override
  Widget build(BuildContext context) {
    final deltaLabel =
        '${changePct >= 0 ? '+' : ''}${changePct.toStringAsFixed(2)}%';

    return VitCard(
      variant: _compact ? VitCardVariant.standard : VitCardVariant.hero,
      radius: _compact ? VitCardRadius.tight : VitCardRadius.standard,
      clip: true,
      density: VitDensity.tool,
      padding: _compact
          ? AppSurfaceSpacing.cardPaddingCompact
          : SharedSpacingTokens.tradeInstrumentHeroPadding,
      background: _compact ? null : const VitHeroGlow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            symbol,
            style: (_compact ? AppTextStyles.micro : AppTextStyles.caption)
                .copyWith(color: AppColors.text2),
          ),
          SizedBox(
            height: _compact ? AppSurfaceSpacing.x1 : AppSurfaceSpacing.x2,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  priceLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      (_compact
                              ? AppTextStyles.sectionTitle
                              : AppTextStyles.heroNumber)
                          .copyWith(
                            color: _priceColor,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                ),
              ),
              SizedBox(width: AppSurfaceSpacing.x3),
              VitMetricDeltaPill(label: deltaLabel, tone: _deltaTone),
            ],
          ),
          if (sparklineValues != null && sparklineValues!.length >= 2) ...[
            SizedBox(
              height: _compact ? AppSurfaceSpacing.x2 : AppSurfaceSpacing.x3,
            ),
            SizedBox(
              height: SharedSpacingTokens.tradeInstrumentHeroSparklineHeight,
              width: double.infinity,
              child: VitSparkline(values: sparklineValues!, color: _priceColor),
            ),
          ],
          if (highLabel != null || lowLabel != null || volumeLabel != null) ...[
            SizedBox(
              height: _compact
                  ? AppSurfaceSpacing.x2
                  : SharedSpacingTokens.tradeInstrumentHeroMetricGap,
            ),
            Row(
              children: [
                if (highLabel != null)
                  Expanded(
                    child: _MetricCell(label: 'Cao', value: highLabel!),
                  ),
                if (lowLabel != null)
                  Expanded(
                    child: _MetricCell(label: 'Thấp', value: lowLabel!),
                  ),
                if (volumeLabel != null)
                  Expanded(
                    child: _MetricCell(label: 'KL 24h', value: volumeLabel!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        SizedBox(height: AppSurfaceSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

/// Compact price + 24h metrics row for fixed trade terminal headers.
class VitTradeHeaderMetricsRow extends StatelessWidget {
  const VitTradeHeaderMetricsRow({
    super.key,
    required this.priceLabel,
    required this.changePct,
    this.highLabel,
    this.lowLabel,
    this.volumeLabel,
  });

  final String priceLabel;
  final double changePct;
  final String? highLabel;
  final String? lowLabel;
  final String? volumeLabel;

  Color get _priceColor {
    if (changePct > 0) return AppColors.buy;
    if (changePct < 0) return AppColors.sell;
    return AppColors.text1;
  }

  @override
  Widget build(BuildContext context) {
    final deltaLabel =
        '${changePct >= 0 ? '+' : ''}${changePct.toStringAsFixed(2)}%';
    final deltaColor = changePct > 0
        ? AppColors.buy
        : changePct < 0
        ? AppColors.sell
        : AppColors.text2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  priceLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: _priceColor,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              SizedBox(width: AppSurfaceSpacing.x2),
              Text(
                deltaLabel,
                style: AppTextStyles.caption.copyWith(
                  color: deltaColor,
                  fontFeatures: AppTextStyles.tabularFigures,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
        if (highLabel != null || lowLabel != null || volumeLabel != null)
          Expanded(
            flex: 6,
            child: Row(
              children: [
                if (highLabel != null)
                  Expanded(
                    child: _MetricCell(label: 'Cao', value: highLabel!),
                  ),
                if (lowLabel != null)
                  Expanded(
                    child: _MetricCell(label: 'Thấp', value: lowLabel!),
                  ),
                if (volumeLabel != null)
                  Expanded(
                    child: _MetricCell(label: 'KL 24h', value: volumeLabel!),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
