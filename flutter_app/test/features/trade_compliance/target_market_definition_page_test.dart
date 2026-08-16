import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/governance/target_market_definition_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTargetMarketDefinition(
    WidgetTester tester, {
    String? initialLocation,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation:
                initialLocation ??
                AppRoutePaths.tradeCopyTargetMarketDefinition,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-101 mock repository exposes target market BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getTargetMarketDefinition();

    expect(snapshot.product.name, 'Mirror Copy Trading');
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-copy-trading-target-market-definition',
    );
    expect(snapshot.actionDraft, contains('POST /copy-trading/follow'));
    expect(snapshot.dimensions.map((dimension) => dimension.category), [
      'Client Type',
      'Knowledge & Experience',
      'Financial Situation',
      'Risk Tolerance',
      'Objectives',
      'Distribution Channel',
    ]);
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

  testWidgets('SC-101 renders target market definition in Trade shell', (
    tester,
  ) async {
    await pumpTargetMarketDefinition(tester);

    expect(find.byType(TargetMarketDefinitionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Target Market Definition'), findsOneWidget);
    expect(find.text('Mirror Copy Trading'), findsWidgets);
    expect(find.text('Target Market Criteria'), findsOneWidget);
    expect(find.text('Client Type'), findsOneWidget);
    expect(find.text('Retail (high knowledge)'), findsOneWidget);
    expect(find.text('Inexperienced retail'), findsOneWidget);
  });

  testWidgets('SC-101 first viewport reaches first target dimension', (
    tester,
  ) async {
    await pumpTargetMarketDefinition(tester);

    expectFirstViewportVisible(
      tester,
      find.byKey(TargetMarketDefinitionPage.dimensionKey('client-type')),
      targetLabel: 'the first target-market dimension',
      minVisibleHeight: 48,
    );
  });

  testWidgets('SC-101 accepts product-scoped navigation edge', (tester) async {
    await pumpTargetMarketDefinition(
      tester,
      initialLocation: AppRoutePaths.tradeCopyTargetMarketDefinitionForProduct(
        'prod-1',
      ),
    );

    expect(find.byType(TargetMarketDefinitionPage), findsOneWidget);
    expect(
      find.byKey(TargetMarketDefinitionPage.dimensionKey('risk-tolerance')),
      findsOneWidget,
    );
    expect(find.text('Comfortable with volatility'), findsOneWidget);
  });
}
