import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_input_states.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: ListView(children: [child])),
  );
}

VitMarketPairRow _row({VoidCallback? onTap}) {
  return VitMarketPairRow(
    leading: const Icon(Icons.currency_bitcoin_rounded),
    title: 'BTC/USDT',
    subtitle: 'Bitcoin',
    price: '117.240,20',
    changeLabel: '+1,24%',
    trend: VitTrendDirection.positive,
    showSparkline: false,
    onTap: onTap,
  );
}

void main() {
  testWidgets('pair row tương tác được mang token hover/focus', (tester) async {
    await tester.pumpWidget(_wrap(_row(onTap: () {})));

    final inkWell = tester.widget<InkWell>(find.byType(InkWell));
    expect(inkWell.hoverColor, AppInputStates.hoverOverlay);
    expect(inkWell.focusColor, AppInputStates.focusOverlay);
  });

  testWidgets('pair row tĩnh không có lớp tương tác ink', (tester) async {
    await tester.pumpWidget(_wrap(_row()));

    expect(find.byType(InkWell), findsNothing);
  });
}
