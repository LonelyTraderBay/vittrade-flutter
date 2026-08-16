import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_api_documentation_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpDocumentation(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnApiDocumentation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-379 mock repository exposes API documentation BE draft', () async {
    final snapshot = await const MockStakingApiDocumentationRepository()
        .getDocumentation();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-api-documentation');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'API Documentation');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.defaultTab, 'endpoints');
    expect(snapshot.defaultLanguage, 'javascript');
    expect(snapshot.stats, hasLength(3));
    expect(snapshot.endpoints, hasLength(5));
    expect(snapshot.endpoints.first.path, '/staking/stake');
    expect(snapshot.endpoints.first.params, hasLength(4));
    expect(snapshot.codeExamples, hasLength(3));
    expect(snapshot.rateLimits, hasLength(3));
    expect(snapshot.errorCodes, hasLength(5));
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-379 renders endpoint catalogue baseline', (tester) async {
    await pumpDocumentation(tester);

    expect(find.byType(StakingApiDocumentationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('API Documentation'), findsOneWidget);
    expect(find.byKey(StakingApiDocumentationPage.infoKey), findsOneWidget);
    expect(find.text('Programmatic Staking API'), findsOneWidget);
    expect(find.byKey(StakingApiDocumentationPage.statsKey), findsOneWidget);
    expect(find.text('99.9%'), findsOneWidget);
    expect(find.text('v1.0'), findsOneWidget);
    expect(find.byKey(StakingApiDocumentationPage.tabsKey), findsOneWidget);
    expect(
      find.byKey(StakingApiDocumentationPage.endpointsKey),
      findsOneWidget,
    );
    expect(find.text('API Endpoints'), findsOneWidget);
    expect(find.text('/staking/stake'), findsWidgets);
    expect(find.text('/staking/positions'), findsOneWidget);
    expect(find.text('/staking/validators'), findsOneWidget);
    expect(find.byKey(StakingApiDocumentationPage.detailKey), findsOneWidget);
    expect(find.text('Endpoint Detail'), findsOneWidget);
    expect(find.text('Parameters'), findsOneWidget);
    expect(find.text('Response Example'), findsOneWidget);
  });

  testWidgets('SC-379 endpoint selection updates detail response', (
    tester,
  ) async {
    await pumpDocumentation(tester);

    await tester.tap(
      find.byKey(
        StakingApiDocumentationPage.endpointKey('GET', '/staking/validators'),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Get available validators with performance metrics'),
      findsWidgets,
    );
    expect(find.text('sortBy'), findsOneWidget);
    expect(find.textContaining('Validator A'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingApiDocumentationPage.copyResponseKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingApiDocumentationPage.copyResponseKey));
    await tester.pumpAndSettle();

    expect(find.text('Copied'), findsOneWidget);
  });

  testWidgets('SC-379 examples tab switches language and copies code', (
    tester,
  ) async {
    await pumpDocumentation(tester);

    await tester.tap(
      find.byKey(StakingApiDocumentationPage.tabKey('examples')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(StakingApiDocumentationPage.examplesKey), findsOneWidget);
    expect(find.text('Code Examples'), findsOneWidget);
    expect(find.text('Create Stake Position'), findsOneWidget);
    expect(find.text('Sandbox Environment'), findsOneWidget);

    await tester.tap(
      find.byKey(StakingApiDocumentationPage.languageKey('python')),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('# Python'), findsOneWidget);

    await tester.tap(find.byKey(StakingApiDocumentationPage.copyExampleKey));
    await tester.pumpAndSettle();

    expect(find.text('Copied'), findsOneWidget);

    await tester.ensureVisible(find.text('Get Sandbox API Key'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Sandbox API Key'));
    await tester.pumpAndSettle();

    expect(find.text('Lấy Sandbox API Key sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-379 auth tab renders limits and error codes', (tester) async {
    await pumpDocumentation(tester);

    await tester.tap(find.byKey(StakingApiDocumentationPage.tabKey('auth')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingApiDocumentationPage.authKey), findsOneWidget);
    expect(find.text('Authentication'), findsOneWidget);
    expect(find.text('API Key Authentication'), findsOneWidget);
    expect(find.text('Rate Limits'), findsOneWidget);
    expect(find.text('Free'), findsOneWidget);
    expect(find.text('Pro'), findsOneWidget);
    expect(find.text('Recommended'), findsOneWidget);
    expect(find.text('Enterprise'), findsOneWidget);
    expect(find.text('Error Codes'), findsOneWidget);
    expect(find.text('401'), findsOneWidget);
    expect(find.text('Internal Server Error'), findsOneWidget);
  });

  testWidgets('SC-379 generate API key CTA shows placeholder feedback', (
    tester,
  ) async {
    await pumpDocumentation(tester);

    await tester.tap(find.byKey(StakingApiDocumentationPage.tabKey('auth')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Generate API Key in Settings ->'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Generate API Key in Settings ->'));
    await tester.pumpAndSettle();

    expect(
      find.text('Tạo API Key trong Cài đặt sẽ sớm ra mắt'),
      findsOneWidget,
    );
  });

  testWidgets('SC-379 contact sales CTA shows placeholder feedback', (
    tester,
  ) async {
    await pumpDocumentation(tester);

    await tester.tap(find.byKey(StakingApiDocumentationPage.tabKey('auth')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Contact Sales'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contact Sales'));
    await tester.pumpAndSettle();

    expect(find.text('Liên hệ Sales sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-379 header back returns to staking hub', (tester) async {
    await pumpDocumentation(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
