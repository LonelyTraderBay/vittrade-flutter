import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';

/// Khóa luồng Financial Safety của SC-191 Join tablet (Đợt 1 redesign
/// 2026-09-19): ack bắt buộc gate nút xác nhận, sheet tổng kết điểm trước khi
/// vào thử thách, điều hướng sang trang thử thách sau xác nhận. Kèm tab + CTA
/// join của SC-190 và render workspace của SC-189/SC-193.
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
                path: '/arena/challenge/:challengeId',
                builder: (_, _) => const Text('challenge-opened'),
              ),
              GoRoute(
                path: '/arena/join/:challengeId',
                builder: (_, _) => const Text('join-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Join SC-191: ack gate + confirm sheet + điều hướng', (
    tester,
  ) async {
    await pumpPage(tester, const ArenaJoinTabletPage(challengeId: 'ch003'));

    expect(find.text('Số dư điểm'), findsOneWidget);
    expect(find.text('Xác nhận bắt buộc'), findsOneWidget);
    expect(find.text('Còn lại sau khi vào'), findsOneWidget);

    // Chưa ack: bấm confirm không mở sheet (nút đang khoá).
    final confirm = find.byKey(ArenaJoinTabletPage.confirmKey);
    await tester.ensureVisible(confirm);
    await tester.tap(confirm, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận tham gia thử thách'), findsNothing);

    // Ack đủ 2 điều kiện bắt buộc.
    final rules = find.byKey(ArenaJoinTabletPage.rulesCheckboxKey);
    final points = find.byKey(ArenaJoinTabletPage.pointsCheckboxKey);
    await tester.ensureVisible(rules);
    await tester.tap(rules);
    await tester.pumpAndSettle();
    await tester.ensureVisible(points);
    await tester.tap(points);
    await tester.pumpAndSettle();

    // Bấm confirm → sheet tổng kết Financial Safety.
    await tester.ensureVisible(confirm);
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận tham gia thử thách'), findsOneWidget);
    expect(find.text('Xác nhận vào thử thách'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Xác nhận vào thử thách'));
    await tester.pumpAndSettle();
    expect(find.text('challenge-opened'), findsOneWidget);
  });

  testWidgets('Challenge SC-190: điều khoản + chuyển tab + CTA join', (
    tester,
  ) async {
    await pumpPage(
      tester,
      const ArenaChallengeDetailTabletPage(challengeId: 'ch003'),
    );

    expect(find.text('Điều khoản'), findsOneWidget);
    expect(find.text('Luật chơi'), findsOneWidget);

    final membersTab = find.text('Thành viên');
    await tester.ensureVisible(membersTab);
    await tester.tap(membersTab);
    await tester.pumpAndSettle();
    expect(find.text('Đội tham gia'), findsOneWidget);

    final joinCta = find.byKey(ArenaChallengeDetailTabletPage.joinCtaKey);
    await tester.ensureVisible(joinCta);
    await tester.tap(joinCta);
    await tester.pumpAndSettle();
    expect(find.text('join-opened'), findsOneWidget);
  });

  testWidgets('Mode SC-189 + Creator SC-193 render workspace đầy đủ', (
    tester,
  ) async {
    await pumpPage(tester, const ArenaModeDetailTabletPage(modeId: 'mode001'));
    expect(find.text('Tóm tắt quy tắc'), findsOneWidget);
    expect(find.text('Chất lượng chế độ'), findsOneWidget);

    await pumpPage(tester, const ArenaCreatorTabletPage(creatorId: 'cr001'));
    expect(find.text('Chỉ số uy tín'), findsOneWidget);
  });
}
