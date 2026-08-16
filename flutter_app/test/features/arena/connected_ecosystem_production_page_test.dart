import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/bridge/connected_ecosystem_production_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpEcosystem(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaEcosystem,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-208 mock repository exposes connected ecosystem BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getConnectedEcosystemProduction();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-ecosystem');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.canonicalScreens.length, 9);
    expect(snapshot.bridgeStates.length, 8);
    expect(snapshot.connectedFlows.map((flow) => flow.id), [
      'prediction_to_arena',
      'arena_to_prediction',
      'profile_dual',
      'market_discover',
    ]);
    expect(
      snapshot.canonicalScreens.map((screen) => screen.name),
      contains('MarketListPage_vFinal_Connected'),
    );
    expect(snapshot.routeRegistry.length, 9);
    expect(
      snapshot.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-208 renders connected ecosystem canonical baseline', (
    tester,
  ) async {
    await pumpEcosystem(tester);

    expect(find.byType(ConnectedEcosystemProductionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('09E - Connected Ecosystem'), findsOneWidget);
    expect(find.text('Release Readiness'), findsOneWidget);
    expect(find.text('Connected Ecosystem'), findsOneWidget);
    expect(find.text('Canonical'), findsOneWidget);
    expect(find.text('Canonical Connected Screens'), findsOneWidget);
    expect(find.text('HomePage_vFinal_Connected'), findsOneWidget);
    expect(find.text('ProfilePage_vFinal_Connected'), findsOneWidget);
    expect(find.text('MarketListPage_vFinal_Connected'), findsOneWidget);

    await tester.ensureVisible(find.text('Summary'));
    expect(find.text('Total screens'), findsOneWidget);
    expect(find.text('Bridge components'), findsOneWidget);
  });

  testWidgets('SC-208 first viewport reaches first canonical screen card', (
    tester,
  ) async {
    await pumpEcosystem(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ConnectedEcosystemProductionPage',
      semanticLabel:
          'Hệ sinh thái kết nối Arena - trạng thái canonical, luồng E2E và tài liệu bàn giao release',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(
        ConnectedEcosystemProductionPage.screenKey('HomePage_vFinal_Connected'),
      ),
      targetLabel: 'first canonical screen card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-208 switches connected ecosystem tabs', (tester) async {
    await pumpEcosystem(tester);

    await tester.tap(ConnectedEcosystemProductionPage.tabKey('states').finder);
    await tester.pumpAndSettle();
    expect(find.text('Bridge State Matrix'), findsOneWidget);
    expect(find.text('Linked context available'), findsOneWidget);

    await tester.tap(ConnectedEcosystemProductionPage.tabKey('flows').finder);
    await tester.pumpAndSettle();
    expect(find.text('Connected E2E Flows'), findsOneWidget);
    expect(find.text('Prediction to Arena Studio'), findsOneWidget);

    await tester.drag(
      find.byKey(ConnectedEcosystemProductionPage.tabsKey),
      const Offset(-190, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      ConnectedEcosystemProductionPage.tabKey('registry').finder,
    );
    await tester.pumpAndSettle();
    expect(find.text('Shared vs Separate Registry'), findsOneWidget);
    expect(find.text('Forbidden UX Patterns'), findsOneWidget);

    await tester.drag(
      find.byKey(ConnectedEcosystemProductionPage.tabsKey),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(ConnectedEcosystemProductionPage.tabKey('handoff').finder);
    await tester.pumpAndSettle();
    expect(find.text('Dev / QA Handoff Pack'), findsOneWidget);
    expect(find.text('Route Registry'), findsOneWidget);

    await tester.tap(
      ConnectedEcosystemProductionPage.handoffKey('rules').finder,
    );
    await tester.pumpAndSettle();
    expect(find.text('Bridge Rules'), findsWidgets);
    expect(find.text('wallet balance'), findsOneWidget);
  });

  testWidgets('SC-208 canonical screen cards navigate to resolved routes', (
    tester,
  ) async {
    await pumpEcosystem(tester);

    await tester.ensureVisible(
      find.byKey(
        ConnectedEcosystemProductionPage.screenKey(
          'MarketListPage_vFinal_Connected',
        ),
      ),
    );
    await tester.tap(
      find.byKey(
        ConnectedEcosystemProductionPage.screenKey(
          'MarketListPage_vFinal_Connected',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MarketListPage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
