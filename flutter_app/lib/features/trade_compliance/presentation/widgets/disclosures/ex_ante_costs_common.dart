part of '../../phone/pages/disclosures/ex_ante_costs_page.dart';

String _formatEur(double value) {
  final fixed = value.round().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < fixed.length; index += 1) {
    if (index > 0 && (fixed.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(fixed[index]);
  }
  return '€${buffer.toString()}';
}
