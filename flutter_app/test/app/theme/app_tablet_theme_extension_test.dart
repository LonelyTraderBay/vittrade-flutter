import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_tablet_theme_extension.dart';
import 'package:vit_trade_flutter/app/theme/app_theme.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';

void main() {
  test('AppTheme.dark registers the tablet token facade', () {
    final extension = AppTheme.dark.extension<AppTabletThemeExtension>();

    expect(extension, isA<AppTabletThemeExtension>());
  });

  test('facade delegates every value to the static token layer', () {
    // The facade owns no numbers — if someone "fixes" a value here instead
    // of in the token classes, this test fails to keep the single source of
    // truth intact (Tablet-Spacing-Gutter + Card-Border standards).
    const tablet = AppTabletThemeExtension();

    expect(tablet.gapMicro, AppSpacing.x1);
    expect(tablet.gapItem, AppSpacing.rowGap);
    expect(tablet.gapCard, AppSpacing.cardGap);
    expect(tablet.gapBlock, AppSpacing.x5);
    expect(tablet.contentPad, AppSpacing.contentPad);

    expect(tablet.outerMargin, TabletDashboardWidths.outerHorizontalMargin);
    expect(tablet.columnGutter, TabletDashboardWidths.columnGutter);
    expect(tablet.blockVerticalGap, TabletDashboardWidths.blockVerticalGap);

    expect(tablet.cardHairline.color, AppColors.cardBorder);
    expect(tablet.heroAccent.color, AppColors.portfolioBorder);
    expect(tablet.solidFrame.color, AppColors.borderSolid);
    expect(tablet.warningStroke.color, AppColors.warningBorder);
    expect(tablet.dividerStroke.color, AppColors.divider);

    // Every stroke stays a 1dp hairline (Card & Border Standard Rule 1).
    expect(tablet.cardHairline.width, 1);
    expect(tablet.heroAccent.width, 1);
    expect(tablet.solidFrame.width, 1);
    expect(tablet.warningStroke.width, 1);
    expect(tablet.dividerStroke.width, 1);
    expect(tablet.tintStroke(AppColors.buy).width, 1);
  });

  test('tintStroke clamps nothing but documents the sanctioned scale', () {
    const tablet = AppTabletThemeExtension();

    // Default alpha is the standard step (.22); callers pick .12/.34
    // explicitly — the border audit guards literal call sites.
    expect(
      tablet.tintStroke(AppColors.buy).color,
      AppColors.buy.withValues(alpha: 0.22),
    );
    expect(
      tablet.tintStroke(AppColors.accent, alpha: 0.34).color,
      AppColors.accent.withValues(alpha: 0.34),
    );
  });

  test('lerp keeps constants (single-brand facade does not interpolate)', () {
    const tablet = AppTabletThemeExtension();

    expect(tablet.lerp(null, 0.5), same(tablet));
    expect(const AppTabletThemeExtension().lerp(tablet, 1), same(tablet));
    expect(tablet.copyWith(), same(tablet));
  });

  testWidgets('context.tablet resolves the registered facade', (tester) async {
    late AppTabletThemeExtension resolved;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Builder(
          builder: (context) {
            resolved = context.tablet;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved.columnGutter, TabletDashboardWidths.columnGutter);
  });

  testWidgets('context.tablet falls back when no theme registers it', (
    tester,
  ) async {
    late AppTabletThemeExtension resolved;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolved = context.tablet;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    // The const default keeps every token identical — consumers never see
    // null and never render off-scale spacing.
    expect(resolved.gapItem, AppSpacing.rowGap);
    expect(resolved.cardHairline.color, AppColors.cardBorder);
  });
}
