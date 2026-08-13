import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_trade_instrument_hero.dart';

/// Beginner hero — pair price, 24h change, trend sparkline, and available
/// balance (Home rhythm).
class VitTradeSimpleHero extends StatelessWidget {
  const VitTradeSimpleHero({
    super.key,
    required this.symbol,
    required this.priceLabel,
    required this.changePct,
    this.sparklineValues,
    this.availableBalanceLabel,
    this.highLabel,
    this.lowLabel,
    this.volumeLabel,
  });

  final String symbol;
  final String priceLabel;
  final double changePct;
  final List<double>? sparklineValues;
  final String? availableBalanceLabel;
  final String? highLabel;
  final String? lowLabel;
  final String? volumeLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTradeInstrumentHero(
          symbol: symbol,
          priceLabel: priceLabel,
          changePct: changePct,
          sparklineValues: sparklineValues,
          highLabel: highLabel,
          lowLabel: lowLabel,
          volumeLabel: volumeLabel,
          density: VitTradeInstrumentHeroDensity.standard,
        ),
        if (availableBalanceLabel != null) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Số dư khả dụng: $availableBalanceLabel',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ],
    );
  }
}
