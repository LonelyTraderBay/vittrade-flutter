import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_pane_workspace.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  // Bố cục host: ép width đúng tầng để LayoutBuilder của workspace rơi vào
  // nhánh mong muốn — height bounded do Scaffold body stretch.
  Widget host(double width) {
    return MaterialApp(
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            height: 600,
            child: const VitTabletPaneWorkspace(
              contentKey: Key('workspace_primary'),
              secondaryContentKey: Key('workspace_secondary'),
              primaryChildren: [Text('Nội dung chính')],
              secondaryChildren: [Text('Panel phụ')],
              narrowChildren: [Text('Cột hẹp')],
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('pane rộng: 2 cột scroll độc lập, panel đóng khung 320dp', (
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
      320,
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

  testWidgets('ngưỡng tách: đúng 720dp là 2 cột, dưới 1dp là một cột', (
    tester,
  ) async {
    await tester.pumpWidget(host(720));
    await tester.pumpAndSettle();
    expect(find.byType(Scrollable), findsNWidgets(2));

    await tester.pumpWidget(host(719.9));
    await tester.pumpAndSettle();
    expect(find.byType(Scrollable), findsOneWidget);
    expect(find.text('Cột hẹp'), findsOneWidget);
  });
}
