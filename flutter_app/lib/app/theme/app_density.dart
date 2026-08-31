import 'package:flutter/widgets.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';

enum VitDensity { compact, standard, relaxed, hero, tool }

extension VitDensityMetrics on VitDensity {
  double get controlHeight {
    switch (this) {
      case VitDensity.compact:
        return 44;
      case VitDensity.standard:
        return AppSpacing.ctaHeight;
      case VitDensity.relaxed:
        return 58;
      case VitDensity.hero:
        return 58;
      case VitDensity.tool:
        return 44;
    }
  }

  double get verticalSpace {
    switch (this) {
      case VitDensity.compact:
        return AppSpacing.pageContentGapTight;
      case VitDensity.standard:
        return AppSpacing.x4;
      case VitDensity.relaxed:
        return AppSpacing.x5;
      case VitDensity.hero:
        return AppSpacing.x5;
      case VitDensity.tool:
        return AppSpacing.pageContentGapTight;
    }
  }

  double get cardHorizontalPadding {
    switch (this) {
      case VitDensity.compact:
        return 12;
      case VitDensity.standard:
        return AppSpacing.pageContentGapDefault;
      case VitDensity.relaxed:
        return AppSpacing.x5;
      case VitDensity.hero:
        return AppSpacing.contentPad;
      case VitDensity.tool:
        return 12;
    }
  }

  double get cardVerticalPadding {
    switch (this) {
      case VitDensity.compact:
        return 12;
      case VitDensity.standard:
        return AppSpacing.pageContentGapDefault;
      case VitDensity.relaxed:
        return AppSpacing.x5;
      case VitDensity.hero:
        return 24;
      case VitDensity.tool:
        return AppSpacing.x2;
    }
  }

  EdgeInsetsGeometry get cardPadding {
    // 2026-09-01 tách token phone/tablet: trên tablet, padding card đọc
    // từ TabletSpacingTokens (giá trị snapshot y hệt — đổi ở đó không
    // ảnh hưởng phone).
    if (TabletSpacingTokens.tabletSurfaceActive) {
      return switch (this) {
        VitDensity.compact => TabletSpacingTokens.cardPaddingCompactDensity,
        VitDensity.standard => TabletSpacingTokens.cardPaddingStandardDensity,
        VitDensity.relaxed => TabletSpacingTokens.cardPaddingRelaxedDensity,
        VitDensity.hero => TabletSpacingTokens.cardPaddingHeroDensity,
        VitDensity.tool => TabletSpacingTokens.cardPaddingToolDensity,
      };
    }
    return EdgeInsetsDirectional.symmetric(
      horizontal: cardHorizontalPadding,
      vertical: cardVerticalPadding,
    );
  }

  double get pageContentTopPadding {
    switch (this) {
      case VitDensity.compact:
      case VitDensity.tool:
        return AppSpacing.pageContentTopCompact;
      case VitDensity.standard:
      case VitDensity.hero:
        return AppSpacing.pageContentTopDefault;
      case VitDensity.relaxed:
        return AppSpacing.pageContentTopRelaxed;
    }
  }

  double get pageContentGap {
    switch (this) {
      case VitDensity.compact:
      case VitDensity.tool:
        return AppSpacing.pageContentGapTight;
      case VitDensity.standard:
      case VitDensity.hero:
        return AppSpacing.pageContentGapDefault;
      case VitDensity.relaxed:
        return AppSpacing.pageContentGapRelaxed;
    }
  }
}
