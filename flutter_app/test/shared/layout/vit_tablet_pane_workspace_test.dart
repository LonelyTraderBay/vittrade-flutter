import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_pane_workspace.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  // Bố cục host: ép width đúng tầng để LayoutBuilder của workspace rơi vào
  // nhánh mong muốn — height bounded do Scaffold body stretch.
  Widget host(double width, {Widget? banner}) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            height: 600,
            child: VitTabletPaneWorkspace(
              contentKey: const Key('workspace_primary'),
              secondaryContentKey: const Key('workspace_secondary'),
              banner: banner,
              primaryChildren: const [Text('Nội dung chính')],
              secondaryChildren: const [Text('Panel phụ')],
              narrowChildren: const [Text('Cột hẹp')],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('banner: khối ngang cố định TRÊN 2 cột, không cuộn theo cột', (
    tester,
  ) async {
    await tester.pumpWidget(host(840, banner: const Text('BANNER KPI')));
    await tester.pumpAndSettle();

    expect(find.text('BANNER KPI'), findsOneWidget);
    // Banner nằm ngoài 2 cột cuộn — vẫn đúng 2 Scrollable (R4 bất biến).
    expect(find.byType(Scrollable), findsNWidgets(2));
    final bannerRect = tester.getRect(find.text('BANNER KPI'));
    final primaryRect = tester.getRect(
      find.byKey(const Key('workspace_primary')),
    );
    expect(bannerRect.bottom, lessThan(primaryRect.top));
    expect(tester.takeException(), isNull);

    // Tầng hẹp: banner vẫn cố định trên cột cuộn duy nhất.
    await tester.pumpWidget(host(360, banner: const Text('BANNER KPI')));
    await tester.pumpAndSettle();
    expect(find.text('BANNER KPI'), findsOneWidget);
    expect(find.byType(Scrollable), findsOneWidget);
    expect(find.text('Cột hẹp'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pane rộng: 2 cột scroll độc lập, panel đóng khung 400dp', (
    tester,
  ) async {
    await tester.pumpWidget(host(840));
    await tester.pumpAndSettle();

    expect(find.text('Nội dung chính'), findsOneWidget);
    expect(find.text('Panel phụ'), findsOneWidget);
    expect(find.text('Cột hẹp'), findsNothing);
    // R4: mỗi cột một Scrollable riêng — không có scroll bọc cả Row.
    expect(find.byType(Scrollable), findsNWidgets(2));
    // R7: panel phụ đóng khung VitCard, đúng chiều rộng token.
    expect(
      find.descendant(
        of: find.byKey(const Key('workspace_secondary')),
        matching: find.byType(VitCard),
      ),
      findsOneWidget,
    );
    expect(
      tester.getSize(find.byKey(const Key('workspace_secondary'))).width,
      400,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('pane hẹp: fallback một cột theo narrowChildren của trang', (
    tester,
  ) async {
    await tester.pumpWidget(host(360));
    await tester.pumpAndSettle();

    expect(find.text('Cột hẹp'), findsOneWidget);
    expect(find.text('Nội dung chính'), findsNothing);
    expect(find.text('Panel phụ'), findsNothing);
    expect(find.byKey(const Key('workspace_secondary')), findsNothing);
    expect(find.byType(Scrollable), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ngưỡng tách: đúng 800dp là 2 cột, dưới 1dp là một cột', (
    tester,
  ) async {
    await tester.pumpWidget(host(800));
    await tester.pumpAndSettle();
    expect(find.byType(Scrollable), findsNWidgets(2));

    await tester.pumpWidget(host(799.9));
    await tester.pumpAndSettle();
    expect(find.byType(Scrollable), findsOneWidget);
    expect(find.text('Cột hẹp'), findsOneWidget);
  });

  testWidgets('tầng top-level rộng: cap cặp cột R5 — cột chính dừng ở 800dp', (
    tester,
  ) async {
    // Mở rộng surface test — host() dùng SizedBox nhưng viewport mặc định
    // 800dp sẽ bóp constraint (bài học: 444 = 800 − 24 − 320 − 12).
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(host(1400));
    await tester.pumpAndSettle();

    // Cặp cột bị cap 800 + 400 + 12 = 1212, căn giữa trong 1400 − 2×12
    // (1376 > 1212 → cap chạm).
    expect(
      tester.getSize(find.byKey(const Key('workspace_secondary'))).width,
      400,
    );
    expect(
      tester.getSize(find.byKey(const Key('workspace_primary'))).width,
      800,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('mép ngang 12dp do workspace sở hữu ở tầng hẹp (top-level)', (
    tester,
  ) async {
    await tester.pumpWidget(host(360));
    await tester.pumpAndSettle();

    final rect = tester.getRect(find.byKey(const Key('workspace_primary')));
    expect(rect.left, 12);
    expect(rect.right, 360 - 12);
  });
}
