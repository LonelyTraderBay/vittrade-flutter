import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/admin/presentation/phone/pages/admin_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';

void main() {
  Future<void> pumpAdminSettings(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.adminSettings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-410 renders admin settings baseline', (tester) async {
    await pumpAdminSettings(tester);

    expect(find.byType(AdminSettingsPage), findsOneWidget);
    expect(find.text('Admin Settings'), findsOneWidget);
    expect(find.text('Operations controls'), findsOneWidget);
    expect(find.text('Dashboard routing'), findsOneWidget);
    expect(find.text('Operational health'), findsOneWidget);
    expect(find.text('System health'), findsNWidgets(2));
    expect(find.text('Analytics Dashboard'), findsOneWidget);
    expect(find.text('A/B Test Dashboard'), findsOneWidget);
    expect(find.text('Funnel Dashboard'), findsOneWidget);
    expect(find.text('Event stream'), findsOneWidget);
    expect(find.byKey(AdminSettingsPage.routingKey), findsOneWidget);
    expect(find.byKey(AdminSettingsPage.contentKey), findsOneWidget);
  });

  testWidgets('SC-410 back navigates to admin dashboard', (tester) async {
    await pumpAdminSettings(tester);

    await tester.tap(find.byType(VitHeaderActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AdminSettingsPage), findsNothing);
    expect(find.byType(AdminHomePage), findsOneWidget);
  });

  testWidgets('SC-410 dashboard routing row opens analytics dashboard', (
    tester,
  ) async {
    await pumpAdminSettings(tester);

    await tester.ensureVisible(find.text('Analytics Dashboard'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Analytics Dashboard'));
    await tester.pumpAndSettle();

    expect(find.byType(AdminSettingsPage), findsNothing);
    expect(find.text('Analytics Dashboard'), findsOneWidget);
  });
}
