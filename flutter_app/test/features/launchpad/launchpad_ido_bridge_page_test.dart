import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/bridge/launchpad_ido_bridge_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpBridge(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadIdoBridgeSample,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-299 mock repository exposes IDO bridge BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getIdoBridge('sample');

    expect(
      snapshot.endpoint,
      '/api/mobile/launchpad/launchpad-idobridge-sample',
    );
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'IDO Bridge');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.projectId, 'sample');
    expect(snapshot.project, isNull);
    expect(snapshot.sourceNetworks, hasLength(3));
    expect(snapshot.routes, hasLength(3));
    expect(snapshot.bridgeCompareRoute, AppRoutePaths.launchpadBridgeCompare);
    expect(snapshot.bridgeOrderRoute, AppRoutePaths.launchpadBridgeOrderTx001);
    expect(snapshot.contractNotes, contains('bridgeNetworks'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-299 renders Flutter not-found state for sample id', (
    tester,
  ) async {
    await pumpBridge(tester);

    expect(find.byType(LaunchpadIdoBridgePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('IDO Bridge'), findsOneWidget);
    expect(find.byKey(LaunchpadIdoBridgePage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadIdoBridgePage.notFoundKey), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(find.text('Dự án không tồn tại'), findsOneWidget);
  });

  testWidgets('SC-299 header back returns to launchpad', (tester) async {
    await pumpBridge(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
    expect(find.text('Launchpad'), findsWidgets);
  });
}
