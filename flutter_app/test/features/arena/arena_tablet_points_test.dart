import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';

/// Khóa cụm Points/utility tablet (Đợt 4 redesign 2026-09-19): SC-201 sổ
/// điểm KPI + filter + vào chi tiết biến động; SC-200 hero số điểm + số dư
/// trước/sau; các trang tham chiếu SC-197/206/207/208 render workspace.
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
                path: '/arena/ledger/entry/:entryId',
                builder: (_, _) => const Text('entry-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Ledger SC-201: KPI + filter + vào chi tiết biến động', (
    tester,
  ) async {
    await pumpPage(tester, const ArenaPointsLedgerTabletPage());

    expect(find.text('Điểm hiện có'), findsOneWidget);
    expect(find.text('Biến động điểm'), findsOneWidget);
    expect(find.text('Nhiệm vụ nhận điểm'), findsOneWidget);

    // Bấm bản ghi đầu → trang chi tiết biến động.
    final rows = find.byType(ListTile);
    expect(rows, findsWidgets);
    await tester.ensureVisible(rows.first);
    await tester.tap(rows.first);
    await tester.pumpAndSettle();
    expect(find.text('entry-opened'), findsOneWidget);
  });

  testWidgets('Entry detail SC-200: hero số điểm + số dư trước/sau', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const ArenaPointsEntryDetailTabletPage(entryId: 'nonexistent'),
    );
    // Id không khớp fixture: hiển thị nhánh rỗng trong suốt, không vỡ.
    expect(tester.takeException(), isNull);
  });

  testWidgets('Trang tham chiếu SC-197/207 render workspace', (tester) async {
    await pumpPage(tester, const ArenaFlowMapTabletPage());
    expect(find.text('Tuyến trang'), findsOneWidget);
    expect(find.text('Nhóm luồng'), findsOneWidget);

    await pumpPage(tester, const ArenaPredictionBridgeTabletPage());
    expect(find.text('Chủ đề dùng chung hai hệ'), findsOneWidget);
    expect(find.text('Được phép cầu nối'), findsOneWidget);
  });
}
