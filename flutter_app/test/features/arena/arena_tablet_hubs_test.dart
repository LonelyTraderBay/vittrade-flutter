import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';

/// Khóa composition 4 hub redesign Bước 2 (2026-09-09): mỗi hub render đầy
/// đủ hero + section chính + panel cột phụ theo pattern flagship SC-184.
/// Hub Điểm Arena (SC-200) đã xoá 2026-09-19: route /arena/points redirect
/// sang /rewards?tab=arena trên cả 2 surface — class tablet là dead code.
void main() {
  tearDown(() => TabletSpacingTokens.tabletSurfaceActive = false);

  Future<void> pumpHub(WidgetTester tester, Widget page) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/hub',
            routes: [
              GoRoute(path: '/hub', builder: (_, _) => page),
              GoRoute(
                path: '/arena',
                builder: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Guide SC-209: bước tạo/tham gia + mẹo an toàn + checklist', (
    tester,
  ) async {
    await pumpHub(tester, const ArenaGuideTabletPage());
    expect(find.text('Các bước tạo thử thách'), findsOneWidget);
    expect(find.text('Các bước tham gia'), findsOneWidget);
    expect(find.text('Mẹo an toàn'), findsOneWidget);
    expect(find.text('Rà soát trước khi đấu'), findsOneWidget);
    expect(find.textContaining('Bước 1 ·'), findsWidgets);
  });

  testWidgets('Studio SC-185: hero phí nền tảng + quy trình + mẫu + công cụ', (
    tester,
  ) async {
    await pumpHub(tester, const ArenaStudioTabletPage());
    expect(find.text('Xưởng tạo thử thách'), findsOneWidget);
    expect(find.textContaining('Phí nền tảng'), findsOneWidget);
    expect(find.text('Quy trình Studio'), findsOneWidget);
    expect(find.text('Mẫu thử thách'), findsOneWidget);
    expect(find.text('Thư viện preset'), findsOneWidget);
    expect(find.text('Luật thông minh'), findsOneWidget);
  });

  testWidgets(
    'MyArena SC-205: hero 3 KPI + danh sách + số liệu + phần thưởng',
    (tester) async {
      await pumpHub(tester, const MyArenaTabletPage());
      expect(find.text('Tổng quan sân chơi'), findsOneWidget);
      expect(find.text('Đang tham gia'), findsAtLeastNWidgets(1));
      expect(find.text('Phòng do tôi tạo'), findsAtLeastNWidgets(1));
      expect(find.text('Số liệu'), findsOneWidget);
      expect(find.text('Phần thưởng đã nhận'), findsOneWidget);
    },
  );

  testWidgets('Leaderboard SC-194: hạng của bạn + bảng + đang lên mạnh', (
    tester,
  ) async {
    await pumpHub(tester, const ArenaLeaderboardTabletPage());
    expect(find.text('Hạng của bạn'), findsOneWidget);
    expect(find.text('Xếp hạng chung'), findsOneWidget);
    expect(find.text('Đang lên mạnh'), findsOneWidget);
    expect(find.textContaining('#'), findsWidgets);
  });
}
