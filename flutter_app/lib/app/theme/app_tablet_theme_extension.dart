import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';

/// Read-facade exposing the tablet design tokens through `Theme.of(context)`.
///
/// Every value delegates to the static const token layer
/// (`AppSpacing`/`AppColors`/`TabletDashboardWidths`) — this extension never
/// owns a number, so the static tokens stay the single source of truth and
/// the facade cannot drift (guarded by
/// `test/app/theme/app_tablet_theme_extension_test.dart`).
///
/// Adopted for widget code that prefers ThemeData-driven access (shared
/// libraries, multi-brand scenarios, theme-matrix goldens). Pages that
/// already import the token classes keep using them directly — both paths
/// resolve to the same constants, and const constructors keep working.
///
/// Border widths follow the Tablet Card & Border Standard: every stroke is a
/// 1dp hairline; visual weight varies through color tokens and the
/// sanctioned tint steps {.12, .22, .34} only.
@immutable
class AppTabletThemeExtension extends ThemeExtension<AppTabletThemeExtension> {
  const AppTabletThemeExtension();

  // ── Spacing scale (role-based, see Tablet-Spacing-Gutter-Standard) ──
  double get gapMicro => AppSpacing.x1; // 3 — pill↔pill inside a Wrap
  double get gapItem => AppSpacing.rowGap; // 8 — rows/chips inside a section
  double get gapCard => AppSpacing.cardGap; // 13 — sibling cards in a column
  double get gapBlock => AppSpacing.x5; // 21 — roomy block breathing
  double get contentPad => AppSpacing.contentPad; // 20 — screen edge inset

  // ── Tablet frame gutters (never re-declared elsewhere) ──
  double get outerMargin => TabletDashboardWidths.outerHorizontalMargin; // 20
  double get columnGutter => TabletDashboardWidths.columnGutter; // 24
  double get blockVerticalGap => TabletDashboardWidths.blockVerticalGap; // 16

  // ── Border tokens (1dp hairlines by standard) ──
  BorderSide get cardHairline =>
      const BorderSide(color: AppColors.cardBorder); // 7% white
  BorderSide get heroAccent =>
      const BorderSide(color: AppColors.portfolioBorder); // 15% amber
  BorderSide get solidFrame => const BorderSide(color: AppColors.borderSolid);
  BorderSide get warningStroke =>
      const BorderSide(color: AppColors.warningBorder);
  BorderSide get dividerStroke => const BorderSide(color: AppColors.divider);

  /// Tinted accent border — [alpha] must stay on the sanctioned scale
  /// {.12, .22, .34} (subtle / standard / strong) per the Card & Border
  /// Standard; [accent] should be a public semantic token.
  BorderSide tintStroke(Color accent, {double alpha = 0.22}) =>
      BorderSide(color: accent.withValues(alpha: alpha));

  @override
  AppTabletThemeExtension copyWith() => const AppTabletThemeExtension();

  @override
  AppTabletThemeExtension lerp(AppTabletThemeExtension? other, double t) =>
      other ?? this; // single-brand: constants do not interpolate
}

/// Convenience accessor: `context.tablet.columnGutter`.
extension AppTabletThemeX on BuildContext {
  AppTabletThemeExtension get tablet =>
      Theme.of(this).extension<AppTabletThemeExtension>() ??
      const AppTabletThemeExtension();
}
