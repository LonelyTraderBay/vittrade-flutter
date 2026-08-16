part of '../../phone/pages/tools/launchpad_abi_diff_page.dart';

extension _AbiChangeUi on LaunchpadAbiChangeType {
  String get value {
    return switch (this) {
      LaunchpadAbiChangeType.added => 'added',
      LaunchpadAbiChangeType.removed => 'removed',
      LaunchpadAbiChangeType.modified => 'modified',
      LaunchpadAbiChangeType.unchanged => 'unchanged',
    };
  }

  String get label {
    return switch (this) {
      LaunchpadAbiChangeType.added => 'Added',
      LaunchpadAbiChangeType.removed => 'Removed',
      LaunchpadAbiChangeType.modified => 'Modified',
      LaunchpadAbiChangeType.unchanged => 'Unchanged',
    };
  }

  Color get color {
    return switch (this) {
      LaunchpadAbiChangeType.added => AppColors.buy,
      LaunchpadAbiChangeType.removed => AppColors.sell,
      LaunchpadAbiChangeType.modified => AppColors.warn,
      LaunchpadAbiChangeType.unchanged => AppColors.text2,
    };
  }

  IconData get icon {
    return switch (this) {
      LaunchpadAbiChangeType.added => Icons.add_rounded,
      LaunchpadAbiChangeType.removed => Icons.remove_rounded,
      LaunchpadAbiChangeType.modified => Icons.sync_rounded,
      LaunchpadAbiChangeType.unchanged => Icons.check_rounded,
    };
  }
}

extension _AbiRiskUi on LaunchpadAbiRiskLevel {
  String get label {
    return switch (this) {
      LaunchpadAbiRiskLevel.none => 'None',
      LaunchpadAbiRiskLevel.low => 'Low',
      LaunchpadAbiRiskLevel.medium => 'Medium',
      LaunchpadAbiRiskLevel.high => 'High',
      LaunchpadAbiRiskLevel.critical => 'Critical',
    };
  }

  Color get color {
    return switch (this) {
      LaunchpadAbiRiskLevel.none => AppColors.text2,
      LaunchpadAbiRiskLevel.low => AppColors.buy,
      LaunchpadAbiRiskLevel.medium => AppColors.warn,
      LaunchpadAbiRiskLevel.high => AppColors.sell,
      LaunchpadAbiRiskLevel.critical => AppColors.sell,
    };
  }

  IconData get icon {
    return switch (this) {
      LaunchpadAbiRiskLevel.none => Icons.shield_outlined,
      LaunchpadAbiRiskLevel.low => Icons.verified_user_outlined,
      LaunchpadAbiRiskLevel.medium => Icons.shield_outlined,
      LaunchpadAbiRiskLevel.high => Icons.gpp_maybe_outlined,
      LaunchpadAbiRiskLevel.critical => Icons.gpp_bad_outlined,
    };
  }
}

Color _riskScoreColor(int score) {
  if (score >= 80) return AppColors.sell;
  if (score >= 60) return AppColors.warn;
  if (score >= 40) return AppColors.accent;
  return AppColors.buy;
}

String _truncateAddress(String value) => maskAddress(value);

String _formatInt(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final fromEnd = text.length - i;
    buffer.write(text[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}

String _compareText(String? oldValue, String? newValue) {
  if (oldValue == null) return newValue ?? '-';
  if (newValue == null || oldValue == newValue) return oldValue;
  return '$oldValue -> $newValue';
}
