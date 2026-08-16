import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/bridge/arena_prediction_bridge_foundation_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/hub/my_arena_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/portfolio/predictions_portfolio_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

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
            initialLocation: AppRoutePaths.arenaBridge,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-207 mock repository exposes bridge foundation BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaPredictionBridge();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-bridge');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.principles.length, 6);
    expect(snapshot.allowedItems.length, 6);
    expect(snapshot.notAllowedItems.length, 7);
    expect(snapshot.topics.map((topic) => topic.id), contains('crypto'));
    expect(snapshot.bridgeComponents.map((item) => item.name), [
      'PredictionContextCard',
      'ArenaRelatedRoomCard',
      'DualModuleStatCard',
      'BridgeSourceBar',
    ]);
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

  testWidgets('SC-207 renders bridge foundation principles baseline', (
    tester,
  ) async {
    await pumpBridge(tester);

    expect(find.byType(ArenaPredictionBridgeFoundationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Bridge Foundation'), findsOneWidget);
    expect(find.textContaining('Prediction - Arena'), findsOneWidget);
    expect(
      find.textContaining('Predictions Bridge Foundation'),
      findsOneWidget,
    );
    expect(find.text('Principles'), findsOneWidget);
    expect(find.text('1 - Cross-Module Principles'), findsOneWidget);
    expect(find.text('Connect by content, not by value'), findsOneWidget);
    expect(find.text('Arena Points are not financial assets'), findsOneWidget);

    await tester.ensureVisible(find.text('Allowed vs Not Allowed'));
    expect(find.text('Allowed vs Not Allowed'), findsOneWidget);
    expect(find.text('Allowed'), findsOneWidget);
    expect(find.text('Not Allowed'), findsOneWidget);
  });

  testWidgets('SC-207 first viewport reaches first bridge principle', (
    tester,
  ) async {
    await pumpBridge(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ArenaPredictionBridgeFoundationPage',
      semanticLabel:
          'Nền tảng kết nối Arena và Dự đoán - nguyên tắc, ranh giới và ví dụ an toàn',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Connect by content, not by value'),
      targetLabel: 'first bridge principle',
      minVisibleHeight: 18,
    );
  });

  testWidgets('SC-207 switches bridge foundation tabs', (tester) async {
    await pumpBridge(tester);

    await tester.tap(
      ArenaPredictionBridgeFoundationPage.tabKey('topics').finder,
    );
    await tester.pumpAndSettle();
    expect(find.text('2 - Shared Topic Taxonomy'), findsOneWidget);
    expect(
      find.byKey(ArenaPredictionBridgeFoundationPage.topicKey('crypto')),
      findsOneWidget,
    );

    await tester.tap(
      ArenaPredictionBridgeFoundationPage.tabKey('boundary').finder,
    );
    await tester.pumpAndSettle();
    expect(find.text('3 - Module Boundary Components'), findsOneWidget);
    expect(find.text('Arena Points are not financial assets'), findsOneWidget);
    expect(find.text('Prediction Markets'), findsWidgets);

    await tester.drag(
      find.byKey(ArenaPredictionBridgeFoundationPage.tabsKey),
      const Offset(-150, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      ArenaPredictionBridgeFoundationPage.tabKey('bridge').finder,
    );
    await tester.pumpAndSettle();
    expect(find.text('4 - Bridge Components'), findsOneWidget);
    expect(find.text('PredictionContextCard'), findsOneWidget);
    expect(find.text('DualModuleStatCard'), findsOneWidget);

    await tester.drag(
      find.byKey(ArenaPredictionBridgeFoundationPage.tabsKey),
      const Offset(-220, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      ArenaPredictionBridgeFoundationPage.tabKey('examples').finder,
    );
    await tester.pumpAndSettle();
    expect(find.text('5 - Example Usage Frames'), findsOneWidget);
    expect(find.text('DO NOT USE'), findsOneWidget);
  });

  testWidgets('SC-207 bridge stats navigate to separate module routes', (
    tester,
  ) async {
    await pumpBridge(tester);

    await tester.drag(
      find.byKey(ArenaPredictionBridgeFoundationPage.tabsKey),
      const Offset(-150, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      ArenaPredictionBridgeFoundationPage.tabKey('bridge').finder,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(ArenaPredictionBridgeFoundationPage.predictionProfileKey),
    );
    await tester.tap(
      find.byKey(ArenaPredictionBridgeFoundationPage.predictionProfileKey),
    );
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsPortfolioPage), findsOneWidget);

    await pumpBridge(tester);
    await tester.drag(
      find.byKey(ArenaPredictionBridgeFoundationPage.tabsKey),
      const Offset(-150, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      ArenaPredictionBridgeFoundationPage.tabKey('bridge').finder,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(ArenaPredictionBridgeFoundationPage.arenaProfileKey),
    );
    await tester.tap(
      find.byKey(ArenaPredictionBridgeFoundationPage.arenaProfileKey),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MyArenaPage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
