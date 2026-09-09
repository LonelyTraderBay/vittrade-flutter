import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';

/// Khóa composition redesign SC-184 (mockup chốt 2026-09-09): dashboard 2
/// cột với hero KPI, phòng đấu đầy đủ thông tin, grid chế độ, cột phụ tìm
/// kiếm/quick actions/creator; search lọc live cả 2 cột.
void main() {
  tearDown(() => TabletSpacingTokens.tabletSurfaceActive = false);

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/frame',
      routes: [
        GoRoute(
          path: '/frame',
          builder: (context, state) => const ArenaHomeTabletPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Future<void> pumpHome(WidgetTester tester) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: buildRouter())),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-184 tablet: hero KPI + phòng đấu + grid mode + cột phụ', (
    tester,
  ) async {
    await pumpHome(tester);

    // Hero: 2 KPI + 2 CTA.
    expect(find.text('Thử thách cộng đồng'), findsOneWidget);
    expect(find.text('Điểm Arena'), findsWidgets);
    expect(find.text('Thử thách đang chạy'), findsOneWidget);
    expect(find.text('Tạo thử thách'), findsOneWidget);
    expect(find.text('Khám phá mode'), findsOneWidget);

    // Phòng đấu: hàng dữ liệu đầy đủ (không còn danh sách chữ trần).
    expect(find.byKey(const Key('sc184_tablet_room_ch001')), findsOneWidget);
    expect(find.text('Đoán sát nhất'), findsOneWidget);
    expect(find.text('38/50 slot'), findsOneWidget);
    expect(find.text('Đang mở'), findsWidgets);

    // Grid chế độ: tile có tên hiển thị (không còn mode001).
    expect(find.byKey(const Key('sc184_tablet_mode_mode001')), findsOneWidget);
    expect(find.text('Dự đoán BTC hàng tuần'), findsOneWidget);
    expect(find.text('Fair-play'), findsWidgets);

    // Cột phụ: quick actions + panel + creator + bridge.
    expect(find.text('Bảng xếp hạng'), findsWidgets);
    expect(find.text('Sân chơi của tôi'), findsWidgets);
    expect(find.text('Creator nổi bật'), findsOneWidget);
    expect(find.text('Cầu nối Prediction Markets'), findsOneWidget);
    expect(find.text('Thử thách đã xác thực'), findsOneWidget);
  });

  testWidgets('SC-184 tablet: tìm kiếm lọc live phòng và chế độ', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.enterText(find.byType(TextField), 'altcoin');
    await tester.pumpAndSettle();

    // Phòng khớp từ khoá còn, phòng khác bị lọc.
    expect(
      find.text('Đấu trường Altcoin — SOL vs AVAX vs MATIC'),
      findsOneWidget,
    );
    expect(find.text("BTC \$70K? — Tuần 9"), findsNothing);
    // Mode khớp (tên có 'Altcoin') còn.
    expect(find.text('Đấu trường sinh tồn Altcoin'), findsOneWidget);
    expect(find.text('Dự đoán BTC hàng tuần'), findsNothing);
  });
}
