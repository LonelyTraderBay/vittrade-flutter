import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/prediction_event_calendar_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCalendar(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsEventCalendar,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-039 mock repository exposes the event calendar BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getEventCalendar();

    expect(snapshot.events, hasLength(6));
    expect(snapshot.categories, ['Crypto', 'Politics', 'Tech', 'Macro']);
    expect(snapshot.watchingCount, 4);
    expect(snapshot.thisMonthCount, 0);
    expect(snapshot.months.first.label, 'December 2026');
    expect(snapshot.upcomingEvents, hasLength(4));
    expect(snapshot.watchingEvents, hasLength(4));
    expect(
      (await repo.getEventCalendar(category: 'Tech')).events,
      hasLength(2),
    );
    expect(snapshot.orders, hasLength(3));
    expect(snapshot.receipts, hasLength(6));
    expect(snapshot.rewards, isNotEmpty);
    expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
    expect(
      snapshot.supportedStates,
      containsAll([
        PredictionScreenState.loading,
        PredictionScreenState.empty,
        PredictionScreenState.error,
        PredictionScreenState.offline,
        PredictionScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-039 renders calendar tab inside the Markets shell', (
    tester,
  ) async {
    await pumpCalendar(tester);

    expect(find.byType(PredictionEventCalendarPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Lịch sự kiện'), findsOneWidget);
    expect(find.text('Lich'), findsOneWidget);
    expect(find.text('Sap toi'), findsOneWidget);
    expect(find.text('Thong bao'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('Watching'), findsOneWidget);
    expect(find.text('This Month'), findsOneWidget);
    expect(find.text('December 2026'), findsOneWidget);
    expect(find.text('BTC > \$100K by Dec 2026?'), findsOneWidget);
    expect(find.text('SpaceX Mars landing in 2026?'), findsOneWidget);
  });

  testWidgets('SC-039 first viewport reaches first calendar event', (
    tester,
  ) async {
    await pumpCalendar(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-039 PredictionEventCalendarPage',
      semanticLabel:
          'Lịch sự kiện dự đoán: theo dõi ngày đóng và các yếu tố tác động',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PredictionEventCalendarPage.eventKey('pred-1')),
      targetLabel: 'the first calendar event card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-039 filter and tabs update locally', (tester) async {
    await pumpCalendar(tester);

    await tester.tap(find.byKey(PredictionEventCalendarPage.filterButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(PredictionEventCalendarPage.categoryKey('Tech')),
    );
    await tester.pumpAndSettle();

    expect(find.text('SpaceX Mars landing in 2026?'), findsOneWidget);
    expect(find.text('AI beats human in chess 2025?'), findsOneWidget);
    expect(find.text('BTC > \$100K by Dec 2026?'), findsNothing);

    await tester.tap(find.byKey(PredictionEventCalendarPage.upcomingTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Su kien sap dien ra'), findsOneWidget);

    await tester.tap(
      find.byKey(PredictionEventCalendarPage.notificationsTabKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cai dat thong bao'), findsOneWidget);
    expect(find.text('Dang theo doi'), findsOneWidget);
    expect(find.text('Resolution Reminder'), findsOneWidget);
  });

  testWidgets('SC-039 event card navigates to SC-030 detail route', (
    tester,
  ) async {
    await pumpCalendar(tester);

    await tester.tap(
      find.byKey(PredictionEventCalendarPage.eventKey('pred-1')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
  });

  testWidgets('SC-039 back button returns to Predictions home', (tester) async {
    await pumpCalendar(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
