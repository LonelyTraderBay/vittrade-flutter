part of '../phone/pages/sub_account_page.dart';

Color _typeColor(String type) {
  return switch (type) {
    'spot' => AppColors.buy,
    'margin' => AppColors.warn,
    'futures' => AppColors.sell,
    _ => AppColors.primary,
  };
}

String _typeLabel(String type) {
  return switch (type) {
    'spot' => 'Spot',
    'margin' => 'Margin',
    'futures' => 'Futures',
    _ => 'T\u1EA5t c\u1EA3',
  };
}

Color _statusColor(String status) {
  return switch (status) {
    'frozen' => AppColors.warn,
    'pending' => AppColors.primary,
    _ => AppColors.buy,
  };
}

IconData _statusIcon(String status) {
  return switch (status) {
    'frozen' => Icons.ac_unit_rounded,
    'pending' => Icons.pause_circle_outline_rounded,
    _ => Icons.check_circle_outline_rounded,
  };
}

String _statusLabel(String status) {
  return switch (status) {
    'frozen' => '\u0110\u00F3ng b\u0103ng',
    'pending' => 'Ch\u1EDD duy\u1EC7t',
    _ => 'Ho\u1EA1t \u0111\u1ED9ng',
  };
}

String _permissionLabel(String permission) {
  return switch (permission) {
    'spot_trade' => 'Spot',
    'margin_trade' => 'Margin',
    'futures_trade' => 'Futures',
    'transfer' => 'Chuy\u1EC3n',
    'withdraw' => 'R\u00FAt',
    'read' => 'Xem',
    _ => permission,
  };
}

String _formatUsd(double value) => VitFormat.usd(value);

String _formatSignedUsd(double value) => VitFormat.usdSigned(value);

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}
