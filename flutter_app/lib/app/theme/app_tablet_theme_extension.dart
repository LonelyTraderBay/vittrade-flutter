import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';

/// Read-facade exposing the tablet design tokens through `Theme.of(context)`.
///
/// Every value delegates to the static const token layer
/// (`TabletSpacingTokens`/`AppColors`/`TabletDashboardWidths`) — this extension never
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
  double get gapMicro => TabletSpacingTokens.x1; // 4 — pill↔pill inside a Wrap
  double get gapItem =>
      TabletSpacingTokens.rowGap; // 8 — rows/chips inside a section
  double get gapCard =>
      TabletSpacingTokens.cardGap; // 12 — sibling cards in a column
  double get gapBlock =>
      TabletSpacingTokens.pageRhythmStandardSectionGap; // 12 — block role
  double get contentPad =>
      TabletSpacingTokens.contentPad; // 20 — screen edge inset

  // ── Tablet frame gutters (never re-declared elsewhere) ──
  double get outerMargin => TabletDashboardWidths.outerHorizontalMargin; // 12
  double get columnGutter => TabletDashboardWidths.columnGutter; // 12
  double get blockVerticalGap => TabletDashboardWidths.blockVerticalGap; // 12

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
