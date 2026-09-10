// P2PTabletUtilityPage: biến thể P2P của khung utility tablet (CI coverage
// 2026-09-10: 67 dòng chưa phủ) — pump build + flow xác nhận.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart';

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    bool requiresConfirmation = false,
    String? actionLabel,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: P2PTabletUtilityPage(
          semanticIdentifier: 'P2P-UT-TEST',
          title: 'Tiện ích P2P thử nghiệm',
          subtitle: 'Kiểm tra khung utility P2P',
          description: 'Mô tả ngắn về tiện ích đang chờ composition thật.',
          facts: const [
            P2PTabletFact(label: 'Trạng thái', value: 'Đang chờ backend'),
            P2PTabletFact(label: 'Bề mặt', value: 'Tablet'),
          ],
          actionLabel: actionLabel,
          requiresConfirmation: requiresConfirmation,
          confirmationTitle: 'Xác nhận P2P',
          confirmationMessage: 'Bạn có muốn tiếp tục thao tác này không?',
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('render đủ nội dung và key', (tester) async {
    await pumpPage(tester, actionLabel: 'Tiếp tục');

    expect(find.byKey(const Key('P2P-UT-TEST-tablet-content')), findsOneWidget);
    expect(find.text('Tiện ích P2P thử nghiệm'), findsOneWidget);
    expect(find.text('Đang chờ backend'), findsOneWidget);
  });

  testWidgets('flow xác nhận mở sheet và đóng bằng cancel', (tester) async {
    await pumpPage(
      tester,
      actionLabel: 'Kích hoạt',
      requiresConfirmation: true,
    );

    await tester.tap(find.byKey(const Key('P2P-UT-TEST-tablet-action')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('P2P-UT-TEST-tablet-confirm-sheet')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('P2P-UT-TEST-tablet-cancel')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('P2P-UT-TEST-tablet-confirm-sheet')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });
}
