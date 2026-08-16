import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_aml_screening_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_compliance_overview_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAmlScreening(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pComplianceAmlScreening,
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

  test('SC-268 mock repository exposes AML screening BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getAmlScreening();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-compliance-aml-screening');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'AML Screening');
    expect(snapshot.subtitle, 'Tuân thủ · P2P');
    expect(snapshot.statusLabel, 'AML Status: Clear');
    expect(snapshot.lastCheckAt, '2026-03-05 10:00');
    expect(snapshot.nextCheckAt, '2026-03-12 10:00');
    expect(snapshot.checks, hasLength(4));
    expect(snapshot.checks.last.status, 'review');
    expect(snapshot.parentRoute, AppRoutePaths.p2pComplianceOverview);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-268 renders AML screening baseline', (tester) async {
    await pumpAmlScreening(tester);

    expect(find.byType(P2PAmlScreeningPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('AML Screening'), findsOneWidget);
    expect(find.text('Tuân thủ · P2P'), findsOneWidget);
    expect(find.byKey(P2PAmlScreeningPage.heroKey), findsOneWidget);
    expect(find.text('AML Status: Clear'), findsOneWidget);
    expect(find.text('Tài khoản đã qua kiểm tra AML'), findsOneWidget);
    expect(find.byKey(P2PAmlScreeningPage.scheduleKey), findsOneWidget);
    expect(find.text('Kiểm tra gần nhất'), findsOneWidget);
    expect(find.text('Kiểm tra tiếp theo'), findsOneWidget);
    expect(find.text('2026-03-05 10:00'), findsOneWidget);
    expect(find.text('2026-03-12 10:00'), findsOneWidget);
    expect(find.byKey(P2PAmlScreeningPage.checksKey), findsOneWidget);
    expect(find.text('Chi tiết kiểm tra'), findsOneWidget);
    expect(find.text('Sanctions List'), findsOneWidget);
    expect(find.text('PEP Check'), findsOneWidget);
    expect(find.text('Adverse Media'), findsOneWidget);
    expect(find.text('Transaction Pattern'), findsOneWidget);
    expect(find.text('Pass'), findsNWidgets(3));
    expect(find.text('Review'), findsOneWidget);
    expect(find.byKey(P2PAmlScreeningPage.infoKey), findsOneWidget);
    expect(find.text('Về AML Screening'), findsOneWidget);
  });

  testWidgets('SC-268 first viewport reaches schedule and first check', (
    tester,
  ) async {
    await pumpAmlScreening(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-268 P2PAMLScreeningPage',
      semanticLabel: 'Sàng lọc chống rửa tiền P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAmlScreeningPage.heroKey),
      routeName: 'SC-268 P2PAMLScreeningPage',
      actionLabel: 'the AML status summary',
      minVisibleHeight: 40,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAmlScreeningPage.scheduleKey),
      routeName: 'SC-268 P2PAMLScreeningPage',
      actionLabel: 'the AML schedule',
      minVisibleHeight: 40,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAmlScreeningPage.checkKey('sanctions')),
      routeName: 'SC-268 P2PAMLScreeningPage',
      actionLabel: 'the first AML check row',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-268 is reachable from compliance overview', (tester) async {
    await pumpAmlScreening(
      tester,
      initialLocation: AppRoutePaths.p2pComplianceOverview,
    );

    await tester.tap(P2PComplianceOverviewPage.itemKey('aml').finder);
    await tester.pumpAndSettle();

    expect(find.byType(P2PAmlScreeningPage), findsOneWidget);
    expect(find.text('AML Status: Clear'), findsOneWidget);
  });

  testWidgets('SC-268 back returns to compliance overview', (tester) async {
    await pumpAmlScreening(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PAmlScreeningPage), findsNothing);
    expect(find.byType(P2PComplianceOverviewPage), findsOneWidget);
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
