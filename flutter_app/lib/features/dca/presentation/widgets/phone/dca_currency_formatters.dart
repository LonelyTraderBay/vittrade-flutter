/// Shared VND currency and percent formatters for DCA surfaces.
///
/// Single source of truth consolidating two previously divergent, duplicate
/// implementations: `dca_page_part_04.dart` (3-tier K/M/B granularity, no
/// negative-sign handling) and `dca_overview_demo_actions.dart` (2-tier
/// M/B only, correct negative-sign handling). This combines the finer
/// K/M/B granularity with the correct sign handling so the same money
/// value renders identically across every DCA screen.
String formatFullVnd(int amount) {
  final sign = amount < 0 ? '-' : '';
  final digits = amount.abs().toString();
  final buffer = StringBuffer(sign);
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String formatCompactVnd(int amount) {
  final sign = amount < 0 ? '-' : '';
  final abs = amount.abs();
  if (abs >= 1000000000) {
    return '$sign${(abs / 1000000000).toStringAsFixed(2)}B';
  }
  if (abs >= 1000000) {
    return '$sign${(abs / 1000000).toStringAsFixed(2)}M';
  }
  if (abs >= 1000) {
    return '$sign${(abs / 1000).toStringAsFixed(0)}K';
  }
  return formatFullVnd(amount);
}

/// USD formatter — was a byte-for-byte identical duplicate defined in both
/// `dca_performance_compare_primitives.dart` and
/// `dca_multi_asset_page_part_03.dart`.
String formatUsd(num value) => '\$${value.round()}';

/// Percent formatters below consolidate three DCA screens' `_formatPercent`
/// helpers into one file. Unlike the VND formatters above, these three were
/// genuinely divergent in output (suffix/sign/rounding all differ), so each
/// is preserved verbatim under a distinct name rather than merged into one
/// behavior — merging would change what already-shipped screens render.

/// No sign, no `%` suffix, comma decimal separator — was local
/// `_formatPercent` in `dca_page_part_04.dart`.
String formatPercentPlain(double percent) {
  return percent.toStringAsFixed(1).replaceAll('.', ',');
}

/// Rounds to a whole number when exact, `%` suffix, no sign — was local
/// `_formatPercent` in `dca_multi_asset_page_part_03.dart`.
String formatPercentTrimmed(double value) {
  final rounded = value.roundToDouble();
  if (rounded == value) return '${rounded.toInt()}%';
  return '${value.toStringAsFixed(1)}%';
}

/// Explicit `+`/`` sign, comma decimal separator, `%` suffix — was local
/// `_formatPercent` in `dca_overview_demo_actions.dart`.
String formatPercentSigned(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1).replaceAll('.', ',')}%';
}
