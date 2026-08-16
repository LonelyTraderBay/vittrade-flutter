part of '../../phone/pages/tools/market_movers_page.dart';

String _formatSignedPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}
