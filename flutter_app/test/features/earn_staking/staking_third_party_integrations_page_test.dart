import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_api_documentation_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_third_party_integrations_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpIntegrations(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnThirdPartyIntegrations,
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

  test('SC-395 mock repository exposes integrations BE draft', () async {
    final snapshot = await const MockStakingThirdPartyIntegrationsRepository()
        .getIntegrations();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-third-party-integrations');
    expect(
      snapshot.actionDraft,
      contains('POST /earn/integrations/:id/connect'),
    );
    expect(snapshot.title, 'Integrations');
    expect(snapshot.backRoute, AppRoutePaths.earn);
    expect(snapshot.heroTitle, 'Connect Your Tools');
    expect(snapshot.integrations, hasLength(6));
    expect(snapshot.integrations.first.name, 'TurboTax');
    expect(snapshot.integrations.first.connected, isTrue);
    expect(snapshot.integrations[2].name, 'Ledger Live');
    expect(snapshot.integrations[2].connected, isFalse);
    expect(snapshot.apiTitle, 'API Access');
    expect(snapshot.apiDocsRoute, AppRoutePaths.earnApiDocumentation);
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

  testWidgets('SC-395 renders integrations list and API access card', (
    tester,
  ) async {
    await pumpIntegrations(tester);

    expect(find.byType(StakingThirdPartyIntegrationsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Integrations'), findsOneWidget);
    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.heroKey),
      findsOneWidget,
    );
    expect(find.text('Connect Your Tools'), findsOneWidget);
    expect(find.textContaining('Sync your staking data'), findsOneWidget);
    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.integrationsKey),
      findsOneWidget,
    );
    expect(find.text('Available Integrations'), findsOneWidget);
    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.integrationKey('turbotax')),
      findsOneWidget,
    );
    expect(find.text('TurboTax'), findsOneWidget);
    expect(find.text('CoinTracker'), findsOneWidget);
    expect(find.text('Ledger Live'), findsOneWidget);
    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.connectedKey('turbotax')),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.connectKey('ledger')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(StakingThirdPartyIntegrationsPage.apiKey),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.apiKey),
      findsOneWidget,
    );
    expect(find.text('API Access'), findsOneWidget);
    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.apiDocsKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-395 connect button updates integration state', (
    tester,
  ) async {
    await pumpIntegrations(tester);

    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.connectKey('ledger')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(StakingThirdPartyIntegrationsPage.connectKey('ledger')),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingThirdPartyIntegrationsPage.connectedKey('ledger')),
      findsOneWidget,
    );
  });

  testWidgets('SC-395 API docs edge opens API documentation', (tester) async {
    await pumpIntegrations(tester);

    await tester.ensureVisible(
      find.byKey(StakingThirdPartyIntegrationsPage.apiDocsKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingThirdPartyIntegrationsPage.apiDocsKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingApiDocumentationPage), findsOneWidget);
    expect(find.text('API Documentation'), findsOneWidget);
  });

  testWidgets('SC-395 header back returns to Earn', (tester) async {
    await pumpIntegrations(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
  });
}
