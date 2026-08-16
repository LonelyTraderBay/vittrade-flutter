import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/arena_home_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_resolution_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpResolution(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaResolution,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-192 mock repository exposes Resolution Center BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaResolutionCenter();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-resolution');
    expect(
      snapshot.actionDraft,
      'POST /p2p/disputes/:id/evidence|resolve; POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.emptyTitle, 'Không tìm thấy');
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

  testWidgets('SC-192 renders Resolution Center empty baseline', (
    tester,
  ) async {
    await pumpResolution(tester);

    expect(find.byType(ArenaResolutionCenterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chốt kết quả'), findsOneWidget);
    expect(find.text('Resolution · Open Arena'), findsOneWidget);
    expect(find.byKey(ArenaResolutionCenterPage.emptyKey), findsOneWidget);
    expect(find.text('Không tìm thấy'), findsOneWidget);
    expect(find.text('Challenge không tồn tại hoặc đã bị xoá'), findsOneWidget);
  });

  testWidgets('SC-192 first viewport exposes empty resolution state', (
    tester,
  ) async {
    await pumpResolution(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-192 ArenaResolutionCenterPage',
      semanticLabel: 'Trung tâm chốt kết quả thử thách trong Open Arena',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaResolutionCenterPage.emptyKey),
      routeName: 'SC-192 ArenaResolutionCenterPage',
      actionLabel: 'the empty resolution state',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-192 back edge returns to Arena home safely', (tester) async {
    await pumpResolution(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaHomePage), findsOneWidget);
  });
}
