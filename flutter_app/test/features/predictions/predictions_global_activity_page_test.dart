import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/predictions_global_activity_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpActivity(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsActivity,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-034 mock repository exposes the global activity BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getGlobalActivity();

    expect(snapshot.activities, hasLength(30));
    expect(snapshot.buyCount, 20);
    expect(snapshot.sellCount, 10);
    expect(snapshot.totalVolume.round(), 10702);
    expect(snapshot.activities.first.user, 'whale_42');
    expect(
      snapshot.activities.first.action,
      PredictionGlobalActivityAction.sold,
    );
    expect(snapshot.activities.first.amount, 22.11);
    expect(snapshot.eventFor(snapshot.activities.first.eventId).id, 'pred-1');
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

    final filtered = await repo.getGlobalActivity(minAmount: 500);
    expect(
      filtered.activities.every((activity) => activity.amount >= 500),
      isTrue,
    );
  });

  testWidgets('SC-034 renders global activity inside the Markets shell', (
    tester,
  ) async {
    await pumpActivity(tester);

    expect(find.byType(PredictionsGlobalActivityPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Global Activity'), findsOneWidget);
    expect(find.text('Hoạt động · Prediction'), findsOneWidget);
    expect(find.text('Live Feed'), findsOneWidget);
    expect(find.text('Volume (1h)'), findsOneWidget);
    expect(find.text('\$11K'), findsOneWidget);
    expect(find.text('Buys'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('Sells'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('Min amount:'), findsOneWidget);
    expect(
      find.byKey(PredictionsGlobalActivityPage.activityKey('ga-0')),
      findsOneWidget,
    );
    expect(find.text('whale_42'), findsWidgets);
    expect(find.text('sold'), findsWidgets);
    expect(find.text('No'), findsWidgets);
    expect(find.text('\$22'), findsOneWidget);
  });

  testWidgets('SC-034 amount filters update the feed locally', (tester) async {
    await pumpActivity(tester);

    await tester.tap(
      find.byKey(PredictionsGlobalActivityPage.amount100FilterKey),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(PredictionsGlobalActivityPage.activityKey('ga-0')),
      findsNothing,
    );
    expect(
      find.byKey(PredictionsGlobalActivityPage.activityKey('ga-4')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(PredictionsGlobalActivityPage.allFilterKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionsGlobalActivityPage.activityKey('ga-0')),
      findsOneWidget,
    );
  });

  testWidgets('SC-034 first viewport reaches the first activity row', (
    tester,
  ) async {
    await pumpActivity(tester);

    expectFirstViewportVisible(
      tester,
      find.byKey(PredictionsGlobalActivityPage.activityKey('ga-0')),
      targetLabel: 'the first global activity row',
      minVisibleHeight: 40,
    );
  });

  testWidgets('SC-034 activity row navigates to event detail', (tester) async {
    await pumpActivity(tester);

    await tester.tap(
      find.byKey(PredictionsGlobalActivityPage.activityKey('ga-0')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
  });
}
