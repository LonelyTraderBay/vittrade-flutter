import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_webhooks_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpWebhooks(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnWebhooks,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-393 mock repository exposes webhooks BE draft', () async {
    final snapshot = await const MockStakingWebhooksRepository().getWebhooks();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-webhooks');
    expect(snapshot.actionDraft, contains('POST /earn/webhooks'));
    expect(snapshot.actionDraft, contains('DELETE /earn/webhooks/:id'));
    expect(snapshot.title, 'Webhooks');
    expect(snapshot.backRoute, AppRoutePaths.earn);
    expect(snapshot.heroTitle, 'Real-time Event Notifications');
    expect(snapshot.webhooks, hasLength(3));
    expect(
      snapshot.webhooks.first.url,
      'https://api.myapp.com/staking/rewards',
    );
    expect(snapshot.webhooks.first.events, ['reward_received']);
    expect(snapshot.webhooks.last.active, isFalse);
    expect(snapshot.availableEvents, contains('validator_changed'));
    expect(snapshot.sheetTitle, 'Create Webhook');
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      ]),
    );
  });

  testWidgets('SC-393 renders webhooks structure and content', (tester) async {
    await pumpWebhooks(tester);

    expect(find.byType(StakingWebhooksPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Webhooks'), findsOneWidget);
    expect(find.byKey(StakingWebhooksPage.heroKey), findsOneWidget);
    expect(find.text('Real-time Event Notifications'), findsOneWidget);
    expect(
      find.textContaining('Receive instant HTTP callbacks'),
      findsOneWidget,
    );
    expect(find.byKey(StakingWebhooksPage.createKey), findsOneWidget);
    expect(find.text('Create Webhook'), findsOneWidget);
    expect(find.byKey(StakingWebhooksPage.activeKey), findsOneWidget);
    expect(find.text('Active Webhooks'), findsOneWidget);
    expect(find.byKey(StakingWebhooksPage.webhookKey('w1')), findsOneWidget);
    expect(find.text('https://api.myapp.com/staking/rewards'), findsOneWidget);
    expect(find.text('Last: 2 mins ago'), findsOneWidget);
    expect(find.text('reward_received'), findsWidgets);
    expect(find.byKey(StakingWebhooksPage.webhookKey('w3')), findsOneWidget);
    expect(find.text('Last: Never'), findsOneWidget);
    expect(find.byKey(StakingWebhooksPage.eventsKey), findsOneWidget);
    expect(find.text('Available Events'), findsOneWidget);
    expect(
      find.byKey(StakingWebhooksPage.eventKey('apy_changed')),
      findsOneWidget,
    );
  });

  testWidgets('SC-393 create action opens webhook sheet', (tester) async {
    await pumpWebhooks(tester);

    await tester.tap(find.byKey(StakingWebhooksPage.createKey));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingWebhooksPage.createSheetKey), findsOneWidget);
    expect(find.text('Webhook URL'), findsOneWidget);
    expect(find.byKey(StakingWebhooksPage.urlFieldKey), findsOneWidget);
    expect(
      find.byKey(StakingWebhooksPage.eventKey('sheet_stake_completed')),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingWebhooksPage.eventKey('sheet_validator_changed')),
      findsOneWidget,
    );
    expect(find.text('Create Webhook'), findsWidgets);
  });

  testWidgets('SC-393 delete webhook CTA shows placeholder feedback', (
    tester,
  ) async {
    await pumpWebhooks(tester);

    await tester.tap(find.byKey(StakingWebhooksPage.webhookDeleteKey('w1')));
    await tester.pumpAndSettle();

    expect(find.text('Xóa webhook sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-393 header back returns to Earn', (tester) async {
    await pumpWebhooks(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
  });
}
