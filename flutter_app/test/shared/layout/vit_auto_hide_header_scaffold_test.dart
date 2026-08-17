import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/shell/phone/phone_app_shell.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

void main() {
  testWidgets('header is visible at the top', (WidgetTester tester) async {
    await tester.pumpWidget(_scaffoldHarness());

    expect(find.text('Auto Header'), findsOneWidget);
    expect(_headerHeight(tester), greaterThan(0));
  });

  testWidgets('custom header and body keys are exposed', (
    WidgetTester tester,
  ) async {
    const headerKey = Key('custom_auto_hide_header');
    const bodyKey = Key('custom_auto_hide_body');

    await tester.pumpWidget(
      _scaffoldHarness(headerKey: headerKey, bodyKey: bodyKey),
    );

    expect(find.byKey(headerKey), findsOneWidget);
    expect(find.byKey(bodyKey), findsOneWidget);
  });

  testWidgets('header hides on downward scroll', (WidgetTester tester) async {
    await tester.pumpWidget(_scaffoldHarness());

    await tester.drag(find.byKey(_scrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_headerHeight(tester), 0);
  });

  testWidgets('short content keeps scroll offset instead of snapping back', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    // Short viewport + modest list → maxScrollExtent ≈ header height.
    // Collapsing the header used to clamp pixels back to 0.
    tester.view.physicalSize = const Size(360, 640);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_scaffoldHarness(itemCount: 10));

    final scrollable = find.byType(Scrollable);
    await tester.drag(find.byKey(_scrollKey), const Offset(0, -120));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    final offsetAfterDrag = tester
        .state<ScrollableState>(scrollable)
        .position
        .pixels;

    expect(
      offsetAfterDrag,
      greaterThan(8),
      reason: 'Short lists must retain scroll offset after a downward drag.',
    );
    expect(
      _headerHeight(tester),
      greaterThan(0),
      reason:
          'Header must stay expanded when collapsing it would clamp the offset.',
    );
  });

  testWidgets('header returns on upward scroll', (WidgetTester tester) async {
    await tester.pumpWidget(_scaffoldHarness());

    await tester.drag(find.byKey(_scrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));
    expect(_headerHeight(tester), 0);

    await tester.drag(find.byKey(_scrollKey), const Offset(0, 160));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_headerHeight(tester), greaterThan(0));
  });

  testWidgets('header returns when scroll position is near top', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_scaffoldHarness());

    await tester.drag(find.byKey(_scrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));
    expect(_headerHeight(tester), 0);

    await tester.drag(find.byKey(_scrollKey), const Offset(0, 1000));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_headerHeight(tester), greaterThan(0));
  });

  testWidgets('back button and trailing actions remain tappable', (
    WidgetTester tester,
  ) async {
    var backTaps = 0;
    var actionTaps = 0;

    await tester.pumpWidget(
      _scaffoldHarness(
        onBack: () => backTaps += 1,
        onAction: () => actionTaps += 1,
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.tap(find.byKey(_trailingActionKey));

    expect(backTaps, 1);
    expect(actionTaps, 1);
  });

  for (final size in const [Size(360, 800), Size(440, 956)]) {
    testWidgets(
      'content clears the bottom nav at ${size.width}x${size.height}',
      (WidgetTester tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          _scaffoldHarness(
            useShell: true,
            renderMode: ShellRenderMode.visualQa,
            bottomInset: DeviceMetrics.bottomChrome,
          ),
        );

        await tester.scrollUntilVisible(
          find.byKey(_lastItemKey),
          500,
          scrollable: find.byType(Scrollable),
        );
        await Scrollable.ensureVisible(
          tester.element(find.byKey(_lastItemKey)),
          alignment: 1,
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 220));

        final lastItemBottom = tester
            .getBottomLeft(find.byKey(_lastItemKey))
            .dy;
        final bottomNavTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;

        expect(
          lastItemBottom <= bottomNavTop + 0.1,
          isTrue,
          reason: 'Last content row should stop above the bottom nav.',
        );
      },
    );
  }
}

const _scrollKey = Key('vit_auto_hide_scroll_test');
const _trailingActionKey = Key('vit_auto_hide_trailing_action_test');
const _lastItemKey = Key('vit_auto_hide_last_item_test');

double _headerHeight(WidgetTester tester) {
  return tester
      .getSize(find.byKey(VitAutoHideHeaderScaffold.headerHostKey))
      .height;
}

Widget _scaffoldHarness({
  VoidCallback? onBack,
  VoidCallback? onAction,
  bool useShell = false,
  ShellRenderMode renderMode = ShellRenderMode.native,
  double bottomInset = 0,
  Key? headerKey,
  Key? bodyKey,
  int itemCount = 40,
}) {
  final page = VitPageLayout(
    variant: VitPageVariant.flush,
    child: VitAutoHideHeaderScaffold(
      semanticLabel: 'Auto hide header test',
      bottomInset: bottomInset,
      headerKey: headerKey,
      bodyKey: bodyKey,
      header: VitHeader(
        title: 'Auto Header',
        subtitle: 'Scroll aware',
        showBack: true,
        onBack: onBack ?? _noop,
        trailing: IconButton(
          key: _trailingActionKey,
          onPressed: onAction,
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ),
      child: SingleChildScrollView(
        key: _scrollKey,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            for (var index = 0; index < itemCount; index++)
              SizedBox(
                key: index == itemCount - 1 ? _lastItemKey : null,
                height: 64,
                child: Text('Row $index'),
              ),
          ],
        ),
      ),
    ),
  );

  final home = useShell
      ? PhoneAppShell(renderMode: renderMode, showBottomNav: true, child: page)
      : page;

  return MaterialApp(home: home);
}

void _noop() {}
