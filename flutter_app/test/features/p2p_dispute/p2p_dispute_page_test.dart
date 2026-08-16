import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/phone/pages/dispute/p2p_dispute_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PDispute(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pDispute('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-221 mock repository exposes P2P dispute BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDisputeOpen('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-dispute-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/disputes/:id/evidence|resolve',
    );
    expect(snapshot.orderId, 'p2p001');
    expect(snapshot.reasons.length, 5);
    expect(snapshot.targetDisputeId, 'sample');
    expect(snapshot.contractNotes, contains('escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-221 renders P2P dispute form baseline', (tester) async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDisputeOpen('p2p001');

    await pumpP2PDispute(tester);

    expect(find.byType(P2PDisputePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(P2PDisputePage.contentKey), findsOneWidget);
    expect(find.byKey(P2PDisputePage.descriptionKey), findsOneWidget);
    expect(find.byKey(P2PDisputePage.uploadKey), findsOneWidget);
    expect(find.byKey(P2PDisputePage.submitKey), findsOneWidget);
    expect(find.textContaining('Order #', findRichText: true), findsOneWidget);
    expect(find.text(snapshot.reasons.first), findsOneWidget);
    expect(find.text(snapshot.reasons[1]), findsOneWidget);
  });

  testWidgets('SC-221 first viewport keeps dispute choices compact', (
    tester,
  ) async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDisputeOpen('p2p001');

    await pumpP2PDispute(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-221 P2PDisputePage',
      semanticLabel: 'Mở tranh chấp P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PDisputePage.reasonKey(snapshot.reasons.first)),
      routeName: 'SC-221 P2PDisputePage',
      actionLabel: 'first dispute reason',
      minVisibleHeight: 39,
    );
    expectFirstViewportVisible(
      tester,
      find.text(snapshot.descriptionLabel),
      targetLabel: 'description label',
      minVisibleHeight: 1,
    );
    expect(
      tester.getSize(find.byKey(P2PDisputePage.uploadKey)).height,
      lessThanOrEqualTo(76),
      reason: 'Evidence upload should stay compact enough for submit context.',
    );
  });

  testWidgets('SC-221 enables submit after reason and description', (
    tester,
  ) async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDisputeOpen('p2p001');

    await pumpP2PDispute(tester);

    await tester.tap(
      find.byKey(P2PDisputePage.reasonKey(snapshot.reasons.first)),
    );
    await tester.enterText(
      find.byKey(P2PDisputePage.descriptionKey),
      'Paid, seller did not release after 30 minutes.',
    );
    await tester.pumpAndSettle();

    final submit = tester.widget<VitCtaButton>(
      find.byKey(P2PDisputePage.submitKey),
    );
    expect(submit.onPressed, isNotNull);
  });

  testWidgets('SC-221 upload state marks evidence added', (tester) async {
    await pumpP2PDispute(tester);

    await tester.tap(find.byKey(P2PDisputePage.uploadKey));
    await tester.pumpAndSettle();

    expect(find.text('evidence_p2p001.png'), findsOneWidget);
  });

  testWidgets('SC-221 submit opens dispute detail route', (tester) async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getDisputeOpen('p2p001');

    await pumpP2PDispute(tester);

    await tester.tap(
      find.byKey(P2PDisputePage.reasonKey(snapshot.reasons.first)),
    );
    await tester.enterText(
      find.byKey(P2PDisputePage.descriptionKey),
      'Paid, seller did not release after 30 minutes.',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PDisputePage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PDisputeDetailPage), findsOneWidget);
  });
}
