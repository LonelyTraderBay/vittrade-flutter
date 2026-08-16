import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_smart_rule_builder_page.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_studio_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpArenaStudio(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaStudio,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-185 mock repository exposes Arena Studio BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaStudio();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-studio');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.platformFeePct, 10);
    expect(snapshot.steps.length, 6);
    expect(
      snapshot.templates.map((template) => template.id),
      contains('prediction'),
    );
    expect(
      snapshot.templates.map((template) => template.id),
      contains('proof_challenge'),
    );
    expect(snapshot.secondaryActions, ['Lưu', 'Xuất', 'Nhập']);
    expect(
      snapshot.trustSignals.map((signal) => signal.value),
      contains('no wallet value'),
    );
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

  testWidgets('SC-185 renders Arena Studio template baseline', (tester) async {
    await pumpArenaStudio(tester);

    expect(find.byType(ArenaStudioPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Arena Studio'), findsOneWidget);
    expect(find.text('Tạo challenge · Points only'), findsOneWidget);
    expect(find.text('Phí vận hành platform'), findsOneWidget);
    expect(find.text('Chọn template'), findsOneWidget);
    expect(find.text('Prediction'), findsOneWidget);
    expect(find.text('Closest Guess'), findsOneWidget);
    expect(find.text('Team Battle'), findsOneWidget);
    expect(find.text('Points-only'), findsWidgets);
    expect(find.text('Bước 1 / 6'), findsOneWidget);
  });

  testWidgets('SC-185 requires a template before continuing', (tester) async {
    await pumpArenaStudio(tester);

    await tester.ensureVisible(find.byKey(ArenaStudioPage.continueKey));
    await tester.tap(find.byKey(ArenaStudioPage.continueKey));
    await tester.pumpAndSettle();
    expect(find.text('Chọn template'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(ArenaStudioPage.templateKey('prediction')),
    );
    await tester.tap(find.byKey(ArenaStudioPage.templateKey('prediction')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(ArenaStudioPage.continueKey));
    await tester.tap(find.byKey(ArenaStudioPage.continueKey));
    await tester.pumpAndSettle();

    expect(find.text('Cấu trúc trận đấu'), findsWidgets);
    expect(find.text('Bước 2 / 6'), findsOneWidget);
  });

  testWidgets('SC-186 opens Smart Rule Builder from rules step', (
    tester,
  ) async {
    await pumpArenaStudio(tester);

    await tester.ensureVisible(
      find.byKey(ArenaStudioPage.templateKey('prediction')),
    );
    await tester.tap(find.byKey(ArenaStudioPage.templateKey('prediction')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(ArenaStudioPage.continueKey));
    await tester.tap(find.byKey(ArenaStudioPage.continueKey));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(ArenaStudioPage.continueKey));
    await tester.tap(find.byKey(ArenaStudioPage.continueKey));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(ArenaStudioPage.smartRuleBuilderKey));
    await tester.tap(find.byKey(ArenaStudioPage.smartRuleBuilderKey));
    await tester.pumpAndSettle();

    expect(find.byType(ArenaSmartRuleBuilderPage), findsOneWidget);
    expect(find.text('Luật chơi — Smart Builder'), findsOneWidget);
  });

  testWidgets('SC-185 first viewport reaches template choice', (tester) async {
    await pumpArenaStudio(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-185 ArenaStudioPage',
      semanticLabel: 'Tạo thử thách mới trong Arena Studio',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaStudioPage.templateKey('prediction')),
      routeName: 'SC-185 ArenaStudioPage',
      actionLabel: 'the first Arena Studio template',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-185 studio scroll clamps at the bottom on Android', (
    tester,
  ) async {
    await pumpArenaStudio(tester);

    final scrollView = tester.widget<SingleChildScrollView>(
      find.byKey(ArenaStudioPage.contentKey),
    );

    expect(scrollView.physics, isA<ClampingScrollPhysics>());
  });

  testWidgets('SC-185 secondary draft actions expose local state', (
    tester,
  ) async {
    await pumpArenaStudio(tester);

    await tester.ensureVisible(find.byKey(ArenaStudioPage.saveKey));
    await tester.tap(find.byKey(ArenaStudioPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã lưu bản nháp'), findsOneWidget);

    await tester.ensureVisible(find.byKey(ArenaStudioPage.exportKey));
    await tester.tap(find.byKey(ArenaStudioPage.exportKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã chuẩn bị file xuất'), findsOneWidget);

    await tester.ensureVisible(find.byKey(ArenaStudioPage.importKey));
    await tester.tap(find.byKey(ArenaStudioPage.importKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã sẵn sàng nhập JSON'), findsOneWidget);
  });

  testWidgets('SC-185 Studio child routes open ported screens safely', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaStudioSmartRules,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ArenaSmartRuleBuilderPage), findsOneWidget);
    expect(find.text('Luật chơi — Smart Builder'), findsOneWidget);
  });
}
