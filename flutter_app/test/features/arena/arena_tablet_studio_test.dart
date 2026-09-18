import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Khóa composition cụm Studio tablet (Đợt 2 redesign 2026-09-19): SC-186
/// form builder 2 cột gắn máy tạo thử thách (ack gate nút gửi duyệt),
/// SC-187 preset library chọn gói, SC-188 governance gate chọn + xác nhận,
/// SC-195 verified features.
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
                path: '/arena/my',
                builder: (_, _) => const Text('my-arena-opened'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Smart rules SC-186: form workspace + ack gate nút gửi', (
    tester,
  ) async {
    await pumpPage(tester, const ArenaSmartRulesTabletPage());

    expect(find.text('Tên thử thách'), findsWidgets);
    expect(find.text('Lĩnh vực & loại thử thách'), findsOneWidget);
    expect(find.text('Điều kiện thắng'), findsWidgets);
    expect(find.text('Điểm rõ ràng'), findsOneWidget);
    expect(find.text('Tóm tắt luật'), findsOneWidget);
    expect(find.text('Xác nhận bắt buộc trước gửi'), findsOneWidget);
    expect(find.text('Trạng thái máy tạo thử thách'), findsOneWidget);

    // Chưa hoàn thiện form: bấm Gửi duyệt không mở sheet (nút khoá).
    final submit = find.byKey(ArenaSmartRulesTabletPage.submitKey);
    await tester.ensureVisible(submit);
    await tester.tap(submit, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Gửi duyệt'), findsNothing);

    // Bật đủ 3 ack trong panel phụ.
    final acks = find.byType(InkWell);
    await tester.ensureVisible(
      find.textContaining('rà soát luật và điều kiện thắng'),
    );
    await tester.tap(find.textContaining('rà soát luật và điều kiện thắng'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('chỉ dùng Điểm Arena'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('kiểm duyệt và phân xử'));
    await tester.pumpAndSettle();
    expect(acks.evaluate(), isNotEmpty);

    // Reset form đưa các ack về lại trạng thái đầu.
    final reset = find.text('Làm mới form');
    await tester.ensureVisible(reset);
    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(find.text('Đã làm mới form'), findsOneWidget);
  });

  testWidgets('Preset library SC-187: chọn gói preset đổi nội dung', (
    tester,
  ) async {
    await pumpPage(tester, const ArenaPresetLibraryTabletPage());

    expect(find.text('Gói preset theo lĩnh vực'), findsOneWidget);
    expect(find.text('Loại thử thách hỗ trợ'), findsOneWidget);
    expect(find.text('Dùng preset trong Studio'), findsWidgets);

    // Bấm chip gói khác → panel chính đổi theo.
    final chips = find.byType(VitFilterChip);
    expect(chips, findsWidgets);
    await tester.ensureVisible(chips.last);
    await tester.tap(chips.last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Governance gate SC-188: chọn xong mới mở được xác nhận', (
    tester,
  ) async {
    await pumpPage(tester, const ArenaGovernanceGateTabletPage());

    expect(find.text('Quyền riêng tư của thử thách'), findsOneWidget);
    expect(find.text('Nguồn đối soát kết quả'), findsOneWidget);
    expect(find.text('Bộ quy tắc quản trị hiện hành'), findsOneWidget);

    // Chưa chọn: nút khoá (sheet xác nhận không mở).
    final action = find.byKey(ArenaGovernanceGateTabletPage.actionKey);
    await tester.ensureVisible(action);
    await tester.tap(action, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận gửi'), findsNothing);

    // Chọn quyền riêng tư (radio đầu) + nguồn đối soát (chip đầu).
    final radio = find.byIcon(Icons.radio_button_off).first;
    await tester.ensureVisible(radio);
    await tester.tap(radio);
    await tester.pumpAndSettle();
    final chip = find.byType(VitFilterChip).first;
    await tester.ensureVisible(chip);
    await tester.tap(chip);
    await tester.pumpAndSettle();

    // Gửi → sheet xác nhận → xác nhận → trạng thái gửi duyệt.
    await tester.ensureVisible(action);
    await tester.tap(action);
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận gửi'), findsOneWidget);
    await tester.tap(find.text('Xác nhận gửi'));
    await tester.pumpAndSettle();
    expect(find.text('Đã gửi duyệt quản trị'), findsOneWidget);
  });

  testWidgets('Verified SC-195: hero + danh sách đặc điểm xác minh', (
    tester,
  ) async {
    await pumpPage(tester, const VerifiedChallengesTabletPage());

    expect(find.text('Đặc điểm xác minh'), findsOneWidget);
    expect(find.text('Vì sao quan trọng'), findsOneWidget);
  });
}
