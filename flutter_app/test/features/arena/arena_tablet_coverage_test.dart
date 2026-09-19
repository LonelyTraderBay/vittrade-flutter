import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bổ sung coverage cho cụm tablet Arena sau redesign 2026-09-19 (giữ sàn
/// 92.0% DEC-coverage): pump toàn bộ trang workspace ở tầng HẸP để phủ
/// nhánh narrowChildren của VitTabletPaneWorkspace, và các tương tác form
/// còn thiếu (filter chips, toggles, hành động máy tạo thử thách).
void main() {
  tearDown(() => TabletSpacingTokens.tabletSurfaceActive = false);

  // 600dp < paneWorkspaceSplitMinWidth (~704dp) → nhánh narrow 1 cột.
  Future<void> pumpNarrow(WidgetTester tester, Widget page) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(600, 900);
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
                path: '/arena/challenge/:challengeId',
                builder: (_, _) => const Text('challenge-opened'),
              ),
              GoRoute(
                path: '/arena/report/:caseId',
                builder: (_, _) => const Text('report-opened'),
              ),
              GoRoute(
                path: '/arena/ledger/entry/:entryId',
                builder: (_, _) => const Text('entry-opened'),
              ),
              GoRoute(
                path: '/arena/mode/:modeId',
                builder: (_, _) => const Text('mode-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Cuộn qua lại để dựng toàn bộ narrow children (phủ tối đa nhánh hẹp).
    final scrollable = find.byType(Scrollable);
    if (scrollable.evaluate().isNotEmpty) {
      await tester.drag(scrollable.first, const Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.drag(scrollable.first, const Offset(0, 400));
      await tester.pumpAndSettle();
    }
  }

  testWidgets('narrow: cụm play 4 trang render 1 cột không vỡ', (tester) async {
    await pumpNarrow(
      tester,
      const ArenaModeDetailTabletPage(modeId: 'mode001'),
    );
    expect(tester.takeException(), isNull);

    await pumpNarrow(
      tester,
      const ArenaChallengeDetailTabletPage(challengeId: 'ch003'),
    );
    expect(find.text('Tham gia thử thách'), findsWidgets);

    await pumpNarrow(tester, const ArenaJoinTabletPage(challengeId: 'ch003'));
    expect(find.text('Xác nhận tham gia'), findsWidgets);

    await pumpNarrow(tester, const ArenaCreatorTabletPage(creatorId: 'cr001'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow: cụm studio + gate 4 trang render 1 cột', (tester) async {
    await pumpNarrow(tester, const ArenaSmartRulesTabletPage());
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const ArenaPresetLibraryTabletPage());
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const ArenaGovernanceGateTabletPage());
    expect(find.text('Gửi duyệt quản trị'), findsWidgets);

    await pumpNarrow(tester, const VerifiedChallengesTabletPage());
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow: cụm governance 6 trang render 1 cột', (tester) async {
    await pumpNarrow(tester, const ArenaResolutionCenterTabletPage());
    expect(tester.takeException(), isNull);

    await pumpNarrow(
      tester,
      const ArenaTrustBreakdownTabletPage(userId: 'cr001'),
    );
    expect(find.text('Báo cáo vi phạm'), findsWidgets);

    // Nhánh creator không tồn tại của trust breakdown.
    await pumpNarrow(tester, const ArenaTrustBreakdownTabletPage(userId: 'xx'));
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const ArenaBlockedUsersTabletPage());
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const MyArenaReportsTabletPage());
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const ArenaReportCaseTabletPage(caseId: 'rpt001'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow: cụm points/utility 6 trang render 1 cột', (
    tester,
  ) async {
    await pumpNarrow(tester, const ArenaPointsLedgerTabletPage());
    expect(find.text('Biến động điểm'), findsOneWidget);

    await pumpNarrow(
      tester,
      const ArenaPointsEntryDetailTabletPage(entryId: 'nonexistent'),
    );
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const ArenaFlowMapTabletPage());
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const ArenaProductionReadyTabletPage());
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const ArenaPredictionBridgeTabletPage());
    expect(tester.takeException(), isNull);

    await pumpNarrow(tester, const ArenaEcosystemTabletPage());
    expect(tester.takeException(), isNull);
  });

  testWidgets('smart rules: chọn đủ nhóm chip + toggle + hành vi máy tạo', (
    tester,
  ) async {
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
              GoRoute(
                path: '/hub',
                builder: (_, _) => const ArenaSmartRulesTabletPage(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Nhập tên + chọn lần lượt chip đầu của mọi nhóm lựa chọn.
    await tester.enterText(
      find.byType(TextField).first,
      'Thử thách coverage test',
    );
    final chips = find.byType(VitFilterChip);
    expect(chips, findsWidgets);
    // Chip nằm rải rác trong scroll — bấm tuần tự từng chip đang thấy được.
    for (var i = 0; i < 10 && i < chips.evaluate().length; i++) {
      await tester.ensureVisible(chips.at(i));
      await tester.pumpAndSettle();
      await tester.tap(chips.at(i));
      await tester.pumpAndSettle();
    }

    // Toggle rematch + saveAsMode.
    final rematch = find.textContaining('tái đấu');
    if (rematch.evaluate().isNotEmpty) {
      await tester.ensureVisible(rematch);
      await tester.tap(rematch);
      await tester.pumpAndSettle();
    }
    final saveMode = find.textContaining('Lưu thành chế độ');
    if (saveMode.evaluate().isNotEmpty) {
      await tester.ensureVisible(saveMode);
      await tester.tap(saveMode);
      await tester.pumpAndSettle();
    }

    // Hành động máy tạo: kiểm tra luật + xem trước payload + lưu nháp.
    for (final label in [
      'Kiểm tra luật',
      'Xem trước payload',
      'Lưu bản nháp',
    ]) {
      final target = find.text(label);
      await tester.ensureVisible(target);
      await tester.tap(target);
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('my reports + ledger: duyệt mọi filter chip', (tester) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> pump(Widget page) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/hub',
              routes: [GoRoute(path: '/hub', builder: (_, _) => page)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pump(const MyArenaReportsTabletPage());
    var chips = find.byType(VitFilterChip);
    for (var i = 0; i < chips.evaluate().length; i++) {
      await tester.ensureVisible(chips.at(i));
      await tester.pumpAndSettle();
      await tester.tap(chips.at(i));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);

    await pump(const ArenaPointsLedgerTabletPage());
    chips = find.byType(VitFilterChip);
    for (var i = 0; i < chips.evaluate().length; i++) {
      await tester.ensureVisible(chips.at(i));
      await tester.pumpAndSettle();
      await tester.tap(chips.at(i));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });
  testWidgets('points/utility: tap các ListTile + CTA secondary', (
    tester,
  ) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> pump(Widget page) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/hub',
              routes: [
                GoRoute(path: '/hub', builder: (_, _) => page),
                GoRoute(
                  path: '/arena/challenge/:challengeId',
                  builder: (_, _) => const Text('challenge-opened'),
                ),
                GoRoute(
                  path: '/arena/mode/:modeId',
                  builder: (_, _) => const Text('mode-opened'),
                ),
                GoRoute(
                  path: '/rewards',
                  builder: (_, _) => const Text('rewards-opened'),
                ),
                GoRoute(
                  path: '/arena/ledger',
                  builder: (_, _) => const Text('ledger-opened'),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> tapFirstTile() async {
      final tiles = find.byType(ListTile);
      if (tiles.evaluate().isNotEmpty) {
        await tester.ensureVisible(tiles.first);
        await tester.pumpAndSettle();
        await tester.tap(tiles.first);
        await tester.pumpAndSettle();
      }
    }

    await pump(const ArenaFlowMapTabletPage());
    await tapFirstTile();
    expect(tester.takeException(), isNull);

    await pump(const ArenaProductionReadyTabletPage());
    await tapFirstTile();
    expect(tester.takeException(), isNull);

    await pump(const ArenaEcosystemTabletPage());
    await tapFirstTile();
    expect(tester.takeException(), isNull);

    await pump(const ArenaPredictionBridgeTabletPage());
    await tapFirstTile();
    expect(tester.takeException(), isNull);

    // Ledger: bấm CTA nhiệm vụ nhận điểm (push rewards) và về sổ điểm từ entry.
    await pump(const ArenaPointsLedgerTabletPage());
    final rewardsCta = find.text('Nhiệm vụ nhận điểm');
    await tester.ensureVisible(rewardsCta);
    await tester.tap(rewardsCta);
    await tester.pumpAndSettle();
    expect(find.text('rewards-opened'), findsOneWidget);

    await pump(const ArenaPointsEntryDetailTabletPage(entryId: 'nonexistent'));
    final backLedger = find.text('Về sổ điểm');
    await tester.ensureVisible(backLedger);
    await tester.tap(backLedger);
    await tester.pumpAndSettle();
    expect(find.text('ledger-opened'), findsWidgets);
  });

  testWidgets('play detail: tap phòng/mode liên quan + CTA hub/trust', (
    tester,
  ) async {
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
              GoRoute(
                path: '/hub',
                builder: (_, _) =>
                    const ArenaModeDetailTabletPage(modeId: 'mode001'),
              ),
              GoRoute(
                path: '/arena/challenge/:challengeId',
                builder: (_, _) => const Text('challenge-opened'),
              ),
              GoRoute(
                path: '/arena/mode/:modeId',
                builder: (_, _) => const Text('mode-opened'),
              ),
              GoRoute(
                path: '/arena/trust/:userId',
                builder: (_, _) => const Text('trust-opened'),
              ),
              GoRoute(
                path: '/arena',
                builder: (_, _) => const Text('arena-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Phòng đấu theo chế độ: tap tile đầu (nếu có).
    final rooms = find.byType(ListTile);
    if (rooms.evaluate().isNotEmpty) {
      await tester.ensureVisible(rooms.first);
      await tester.tap(rooms.first);
      await tester.pumpAndSettle();
    }

    // CTA về hub.
    final hubCta = find.text('Về hub Open Arena');
    await tester.ensureVisible(hubCta);
    await tester.tap(hubCta);
    await tester.pumpAndSettle();
    expect(find.text('arena-opened'), findsOneWidget);
  });

  testWidgets('report case: CTA thử thách liên quan + quick links', (
    tester,
  ) async {
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
              GoRoute(
                path: '/hub',
                builder: (_, _) =>
                    const ArenaReportCaseTabletPage(caseId: 'rpt001'),
              ),
              GoRoute(
                path: '/arena/challenge/:challengeId',
                builder: (_, _) => const Text('challenge-opened'),
              ),
              GoRoute(
                path: '/arena/my-reports',
                builder: (_, _) => const Text('reports-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final linked = find.text('Xem thử thách liên quan');
    if (linked.evaluate().isNotEmpty) {
      await tester.ensureVisible(linked);
      await tester.tap(linked);
      await tester.pumpAndSettle();
      expect(find.text('challenge-opened'), findsOneWidget);
    }

    // Pump lại trang hồ sơ (đã push sang thử thách) để tiếp tục tương tác.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/hub',
            routes: [
              GoRoute(
                path: '/hub',
                builder: (_, _) =>
                    const ArenaReportCaseTabletPage(caseId: 'rpt001'),
              ),
              GoRoute(
                path: '/arena/my-reports',
                builder: (_, _) => const Text('reports-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final allReports = find.text('Tất cả báo cáo');
    await tester.ensureVisible(allReports);
    await tester.tap(allReports);
    await tester.pumpAndSettle();
    expect(find.text('reports-opened'), findsOneWidget);
  });
  testWidgets('challenge: chuyển đủ 4 tab + narrow join ack đến sheet', (
    tester,
  ) async {
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
              GoRoute(
                path: '/hub',
                builder: (_, _) =>
                    const ArenaChallengeDetailTabletPage(challengeId: 'ch003'),
              ),
              GoRoute(
                path: '/arena/join/:challengeId',
                builder: (_, _) =>
                    const ArenaJoinTabletPage(challengeId: 'ch003'),
              ),
              GoRoute(
                path: '/arena/challenge/:challengeId',
                builder: (_, _) => const Text('challenge-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Chuyệt lần lượt 4 tab.
    for (final tab in ['Bằng chứng', 'Thành viên', 'Hoạt động', 'Luật chơi']) {
      final target = find.text(tab).first;
      await tester.ensureVisible(target);
      await tester.tap(target);
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);

    // Vào join từ CTA rồi ack + xác nhận trong narrow.
    tester.view.physicalSize = const Size(600, 900);
    await tester.pumpAndSettle();
    final joinCta = find.byKey(ArenaChallengeDetailTabletPage.joinCtaKey);
    await tester.ensureVisible(joinCta);
    await tester.tap(joinCta);
    await tester.pumpAndSettle();

    final rules = find.byKey(ArenaJoinTabletPage.rulesCheckboxKey);
    final points = find.byKey(ArenaJoinTabletPage.pointsCheckboxKey);
    await tester.ensureVisible(rules);
    await tester.tap(rules);
    await tester.pumpAndSettle();
    await tester.ensureVisible(points);
    await tester.tap(points);
    await tester.pumpAndSettle();

    final confirm = find.byKey(ArenaJoinTabletPage.confirmKey);
    await tester.ensureVisible(confirm);
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận vào thử thách'), findsOneWidget);
    await tester.tap(find.text('Xác nhận vào thử thách'));
    await tester.pumpAndSettle();
    expect(find.text('challenge-opened'), findsOneWidget);
  });

  testWidgets('smart rules: chip thứ hai mỗi nhóm + gợi ý tên + luật tự viết', (
    tester,
  ) async {
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
              GoRoute(
                path: '/hub',
                builder: (_, _) => const ArenaSmartRulesTabletPage(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Nhập cả 3 ô nhập (tên / luật tự viết / mô tả).
    final fields = find.byType(TextField);
    expect(fields, findsAtLeastNWidgets(3));
    await tester.enterText(fields.at(0), 'Challenge coverage 2');
    await tester.pumpAndSettle();
    await tester.ensureVisible(fields.at(1));
    await tester.enterText(
      fields.at(1),
      'Giá BTC vượt mốc 100k vào cuối tháng',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(fields.at(2));
    await tester.enterText(fields.at(2), 'Mô tả coverage');
    await tester.pumpAndSettle();

    // Duyệt và bấm chip thứ hai của mỗi nhóm đang thấy được.
    final chips = find.byType(VitFilterChip);
    for (var i = 0; i < chips.evaluate().length; i++) {
      await tester.ensureVisible(chips.at(i));
      await tester.pumpAndSettle();
      await tester.tap(chips.at(i));
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('governance narrow: mở chặn + bấm hồ sơ báo cáo', (tester) async {
    TabletSpacingTokens.tabletSurfaceActive = true;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(600, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/hub',
            routes: [
              GoRoute(
                path: '/hub',
                builder: (_, _) => const ArenaBlockedUsersTabletPage(),
              ),
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

    final unblock = find.text('Mở chặn');
    if (unblock.evaluate().isNotEmpty) {
      await tester.ensureVisible(unblock.first);
      await tester.tap(unblock.first);
      await tester.pumpAndSettle();
      expect(find.text('Mở chặn người chơi'), findsOneWidget);
      await tester.tap(find.text('Mở chặn').last);
      await tester.pumpAndSettle();
    }

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/hub',
            routes: [
              GoRoute(
                path: '/hub',
                builder: (_, _) => const MyArenaReportsTabletPage(),
              ),
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
    final rows = find.textContaining('Cập nhật');
    if (rows.evaluate().isNotEmpty) {
      await tester.ensureVisible(rows.first);
      await tester.tap(rows.first);
      await tester.pumpAndSettle();
      expect(find.text('report-opened'), findsOneWidget);
    }
  });
}
