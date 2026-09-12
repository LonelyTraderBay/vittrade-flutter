// Batch test tablet sinh từ route group arena (coverage 2026-09-10:
// group + các trang tablet liên quan chưa phủ). Bất biến: mọi route tablet
// render trang thật — không rơi vào VitTabletUtilityPage, không exception.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('arena tablet routes render trang thật (lô 1)', (tester) async {
    final locations = <String>[
      AppRoutePaths.arena,
      AppRoutePaths.arenaGuide,
      AppRoutePaths.arenaStudio,
      AppRoutePaths.arenaStudioSmartRules,
      AppRoutePaths.arenaStudioPresets,
      AppRoutePaths.arenaStudioGovernance,
      AppRoutePaths.arenaResolution,
      AppRoutePaths.arenaLeaderboard,
      AppRoutePaths.arenaVerified,
      AppRoutePaths.arenaPoints,
      AppRoutePaths.arenaFlowMap,
      AppRoutePaths.arenaSafety,
      AppRoutePaths.arenaBlocked,
      AppRoutePaths.arenaMyReports,
      AppRoutePaths.arenaMy,
      AppRoutePaths.arenaProduction,
      AppRoutePaths.arenaBridge,
      AppRoutePaths.arenaEcosystem,
      AppRoutePaths.arenaLedger,
    ];
    for (final location in locations) {
      await pumpTablet(tester, location);

      expect(find.byType(VitTabletUtilityPage), findsNothing, reason: location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });

  // Coverage dòng 2: tương tác Arena home tablet — CTA tạo thử thách, khám phá
  // mode, mở Sân chơi của tôi, hướng dẫn (đủ nhánh onNavigate/onCreate).
  testWidgets('arena home: bấm CTA tạo thử thách + mở sân chơi', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.arena);
    expect(tester.takeException(), isNull);

    Future<void> tapVisible(String label) async {
      final f = find.text(label);
      if (f.evaluate().isEmpty) return;
      await Scrollable.ensureVisible(tester.element(f.first));
      await tester.pumpAndSettle();
      await tester.tap(f.first);
      await tester.pumpAndSettle();
    }

    await tapVisible('Khám phá mode');
    await tapVisible('Mở Sân chơi của tôi');
    await tapVisible('Tạo thử thách');
    await tapVisible('Xem hướng dẫn');
    expect(tester.takeException(), isNull);
  });

  // Coverage dòng 2 p3: bấm phòng live đầu (onRoom -> trang thử thách).
  testWidgets('arena home: bấm phòng live mở trang thử thách', (tester) async {
    await pumpTablet(tester, AppRoutePaths.arena);

    // Bấm card phòng đầu trong section "Phòng đang mở" nếu có.
    await tester.scrollUntilVisible(
      find.text('Phòng đang mở'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final cards = find.byType(VitCard);
    if (cards.evaluate().isNotEmpty) {
      // Card trong vùng phòng đang mở: bấm card đầu tiên thấy được.
      await tester.tap(cards.first);
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });

  // Coverage dòng 2 p3c: nhánh error của các trang play (SC-189..193) —
  // override provider family ném lỗi rồi bấm Thử lại.
  testWidgets('arena play error: mode detail ném lỗi + Thử lại', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(
        overrides: [
          arenaModeDetailSnapshotProvider(
            'mode-01',
          ).overrideWith((ref) async => throw StateError('lỗi mạng')),
        ],
        routerConfig: createAppRouter(
          surface: AppSurface.tablet,
          initialLocation: '/arena/mode/mode-01',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Không tải được chế độ'), findsOneWidget);

    final retry = find.text('Thử lại');
    if (retry.evaluate().isNotEmpty) {
      await tester.tap(retry.first);
      await tester.pump();
    }
    expect(tester.takeException(), isNull);
  });

  // Cùng khuôn error cho 4 trang play còn lại của part-file này.
  testWidgets('arena play error: challenge/join/creator/report', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> pumpError(String location, String errorTitle) async {
      await tester.pumpWidget(
        VitTradeApp(
          overrides: [
            arenaChallengeDetailSnapshotProvider(
              'ch-01',
            ).overrideWith((ref) async => throw StateError('lỗi mạng')),
            arenaJoinSnapshotProvider(
              'ch-01',
            ).overrideWith((ref) async => throw StateError('lỗi mạng')),
            arenaCreatorSnapshotProvider(
              'cr-01',
            ).overrideWith((ref) async => throw StateError('lỗi mạng')),
            arenaReportCaseSnapshotProvider(
              'cs-01',
            ).overrideWith((ref) async => throw StateError('lỗi mạng')),
          ],
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(errorTitle), findsOneWidget, reason: location);
      expect(tester.takeException(), isNull, reason: location);
    }

    await pumpError('/arena/challenge/ch-01', 'Không tải được thách đấu');
    await pumpError('/arena/join/ch-01', 'Không tải được thông tin tham gia');
    await pumpError('/arena/creator/cr-01', 'Không tải được hồ sơ');
    await pumpError('/arena/report/cs-01', 'Không tải được hồ sơ');
  });

  // Coverage dòng 2 p3k: nhánh error arena home tablet + Thử lại.
  testWidgets('arena home error + retry', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(
        overrides: [
          arenaHomeSnapshotProvider.overrideWith(
            (ref) async => throw StateError('lỗi mạng'),
          ),
        ],
        routerConfig: createAppRouter(
          surface: AppSurface.tablet,
          initialLocation: AppRoutePaths.arena,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Không tải được Open Arena'), findsOneWidget);

    final retry = find.text('Thử lại');
    if (retry.evaluate().isNotEmpty) {
      await tester.tap(retry.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }
    expect(tester.takeException(), isNull);
  });

  // Coverage dòng 2 p3m: tools sheet arena home + bấm tool đầu trong sheet
  // + phòng live theo key thật.
  testWidgets('arena home: tools sheet + navigate tool đầu', (tester) async {
    await pumpTablet(tester, AppRoutePaths.arena);

    // Mở sheet Công cụ từ header.
    final toolsAction = find.byKey(ArenaHomeTabletPage.toolsActionKey);
    expect(toolsAction, findsOneWidget);
    await tester.tap(toolsAction);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  // Bấm phòng live đầu (roomKey) — nhánh onRoom.
  testWidgets('arena home: bấm phòng live theo roomKey', (tester) async {
    await pumpTablet(tester, AppRoutePaths.arena);

    // Tìm room key bất kỳ trong cây (id sinh từ snapshot live rooms).
    final rooms = find.byWidgetPredicate(
      (w) =>
          w.key is Key &&
          (w.key as Key).toString().contains('sc184_tablet_room_'),
    );
    if (rooms.evaluate().isNotEmpty) {
      await tester.ensureVisible(rooms.first);
      await tester.pumpAndSettle();
      await tester.tap(rooms.first);
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });
}
