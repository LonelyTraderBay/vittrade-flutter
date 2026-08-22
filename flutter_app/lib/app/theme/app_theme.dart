import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_tablet_theme_extension.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// App-wide Material theme contract shared by the Phone bootstrap and future
/// surface adapters. Product widgets still use the more granular VitTrade
/// tokens directly; this theme covers Material defaults and system surfaces.
final class AppTheme {
  AppTheme._();

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.sell,
      onPrimary: AppColors.navCenterIcon,
      onSecondary: AppColors.text1,
      onSurface: AppColors.text1,
      onError: AppColors.navCenterIcon,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.jumbo,
      displayMedium: AppTextStyles.display,
      displaySmall: AppTextStyles.amountLg,
      headlineLarge: AppTextStyles.amountLg,
      headlineMedium: AppTextStyles.heroNumber,
      headlineSmall: AppTextStyles.sectionTitle,
      titleLarge: AppTextStyles.sectionTitle,
      titleMedium: AppTextStyles.baseMedium,
      titleSmall: AppTextStyles.sectionTitleSm,
      bodySmall: AppTextStyles.caption,
      bodyMedium: AppTextStyles.body,
      bodyLarge: AppTextStyles.base,
      labelSmall: AppTextStyles.micro,
      labelMedium: AppTextStyles.badge,
      labelLarge: AppTextStyles.control,
    ),
    // Read-facade over the static token layer — registered so widgets can
    // reach tablet spacing/border tokens via Theme.of(context); the static
    // classes remain the single source of truth (facade owns no numbers).
    extensions: const <ThemeExtension<dynamic>>[AppTabletThemeExtension()],
  );
}
