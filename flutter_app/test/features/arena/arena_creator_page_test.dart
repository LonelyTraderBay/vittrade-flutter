import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_creator_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/arena_mode_detail_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_studio_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCreator(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaCreator('cr001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-193 mock repository exposes Arena Creator BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaCreator('cr001');

    expect(snapshot.endpoint, '/api/mobile/arena/arena-creator-cr001');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.creator.id, 'cr001');
    expect(snapshot.creator.name, 'CryptoMaster_VN');
    expect(snapshot.creator.trustScore, 95);
    expect(
      snapshot.trustMetrics.map((metric) => metric.label),
      contains('Fair Play'),
    );
    expect(snapshot.modes.single.id, 'mode001');
    expect(snapshot.policyLabel, 'Chính sách creator');
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

  testWidgets('SC-193 renders Arena Creator baseline', (tester) async {
    await pumpCreator(tester);

    expect(find.byType(ArenaCreatorPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hồ sơ creator'), findsOneWidget);
    expect(find.text('Nhà sáng tạo · Open Arena'), findsOneWidget);
    expect(find.text('CryptoMaster_VN'), findsOneWidget);
    expect(find.text('Fair Play'), findsWidgets);
    expect(find.text('Gold'), findsOneWidget);
    expect(find.text('Lv.5'), findsOneWidget);
    expect(find.text('95%'), findsWidgets);
    expect(find.text('Chi tiết tin cậy'), findsOneWidget);
    expect(find.text('BTC Weekly Predict'), findsOneWidget);
    expect(find.text('234 clone · 92% hoàn thành'), findsOneWidget);
    expect(find.text('Xem mode'), findsOneWidget);
    expect(find.text('Dùng mode'), findsOneWidget);
    expect(find.text('Chính sách creator'), findsOneWidget);
  });

  testWidgets('SC-193 first viewport exposes trust and mode actions', (
    tester,
  ) async {
    await pumpCreator(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-193 ArenaCreatorPage',
      semanticLabel: 'Hồ sơ nhà sáng tạo (creator) trong Open Arena',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaCreatorPage.trustDetailKey),
      routeName: 'SC-193 ArenaCreatorPage',
      actionLabel: 'the trust detail action',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaCreatorPage.modeKey('mode001')),
      routeName: 'SC-193 ArenaCreatorPage',
      actionLabel: 'the first creator mode',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-193 tab state switches to about content', (tester) async {
    await pumpCreator(tester);

    await tester.tap(find.text('Giới thiệu'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Creator chuyên xây mode'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('12.4K'), findsOneWidget);
  });

  testWidgets('SC-193 navigation edges use canonical Arena routes', (
    tester,
  ) async {
    await pumpCreator(tester);

    await tester.tap(find.text('Xem chi tiết'));
    await tester.pumpAndSettle();
    expect(find.text('Trust Score'), findsOneWidget);

    await pumpCreator(tester);
    await tester.tap(find.byKey(ArenaCreatorPage.modeKey('mode001')));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaModeDetailPage), findsOneWidget);

    await pumpCreator(tester);
    await tester.tap(find.byKey(ArenaCreatorPage.useModeKey));
    await tester.pumpAndSettle();
    expect(find.byType(ArenaStudioPage), findsOneWidget);

    await pumpCreator(tester);
    await tester.ensureVisible(find.byKey(ArenaCreatorPage.policyKey));
    await tester.tap(find.byKey(ArenaCreatorPage.policyKey));
    await tester.pumpAndSettle();
    expect(find.text('An toàn & Quy tắc Arena'), findsOneWidget);
  });
}
