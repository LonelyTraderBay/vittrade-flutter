import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/points/arena_points_ledger_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_production_ready_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpReleaseReadiness(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaProduction,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-206 mock repository exposes release readiness BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaProductionReady();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-production');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.canonicalScreens.length, 7);
    expect(
      snapshot.canonicalScreens.map((screen) => screen.name),
      contains('ArenaPointsLedgerPage'),
    );
    expect(
      snapshot.supportingScreens.map((screen) => screen.name),
      contains('ArenaProductionReadyPage'),
    );
    expect(snapshot.flows.map((flow) => flow.id), contains('points_audit'));
    expect(snapshot.components.first.file, 'ArenaChips.tsx');
    expect(snapshot.dictionaries.first.category, 'Resolution Methods');
    expect(snapshot.qaItems, contains('Arena Points disclaimer hiển thị rõ'));
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

  testWidgets('SC-206 renders release readiness handoff baseline', (
    tester,
  ) async {
    await pumpReleaseReadiness(tester);

    expect(find.byType(ArenaProductionReadyPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Release Readiness'), findsOneWidget);
    expect(find.text('Internal handoff - Open Arena'), findsOneWidget);
    expect(find.text('08 - Open Arena Release Readiness'), findsOneWidget);
    expect(find.text('Screens'), findsOneWidget);
    expect(find.text('A - Canonical Screens (vFinal)'), findsOneWidget);
    expect(find.text('ArenaHomePage'), findsOneWidget);
    expect(find.text('/arena'), findsOneWidget);
    expect(find.text('ArenaChallengeDetailPage'), findsOneWidget);
  });

  testWidgets('SC-206 first viewport reaches first canonical screen card', (
    tester,
  ) async {
    await pumpReleaseReadiness(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-206 ArenaProductionReadyPage',
      semanticLabel:
          'Tổng hợp mức độ sẵn sàng phát hành Open Arena - màn hình, trạng thái và tài liệu bàn giao nội bộ',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ArenaProductionReadyPage.screenKey('ArenaHomePage')),
      targetLabel: 'the first Arena canonical screen card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-206 switches readiness tabs with stable mock data', (
    tester,
  ) async {
    await pumpReleaseReadiness(tester);

    await tester.tap(ArenaProductionReadyPage.tabKey('states').finder);
    await tester.pumpAndSettle();
    expect(find.text('B - State Matrix'), findsOneWidget);
    expect(find.text('under_review'), findsWidgets);

    await tester.tap(ArenaProductionReadyPage.tabKey('flows').finder);
    await tester.pumpAndSettle();
    expect(find.text('C - End-to-End Flows'), findsOneWidget);
    expect(find.text('Creator Flow'), findsOneWidget);

    await tester.drag(
      find.byKey(ArenaProductionReadyPage.tabsKey),
      const Offset(-160, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(ArenaProductionReadyPage.tabKey('registry').finder);
    await tester.pumpAndSettle();
    expect(find.text('D - Live vs Release-gated vs QA'), findsOneWidget);
    expect(find.text('QA/Dev (2)'), findsOneWidget);

    await tester.drag(
      find.byKey(ArenaProductionReadyPage.tabsKey),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(ArenaProductionReadyPage.tabKey('handoff').finder);
    await tester.pumpAndSettle();
    expect(find.text('E - Dev Handoff Pack'), findsOneWidget);
    expect(find.text('QA Checklist - Pre-ship'), findsOneWidget);
  });

  testWidgets('SC-206 screen cards navigate through canonical routes', (
    tester,
  ) async {
    await pumpReleaseReadiness(tester);

    await tester.ensureVisible(
      find.byKey(ArenaProductionReadyPage.screenKey('ArenaPointsLedgerPage')),
    );
    await tester.tap(
      find.byKey(ArenaProductionReadyPage.screenKey('ArenaPointsLedgerPage')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ArenaPointsLedgerPage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
