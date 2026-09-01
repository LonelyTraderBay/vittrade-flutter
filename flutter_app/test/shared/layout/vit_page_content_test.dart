import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';

void main() {
  tearDown(() => TabletSpacingTokens.tabletSurfaceActive = false);

  testWidgets('VitPageSection resolves standard inner gap per surface', (
    tester,
  ) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    await tester.pumpWidget(_sectionWithRhythm(VitPageRhythm.standard));

    expect(_labelToBodyGap(tester), TabletSpacingTokens.x4);

    TabletSpacingTokens.tabletSurfaceActive = false;
    await tester.pumpWidget(_sectionWithRhythm(VitPageRhythm.standard));

    expect(_labelToBodyGap(tester), AppSpacing.pageRhythmStandardInnerGap);
  });

  testWidgets('VitPageSection resolves compact inner gap on Tablet', (
    tester,
  ) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    await tester.pumpWidget(_sectionWithRhythm(VitPageRhythm.compact));

    expect(
      _labelToBodyGap(tester),
      TabletSpacingTokens.pageRhythmCompactInnerGap,
    );
  });
}

Widget _sectionWithRhythm(VitPageRhythm rhythm) {
  return MaterialApp(
    home: Scaffold(
      body: VitPageSection(
        label: 'Tiêu đề',
        rhythm: rhythm,
        children: const [SizedBox(key: _bodyKey, height: 20)],
      ),
    ),
  );
}

const _bodyKey = Key('vit_page_section_test_body');

double _labelToBodyGap(WidgetTester tester) {
  return tester
      .widget<VitSectionHeader>(find.byType(VitSectionHeader))
      .bottomGap!;
}
