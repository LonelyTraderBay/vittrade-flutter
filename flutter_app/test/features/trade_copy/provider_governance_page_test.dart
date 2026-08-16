import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/provider/provider_governance_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpProviderGovernance(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyProviderGovernance,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-081 mock repository exposes provider governance BE draft', () async {
    final snapshot = await const MockTradeCopyTradingRepository(
      loadDelay: Duration.zero,
    ).getProviderGovernance();

    expect(snapshot.defaultTabId, 'modifications');
    expect(snapshot.stats.followers, 245);
    expect(snapshot.stats.complianceScore, 95);
    expect(snapshot.tabs.map((tab) => tab.id), [
      'modifications',
      'communication',
      'fees',
      'compliance',
    ]);
    expect(snapshot.modifications, hasLength(3));
    expect(snapshot.messages, hasLength(2));
    expect(snapshot.feeContributors, hasLength(5));
    expect(snapshot.complianceItems, hasLength(6));
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-081 renders governance baseline inside the Trade shell', (
    tester,
  ) async {
    await pumpProviderGovernance(tester);

    expect(find.byType(ProviderGovernancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Quản trị provider'), findsOneWidget);
    expect(find.text('Provider Dashboard'), findsOneWidget);
    expect(find.text('Managing 245 followers'), findsOneWidget);
    expect(find.text('Strategy Modification Log'), findsOneWidget);
    expect(find.text('STRATEGY CHANGE'), findsOneWidget);
    expect(find.text('RISK LEVEL'), findsOneWidget);
    expect(find.text('Request Strategy Modification'), findsOneWidget);
  });

  testWidgets('SC-081 first viewport reaches governance tabs', (tester) async {
    await pumpProviderGovernance(tester);

    expectActionableInFirstViewport(
      tester,
      find.byKey(ProviderGovernancePage.tabKey('fees')),
      routeName: 'ProviderGovernancePage',
      actionLabel: 'fees governance tab',
    );
  });

  testWidgets('SC-081 tabs switch to fees content', (tester) async {
    await pumpProviderGovernance(tester);

    await tester.tap(find.byKey(ProviderGovernancePage.tabKey('fees')));
    await tester.pumpAndSettle();

    expect(find.text('Performance Fee Waterfall'), findsOneWidget);
    expect(find.text('Follower #001'), findsOneWidget);
  });

  testWidgets('SC-081 request button opens message panel', (tester) async {
    await pumpProviderGovernance(tester);

    await tester.scrollUntilVisible(
      find.byKey(ProviderGovernancePage.requestActionKey),
      120,
      scrollable: find
          .descendant(
            of: find.byType(ProviderGovernancePage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(find.byKey(ProviderGovernancePage.requestActionKey));
    await tester.pumpAndSettle();

    expect(find.text('Broadcast Message'), findsOneWidget);
    expect(find.text('Send announcement to all followers'), findsOneWidget);
  });
}
