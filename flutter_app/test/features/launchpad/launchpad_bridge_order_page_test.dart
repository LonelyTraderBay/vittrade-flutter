import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/bridge/launchpad_bridge_order_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/bridge/launchpad_ido_bridge_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpBridgeOrder(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadBridgeOrderTx001,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-303 mock repository exposes bridge order BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getBridgeOrder('tx001');

    expect(
      snapshot.endpoint,
      '/api/mobile/launchpad/launchpad-bridge-order-tx001',
    );
    expect(
      snapshot.actionDraft,
      'POST /orders/:id/action where applicable; POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Chi tiet Bridge');
    expect(snapshot.backRoute, AppRoutePaths.launchpadIdoBridgeSample);
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=launchpad'));
    expect(snapshot.supportRoute, contains('tx001'));
    expect(snapshot.txId, 'tx001');
    expect(snapshot.order.id, 'btx1');
    expect(snapshot.order.projectName, 'MetaVerse Land');
    expect(snapshot.order.expectedOutput, 62500);
    expect(snapshot.order.status, LaunchpadBridgeOrderStatus.approved);
    expect(snapshot.order.steps, hasLength(7));
    expect(snapshot.events, hasLength(2));
    expect(snapshot.contractNotes, contains('bridgeOrders'));
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
  });

  testWidgets('SC-303 renders bridge order tracking baseline', (tester) async {
    await pumpBridgeOrder(tester);

    expect(find.byType(LaunchpadBridgeOrderPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiet Bridge'), findsOneWidget);
    expect(find.byKey(LaunchpadBridgeOrderPage.heroKey), findsOneWidget);
    expect(find.text('Đang xử lý bridge...'), findsOneWidget);
    expect(find.text('Ethereum -> Polygon'), findsWidgets);
    expect(find.text('62,500'), findsOneWidget);
    expect(find.byKey(LaunchpadBridgeOrderPage.timelineKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadBridgeOrderPage.stepKey('approved')),
      findsOneWidget,
    );
    expect(find.byKey(LaunchpadBridgeOrderPage.eventLogKey), findsOneWidget);
    expect(find.byKey(LaunchpadBridgeOrderPage.detailsKey), findsOneWidget);
    expect(find.text('MetaVerse Land'), findsOneWidget);
  });

  testWidgets('SC-303 support opens contextual launchpad support', (
    tester,
  ) async {
    await pumpBridgeOrder(tester);

    await tester.scrollUntilVisible(
      find.byKey(LaunchpadBridgeOrderPage.supportKey),
      220,
    );
    await tester.tap(find.byKey(LaunchpadBridgeOrderPage.supportKey));
    await tester.pumpAndSettle();

    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('Launchpad bridge order support'), findsOneWidget);
    expect(find.text('tx001'), findsOneWidget);
  });

  testWidgets('SC-303 event log expands basic websocket state', (tester) async {
    await pumpBridgeOrder(tester);

    await tester.scrollUntilVisible(
      find.byKey(LaunchpadBridgeOrderPage.eventLogKey),
      220,
    );
    await tester.tap(find.text('Nhật ký sự kiện'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(LaunchpadBridgeOrderPage.eventKey('ws1')),
      findsOneWidget,
    );
    expect(
      find.byKey(LaunchpadBridgeOrderPage.eventKey('ws2')),
      findsOneWidget,
    );
    expect(find.text('wss://bridge-relay.vitrading.io'), findsOneWidget);
  });

  testWidgets('SC-303 header back returns to IDO bridge route', (tester) async {
    await pumpBridgeOrder(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadIdoBridgePage), findsOneWidget);
    expect(find.text('IDO Bridge'), findsOneWidget);
  });
}
