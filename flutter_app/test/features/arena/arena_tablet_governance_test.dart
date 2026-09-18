import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Khóa cụm Governance & An toàn tablet (Đợt 3 redesign 2026-09-19):
/// SC-203 mở chặn thật qua state controller + confirm sheet, SC-204 filter
/// trạng thái danh sách báo cáo, SC-202 kháng cáo qua reviewState,
/// SC-199/SC-198/SC-192 render workspace đầy đủ.
void main() {
  tearDown(() => TabletSpacingTokens.tabletSurfaceActive = false);

  Future<void> pumpPage(WidgetTester tester, Widget page) async {
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
                path: '/arena/report/:caseId',
                builder: (_, _) => const Text('report-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Blocked users SC-203: mở chặn qua confirm sheet', (
    tester,
  ) async {
    await pumpPage(tester, const ArenaBlockedUsersTabletPage());

    final before = find.text('Mở chặn');
    final rowsBefore = find.byType(ListTile).evaluate().length;
    expect(before, findsWidgets);

    // Bấm nút mở chặn đầu → sheet xác nhận.
    await tester.ensureVisible(before.first);
    await tester.tap(before.first);
    await tester.pumpAndSettle();
    expect(find.text('Mở chặn người chơi'), findsOneWidget);

    // Xác nhận trong sheet → hàng biến mất khỏi danh sách.
    await tester.tap(find.text('Mở chặn').last);
    await tester.pumpAndSettle();
    expect(
      find.byType(ListTile).evaluate().length,
      rowsBefore - 1,
      reason: 'Một người đã được mở chặn khỏi danh sách',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('My reports SC-204: KPI + lọc trạng thái + vào hồ sơ', (
    tester,
  ) async {
    await pumpPage(tester, const MyArenaReportsTabletPage());

    expect(find.text('Tổng báo cáo'), findsOneWidget);
    expect(find.text('Hồ sơ báo cáo'), findsOneWidget);

    // Bấm chip lọc đầu (khác "tất cả" nếu có) — danh sách không vỡ.
    final chips = find.byType(VitFilterChip);
    expect(chips, findsWidgets);
    await tester.ensureVisible(chips.first);
    await tester.tap(chips.first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Bấm hồ sơ đầu (nếu hiển thị) → chuyển trang hồ sơ báo cáo.
    final rows = find.textContaining('Cập nhật');
    if (rows.evaluate().isNotEmpty) {
      await tester.ensureVisible(rows.first);
      await tester.tap(rows.first);
      await tester.pumpAndSettle();
      expect(find.text('report-opened'), findsOneWidget);
    }
  });

  testWidgets('Report case SC-202: timeline + gửi kháng cáo', (tester) async {
    await pumpPage(tester, const ArenaReportCaseTabletPage(caseId: 'rpt001'));

    expect(find.text('Nội dung báo cáo'), findsOneWidget);
    expect(find.text('Timeline xử lý'), findsOneWidget);
    expect(find.text('Trạng thái xem xét'), findsOneWidget);

    final appeal = find.byType(VitCtaButton);
    final appealText = find.text('Gửi kháng cáo');
    expect(appealText, findsOneWidget);
    await tester.ensureVisible(appealText);
    await tester.tap(appealText);
    await tester.pumpAndSettle();
    expect(find.text('Gửi kháng cáo'), findsAtLeastNWidgets(1));

    // Xác nhận trong sheet → trạng thái chuyển sang đã ghi nhận.
    await tester.tap(find.byType(VitCtaButton).last);
    await tester.pumpAndSettle();
    expect(find.text('Đã ghi nhận kháng cáo'), findsOneWidget);
    expect(appeal, findsWidgets);
  });

  testWidgets('Trust/Resolution/Safety render workspace đầy đủ', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const ArenaTrustBreakdownTabletPage(userId: 'cr001'),
    );
    expect(find.text('Chỉ số độ tin cậy'), findsOneWidget);

    await pumpPage(tester, const ArenaResolutionCenterTabletPage());
    expect(find.text('Trung tâm phân xử'), findsOneWidget);
    expect(find.text('Báo cáo của tôi'), findsAtLeastNWidgets(1));

    await pumpPage(tester, const ArenaSafetyCenterTabletPage());
    expect(find.text('Quy tắc cộng đồng'), findsWidgets);
    expect(find.text('Quy trình xử lý vi phạm'), findsOneWidget);
    expect(find.text('Hành động báo cáo'), findsOneWidget);
  });
}
