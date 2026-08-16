import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dev/data/dev_tools_repository.dart';
import 'package:vit_trade_flutter/features/dev/presentation/phone/pages/route_checker_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpRouteChecker(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.routeChecker,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-325 mock repository exposes route checker BE draft', () async {
    final snapshot = await const MockRouteCheckerRepository().getRouteChecker();

    expect(snapshot.endpoint, '/api/mobile/dev/dev-route-checker');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Staking Route Checker');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.totalRoutes, 43);
    expect(snapshot.phaseTotal(1), 5);
    expect(snapshot.phaseTotal(3), 7);
    expect(snapshot.phaseTotal(8), 4);
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

  testWidgets('SC-325 renders route checker baseline', (tester) async {
    await pumpRouteChecker(tester);

    expect(find.byType(RouteChecker), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Staking Route Checker'), findsWidgets);
    expect(find.text('Testing Progress'), findsOneWidget);
    expect(find.text('0 / 43'), findsOneWidget);
    expect(find.text('All (43)'), findsOneWidget);
    expect(find.text('Phase 1 (5)'), findsOneWidget);
    expect(find.text('Terms of Service'), findsOneWidget);
    expect(find.text('/earn/staking/terms'), findsOneWidget);
  });

  testWidgets('SC-325 filters phases and tracks local route checks', (
    tester,
  ) async {
    await pumpRouteChecker(tester);

    await tester.ensureVisible(find.byKey(RouteChecker.phaseKey(3)));
    await tester.pump();
    await tester.tap(find.byKey(RouteChecker.phaseKey(3)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(find.text('Validator Selection'), findsOneWidget);
    expect(find.text('Advanced Orders'), findsOneWidget);

    final autoCompoundRoute = find.byKey(
      RouteChecker.routeKey('/earn/auto-compound'),
    );
    await tester.ensureVisible(autoCompoundRoute);
    await tester.pump();
    await tester.tap(autoCompoundRoute);
    await tester.pump();
    expect(find.text('1 / 43'), findsOneWidget);

    await tester.ensureVisible(find.byKey(RouteChecker.resetButtonKey));
    await tester.pump();
    await tester.tap(find.byKey(RouteChecker.resetButtonKey));
    await tester.pump();
    expect(find.text('0 / 43'), findsOneWidget);
  });
}
