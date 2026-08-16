import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_theme.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

void main() {
  test('AppTheme.dark preserves the app-wide Phone theme contract', () {
    final theme = AppTheme.dark;

    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, AppColors.bg);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.colorScheme.secondary, AppColors.accent);
    expect(theme.colorScheme.error, AppColors.sell);
    final bodyMedium = theme.textTheme.bodyMedium!;
    expect(bodyMedium.fontFamily, AppTextStyles.body.fontFamily);
    expect(bodyMedium.fontSize, AppTextStyles.body.fontSize);
    expect(bodyMedium.color, AppTextStyles.body.color);
    expect(bodyMedium.fontWeight, AppTextStyles.body.fontWeight);
    expect(bodyMedium.height, AppTextStyles.body.height);

    final labelLarge = theme.textTheme.labelLarge!;
    expect(labelLarge.fontFamily, AppTextStyles.control.fontFamily);
    expect(labelLarge.fontSize, AppTextStyles.control.fontSize);
    expect(labelLarge.color, AppTextStyles.control.color);
    expect(labelLarge.fontWeight, AppTextStyles.control.fontWeight);
    expect(labelLarge.height, AppTextStyles.control.height);
  });
}
