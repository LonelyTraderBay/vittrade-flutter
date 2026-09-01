import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';

void main() {
  tearDown(() {
    TabletSpacingTokens.tabletSurfaceActive = false;
  });

  test('shared adapter keeps Phone spacing when Tablet is inactive', () {
    expect(AppSurfaceSpacing.x4, AppSpacing.x4);
    expect(
      AppSurfaceSpacing.pageRhythmStandardInnerGap,
      AppSpacing.pageRhythmStandardInnerGap,
    );
    expect(AppSurfaceSpacing.pageEndBreathing, AppSpacing.pageContentGapLoose);
    expect(AppSurfaceSpacing.inputHeight, AppSpacing.inputHeight);
    expect(VitDensity.standard.verticalSpace, AppSpacing.x4);
  });

  test('shared adapter switches to Tablet spacing at the composition root', () {
    TabletSpacingTokens.tabletSurfaceActive = true;

    expect(AppSurfaceSpacing.x4, TabletSpacingTokens.x4);
    expect(
      AppSurfaceSpacing.pageRhythmStandardInnerGap,
      TabletSpacingTokens.pageRhythmStandardInnerGap,
    );
    expect(
      AppSurfaceSpacing.formFieldLabelGap,
      TabletSpacingTokens.formFieldLabelGap,
    );
    expect(VitDensity.standard.verticalSpace, TabletSpacingTokens.x4);
    expect(
      VitDensity.relaxed.cardHorizontalPadding,
      TabletSpacingTokens.cardPaddingRelaxedDensity.horizontal / 2,
    );
    expect(
      VitDensity.tool.pageContentGap,
      TabletSpacingTokens.pageContentGapTight,
    );
    expect(
      AppSurfaceSpacing.pageContentGapDefault,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
    expect(
      AppSurfaceSpacing.pageContentGapRelaxed,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
    expect(
      AppSurfaceSpacing.pageContentGapLoose,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
    expect(
      AppSurfaceSpacing.pageEndBreathing,
      TabletSpacingTokens.pageEndBreathing,
    );
  });
}
