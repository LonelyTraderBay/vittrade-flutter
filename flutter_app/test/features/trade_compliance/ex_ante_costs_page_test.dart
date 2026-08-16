import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/ex_ante_costs_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpExAnteCosts(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyExAnteCosts,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-105 mock repository exposes ex-ante costs BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getExAnteCosts();

    expect(snapshot.investmentAmount, 10000);
    expect(snapshot.oneOffCosts, 50);
    expect(snapshot.recurringCosts, 300);
    expect(snapshot.incidentalCosts, 100);
    expect(snapshot.totalFirstYear, 450);
    expect(snapshot.totalPercentage, 4.5);
    expect(snapshot.reductionInYield, 1.5);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-ex-ante-costs',
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

  testWidgets('SC-105 renders ex-ante costs in Trade shell', (tester) async {
    await pumpExAnteCosts(tester);

    expect(find.byType(ExAnteCostsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Cost Disclosure (Ex-Ante)'), findsOneWidget);
    expect(find.text('Before You Invest'), findsOneWidget);
    expect(find.text('PRIIPs Cost Disclosure'), findsOneWidget);
    expect(find.text('Example Investment Amount'), findsOneWidget);
    expect(find.text('€10,000'), findsOneWidget);
    expect(find.text('Cost Summary'), findsOneWidget);
    expect(find.text('€450'), findsOneWidget);
    expect(find.text('4.50%'), findsOneWidget);
  });

  testWidgets('SC-105 first viewport reaches cost summary content', (
    tester,
  ) async {
    await pumpExAnteCosts(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-105 ExAnteCostsPage',
      semanticLabel: 'Công bố chi phí dự kiến trước khi đầu tư',
    );
    expectFirstViewportVisible(
      tester,
      find.text('One-off Costs'),
      targetLabel: 'the first ex-ante cost summary row',
      minVisibleHeight: 18,
    );
  });

  testWidgets('SC-105 switches breakdown and scenarios tabs', (tester) async {
    await pumpExAnteCosts(tester);

    await tester.tap(find.byKey(ExAnteCostsPage.tabKey('breakdown')));
    await tester.pumpAndSettle();

    expect(find.text('Detailed Cost Breakdown'), findsOneWidget);
    expect(find.text('Entry Cost'), findsOneWidget);
    expect(find.text('Performance Fee'), findsOneWidget);

    await tester.tap(find.byKey(ExAnteCostsPage.tabKey('scenarios')));
    await tester.pumpAndSettle();

    expect(find.text('Cost Scenarios by Holding Period'), findsOneWidget);
    expect(find.text('3 Years'), findsOneWidget);
    expect(find.text('Total Costs Over 3 Years'), findsOneWidget);
    expect(find.text('€1,250'), findsOneWidget);
  });

  testWidgets('SC-105 wires outgoing RIY calculator edge', (tester) async {
    await pumpExAnteCosts(tester);

    await tester.drag(
      find.byKey(ExAnteCostsPage.contentKey),
      const Offset(0, -720),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExAnteCostsPage.riyKey));
    await tester.pumpAndSettle();

    expect(find.text('RIY Calculator'), findsOneWidget);
  });
}
