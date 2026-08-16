import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/bridge/launchpad_bridge_compare_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/bridge/launchpad_bridge_order_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBridgeCompare(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadBridgeCompare,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-305 mock repository exposes bridge compare BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getBridgeCompare();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-bridge-compare');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable; GET with query filters',
    );
    expect(snapshot.title, 'So sánh routes');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.bridgeOrderRoute, AppRoutePaths.launchpadBridgeOrderTx001);
    expect(snapshot.comparison.sourceChain, 'Ethereum');
    expect(snapshot.comparison.targetChain, 'Polygon');
    expect(snapshot.comparison.inputAmount, 1000);
    expect(snapshot.comparison.routes, hasLength(5));
    expect(snapshot.comparison.bestOutput, 'rc_1');
    expect(snapshot.comparison.bestFee, 'rc_2');
    expect(snapshot.sortOptions.map((option) => option.value), [
      'recommended',
      'output',
      'fee',
      'speed',
      'security',
    ]);
    expect(snapshot.contractNotes, contains('bridge comparison input'));
    expect(snapshot.contractNotes, contains('tx001 bridge-order route'));
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

  testWidgets('SC-305 renders bridge comparison baseline', (tester) async {
    await pumpBridgeCompare(tester);

    expect(find.byType(LaunchpadBridgeComparePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadBridgeComparePage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadBridgeComparePage.heroKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadBridgeComparePage.quickCompareKey),
      findsOneWidget,
    );
    expect(
      find.byKey(LaunchpadBridgeComparePage.sortKey('recommended')),
      findsOneWidget,
    );
    expect(
      find.byKey(LaunchpadBridgeComparePage.routeKey('rc_1')),
      findsOneWidget,
    );
    expect(
      find.byKey(LaunchpadBridgeComparePage.routeKey('rc_5')),
      findsOneWidget,
    );
    expect(find.text('VitBridge Aggregator'), findsOneWidget);
    expect(find.text('Direct Bridge'), findsOneWidget);
    expect(find.byKey(LaunchpadBridgeComparePage.riskKey), findsOneWidget);
  });

  testWidgets('SC-305 first viewport reaches recommended route', (
    tester,
  ) async {
    await pumpBridgeCompare(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-305 LaunchpadBridgeComparePage',
      semanticLabel: 'So sánh route bridge trước khi chuyển',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadBridgeComparePage.routeKey('rc_1')),
      routeName: 'SC-305 LaunchpadBridgeComparePage',
      actionLabel: 'the recommended bridge route',
    );
  });

  testWidgets('SC-305 sort, expand, and selection states work', (tester) async {
    await pumpBridgeCompare(tester);

    await tester.tap(find.byKey(LaunchpadBridgeComparePage.sortKey('output')));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(LaunchpadBridgeComparePage.contentKey),
      const Offset(0, -160),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LaunchpadBridgeComparePage.expandKey('rc_1')));
    await tester.pumpAndSettle();
    expect(find.text('Uniswap V3'), findsOneWidget);
    expect(find.text('QuickSwap'), findsOneWidget);

    await tester.tap(
      find.byKey(LaunchpadBridgeComparePage.routeSelectKey('rc_1')),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadBridgeComparePage.footerKey), findsOneWidget);
  });

  testWidgets('SC-305 confirm uses safe bridge order placeholder route', (
    tester,
  ) async {
    await pumpBridgeCompare(tester);

    await tester.drag(
      find.byKey(LaunchpadBridgeComparePage.contentKey),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(LaunchpadBridgeComparePage.routeSelectKey('rc_2')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byKey(LaunchpadBridgeComparePage.footerKey),
        matching: find.byType(VitCtaButton),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận route'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadBridgeComparePage.confirmKey));
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadBridgeOrderPage), findsOneWidget);
    expect(find.text('MetaVerse Land'), findsOneWidget);
  });

  testWidgets('SC-305 header back returns to launchpad', (tester) async {
    await pumpBridgeCompare(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
    expect(find.text('Launchpad'), findsWidgets);
  });
}
