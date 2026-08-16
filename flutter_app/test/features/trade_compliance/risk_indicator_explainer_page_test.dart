import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/disclosures/risk_indicator_explainer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskIndicator(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyRiskIndicatorExplainer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-110 mock repository exposes risk indicator BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getRiskIndicatorExplainer();

    expect(snapshot.productName, 'Mirror Copy Trading');
    expect(snapshot.productSri, 6);
    expect(snapshot.holdingPeriodYears, 3);
    expect(snapshot.levels, hasLength(7));
    expect(snapshot.levels[5].label, 'High Risk');
    expect(snapshot.levels[5].examples, contains('Copy trading'));
    expect(snapshot.additionalRisks.map((risk) => risk.title), [
      'Provider Risk',
      'Liquidity Risk',
      'Operational Risk',
    ]);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-risk-indicator-explainer',
    );
    expect(snapshot.actionDraft, contains('POST /copy-trading/follow'));
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

  testWidgets('SC-110 renders risk indicator in Trade shell', (tester) async {
    await pumpRiskIndicator(tester);

    expect(find.byType(RiskIndicatorExplainerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Risk Indicator'), findsOneWidget);
    expect(find.text('Summary Risk Indicator (SRI)'), findsOneWidget);
    expect(find.text('Mirror Copy Trading'), findsOneWidget);
    expect(find.text('Summary Risk Indicator'), findsOneWidget);
    expect(find.byKey(RiskIndicatorExplainerPage.levelKey(6)), findsOneWidget);
    expect(find.text('THIS PRODUCT'), findsOneWidget);
    expect(find.text('Provider Risk'), findsOneWidget);
    expect(find.text('Operational Risk'), findsOneWidget);
  });

  testWidgets('SC-110 first viewport reaches risk scale details', (
    tester,
  ) async {
    await pumpRiskIndicator(tester);

    await tester.scrollUntilVisible(
      find.byKey(RiskIndicatorExplainerPage.levelKey(1)),
      120,
      scrollable: find
          .descendant(
            of: find.byType(RiskIndicatorExplainerPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );

    expectFirstViewportVisible(
      tester,
      find.byKey(RiskIndicatorExplainerPage.levelKey(1)),
      targetLabel: 'the first risk scale level',
    );
  });
}
