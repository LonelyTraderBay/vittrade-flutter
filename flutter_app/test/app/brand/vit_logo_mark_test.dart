import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/brand/vit_logo_mark.dart';

void main() {
  group('VitLogoMark', () {
    testWidgets('render đúng cạnh tại nhiều size', (tester) async {
      for (final size in [48.0, 64.0, 256.0]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(child: VitLogoMark(size: size)),
            ),
          ),
        );
        expect(
          tester.getSize(find.byType(VitLogoMark)),
          Size.square(size),
          reason: 'size=$size',
        );
        final painter = tester.widget<CustomPaint>(
          find.descendant(
            of: find.byType(VitLogoMark),
            matching: find.byType(CustomPaint),
          ),
        );
        expect(painter.painter, isNotNull, reason: 'size=$size');
      }
    });

    testWidgets('có semantics label mặc định cho screen reader', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: VitLogoMark(size: 64))),
        ),
      );
      expect(find.bySemanticsLabel('Logo VitTrade'), findsOneWidget);
    });

    testWidgets('semantics label tuỳ chỉnh ghi đè mặc định', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: VitLogoMark(size: 64, semanticLabel: 'Dấu VitTrade'),
            ),
          ),
        ),
      );
      expect(find.bySemanticsLabel('Dấu VitTrade'), findsOneWidget);
      expect(find.bySemanticsLabel('Logo VitTrade'), findsNothing);
    });
  });
}
