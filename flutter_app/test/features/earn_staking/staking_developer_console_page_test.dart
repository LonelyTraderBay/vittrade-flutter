import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_developer_console_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpConsole(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnDeveloperConsole,
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

  test('SC-396 mock repository exposes developer console BE draft', () async {
    final snapshot = await const MockStakingDeveloperConsoleRepository()
        .getConsole();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-developer-console');
    expect(
      snapshot.actionDraft,
      contains('POST /earn/developer-console/api-keys'),
    );
    expect(snapshot.title, 'Developer Console');
    expect(snapshot.backRoute, AppRoutePaths.earn);
    expect(snapshot.heroTitle, 'API Management');
    expect(snapshot.defaultTab, 'keys');
    expect(snapshot.tabs.map((tab) => tab.id), ['keys', 'logs', 'docs']);
    expect(snapshot.stats, hasLength(3));
    expect(snapshot.stats[1].value, '99.9%');
    expect(snapshot.apiKeys, hasLength(2));
    expect(snapshot.apiKeys.first.keyPreview, 'sk_live_4f8b...2a3c');
    expect(snapshot.recentRequests, hasLength(3));
    expect(snapshot.docs.last.title, 'Webhooks Guide');
    expect(snapshot.contractNotes, contains('dev flag'));
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

  testWidgets('SC-396 renders API keys tab by default', (tester) async {
    await pumpConsole(tester);

    expect(find.byType(StakingDeveloperConsolePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Developer Console'), findsOneWidget);
    expect(find.byKey(StakingDeveloperConsolePage.heroKey), findsOneWidget);
    expect(find.text('API Management'), findsOneWidget);
    expect(find.byKey(StakingDeveloperConsolePage.statsKey), findsOneWidget);
    expect(find.text('13.4K'), findsOneWidget);
    expect(find.text('99.9%'), findsOneWidget);
    expect(find.text('12ms'), findsOneWidget);
    expect(find.byKey(StakingDeveloperConsolePage.tabsKey), findsOneWidget);
    expect(find.byKey(StakingDeveloperConsolePage.keysKey), findsOneWidget);
    expect(find.text('Production API'), findsOneWidget);
    expect(find.text('sk_live_4f8b...2a3c'), findsOneWidget);
    expect(find.text('12,543'), findsOneWidget);
    expect(find.byKey(StakingDeveloperConsolePage.createKey), findsOneWidget);
  });

  testWidgets('SC-396 switches to logs and docs tabs', (tester) async {
    await pumpConsole(tester);

    await tester.tap(find.text('Logs'));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingDeveloperConsolePage.logsKey), findsOneWidget);
    expect(find.text('Recent API Requests'), findsOneWidget);
    expect(
      find.byKey(StakingDeveloperConsolePage.requestKey(0)),
      findsOneWidget,
    );
    expect(find.text('POST /staking/stake'), findsOneWidget);
    expect(find.text('45ms'), findsOneWidget);

    await tester.tap(find.text('Docs'));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingDeveloperConsolePage.docsKey), findsOneWidget);
    expect(find.text('Quick Links'), findsOneWidget);
    expect(
      find.byKey(StakingDeveloperConsolePage.docKey('API Reference')),
      findsOneWidget,
    );
    expect(find.text('Webhooks Guide'), findsOneWidget);
  });

  testWidgets('SC-396 header back returns to Earn', (tester) async {
    await pumpConsole(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
  });

  testWidgets('SC-396 create API key CTA shows coming-soon snack bar', (
    tester,
  ) async {
    await pumpConsole(tester);

    await tester.ensureVisible(
      find.byKey(StakingDeveloperConsolePage.createKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingDeveloperConsolePage.createKey));
    await tester.pumpAndSettle();

    expect(find.text('Tạo API Key sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-396 doc card tap shows coming-soon snack bar', (
    tester,
  ) async {
    await pumpConsole(tester);

    await tester.tap(find.text('Docs'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingDeveloperConsolePage.docKey('API Reference')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Xem tài liệu sẽ sớm ra mắt'), findsOneWidget);
  });
}
