import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/shell/phone/phone_app_shell.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  testWidgets('VitPhoneFrame uses the 440x956 visual QA viewport', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = DeviceMetrics.viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: VitPhoneFrame(child: SizedBox.expand())),
    );

    expect(
      tester.getSize(find.byKey(VitPhoneFrame.frameKey)),
      DeviceMetrics.viewport,
    );
    expect(
      tester.getTopLeft(find.byKey(VitPhoneFrame.dynamicIslandKey)).dy,
      11,
    );
    expect(find.byKey(VitPhoneFrame.homeIndicatorKey), findsOneWidget);
  });

  testWidgets('layout primitives compose without routing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              VitStatusBar(time: '09:41'),
              Expanded(
                child: VitPageLayout(
                  child: Column(
                    children: [
                      VitHeader(title: 'Shell', showBack: true, onBack: _noop),
                      VitPageContent(
                        children: [
                          VitPageSection(
                            label: 'Section',
                            children: [SizedBox(height: 24)],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              VitBottomNav(),
            ],
          ),
        ),
      ),
    );

    expect(find.text('09:41'), findsOneWidget);
    expect(find.text('Shell'), findsOneWidget);
    expect(find.text('Section'), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
  });

  testWidgets('VitBottomNav uses compact native and full visual QA heights', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [
            VitBottomNav(),
            VitBottomNav(renderMode: ShellRenderMode.visualQa),
          ],
        ),
      ),
    );

    final navs = find.byType(VitBottomNav);
    expect(tester.getSize(navs.first).height, DeviceMetrics.nativeBottomChrome);
    expect(tester.getSize(navs.last).height, DeviceMetrics.bottomChrome);
  });

  testWidgets('VitBottomNav renders stable notification badge states', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [
            VitBottomNav(homeNotificationBadgeCount: 7),
            VitBottomNav(homeNotificationBadgeCount: 0),
            VitBottomNav(homeNotificationBadgeCount: 125),
          ],
        ),
      ),
    );

    expect(find.text('7'), findsOneWidget);
    expect(find.text('99+'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('PhoneAppShell native bottom nav hides and restores on scroll', (
    WidgetTester tester,
  ) async {
    await _setPhoneViewport(tester);
    await tester.pumpWidget(_shellWithScrollableContent());

    expect(_nativeBottomNavOffset(tester), Offset.zero);

    await tester.drag(find.byKey(_shellScrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_nativeBottomNavOffset(tester), const Offset(0, 1));

    await tester.drag(find.byKey(_shellScrollKey), const Offset(0, 160));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_nativeBottomNavOffset(tester), Offset.zero);
  });

  testWidgets('PhoneAppShell restores native bottom nav on route change', (
    WidgetTester tester,
  ) async {
    await _setPhoneViewport(tester);
    await tester.pumpWidget(_shellWithScrollableContent(currentPath: '/home'));

    await tester.drag(find.byKey(_shellScrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(_nativeBottomNavOffset(tester), const Offset(0, 1));

    await tester.pumpWidget(
      _shellWithScrollableContent(currentPath: '/markets'),
    );
    await tester.pump();

    expect(_nativeBottomNavOffset(tester), Offset.zero);
  });

  testWidgets('PhoneAppShell visual QA bottom nav does not auto-hide', (
    WidgetTester tester,
  ) async {
    await _setPhoneViewport(tester);
    await tester.pumpWidget(
      _shellWithScrollableContent(renderMode: ShellRenderMode.visualQa),
    );

    final before = tester.getTopLeft(find.byType(VitBottomNav)).dy;

    await tester.drag(find.byKey(_shellScrollKey), const Offset(0, -320));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(tester.getTopLeft(find.byType(VitBottomNav)).dy, before);
    expect(
      tester.getSize(find.byType(VitBottomNav)).height,
      DeviceMetrics.bottomChrome,
    );
  });
}

const _shellScrollKey = Key('vit_app_shell_scroll_test');

void _noop() {}

/// These bottom-nav assertions target the phone shell composition — pin a
/// realistic phone viewport instead of Flutter's default 800x600 logical
/// test surface so nav metrics match what devices actually render.
Future<void> _setPhoneViewport(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(440, 956);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Offset _nativeBottomNavOffset(WidgetTester tester) {
  return tester
      .widget<AnimatedSlide>(find.byKey(PhoneAppShell.bottomNavHostKey))
      .offset;
}

Widget _shellWithScrollableContent({
  ShellRenderMode renderMode = ShellRenderMode.native,
  String currentPath = '/home',
}) {
  return MaterialApp(
    home: PhoneAppShell(
      renderMode: renderMode,
      currentPath: currentPath,
      child: ListView.builder(
        key: _shellScrollKey,
        itemCount: 40,
        itemBuilder: (context, index) {
          return SizedBox(height: 64, child: Text('Row $index'));
        },
      ),
    ),
  );
}
