import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  // Pop-over cap (Bottom-Sheet-Standard): bề rộng sheet theo surface đã
  // resolve ở bootstrap — tablet kẹp 480dp căn giữa, phone full-width.

  Future<void> pumpOpener(
    WidgetTester tester, {
    required Size viewport,
    BoxConstraints? constraints,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  unawaited(
                    showVitBottomSheet<void>(
                      context: context,
                      constraints: constraints,
                      builder: (sheetContext) => const VitSheetPanel(
                        title: 'Sheet chuẩn',
                        child: SizedBox(key: Key('sheet_body'), height: 48),
                      ),
                    ),
                  );
                },
                child: const Text('Open sheet'),
              );
            },
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
  }

  testWidgets('tablet surface: sheet bị cap 480dp và căn giữa', (tester) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    addTearDown(() => TabletSpacingTokens.tabletSurfaceActive = false);
    await pumpOpener(tester, viewport: const Size(1280, 800));

    final body = tester.getSize(find.byKey(const Key('sheet_body')));
    // 480 cap − 2 × contentPad 20 = 440.
    expect(body.width, 480 - TabletSpacingTokens.contentPad * 2);
    final topLeft = tester.getTopLeft(find.byKey(const Key('sheet_body')));
    // Căn giữa: (1280 − 480) / 2 + contentPad 20.
    expect(
      topLeft.dx,
      (1280 - TabletSpacingTokens.sheetMaxWidth) / 2 +
          TabletSpacingTokens.contentPad,
    );
  });

  testWidgets('phone surface: sheet full-width theo viewport', (tester) async {
    TabletSpacingTokens.tabletSurfaceActive = false;
    await pumpOpener(tester, viewport: const Size(400, 800));

    final body = tester.getSize(find.byKey(const Key('sheet_body')));
    // 400 − 2 × 10 (padding sheet phone SharedSpacingTokens).
    expect(body.width, 380);
  });

  testWidgets('caller truyền constraints thì được tôn trọng (no cap)', (
    tester,
  ) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    addTearDown(() => TabletSpacingTokens.tabletSurfaceActive = false);
    await pumpOpener(
      tester,
      viewport: const Size(1280, 800),
      constraints: const BoxConstraints(maxWidth: 300),
    );

    final body = tester.getSize(find.byKey(const Key('sheet_body')));
    expect(body.width, 300 - TabletSpacingTokens.contentPad * 2);
  });

  testWidgets('VitSheetPanel: footer ghim dưới có Divider hairline', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitSheetPanel(
            title: 'Xác nhận',
            footer: Text('Hủy', key: Key('sheet_footer')),
            child: Text('Nội dung chính', key: Key('sheet_content')),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('sheet_content')), findsOneWidget);
    expect(find.byKey(const Key('sheet_footer')), findsOneWidget);
    // Footer nằm dưới Divider, dưới content.
    final contentBottom = tester
        .getBottomLeft(find.byKey(const Key('sheet_content')))
        .dy;
    final dividerBottom = tester.getBottomLeft(find.byType(Divider)).dy;
    final footerTop = tester
        .getTopLeft(find.byKey(const Key('sheet_footer')))
        .dy;
    expect(dividerBottom, greaterThan(contentBottom));
    expect(footerTop, greaterThan(dividerBottom));
  });

  testWidgets('VitSheetTwoColGrid: ô tính từ bề rộng thật, không viewport', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 440, // 480 cap − 2 × contentPad 20.
              child: VitSheetTwoColGrid(
                spacing: 12,
                children: [
                  SizedBox(key: Key('tile_a'), height: 40),
                  SizedBox(key: Key('tile_b'), height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('tile_a'))).width, 214);
    expect(tester.getSize(find.byKey(const Key('tile_b'))).width, 214);
  });

  testWidgets('showVitBottomSheet opens and returns a typed value', (
    tester,
  ) async {
    Future<String?>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  result = showVitBottomSheet<String>(
                    context: context,
                    builder: (sheetContext) {
                      return SafeArea(
                        top: false,
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(sheetContext).pop('selected'),
                          child: const Text('Choose value'),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open sheet'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Choose value'), findsOneWidget);

    await tester.tap(find.text('Choose value'));
    await tester.pumpAndSettle();

    expect(await result, 'selected');
    expect(find.text('Choose value'), findsNothing);
  });
}
