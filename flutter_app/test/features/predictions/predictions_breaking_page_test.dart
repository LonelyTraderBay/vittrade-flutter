import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/event/prediction_event_detail_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_breaking_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBreaking(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsBreaking,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-029 mock repository exposes the breaking movers BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getBreaking();

    expect(snapshot.movers, hasLength(12));
    expect(snapshot.movers.map((event) => event.id).take(3), [
      'pred-5',
      'pred-10',
      'pred-1',
    ]);
    expect(snapshot.upCount, 9);
    expect(snapshot.downCount, 3);
    expect(snapshot.categories, containsAll(['Live Crypto', 'Finance', 'AI']));
    expect(snapshot.orders, hasLength(2));
    expect(snapshot.receipts, hasLength(1));
    expect(snapshot.rewards, hasLength(2));
    expect(snapshot.lastUpdatedLabel, 'read-only');
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

    final crypto = await repo.getBreaking(category: 'Live Crypto');
    expect(crypto.movers.map((event) => event.category).toSet(), {
      'Live Crypto',
    });
    expect(crypto.movers.first.id, 'pred-1');
  });

  testWidgets('SC-029 renders breaking movers inside the Markets shell', (
    tester,
  ) async {
    await pumpBreaking(tester);

    expect(find.byType(PredictionsBreakingPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Biến động'), findsOneWidget);
    expect(find.text('Biến động 24h'), findsOneWidget);
    expect(find.text('9 tăng'), findsOneWidget);
    expect(find.text('3 giảm'), findsOneWidget);
    expect(find.text('Apple releases AR glasses in 2026?'), findsOneWidget);
    expect(find.text('Tesla stock above \$400 by mid-2026?'), findsOneWidget);
    expect(find.text('Nhận cập nhật hàng ngày'), findsOneWidget);
  });

  testWidgets('SC-029 first viewport reaches first mover card', (tester) async {
    await pumpBreaking(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-029 PredictionsBreakingPage',
      semanticLabel:
          'Biến động thị trường dự đoán: xác suất thay đổi trong 24 giờ',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(PredictionsBreakingPage.moverKey('pred-5')),
      targetLabel: 'the first breaking mover card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-029 filters movers by category and subscribes locally', (
    tester,
  ) async {
    await pumpBreaking(tester);

    await tester.tap(find.byKey(PredictionsBreakingPage.cryptoTabKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(PredictionsBreakingPage.moverKey('pred-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(PredictionsBreakingPage.moverKey('pred-5')),
      findsNothing,
    );

    await tester.enterText(find.byType(TextField), 'user@vittrade.vn');
    await tester.tap(find.byKey(PredictionsBreakingPage.subscribeKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã đăng ký'), findsOneWidget);
  });

  testWidgets('SC-029 result tap and back button are wired', (tester) async {
    await pumpBreaking(tester);

    await tester.tap(find.byKey(PredictionsBreakingPage.moverKey('pred-5')));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailPage), findsOneWidget);
    expect(find.text('Chi tiết sự kiện'), findsOneWidget);
    expect(find.text('Apple releases AR glasses in 2026?'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
