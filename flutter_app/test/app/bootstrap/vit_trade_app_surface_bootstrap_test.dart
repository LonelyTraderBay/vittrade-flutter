import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/tablet/pages/home_tablet_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/tablet/pages/markets_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';

// Tái hiện race cold-start quan sát trên Android tablet emulator
// (2026-08-21): build đầu tiên của VitTradeApp có thể chạy trước khi engine
// nhận metrics thật (viewport width = 0). Trước fix, surface bị chốt Phone
// từ width 0 — sai và khóa cả session vì surface router chỉ dựng một lần.
void main() {
  void pinView(WidgetTester tester, Size physicalSize, double dpr) {
    tester.view.devicePixelRatio = dpr;
    tester.view.physicalSize = physicalSize;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets(
    'bootstrap chờ metrics hợp lệ thay vì khóa Phone khi viewport width = 0',
    (tester) async {
      pinView(tester, Size.zero, 2.0);

      await tester.pumpWidget(const VitTradeApp());
      await tester.pump();

      // Metrics chưa hợp lệ: giữ frame placeholder, chưa dựng surface
      // router — surface sai không thể bị khóa từ dữ liệu rỗng.
      expect(find.byType(MaterialApp), findsNothing);

      // Metrics thật về (tablet landscape 1280x800dp) → dựng đúng Tablet.
      tester.view.physicalSize = const Size(2560, 1600);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(HomeTabletPage), findsOneWidget);
      expect(find.byType(VitNavigationRail), findsOneWidget);
      expect(find.byType(VitBottomNav), findsNothing);
      expect(find.byType(HomePage), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('metrics hợp lệ ngay từ đầu dựng Phone không cần frame chờ', (
    tester,
  ) async {
    pinView(tester, const Size(440, 956), 1.0);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const MockHomeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: const VitTradeApp(),
      ),
    );
    // Frame đầu đã có MaterialApp — metrics hợp lệ không qua placeholder.
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitNavigationRail), findsNothing);
  });

  testWidgets('surface tường minh bỏ qua gate metrics (không frame chờ)', (
    tester,
  ) async {
    pinView(tester, Size.zero, 2.0);

    await tester.pumpWidget(const VitTradeApp(surface: AppSurface.tablet));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(HomeTabletPage), findsOneWidget);
    expect(find.byType(VitNavigationRail), findsOneWidget);
  });

  testWidgets('surface đã chốt không dựng lại khi metrics đổi sau đó', (
    tester,
  ) async {
    pinView(tester, const Size(2560, 1600), 2.0);

    await tester.pumpWidget(const VitTradeApp());
    await tester.pumpAndSettle();
    expect(find.byType(HomeTabletPage), findsOneWidget);

    // Điều hướng đi nơi khác — nếu router bị dựng lại, route state này mất.
    await tester.tap(find.byKey(const Key('vit_navigation_rail_markets')));
    await tester.pumpAndSettle();
    expect(find.byType(MarketsTabletPage), findsOneWidget);

    // Metrics đổi (xoay dọc 800dp): surface đã chốt phải giữ nguyên.
    tester.view.physicalSize = const Size(1600, 2560);
    await tester.pumpAndSettle();

    expect(find.byType(MarketsTabletPage), findsOneWidget);
    expect(find.byType(VitNavigationRail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
