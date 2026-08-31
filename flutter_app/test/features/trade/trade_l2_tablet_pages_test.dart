import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/orders_history_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/hub/position_dashboard_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/orders_history_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/position_dashboard_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';

void main() {
  Future<void> pumpTablet(
    WidgetTester tester, {
    required String initialLocation,
    Size size = const Size(1280, 800),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: initialLocation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('SC-050 OrdersHistoryTabletPage', () {
    testWidgets('renders the real tablet table page, not the utility '
        'placeholder nor the phone page', (tester) async {
      await pumpTablet(tester, initialLocation: '/trade/orders-history');

      expect(find.byType(OrdersHistoryTabletPage), findsOneWidget);
      expect(find.byType(TradeTabletUtilityPage), findsNothing);
      expect(find.byType(OrdersHistoryPage), findsNothing);
      expect(find.byType(VitNavigationRail), findsOneWidget);
    });

    testWidgets('shows the full-field table with stats panel at tablet '
        'width', (tester) async {
      await pumpTablet(tester, initialLocation: '/trade/orders-history');

      expect(find.byKey(OrdersHistoryTabletPage.tableKey), findsOneWidget);
      expect(find.byKey(OrdersHistoryTabletPage.statsKey), findsOneWidget);
      // Tab mặc định = Đang mở (4 lệnh mở từ fixture).
      expect(find.byKey(OrdersHistoryTabletPage.openTabKey), findsOneWidget);
      expect(find.text('ord-open-001'), findsNothing); // id không vẽ trực tiếp
      expect(find.byKey(const Key('sc050_order_ord-open-001')), findsOneWidget);
      // Cột header đầy đủ của bảng tablet ("Đã khớp" cũng xuất hiện
      // trong panel thống kê bên phải).
      expect(find.text('Đã khớp'), findsNWidgets(2));
      expect(find.text('Tổng phí đã trả'), findsOneWidget);
    });

    testWidgets('switching to history tab swaps the rows', (tester) async {
      await pumpTablet(tester, initialLocation: '/trade/orders-history');

      await tester.tap(find.byKey(OrdersHistoryTabletPage.historyTabKey));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('sc050_order_ord-history-001')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow at portrait QA width', (tester) async {
      await pumpTablet(
        tester,
        initialLocation: '/trade/orders-history',
        size: const Size(800, 1280),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('SC-053 PositionDashboardTabletPage', () {
    testWidgets('renders the real tablet table page, not the utility '
        'placeholder nor the phone page', (tester) async {
      await pumpTablet(tester, initialLocation: '/trade/positions');

      expect(find.byType(PositionDashboardTabletPage), findsOneWidget);
      expect(find.byType(TradeTabletUtilityPage), findsNothing);
      expect(find.byType(PositionDashboardPage), findsNothing);
    });

    testWidgets('shows the position table with summary + risk panels', (
      tester,
    ) async {
      await pumpTablet(tester, initialLocation: '/trade/positions');

      expect(find.byKey(PositionDashboardTabletPage.tableKey), findsOneWidget);
      expect(
        find.byKey(PositionDashboardTabletPage.summaryKey),
        findsOneWidget,
      );
      // 6 vị thế từ fixture (spot/futures/margin).
      expect(find.byKey(const Key('sc053_tablet_row_sp1')), findsOneWidget);
      expect(find.byKey(const Key('sc053_tablet_row_ft1')), findsOneWidget);
      expect(find.text('Tổng P/L chưa realise'), findsOneWidget);
      expect(find.text('Xem lại rủi ro vị thế mở'), findsOneWidget);
    });

    testWidgets('futures tab filters to futures rows only', (tester) async {
      await pumpTablet(tester, initialLocation: '/trade/positions');

      await tester.tap(find.byKey(const Key('sc053_tablet_tab_futures')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sc053_tablet_row_ft1')), findsOneWidget);
      expect(find.byKey(const Key('sc053_tablet_row_ft2')), findsOneWidget);
      expect(find.byKey(const Key('sc053_tablet_row_sp1')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('no overflow at portrait QA width', (tester) async {
      await pumpTablet(
        tester,
        initialLocation: '/trade/positions',
        size: const Size(800, 1280),
      );
      expect(tester.takeException(), isNull);
    });
  });
}
