part of '../../phone/pages/staking/staking_insurance_page.dart';

extension on StakingInsuranceSnapshot {
  StakingInsurancePlanDraft? planById(String? id) {
    if (id == null) return null;
    for (final plan in plans) {
      if (plan.id == id) return plan;
    }
    return null;
  }
}

String _formatUsd(double value) {
  if (value >= 1000000) return '\$${(value / 1000000).toStringAsFixed(1)}M';
  final parts = value.toStringAsFixed(2).split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');
}
