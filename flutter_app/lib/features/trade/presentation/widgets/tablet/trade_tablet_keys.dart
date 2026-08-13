import 'package:flutter/foundation.dart';

/// Semantic keys owned by the tablet Trade surface.
final class TradeTabletKeys {
  const TradeTabletKeys._();

  static const back = Key('sc048_trade_back');
  static const buySide = Key('sc048_trade_buy_side');
  static const sellSide = Key('sc048_trade_sell_side');
  static const amountField = Key('sc048_trade_amount_field');
  static const submit = Key('sc048_trade_submit');
  static const nextAction = Key('sc048_trade_next_action');

  static Key quickNav(String id) => Key('sc048_quick_$id');
  static Key pct(int pct) => Key('sc048_pct_$pct');
}
