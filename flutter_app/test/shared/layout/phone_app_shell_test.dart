import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/shell/phone/phone_app_shell.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Widget phoneShell({
    required bool showBottomNav,
    required ScrollController controller,
  }) {
    return MaterialApp(
      home: PhoneAppShell(
        showBottomNav: showBottomNav,
        child: ListView.builder(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          itemCount: 40,
          itemBuilder: (context, index) =>
              SizedBox(height: 80, child: Text('Nội dung $index')),
        ),
      ),
    );
  }

  testWidgets('Phone bottom nav hiện lại khi được bật sau auto-hide', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      phoneShell(showBottomNav: true, controller: controller),
    );
    await tester.pumpAndSettle();

    final scrollAnimation = controller.animateTo(
      320,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
    await tester.pumpAndSettle();
    await scrollAnimation;
    expect(
      tester
          .widget<AnimatedSlide>(find.byKey(PhoneAppShell.bottomNavHostKey))
          .offset,
      const Offset(0, 1),
    );

    await tester.pumpWidget(
      phoneShell(showBottomNav: false, controller: controller),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(PhoneAppShell.bottomNavHostKey), findsNothing);

    await tester.pumpWidget(
      phoneShell(showBottomNav: true, controller: controller),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AnimatedSlide>(find.byKey(PhoneAppShell.bottomNavHostKey))
          .offset,
      Offset.zero,
    );
  });

  testWidgets('Phone bottom nav badge có semantics tiếng Việt', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: VitBottomNav(homeNotificationBadgeCount: 2)),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Trang chủ, 2 thông báo chưa đọc',
      ),
      findsOneWidget,
    );
  });
}
