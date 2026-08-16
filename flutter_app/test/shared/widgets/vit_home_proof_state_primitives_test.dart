import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('status and state primitives render shared Home-proof states', (
    tester,
  ) async {
    var retry = 0;

    await tester.pumpWidget(
      _wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VitStatusPill(
              label: 'Live',
              status: VitStatusPillStatus.success,
              pulse: true,
              count: 3,
            ),
            const SizedBox(height: 8),
            const VitSkeletonList(rows: 2),
            const SizedBox(height: 8),
            const VitEmptyState(title: 'No assets'),
            const SizedBox(height: 8),
            VitErrorState(onAction: () => retry++),
            const SizedBox(height: 8),
            const VitOfflineBanner(detail: 'Updated 2 minutes ago.'),
          ],
        ),
      ),
    );

    expect(find.text('Live'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('No assets'), findsOneWidget);
    expect(
      find.text('Ngoại tuyến. Đang hiển thị dữ liệu đã lưu gần nhất.'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.text('Thử lại'));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.text('Thử lại'));
    await tester.pump();

    expect(retry, 1);
  });
}
