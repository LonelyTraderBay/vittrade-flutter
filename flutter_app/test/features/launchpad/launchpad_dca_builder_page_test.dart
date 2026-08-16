import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_dca_builder_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDcaBuilder(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadDcaBuilder,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-316 mock repository exposes launchpad DCA builder BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getDcaBuilder();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-dca-builder');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable; POST /dca/plans|rebalance|schedule',
    );
    expect(snapshot.title, 'DCA Builder');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.tabs, ['Chien luoc', 'Lich su', 'Tao moi']);
    expect(snapshot.strategies, hasLength(3));
    expect(snapshot.executions, hasLength(4));
    expect(snapshot.totalInvested, 2500);
    expect(snapshot.currentValue, closeTo(2526.10, .01));
    expect(snapshot.activeStrategyCount, 2);
    expect(snapshot.executedOrderCount, 10);
    expect(snapshot.contractNotes, contains('DCA strategies'));
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

  testWidgets('SC-316 renders DCA strategies baseline', (tester) async {
    await pumpDcaBuilder(tester);

    expect(find.byType(LaunchpadDcaBuilderPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('DCA Builder'), findsOneWidget);
    expect(find.byKey(LaunchpadDcaBuilderPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadDcaBuilderPage.summaryKey), findsOneWidget);
    expect(find.byKey(LaunchpadDcaBuilderPage.strategiesKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadDcaBuilderPage.strategyKey('dca_001')),
      findsOneWidget,
    );
    expect(find.text(r'$2500.00'), findsOneWidget);
    expect(find.text(r'$2526.10'), findsOneWidget);
    expect(find.text('Arbitrum'), findsOneWidget);
    expect(find.text('Optimism'), findsOneWidget);
    expect(find.text('ACTIVE'), findsWidgets);
  });

  testWidgets('SC-316 first viewport reaches first strategy', (tester) async {
    await pumpDcaBuilder(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-316 LaunchpadDcaBuilderPage',
      semanticLabel: 'Xây dựng chiến lược đầu tư định kỳ DCA',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadDcaBuilderPage.strategyKey('dca_001')),
      routeName: 'SC-316 LaunchpadDcaBuilderPage',
      actionLabel: 'the first DCA strategy card',
    );
  });

  testWidgets('SC-316 switches to execution history', (tester) async {
    await pumpDcaBuilder(tester);

    await tester.tap(find.text('Lich su'));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadDcaBuilderPage.historyKey), findsOneWidget);
    expect(find.byKey(LaunchpadDcaBuilderPage.chartKey), findsOneWidget);
    expect(find.text('Price & Tokens Purchased (ARB)'), findsOneWidget);
    expect(find.text(r'$100 -> 40.82 ARB'), findsOneWidget);
    expect(find.text(r'Fee: $0.5'), findsWidgets);
  });

  testWidgets('SC-316 create tab previews and submits DCA strategy', (
    tester,
  ) async {
    await pumpDcaBuilder(tester);

    await tester.tap(find.byKey(LaunchpadDcaBuilderPage.headerCreateKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadDcaBuilderPage.createKey), findsOneWidget);
    expect(find.text('Tan suat mua'), findsOneWidget);

    await tester.tap(
      find.byKey(
        LaunchpadDcaBuilderPage.frequencyKey(LaunchpadDcaFrequency.biweekly),
      ),
    );
    await tester.enterText(
      find.byKey(LaunchpadDcaBuilderPage.amountFieldKey),
      '100',
    );
    await tester.enterText(
      find.byKey(LaunchpadDcaBuilderPage.budgetFieldKey),
      '1000',
    );
    await tester.enterText(
      find.byKey(LaunchpadDcaBuilderPage.startDateFieldKey),
      '2026-05-25',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadDcaBuilderPage.previewKey), findsOneWidget);
    expect(find.byKey(LaunchpadDcaBuilderPage.reviewStateKey), findsOneWidget);
    expect(find.text('Review DCA plan'), findsOneWidget);
    expect(find.text('2 tuan/lan'), findsWidgets);
    expect(find.text('10'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadDcaBuilderPage.ctaKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã tạo chiến lược DCA'), findsOneWidget);
    expect(find.text('2 tuan/lan 100 USD vào ARB.'), findsOneWidget);
  });

  testWidgets('SC-316 create tab is reachable from tab bar', (tester) async {
    await pumpDcaBuilder(tester);

    await tester.tap(find.text('Tao moi'));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadDcaBuilderPage.createKey), findsOneWidget);
    expect(find.text('Chon token'), findsOneWidget);
  });

  testWidgets('SC-316 pause mini icon button shows a placeholder snackbar', (
    tester,
  ) async {
    await pumpDcaBuilder(tester);

    final strategyCard = find.byKey(
      LaunchpadDcaBuilderPage.strategyKey('dca_001'),
    );
    await tester.ensureVisible(strategyCard);

    await tester.tap(
      find.descendant(
        of: strategyCard,
        matching: find.byIcon(Icons.pause_rounded),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Tạm dừng/tiếp tục chiến lược sẽ sớm ra mắt'),
      findsOneWidget,
    );
  });

  testWidgets('SC-316 settings mini icon button shows a placeholder snackbar', (
    tester,
  ) async {
    await pumpDcaBuilder(tester);

    final strategyCard = find.byKey(
      LaunchpadDcaBuilderPage.strategyKey('dca_001'),
    );
    await tester.ensureVisible(strategyCard);

    await tester.tap(
      find.descendant(
        of: strategyCard,
        matching: find.byIcon(Icons.settings_outlined),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cài đặt chiến lược sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-316 header back returns to launchpad', (tester) async {
    await pumpDcaBuilder(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
