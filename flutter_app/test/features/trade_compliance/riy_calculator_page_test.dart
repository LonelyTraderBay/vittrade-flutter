import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/riy_calculator_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiyCalculator(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyRiyCalculator,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-106 mock repository exposes RIY calculator BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getRiyCalculator();

    expect(snapshot.investmentAmount, 10000);
    expect(snapshot.expectedReturnPct, 8);
    expect(snapshot.totalCostsPct, 4.5);
    expect(snapshot.holdingPeriodYears, 5);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-riy-calculator',
    );
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-106 renders RIY calculator in Trade shell', (tester) async {
    await pumpRiyCalculator(tester);

    expect(find.byType(RIYCalculatorPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('RIY Calculator'), findsOneWidget);
    expect(find.text('Cost Impact Analysis'), findsOneWidget);
    expect(find.text('Investment Parameters'), findsOneWidget);
    expect(find.text('Impact Analysis'), findsOneWidget);
    expect(find.text('€14,693'), findsOneWidget);
    expect(find.text('€11,877'), findsOneWidget);
    expect(find.text('-€2,816'), findsOneWidget);
  });

  testWidgets('SC-106 first viewport reaches investment input', (tester) async {
    await pumpRiyCalculator(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'RIYCalculatorPage',
      semanticLabel: 'Máy tính mức giảm lợi suất do chi phí (RIY)',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(RIYCalculatorPage.investmentKey),
      minVisibleHeight: 32,
      targetLabel: 'RIY investment input',
      reason:
          'RIY calculator should expose the first editable assumption above '
          'bottom navigation on the QA phone viewport.',
    );
  });

  testWidgets('SC-106 recalculates when cost input changes', (tester) async {
    await pumpRiyCalculator(tester);

    await tester.enterText(find.byKey(RIYCalculatorPage.totalCostsKey), '2');
    await tester.pumpAndSettle();

    expect(find.text('€14,693'), findsOneWidget);
    expect(find.text('€13,382'), findsOneWidget);
    expect(find.text('-€1,311'), findsOneWidget);
  });
}
