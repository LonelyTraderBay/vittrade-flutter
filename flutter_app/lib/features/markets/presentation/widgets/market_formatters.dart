// Shared price/volume formatters for markets browse surfaces.
//
// Consolidates private `_formatPrice`/`_formatCompact` helpers that were
// hand-rolled independently per page (ponytail audit 2026-07-11, finding
// #3). Only the verified byte-identical/output-identical duplicates were
// folded in here — formatters with genuinely different decimal-tier or
// sign-handling behavior were left local to preserve their output exactly.

/// Adaptive-precision price: 2 decimals for values >= 1, 4 decimals for
/// values >= 0.01, else 6 decimals — thousands-separated, no currency
/// prefix.
String formatMarketPriceAdaptive(double value) {
  if (value >= 1) return _formatMarketFixed(value, 2);
  if (value >= 0.01) return _formatMarketFixed(value, 4);
  return _formatMarketFixed(value, 6);
}

/// Fixed 2-decimal price, thousands-separated, no currency prefix.
String formatMarketPriceFixed2(double value) => _formatMarketFixed(value, 2);

/// Tiered price: 2 decimals for values >= 1, else 4 decimals —
/// thousands-separated, with an optional leading [prefix] (e.g. `r'$'`).
String formatMarketPriceTiered(double value, {String prefix = ''}) {
  return '$prefix${_formatMarketFixed(value, value >= 1 ? 2 : 4)}';
}

/// Compact B/M/K notation at 2 decimals, with an optional leading [prefix]
/// (e.g. `r'$'`).
String formatMarketCompact(double value, {String prefix = ''}) {
  if (value >= 1000000000) {
    return '$prefix${_formatMarketFixed(value / 1000000000, 2)}B';
  }
  if (value >= 1000000) {
    return '$prefix${_formatMarketFixed(value / 1000000, 2)}M';
  }
  if (value >= 1000) {
    return '$prefix${_formatMarketFixed(value / 1000, 2)}K';
  }
  return '$prefix${_formatMarketFixed(value, 2)}';
}

String _formatMarketFixed(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
