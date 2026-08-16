import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/complaints/complaint_tracking_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTracking(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.tradeCopyComplaintTrackingBase,
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

  test('SC-113 mock repository exposes complaint tracking BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getComplaintTracking();

    expect(snapshot.complaintId, 'undefined');
    expect(snapshot.statusLabel, 'Under Review');
    expect(snapshot.daysRemaining, 34);
    expect(snapshot.timeline, hasLength(5));
    expect(snapshot.actions.map((action) => action.label), [
      'Add Information',
      'View Correspondence',
      'Ombudsman Referral Info',
    ]);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-complaint-tracking',
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

  testWidgets('SC-113 renders complaint tracking baseline in Trade shell', (
    tester,
  ) async {
    await pumpTracking(tester);

    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Complaint undefined'), findsOneWidget);
    expect(find.text('Under Review'), findsWidgets);
    expect(find.text('34 Days Remaining'), findsOneWidget);
    expect(find.text('Investigation Timeline'), findsOneWidget);
    expect(find.text('Complaint Submitted'), findsOneWidget);
    expect(find.text('Final Response'), findsOneWidget);
    expect(find.text('Add Information'), findsOneWidget);
  });

  testWidgets('SC-113 first viewport reaches investigation timeline', (
    tester,
  ) async {
    await pumpTracking(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-113 ComplaintTrackingPage',
      semanticLabel: 'Theo dõi tiến trình xử lý khiếu nại',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Complaint Submitted'),
      targetLabel: 'the first complaint timeline step',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-113 dynamic complaint id edge renders resolved id', (
    tester,
  ) async {
    await pumpTracking(
      tester,
      initialLocation: AppRoutePaths.tradeCopyComplaintTracking(
        'COMP-2026-NEW',
      ),
    );

    expect(find.text('Complaint COMP-2026-NEW'), findsOneWidget);
  });

  testWidgets('SC-113 ombudsman edge opens SC-114', (tester) async {
    await pumpTracking(tester);

    await tester.drag(
      find.byKey(ComplaintTrackingPage.contentKey),
      const Offset(0, -260),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ComplaintTrackingPage.actionKey('ombudsman')));
    await tester.pumpAndSettle();

    expect(find.text('Financial Ombudsman'), findsOneWidget);
    expect(find.text('Independent Dispute Resolution'), findsOneWidget);
  });
}
