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
  static const tickerStrip = Key('sc048_trade_ticker_strip');

  // Terminal 3 vùng (hướng Bybit 2026-08-31).
  static const metaStrip = Key('sc048_trade_meta_strip');
  static const pairPicker = Key('sc048_trade_pair_picker');
  static const pairPickerItem = Key('sc048_trade_pair_picker_item');
  static const refresh = Key('sc048_trade_refresh');
  static const chartPanel = Key('sc048_trade_chart_panel');
  static const chartCanvas = Key('sc048_trade_chart_canvas');
  static const ohlcReadout = Key('sc048_trade_ohlc_readout');
  static const bookPanel = Key('sc048_trade_book_panel');
  static const tapePanel = Key('sc048_trade_tape_panel');
  static const entryPanel = Key('sc048_trade_entry_panel');
  static const bottomPanel = Key('sc048_trade_bottom_panel');

  static Key timeframe(String tf) => Key('sc048_trade_tf_$tf');
  static Key indicator(String id) => Key('sc048_trade_indicator_$id');
  static Key bookRow(String side, int index) =>
      Key('sc048_trade_book_${side}_$index');
  static Key tapeRow(int index) => Key('sc048_trade_tape_$index');
  static Key bottomTab(String id) => Key('sc048_trade_bottom_tab_$id');

  static Key quickNav(String id) => Key('sc048_quick_$id');
  static Key pct(int pct) => Key('sc048_pct_$pct');
}
