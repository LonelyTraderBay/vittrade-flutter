import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';

void main() {
  testWidgets('Phone router được giữ nguyên qua app rebuild', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const VitTradeApp());
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);

    await tester.tap(find.byKey(const Key('vit_bottom_nav_markets')));
    await tester.pumpAndSettle();
    expect(find.byType(MarketListPage), findsOneWidget);

    await tester.pumpWidget(const VitTradeApp());
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });
}
