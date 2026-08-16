import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_rebalance_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRebalance(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadRebalance,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-312 mock repository exposes launchpad rebalance BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getRebalance();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-rebalance');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Rebalance');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.defaultStrategyId, 'moderate');
    expect(snapshot.assets, hasLength(7));
    expect(snapshot.strategies, hasLength(3));
    expect(snapshot.assets.first.symbol, 'USDT');
    expect(
      snapshot.strategies.map((strategy) => strategy.id),
      containsAll(['conservative', 'moderate', 'aggressive']),
    );
    expect(snapshot.contractNotes, contains('portfolio assets'));
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

  testWidgets('SC-312 renders rebalance baseline', (tester) async {
    await pumpRebalance(tester);

    expect(find.byType(LaunchpadRebalancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadRebalancePage.heroKey), findsOneWidget);
    expect(find.byKey(LaunchpadRebalancePage.strategyKey), findsOneWidget);
    expect(find.byKey(LaunchpadRebalancePage.allocationKey), findsOneWidget);
    expect(find.byKey(LaunchpadRebalancePage.deviationKey), findsOneWidget);
    expect(find.byKey(LaunchpadRebalancePage.previewKey), findsOneWidget);
    expect(find.text('Rebalance'), findsOneWidget);
    expect(find.text('Giá trị danh mục'), findsOneWidget);
    expect(find.text('An toan'), findsOneWidget);
    expect(find.text('Can bang'), findsWidgets);
    expect(find.text('Tang truong'), findsOneWidget);
    expect(find.text('Hien tai vs Muc tieu'), findsOneWidget);
    expect(find.text('Do lech phan bo'), findsOneWidget);
  });

  testWidgets('SC-312 first viewport reaches strategy controls', (
    tester,
  ) async {
    await pumpRebalance(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-312 LaunchpadRebalancePage',
      semanticLabel: 'Cân bằng lại danh mục đầu tư',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadRebalancePage.strategyButtonKey('moderate')),
      routeName: 'SC-312 LaunchpadRebalancePage',
      actionLabel: 'the default rebalance strategy control',
    );
  });

  testWidgets('SC-312 strategy selection updates summary risk', (tester) async {
    await pumpRebalance(tester);

    await tester.tap(
      find.byKey(LaunchpadRebalancePage.strategyButtonKey('aggressive')),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(LaunchpadRebalancePage.summaryKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadRebalancePage.summaryKey), findsOneWidget);
    expect(find.text('Tom tat rebalance'), findsOneWidget);
    expect(find.text('Tang truong'), findsWidgets);
    expect(find.text('aggressive'), findsOneWidget);
  });

  testWidgets('SC-312 renders suggestions summary and warning', (tester) async {
    await pumpRebalance(tester);

    await tester.ensureVisible(
      find.byKey(LaunchpadRebalancePage.suggestionsKey),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadRebalancePage.suggestionsKey), findsOneWidget);
    expect(find.byKey(LaunchpadRebalancePage.summaryKey), findsOneWidget);
    expect(find.byKey(LaunchpadRebalancePage.warningKey), findsOneWidget);
    expect(find.text('De xuat rebalance'), findsOneWidget);
    expect(
      find.byKey(LaunchpadRebalancePage.suggestionKey('pa1')),
      findsOneWidget,
    );
    expect(find.text('USDT'), findsWidgets);
    expect(find.text('Tom tat rebalance'), findsOneWidget);
  });

  testWidgets('SC-312 opens and closes rebalance confirmation sheet', (
    tester,
  ) async {
    await pumpRebalance(tester);

    await tester.tap(find.byKey(LaunchpadRebalancePage.previewKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadRebalancePage.confirmSheetKey), findsOneWidget);
    expect(find.text('Xác nhận Rebalance'), findsOneWidget);
    expect(find.byKey(LaunchpadRebalancePage.confirmKey), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadRebalancePage.cancelKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadRebalancePage.confirmSheetKey), findsNothing);
  });

  testWidgets('SC-312 header back returns to launchpad', (tester) async {
    await pumpRebalance(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
