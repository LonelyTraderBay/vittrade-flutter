import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/reset_password_page.dart';
import 'package:vit_trade_flutter/features/dev/data/dev_tools_repository.dart';
import 'package:vit_trade_flutter/features/dev/presentation/pages/missing_screens_showcase_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpShowcase(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.devShowcase,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-398 mock repository exposes dev showcase BE draft', () async {
    final snapshot = await const MockMissingScreensShowcaseRepository()
        .getShowcase();

    expect(snapshot.endpoint, '/api/mobile/dev/dev-showcase');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, '03 – Missing Screens & Flow Fix');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.tabs.map((tab) => tab.id), ['new', 'v2']);
    expect(snapshot.newScreens, hasLength(3));
    expect(snapshot.newScreens.first.route, '/auth/reset-password');
    expect(snapshot.v2Pages, hasLength(4));
    expect(snapshot.flowConnections, hasLength(7));
    expect(snapshot.contractNotes, contains('internal role or dev flag'));
    expect(
      snapshot.supportedStates,
      containsAll([
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-398 renders new screens showcase baseline', (tester) async {
    await pumpShowcase(tester);

    expect(find.byType(MissingScreensShowcasePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('03 – Missing Screens & Flow Fix'), findsOneWidget);
    expect(find.byKey(MissingScreensShowcasePage.tabsKey), findsOneWidget);
    expect(
      find.byKey(MissingScreensShowcasePage.newSectionKey),
      findsOneWidget,
    );
    expect(find.text('New Screens (3)'), findsOneWidget);
    expect(find.text('Auth – Reset Password'), findsOneWidget);
    expect(find.text('/auth/reset-password'), findsOneWidget);
    expect(find.text('P2P – My Orders'), findsOneWidget);
    expect(find.text('Wallet – Transaction Detail'), findsOneWidget);
    expect(find.text('Preview'), findsNWidgets(3));
  });

  testWidgets('SC-398 switches to v2 flow links', (tester) async {
    await pumpShowcase(tester);

    await tester.tap(find.text('v2 + Prototype Links'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));

    expect(find.byKey(MissingScreensShowcasePage.v2SectionKey), findsOneWidget);
    expect(find.text('OTPPage (consolidated)'), findsOneWidget);
    expect(find.text('P2PHomePage (consolidated)'), findsOneWidget);
    expect(
      find.text('Prototype Connections (On Tap → Navigate)'),
      findsOneWidget,
    );
    expect(
      find.byKey(MissingScreensShowcasePage.flowKey('otp_reset')),
      findsOneWidget,
    );
  });

  testWidgets('SC-398 preview card opens reset password route', (tester) async {
    await pumpShowcase(tester);

    await tester.tap(
      find.byKey(MissingScreensShowcasePage.screenKey('reset_password')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ResetPasswordPage), findsOneWidget);
  });
}
