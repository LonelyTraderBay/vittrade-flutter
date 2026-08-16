import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_gas_tracker_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpGasTracker(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadGasTracker,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-311 mock repository exposes launchpad gas tracker BE draft',
    () async {
      final snapshot = await const MockLaunchpadRepository(
        loadDelay: Duration.zero,
      ).getGasTracker();

      expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-gas-tracker');
      expect(
        snapshot.actionDraft,
        'POST /launchpad/subscribe|claim|bridge where applicable',
      );
      expect(snapshot.title, 'Gas Tracker');
      expect(snapshot.backRoute, AppRoutePaths.launchpad);
      expect(snapshot.tabs, ['prices', 'estimator', 'alerts']);
      expect(snapshot.prices, hasLength(5));
      expect(snapshot.estimates, hasLength(5));
      expect(snapshot.alerts, hasLength(3));
      expect(snapshot.prices.first.chain, 'Ethereum');
      expect(snapshot.contractNotes, contains('multi-chain gas prices'));
      expect(
        snapshot.supportedStates,
        containsAll([
          LaunchpadScreenState.loading,
          LaunchpadScreenState.empty,
          LaunchpadScreenState.error,
          LaunchpadScreenState.offline,
          LaunchpadScreenState.submitting,
          LaunchpadScreenState.success,
        ]),
      );
    },
  );

  testWidgets('SC-311 renders gas tracker price baseline', (tester) async {
    await pumpGasTracker(tester);

    expect(find.byType(LaunchpadGasTrackerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadGasTrackerPage.heroKey), findsOneWidget);
    expect(find.byKey(LaunchpadGasTrackerPage.tabsKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadGasTrackerPage.chainSelectorKey),
      findsOneWidget,
    );
    expect(find.byKey(LaunchpadGasTrackerPage.chartKey), findsOneWidget);
    expect(find.byKey(LaunchpadGasTrackerPage.eipKey), findsOneWidget);
    expect(find.byKey(LaunchpadGasTrackerPage.allChainsKey), findsOneWidget);
    expect(find.text('Gas Tracker'), findsOneWidget);
    expect(find.text('Gas Ethereum'), findsOneWidget);
    expect(find.text('Gas 24h - Ethereum'), findsOneWidget);
    expect(find.text('BSC'), findsWidgets);
  });

  testWidgets('SC-311 chain selection updates featured gas and EIP card', (
    tester,
  ) async {
    await pumpGasTracker(tester);

    await tester.tap(find.byKey(LaunchpadGasTrackerPage.chainKey('Polygon')));
    await tester.pumpAndSettle();

    expect(find.text('Gas Polygon'), findsOneWidget);
    expect(find.text('Gas 24h - Polygon'), findsOneWidget);
    expect(find.byKey(LaunchpadGasTrackerPage.eipKey), findsNothing);
  });

  testWidgets('SC-311 first viewport reaches gas chart', (tester) async {
    await pumpGasTracker(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-311 LaunchpadGasTrackerPage',
      semanticLabel: 'Theo dõi phí gas trên nhiều chuỗi',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(LaunchpadGasTrackerPage.chartKey),
      targetLabel: 'the gas trend chart',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-311 estimator tab renders operation cost table', (
    tester,
  ) async {
    await pumpGasTracker(tester);

    await tester.tap(find.byKey(LaunchpadGasTrackerPage.estimatorTabKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadGasTrackerPage.estimatesKey), findsOneWidget);
    expect(find.text('Chi phi uoc tinh'), findsOneWidget);
    expect(find.text('ERC20 Transfer'), findsOneWidget);
    expect(find.text('Bridge (cross-chain)'), findsOneWidget);
    expect(find.text(r'$1.40'), findsOneWidget);
  });

  testWidgets('SC-311 alerts tab toggles deletes and opens add sheet', (
    tester,
  ) async {
    await pumpGasTracker(tester);

    await tester.tap(find.byKey(LaunchpadGasTrackerPage.alertsTabKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadGasTrackerPage.alertsKey), findsOneWidget);
    expect(find.byKey(LaunchpadGasTrackerPage.alertKey('ga1')), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadGasTrackerPage.alertToggleKey('ga1')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.notifications_off_outlined), findsWidgets);

    await tester.tap(find.byKey(LaunchpadGasTrackerPage.alertDeleteKey('ga1')));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadGasTrackerPage.alertKey('ga1')), findsNothing);

    await tester.tap(find.byKey(LaunchpadGasTrackerPage.addAlertKey));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadGasTrackerPage.addSheetKey), findsOneWidget);
    expect(find.text('Them canh bao gas'), findsWidgets);
  });

  testWidgets('SC-311 header back returns to launchpad', (tester) async {
    await pumpGasTracker(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
