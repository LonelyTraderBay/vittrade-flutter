part of 'token_unlocks_page.dart';

String _countdownLabel(TokenUnlockDraft unlock) {
  if (unlock.daysUntil == 0) return '(Hôm nay)';
  return '(${unlock.daysUntil} ngày)';
}

Color _countdownColor(int daysUntil) {
  if (daysUntil <= 3) return AppColors.sell;
  if (daysUntil <= 7) return AppColors.warn;
  return AppColors.text2;
}

String _formatCompactUsd(double value) {
  final roundedMillions = (value / 10000).round() / 100;
  final fixed = roundedMillions.toStringAsFixed(2);
  final text = fixed.endsWith('.00')
      ? fixed.substring(0, fixed.length - 3)
      : fixed;
  return '\$${text}M';
}

String _formatCompactNumber(double value) {
  if (value >= 1000000) {
    final text = (value / 1000000).toStringAsFixed(2);
    return '${_trimTrailingZeros(text)}M';
  }
  if (value >= 1000) {
    final text = (value / 1000).toStringAsFixed(2);
    return '${_trimTrailingZeros(text)}K';
  }
  return value.toStringAsFixed(0);
}

String _formatPriceUsd(double value) {
  final text = value >= 10
      ? value.toStringAsFixed(2)
      : value.toStringAsFixed(2);
  return '\$$text';
}

String _formatPct(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String _trimTrailingZeros(String value) {
  return value
      .replaceFirst(RegExp(r'\.00$'), '')
      .replaceFirst(RegExp(r'0$'), '');
}

String _vestingTypeLabel(MarketUnlockVestingType type) {
  return switch (type) {
    MarketUnlockVestingType.cliff => 'Cliff (gộp)',
    MarketUnlockVestingType.linear => 'Linear (dần)',
    MarketUnlockVestingType.milestone => 'Milestone',
  };
}

String _shortVestingTypeLabel(MarketUnlockVestingType type) {
  return switch (type) {
    MarketUnlockVestingType.cliff => 'Cliff',
    MarketUnlockVestingType.linear => 'Linear',
    MarketUnlockVestingType.milestone => 'Milestone',
  };
}
