import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

void main() {
  tearDown(() {
    TabletSpacingTokens.tabletSurfaceActive = false;
  });

  testWidgets(
    'semanticIdentifier maps to Semantics.identifier, not the announced '
    'label (A11Y-1)',
    (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: VitPageLayout(
            semanticLabel: 'Đăng nhập',
            semanticIdentifier: 'SC-007',
            child: Text('body'),
          ),
        ),
      );

      final finder = find.bySemanticsLabel(RegExp('Đăng nhập'));
      expect(finder, findsOneWidget);
      final semantics = tester.getSemantics(finder);
      expect(semantics.identifier, 'SC-007');
      // The identifier is not announced — a screen reader speaks the label.
      expect(semantics.label, isNot(contains('SC-007')));

      handle.dispose();
    },
  );

  testWidgets('semanticIdentifier is optional', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      const MaterialApp(
        home: VitPageLayout(semanticLabel: 'Đăng nhập', child: Text('body')),
      ),
    );

    final finder = find.bySemanticsLabel(RegExp('Đăng nhập'));
    expect(finder, findsOneWidget);
    final semantics = tester.getSemantics(finder);
    expect(semantics.identifier, '');

    handle.dispose();
  });

  testWidgets('default tablet page uses the dedicated 32dp page-end role', (
    tester,
  ) async {
    TabletSpacingTokens.tabletSurfaceActive = true;

    await tester.pumpWidget(
      const MaterialApp(home: VitPageLayout(child: Text('body'))),
    );

    final padding = tester.widget<Padding>(find.byType(Padding));
    expect(
      padding.padding.resolve(TextDirection.ltr).bottom,
      TabletSpacingTokens.pageEndBreathing,
    );
  });
}
