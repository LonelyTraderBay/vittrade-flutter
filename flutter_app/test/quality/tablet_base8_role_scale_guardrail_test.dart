// Guardrail: Tablet Base-8-derived Role Scale.
//
// Đây là hợp đồng semantic của surface Tablet, không phải lưới 4dp tự do:
// 4dp chỉ là nền căn chỉnh; call-site chọn role đã khóa. Mọi thay đổi bộ
// giá trị hoặc đổi nghĩa role phải cập nhật tài liệu + test trong cùng batch.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_tablet_theme_extension.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';

void main() {
  test('Tablet scale stays closed to the approved Base-8-derived values', () {
    expect(
      [
        TabletSpacingTokens.x1,
        TabletSpacingTokens.x2,
        TabletSpacingTokens.x3,
        TabletSpacingTokens.x4,
        TabletSpacingTokens.x5,
        TabletSpacingTokens.x6,
        TabletSpacingTokens.x7,
      ],
      <double>[4, 4, 8, 12, 24, 32, 56],
    );
  });

  test('Tablet gap roles have one semantic value and no block-gap escape', () {
    expect(
      TabletSpacingTokens.sectionGapCompact,
      TabletSpacingTokens.pageContentGapTight,
    );
    expect(
      TabletSpacingTokens.sectionGapRegular,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
    expect(
      TabletSpacingTokens.sectionGapRelaxed,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
    expect(
      TabletSpacingTokens.pageContentGapDefault,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
    expect(
      TabletSpacingTokens.pageContentGapRelaxed,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
    expect(
      TabletSpacingTokens.pageContentGapLoose,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
    expect(TabletSpacingTokens.pageEndBreathing, TabletSpacingTokens.x6);
    expect(
      const AppTabletThemeExtension().gapBlock,
      TabletSpacingTokens.pageRhythmStandardSectionGap,
    );
  });

  test('Tablet frame and padding roles stay on the published contract', () {
    expect(TabletSpacingTokens.contentPad, 20);
    expect(
      TabletSpacingTokens.contentInsets,
      const EdgeInsets.symmetric(horizontal: 20),
    );
    expect(TabletSpacingTokens.cardPadding, const EdgeInsets.all(16));
    expect(
      TabletSpacingTokens.cardPaddingStandardDensity,
      const EdgeInsets.all(16),
    );
    expect(
      TabletSpacingTokens.cardPaddingCompactDensity,
      const EdgeInsets.all(12),
    );
    expect(TabletSpacingTokens.rowGap, 8);
    expect(TabletSpacingTokens.pageRhythmFormInnerGap, 8);
    expect(TabletSpacingTokens.cardGap, 12);
    expect(TabletSpacingTokens.pageContentTopRelaxed, 16);
    expect(TabletSpacingTokens.pageEndBreathing, 32);
  });
}
