import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/safety/dispute_resolution_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDisputeResolution(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyDisputeResolution,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fillComplaintForm(WidgetTester tester) async {
    await tester.tap(
      find.byKey(DisputeResolutionPage.complaintTypeKey('execution_issue')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DisputeResolutionPage.providerKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SwingMaster').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(DisputeResolutionPage.subjectKey),
      'Excessive slippage on BTC trade',
    );
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(DisputeResolutionPage.contentKey),
      const Offset(0, -360),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(DisputeResolutionPage.descriptionKey),
      'Provider executed at a materially different price.',
    );
    await tester.pumpAndSettle();
  }

  test('SC-082 mock repository exposes dispute resolution BE draft', () async {
    final snapshot = await const MockTradeCopyTradingRepository(
      loadDelay: Duration.zero,
    ).getDisputeResolution();

    expect(snapshot.defaultTabId, 'file');
    expect(snapshot.noticeTitle, 'Fair Dispute Resolution');
    expect(snapshot.complaintTypes, hasLength(5));
    expect(snapshot.providers.map((provider) => provider.name), [
      'CryptoKing',
      'SwingMaster',
      'AlgoTrader',
    ]);
    expect(snapshot.activeCases, hasLength(1));
    expect(snapshot.resolvedCases, hasLength(1));
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

    final result =
        await const MockTradeCopyTradingRepository(
          loadDelay: Duration.zero,
        ).submitDisputeComplaint(
          const TradeDisputeComplaintDraft(
            complaintType: 'execution_issue',
            providerId: 'trader-2',
            subject: 'Excessive slippage',
            description: 'Provider executed at a materially different price.',
          ),
        );
    expect(result.caseId, 'case-003');
    expect(result.status, 'submitted');
  });

  testWidgets('SC-082 renders complaint form inside the Trade shell', (
    tester,
  ) async {
    await pumpDisputeResolution(tester);

    expect(find.byType(DisputeResolutionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Giải quyết khiếu nại'), findsOneWidget);
    expect(find.text('Fair Dispute Resolution'), findsOneWidget);
    expect(find.text('Complaint Type'), findsOneWidget);
    expect(find.text('Execution Issue'), findsOneWidget);
    expect(find.text('Fee Discrepancy'), findsOneWidget);
    expect(find.text('Provider Misconduct'), findsOneWidget);
    expect(find.text('Submit Complaint'), findsOneWidget);
    expect(
      find.byKey(DisputeResolutionPage.submitKey).hitTestable(),
      findsNothing,
    );
  });

  testWidgets('SC-082 first viewport reaches complaint type inventory', (
    tester,
  ) async {
    await pumpDisputeResolution(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'DisputeResolutionPage',
      semanticLabel: 'Giải quyết khiếu nại',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(DisputeResolutionPage.complaintTypeSectionKey),
      minVisibleHeight: 24,
      targetLabel: 'complaint type section',
      reason:
          'Dispute intake must expose complaint type choices above the sticky '
          'submit footer and bottom navigation.',
    );
  });

  testWidgets('SC-082 submits complaint and switches to active cases', (
    tester,
  ) async {
    await pumpDisputeResolution(tester);

    await tester.ensureVisible(find.byKey(DisputeResolutionPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DisputeResolutionPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Active Cases'), findsNothing);

    await fillComplaintForm(tester);
    await tester.ensureVisible(find.byKey(DisputeResolutionPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DisputeResolutionPage.submitKey));
    await tester.pumpAndSettle();

    expect(
      find.text('Complaint submitted successfully: case-003'),
      findsOneWidget,
    );
    expect(find.text('Active Cases'), findsOneWidget);
    expect(find.text('Excessive slippage on BTC trade'), findsOneWidget);
    expect(find.text('UNDER REVIEW'), findsOneWidget);
  });

  testWidgets('SC-082 history tab shows resolved case', (tester) async {
    await pumpDisputeResolution(tester);

    await fillComplaintForm(tester);
    await tester.ensureVisible(find.byKey(DisputeResolutionPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DisputeResolutionPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DisputeResolutionPage.tabKey('history')));
    await tester.pumpAndSettle();

    expect(find.text('Refund Issued'), findsOneWidget);
    expect(find.text('Charged 15% instead of 10%'), findsOneWidget);
  });
}
