/// Shared ISO (`yyyy-MM-dd`) <-> display (`MM/dd/yyyy`) date formatting
/// helpers for Arena flows.
///
/// Consolidates the near-identical governance-gate and smart-rule-builder
/// copies (ponytail-audit arena finding #5) into one implementation. Uses
/// the smart-rule-builder variant's length validation since it is the more
/// defensive of the two.
library;

String formatArenaDateInput(String isoDate) {
  final parts = isoDate.split('-');
  if (parts.length != 3) return isoDate;
  final year = parts[0];
  final month = parts[1];
  final day = parts[2];
  if (year.length != 4 || month.length != 2 || day.length != 2) {
    return isoDate;
  }
  return '$month/$day/$year';
}

String normalizeArenaDateInput(String displayDate) {
  final parts = displayDate.split('/');
  if (parts.length != 3) return displayDate;
  final month = parts[0].padLeft(2, '0');
  final day = parts[1].padLeft(2, '0');
  final year = parts[2].padLeft(4, '0');
  return '$year-$month-$day';
}
