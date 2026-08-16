import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Finder semanticsWithLabel(Pattern pattern) {
  return find.byWidgetPredicate((widget) {
    if (widget is! Semantics) return false;
    final label = widget.properties.label;
    if (label == null) return false;
    return switch (pattern) {
      String() => label == pattern,
      RegExp() => pattern.hasMatch(label),
      _ => false,
    };
  });
}

Finder liveRegionSemantics() {
  return find.byWidgetPredicate((widget) {
    return widget is Semantics && widget.properties.liveRegion == true;
  });
}

void main() {
  testWidgets('loading skeleton announces its state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: VitSkeletonList(rows: 2))),
    );

    expect(semanticsWithLabel('Đang tải dữ liệu'), findsOneWidget);
    expect(liveRegionSemantics(), findsWidgets);
  });

  testWidgets('empty state is a live semantic container', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: VitEmptyState(title: 'Không có dữ liệu')),
      ),
    );

    expect(liveRegionSemantics(), findsWidgets);
    expect(find.text('Không có dữ liệu'), findsOneWidget);
  });

  testWidgets('error state uses Vietnamese defaults and live semantics', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: VitErrorState(onAction: () {})),
      ),
    );

    expect(find.text('Đã xảy ra lỗi'), findsOneWidget);
    expect(
      find.text('Vui lòng thử lại hoặc kiểm tra kết nối.'),
      findsOneWidget,
    );
    expect(find.text('Thử lại'), findsOneWidget);
    expect(liveRegionSemantics(), findsWidgets);
  });

  testWidgets('offline banner announces reconnecting state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: VitOfflineBanner(reconnecting: true)),
      ),
    );

    expect(find.text('Đang kết nối lại...'), findsOneWidget);
    expect(find.text('Đang tự động thử lại.'), findsOneWidget);
    expect(liveRegionSemantics(), findsWidgets);
  });

  testWidgets('submitting high-risk state announces processing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitHighRiskStatePanel(
            state: VitHighRiskUiState.submitting,
            title: 'Đang gửi lệnh',
            message: 'Vui lòng chờ kết quả xác nhận.',
          ),
        ),
      ),
    );

    expect(semanticsWithLabel('Đang xử lý'), findsOneWidget);
  });
}
