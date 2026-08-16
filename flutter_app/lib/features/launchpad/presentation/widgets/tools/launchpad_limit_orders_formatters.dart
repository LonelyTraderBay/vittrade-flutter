part of '../../phone/pages/tools/launchpad_limit_orders_page.dart';

String _formatPrice(double value) => VitFormat.usd(value);

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(2);
}
