// VitTabletUtilityPage: trang placeholder tablet dùng chung — pump đủ nhánh
// build + flow xác nhận (CI coverage 2026-09-10: 71 dòng chưa phủ).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

const _facts = [
  VitTabletUtilityFact(label: 'Trạng thái', value: 'Đang chờ backend'),
  VitTabletUtilityFact(label: 'Bề mặt', value: 'Tablet'),
];

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    bool requiresConfirmation = false,
    String? actionLabel,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: VitTabletUtilityPage(
          semanticIdentifier: 'UT-TEST',
          title: 'Tiện ích thử nghiệm',
          subtitle: 'Kiểm tra khung trang utility',
          description: 'Mô tả ngắn về tiện ích đang chờ composition thật.',
          facts: _facts,
          actionLabel: actionLabel,
          requiresConfirmation: requiresConfirmation,
          confirmationTitle: 'Xác nhận thử nghiệm',
          confirmationMessage: 'Bạn có muốn tiếp tục thao tác này không?',
          onBack: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('render đủ header, facts và key nội dung', (tester) async {
    await pumpPage(tester, actionLabel: 'Tiếp tục');

    expect(find.byKey(const Key('UT-TEST-tablet-content')), findsOneWidget);
    expect(find.text('Tiện ích thử nghiệm'), findsOneWidget);
    expect(find.text('Trạng thái'), findsOneWidget);
    expect(find.text('Đang chờ backend'), findsOneWidget);
    expect(find.byKey(const Key('UT-TEST-tablet-action')), findsOneWidget);
  });

  testWidgets('requiresConfirmation=false: action mở notice sheet', (
    tester,
  ) async {
    await pumpPage(tester, actionLabel: 'Tiếp tục');

    await tester.tap(find.byKey(const Key('UT-TEST-tablet-action')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('UT-TEST-tablet-confirm-sheet')), findsNothing);
    expect(find.text('Đã mở thao tác'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'requiresConfirmation=true: action mở sheet, cancel/confirm hoạt động',
    (tester) async {
      await pumpPage(
        tester,
        actionLabel: 'Kích hoạt',
        requiresConfirmation: true,
      );

      await tester.tap(find.byKey(const Key('UT-TEST-tablet-action')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('UT-TEST-tablet-confirm-sheet')),
        findsOneWidget,
      );
      expect(find.text('Xác nhận thử nghiệm'), findsOneWidget);
      expect(find.byKey(const Key('UT-TEST-tablet-cancel')), findsOneWidget);

      await tester.tap(find.byKey(const Key('UT-TEST-tablet-cancel')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('UT-TEST-tablet-confirm-sheet')),
        findsNothing,
      );

      await tester.tap(find.byKey(const Key('UT-TEST-tablet-action')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('UT-TEST-tablet-confirm')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('UT-TEST-tablet-confirm-sheet')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
