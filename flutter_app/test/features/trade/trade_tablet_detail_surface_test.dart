import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_detail_surface.dart';

Widget _surface({Widget? footer}) => MaterialApp(
  home: Scaffold(
    body: TradeTabletDetailSurface(
      semanticLabel: 'Chuyển đổi tài sản trên tablet',
      semanticIdentifier: 'SC-056',
      title: 'Chuyển đổi tài sản',
      subtitle: 'Đổi tài sản · xem trước tỷ giá và phí',
      onBack: () {},
      primary: const Text('PRIMARY_CONTENT'),
      secondary: const Text('SECONDARY_CONTENT'),
      footer: footer,
    ),
  ),
);

void main() {
  testWidgets('hai cột + footer ghim render không overflow ở 1280x800', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_surface(footer: const Text('PINNED_FLOW_CTA')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('PRIMARY_CONTENT'), findsOneWidget);
    expect(find.text('SECONDARY_CONTENT'), findsOneWidget);
    final cta = tester.getRect(find.text('PINNED_FLOW_CTA'));
    expect(cta.bottom, greaterThan(700));
  });

  testWidgets('không truyền footer thì không render dải ghim', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_surface());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('PRIMARY_CONTENT'), findsOneWidget);
    expect(find.byType(Divider), findsNothing);
  });
}
