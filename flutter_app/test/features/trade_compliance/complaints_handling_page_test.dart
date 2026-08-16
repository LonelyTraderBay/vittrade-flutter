import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/complaints/complaints_handling_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpComplaints(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyComplaintsHandling,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-111 mock repository exposes complaints BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getComplaintsHandling();

    expect(snapshot.activeCount, 1);
    expect(snapshot.resolvedCount, 1);
    expect(snapshot.averageResolutionDays, 12);
    expect(snapshot.categories.map((category) => category.label), [
      'Trade Execution',
      'Account Management',
      'Payments & Withdrawals',
      'Customer Service',
      'Fees & Charges',
      'Other',
    ]);
    expect(snapshot.timeline.map((step) => step.label), [
      'Submit Complaint',
      'Acknowledgement',
      'Investigation',
      'Final Response',
    ]);
    expect(snapshot.complaints.first.id, 'COMP-2026-001');
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-complaints-handling',
    );
    expect(snapshot.actionDraft, contains('POST /copy-trading/follow'));
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

  testWidgets('SC-111 renders complaints overview in Trade shell', (
    tester,
  ) async {
    await pumpComplaints(tester);

    expect(find.byType(ComplaintsHandlingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Complaints Handling'), findsOneWidget);
    expect(find.text('FCA Regulated Process'), findsOneWidget);
    expect(find.text('Your Rights'), findsOneWidget);
    expect(find.text('Submit a Complaint'), findsWidgets);
    expect(find.text('Complaint Categories'), findsOneWidget);
    expect(find.text('Trade Execution'), findsOneWidget);
    expect(find.text('Resolution Timeline'), findsOneWidget);
    expect(find.text('Final Response'), findsOneWidget);
  });

  testWidgets('SC-111 first viewport reaches complaint review panel', (
    tester,
  ) async {
    await pumpComplaints(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ComplaintsHandlingPage',
      semanticLabel: 'Xử lý khiếu nại theo quy trình được FCA quản lý',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Complaint process review'),
      minVisibleHeight: 18,
      targetLabel: 'complaint process review panel',
      reason:
          'Complaints handling must expose the regulated review panel above '
          'bottom navigation before rights and complaint workflow content.',
    );
  });

  testWidgets('SC-111 resolved complaint submission edge opens SC-112', (
    tester,
  ) async {
    await pumpComplaints(tester);

    await tester.tap(find.byKey(ComplaintsHandlingPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.text('Submit Complaint'), findsWidgets);
    expect(find.text('FCA Regulated Process'), findsOneWidget);
  });

  testWidgets('SC-111 dynamic complaint tracking edge opens SC-113', (
    tester,
  ) async {
    await pumpComplaints(tester);

    await tester.tap(find.byKey(ComplaintsHandlingPage.tabKey('myComplaints')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(ComplaintsHandlingPage.complaintKey('COMP-2026-001')),
      120,
      scrollable: find
          .descendant(
            of: find.byType(ComplaintsHandlingPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(
      find.byKey(ComplaintsHandlingPage.complaintKey('COMP-2026-001')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Complaint COMP-2026-001'), findsOneWidget);
    expect(find.text('Under Review'), findsWidgets);
  });
}
