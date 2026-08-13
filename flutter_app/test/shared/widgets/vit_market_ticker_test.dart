import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
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
  testWidgets('VitMarketTickerStrip renders trends and dispatches taps', (
    tester,
  ) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        VitMarketTickerStrip(
          items: [
            VitMarketTickerData(
              title: 'BTC/USDT',
              price: '\$68,000.00',
              changeLabel: '+2.10%',
              trend: VitTrendDirection.positive,
              onTap: () => taps++,
            ),
            const VitMarketTickerData(
              title: 'ETH/USDT',
              price: '\$3,400.00',
              changeLabel: '-1.20%',
              trend: VitTrendDirection.negative,
            ),
          ],
        ),
      ),
    );

    expect(find.text('BTC/USDT'), findsOneWidget);
    expect(find.text('-1.20%'), findsOneWidget);

    await tester.tap(find.text('BTC/USDT'));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('VitMarketTickerStrip supports a compact card gap', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const VitMarketTickerStrip(
          itemGap: AppSpacing.x2,
          items: [
            VitMarketTickerData(
              title: 'BTC/USDT',
              price: '\$68,000.00',
              changeLabel: '+2.10%',
              trend: VitTrendDirection.positive,
            ),
            VitMarketTickerData(
              title: 'ETH/USDT',
              price: '\$3,400.00',
              changeLabel: '-1.20%',
              trend: VitTrendDirection.negative,
            ),
          ],
        ),
      ),
    );

    final firstCard = tester.getRect(find.byType(VitMarketTickerCard).at(0));
    final secondCard = tester.getRect(find.byType(VitMarketTickerCard).at(1));

    expect(secondCard.left - firstCard.right, closeTo(AppSpacing.x2, 0.01));
  });
}
