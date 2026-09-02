import 'package:vit_trade_flutter/shared/utils/vit_format.dart';

/// Shared price/money formatters for trade terminal surfaces.
String formatTradePrice(double value) =>
    VitFormat.usd(value).replaceFirst('\$', '');

String formatTradeMoney(double value) => formatTradePrice(value);

/// Thousands-grouped non-negative integer, e.g. `1,234`.
String formatTradeInt(int value) => VitFormat.count(value);

/// USD amount with thousands separators and exact cents, e.g. `$1,234.56`.
String formatTradeUsd(double value) => VitFormat.usd(value);

/// Whole-dollar USD amount with thousands separators, e.g. `$1,235.00`.
String formatTradeUsdWhole(double value) =>
    VitFormat.usd(value.roundToDouble());

/// Rounded whole-dollar USD amount with thousands separators and no
/// decimal places, e.g. `$1,235`.
String formatTradeUsdRounded(double value) =>
    '\$${VitFormat.count(value.round())}';

/// Signed, rounded whole-dollar USD amount, e.g. `+$1,235` / `-$1,235`.
String formatTradeSignedUsdRounded(double value) =>
    '${value >= 0 ? '+' : '-'}${formatTradeUsdRounded(value.abs())}';

/// Signed USD amount with thousands separators and exact cents,
/// e.g. `+$1,234.56` / `-$1,234.56`.
String formatTradeSignedMoney(double value) => VitFormat.usdSigned(value);

/// EUR amount with thousands separators, sign before the currency symbol,
/// e.g. `-€1,234`.
String formatTradeEur(double value) {
  final rounded = value.round();
  final sign = rounded < 0 ? '-' : '';
  return '$sign€${formatTradeInt(rounded.abs())}';
}

/// Compact `K`-suffixed integer, e.g. `1K` for values >= 1000, else the
/// plain integer.
String formatTradeCompactNumber(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}

/// Deterministic 24h snapshot (mini trend line + high/low/volume) derived
/// from a pair's current [price] and [changePct] — feeds the Simple-mode
/// price hero's sparkline + 24h stat row (Trade Redesign V2 §3) when the
/// repository has no live tick history yet. Values are a pure function of
/// the inputs so goldens/tests stay stable.
final class TradeSyntheticDaySnapshot {
  const TradeSyntheticDaySnapshot({
    required this.sparkline,
    required this.highLabel,
    required this.lowLabel,
    required this.volumeLabel,
    required this.coinVolumeLabel,
  });

  /// Recent price series, oldest first, ending exactly at [price].
  final List<double> sparkline;
  final String highLabel;
  final String lowLabel;

  /// Giá trị giao dịch 24h theo quote (USDT) — không kèm đơn vị.
  final String volumeLabel;

  /// Khối lượng giao dịch 24h theo đồng base (BTC/ETH/…) — không kèm đơn vị.
  final String coinVolumeLabel;
}

TradeSyntheticDaySnapshot tradeSyntheticDaySnapshot(
  double price,
  double changePct,
) {
  const points = 12;
  final divisor = 1 + (changePct.clamp(-90, 900) / 100);
  final startPrice = divisor == 0 ? price : price / divisor;

  final sparkline = <double>[
    for (var i = 0; i < points; i++)
      startPrice +
          (price - startPrice) * (i / (points - 1)) +
          (i.isEven ? 1 : -1) * price * 0.003,
  ];
  sparkline[points - 1] = price;

  final high = sparkline.reduce((a, b) => a > b ? a : b);
  final low = sparkline.reduce((a, b) => a < b ? a : b);
  // Arbitrary but deterministic 24h notional-volume multiplier for mock
  // data — not a real market figure.
  final volumeBillions = ((price * 18500) / 1e9).clamp(0.1, 999.9);
  // KL theo đồng base = notional / giá — cùng nguồn mock deterministic.
  final coinVolume = price <= 0 ? 0.0 : (volumeBillions * 1e9) / price;
  final coinVolumeLabel = coinVolume >= 1000
      ? '${(coinVolume / 1000).toStringAsFixed(1)}K'
      : coinVolume.toStringAsFixed(0);

  return TradeSyntheticDaySnapshot(
    sparkline: sparkline,
    highLabel: formatTradePrice(high),
    lowLabel: formatTradePrice(low),
    volumeLabel: '${volumeBillions.toStringAsFixed(1)}B',
    coinVolumeLabel: coinVolumeLabel,
  );
}
