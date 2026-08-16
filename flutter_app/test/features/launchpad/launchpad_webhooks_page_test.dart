import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_webhooks_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpWebhooks(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadWebhooks,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-310 mock repository exposes launchpad webhooks BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getWebhooks();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-webhooks');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Webhooks');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.tabs, ['subscriptions', 'deliveries']);
    expect(snapshot.subscriptions, hasLength(4));
    expect(snapshot.deliveries, hasLength(6));
    expect(
      snapshot.eventTypes.map((event) => event.type),
      contains('Transfer'),
    );
    expect(snapshot.contractNotes, contains('webhook subscription list'));
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

  testWidgets('SC-310 renders webhooks baseline', (tester) async {
    await pumpWebhooks(tester);

    expect(find.byType(LaunchpadWebhooksPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadWebhooksPage.statsKey), findsOneWidget);
    expect(find.byKey(LaunchpadWebhooksPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadWebhooksPage.createKey), findsOneWidget);
    expect(find.byKey(LaunchpadWebhooksPage.subscriptionsKey), findsOneWidget);
    expect(find.text('Webhooks'), findsOneWidget);
    expect(find.text('Tao webhook moi'), findsOneWidget);
    expect(find.text('NexaAI Staking Events'), findsOneWidget);
    expect(find.text('IDO Participation Tracker'), findsOneWidget);
    expect(find.byKey(LaunchpadWebhooksPage.infoKey), findsOneWidget);
  });

  testWidgets('SC-310 first viewport reaches first subscription', (
    tester,
  ) async {
    await pumpWebhooks(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-310 LaunchpadWebhooksPage',
      semanticLabel: 'Quản lý webhook tích hợp cho nhà phát triển',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadWebhooksPage.expandKey('wh1')),
      routeName: 'SC-310 LaunchpadWebhooksPage',
      actionLabel: 'the first webhook subscription',
    );
  });

  testWidgets('SC-310 expands copies toggles and deletes subscription', (
    tester,
  ) async {
    await pumpWebhooks(tester);

    await tester.tap(find.byKey(LaunchpadWebhooksPage.expandKey('wh1')));
    await tester.pumpAndSettle();
    expect(find.text('URL'), findsOneWidget);
    expect(find.text('Contract'), findsOneWidget);
    expect(find.text('exponential (max 3)'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadWebhooksPage.copyKey('wh1', 'URL')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsWidgets);

    await tester.tap(find.byKey(LaunchpadWebhooksPage.toggleKey('wh1')));
    await tester.pumpAndSettle();
    expect(find.text('Paused'), findsWidgets);

    await tester.tap(find.byKey(LaunchpadWebhooksPage.deleteKey('wh1')));
    await tester.pumpAndSettle();
    expect(find.text('NexaAI Staking Events'), findsNothing);
  });

  testWidgets('SC-310 switches delivery history tab and copies tx hash', (
    tester,
  ) async {
    await pumpWebhooks(tester);

    await tester.tap(find.byKey(LaunchpadWebhooksPage.deliveriesTabKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadWebhooksPage.deliveriesKey), findsOneWidget);
    expect(find.text('Delivery History'), findsOneWidget);
    expect(find.text('Staked'), findsOneWidget);
    expect(find.text('Delivered'), findsWidgets);

    await tester.tap(find.byKey(LaunchpadWebhooksPage.deliveryCopyKey('wd1')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsWidgets);
  });

  testWidgets('SC-310 create sheet opens from add card', (tester) async {
    await pumpWebhooks(tester);

    await tester.tap(find.byKey(LaunchpadWebhooksPage.createKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadWebhooksPage.createSheetKey), findsOneWidget);
    expect(find.text('Tao Webhook moi'), findsOneWidget);
    expect(find.text('Webhook URL'), findsOneWidget);
    expect(find.text('Retry Policy'), findsOneWidget);
  });

  testWidgets('SC-310 header back returns to launchpad', (tester) async {
    await pumpWebhooks(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });

  testWidgets('SC-310 STATE-S23 round-trip: delete persists via Notifier', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter(
      initialLocation: AppRoutePaths.launchpadWebhooks,
    );
    await tester.pumpWidget(
      ProviderScope(child: VitTradeApp(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(LaunchpadWebhooksPage.expandKey('wh1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LaunchpadWebhooksPage.deleteKey('wh1')));
    await tester.pumpAndSettle();
    expect(find.text('NexaAI Staking Events'), findsNothing);

    // STATE-S23 round-trip: điều hướng đi rồi quay lại — mutation giữ nguyên
    // (state sống ở Notifier, không phải late List của trang).
    router.go(AppRoutePaths.launchpad);
    await tester.pumpAndSettle();
    expect(find.byType(LaunchpadPage), findsOneWidget);

    router.go(AppRoutePaths.launchpadWebhooks);
    await tester.pumpAndSettle();
    expect(find.byType(LaunchpadWebhooksPage), findsOneWidget);
    expect(find.text('NexaAI Staking Events'), findsNothing);
  });
}
