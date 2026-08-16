/// Shared USD comma-grouping formatters for wallet widgets.
///
/// Consolidates a formatter (`$1,234.56` style: fixed decimals, thousands
/// separators, decimal portion always shown) that was previously
/// copy-pasted byte-for-byte across `wallet_transfer_sections.dart` and
/// `asset_detail_page_common.dart` / `asset_detail_page_sections.dart`.
library;

/// Formats [value] as `$1,234.56` with [decimals] fixed decimal places.
String formatWalletUsdGrouped(double value, {int decimals = 2}) {
  return '\$${walletGroupThousands(value.toStringAsFixed(decimals))}';
}

/// Groups the integer portion of a formatted numeric string with thousands
/// separators, leaving any decimal portion untouched (e.g. `1234.50` ->
/// `1,234.50`).
String walletGroupThousands(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
