// Phone/fallback trade side switch.
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_segmented_choice.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

/// Spot MUA/BÁN side toggle — shared across Spot terminal surfaces.
class VitTradeSpotSideSwitch extends StatelessWidget {
  const VitTradeSpotSideSwitch({
    super.key,
    required this.side,
    required this.onChanged,
    this.buyKey,
    this.sellKey,
    this.activeBuyKey,
    this.activeSellKey,
  });

  final TradeOrderSide side;
  final ValueChanged<TradeOrderSide> onChanged;
  final Key? buyKey;
  final Key? sellKey;
  final Key? activeBuyKey;
  final Key? activeSellKey;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<TradeOrderSide>(
      selected: side,
      onChanged: onChanged,
      options: [
        VitSegmentedChoiceOption(
          key: buyKey,
          activeKey: activeBuyKey,
          value: TradeOrderSide.buy,
          label: 'MUA',
          accentColor: AppColors.buy,
          semanticLabel: 'Chọn mua',
        ),
        VitSegmentedChoiceOption(
          key: sellKey,
          activeKey: activeSellKey,
          value: TradeOrderSide.sell,
          label: 'BÁN',
          accentColor: AppColors.sell,
          semanticLabel: 'Chọn bán',
        ),
      ],
    );
  }
}

/// Futures Long/Short side toggle — shared across Futures terminal surfaces.
class VitTradeFuturesSideSwitch extends StatelessWidget {
  const VitTradeFuturesSideSwitch({
    super.key,
    required this.side,
    required this.onChanged,
    this.longKey,
    this.shortKey,
  });

  final TradeFuturesSide side;
  final ValueChanged<TradeFuturesSide> onChanged;
  final Key? longKey;
  final Key? shortKey;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<TradeFuturesSide>(
      selected: side,
      onChanged: onChanged,
      height: TradeSpacingTokens.futuresSideSwitchHeight,
      options: [
        VitSegmentedChoiceOption(
          key: longKey,
          value: TradeFuturesSide.long,
          label: 'Long',
          accentColor: AppColors.buy,
          leading: const Icon(Icons.trending_up_rounded),
          semanticLabel: 'Chọn hướng Long futures',
        ),
        VitSegmentedChoiceOption(
          key: shortKey,
          value: TradeFuturesSide.short,
          label: 'Short',
          accentColor: AppColors.sell,
          leading: const Icon(Icons.trending_down_rounded),
          semanticLabel: 'Chọn hướng Short futures',
        ),
      ],
    );
  }
}
