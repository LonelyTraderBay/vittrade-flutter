import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/complaints/complaint_submission_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSubmission(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyComplaintSubmission,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-112 mock repository exposes complaint submission BE draft',
    () async {
      final snapshot = await const MockTradeRegulatoryRepository(
        loadDelay: Duration.zero,
      ).getComplaintSubmission();

      expect(snapshot.processTitle, 'Complaint Process');
      expect(snapshot.categories, contains('Trade Execution'));
      expect(snapshot.subjectMinLength, 10);
      expect(snapshot.descriptionMinLength, 50);
      expect(snapshot.confirmationComplaintId, 'COMP-2026-NEW');
      expect(
        snapshot.endpoint,
        '/api/mobile/trade/trade-copy-trading-complaint-submission',
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
    },
  );

  testWidgets('SC-112 renders complaint submission form in Trade shell', (
    tester,
  ) async {
    await pumpSubmission(tester);

    expect(find.byType(ComplaintSubmissionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Submit Complaint'), findsWidgets);
    expect(find.text('FCA Regulated Process'), findsOneWidget);
    expect(find.text('Complaint Process'), findsOneWidget);
    expect(find.text('Complaint Details'), findsOneWidget);
    expect(find.text('Select category'), findsOneWidget);
    expect(find.text('Upload Evidence (Optional)'), findsOneWidget);
    expect(find.byKey(ComplaintSubmissionPage.submitKey), findsOneWidget);
    expect(
      find.byKey(ComplaintSubmissionPage.submitKey).hitTestable(),
      findsNothing,
    );
    await tester.ensureVisible(find.byKey(ComplaintSubmissionPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ComplaintSubmissionPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.byType(ComplaintSubmissionPage), findsOneWidget);
  });

  testWidgets('SC-112 first viewport reaches complaint category field', (
    tester,
  ) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyComplaintSubmission,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-112 ComplaintSubmissionPage',
      semanticLabel: 'Gửi khiếu nại mới theo quy trình được FCA quản lý',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ComplaintSubmissionPage.categoryKey),
      targetLabel: 'the complaint category field',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-112 valid form opens SC-113 complaint tracking', (
    tester,
  ) async {
    await pumpSubmission(tester);

    await tester.tap(find.byKey(ComplaintSubmissionPage.categoryKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trade Execution').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(ComplaintSubmissionPage.subjectKey),
      'Order execution complaint',
    );
    await tester.enterText(
      find.byKey(ComplaintSubmissionPage.descriptionKey),
      'My copied order was not executed at the expected price and I need a formal review of the execution timeline.',
    );
    await tester.drag(
      find.byKey(ComplaintSubmissionPage.contentKey),
      const Offset(0, -320),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ComplaintSubmissionPage.acceptKey));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(ComplaintSubmissionPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ComplaintSubmissionPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.text('Complaint COMP-2026-NEW'), findsOneWidget);
    expect(find.text('Under Review'), findsWidgets);
  });
}
