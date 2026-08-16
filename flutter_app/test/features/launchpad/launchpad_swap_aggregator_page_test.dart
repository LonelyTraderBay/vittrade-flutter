import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/bridge/launchpad_swap_aggregator_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_next_action_card.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSwapAggregator(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadSwapAggregator,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-314 mock repository exposes launchpad swap aggregator BE draft',
    () async {
      final snapshot = await const MockLaunchpadRepository(
        loadDelay: Duration.zero,
      ).getSwapAggregator();

      expect(
        snapshot.endpoint,
        '/api/mobile/launchpad/launchpad-swap-aggregator',
      );
      expect(
        snapshot.actionDraft,
        'POST /launchpad/subscribe|claim|bridge where applicable',
      );
      expect(snapshot.title, 'Swap Aggregator');
      expect(snapshot.backRoute, AppRoutePaths.launchpad);
      expect(snapshot.tabs, [
        'So s\u00E1nh',
        'L\u1ECBch s\u1EED',
        'C\u00E0i \u0111\u1EB7t',
      ]);
      expect(snapshot.fromToken, 'USDT');
      expect(snapshot.toToken, 'ARB');
      expect(snapshot.dexQuotes, hasLength(5));
      expect(snapshot.dexQuotes.first.recommended, isTrue);
      expect(snapshot.history, hasLength(3));
      expect(snapshot.contractNotes, contains('DEX quotes'));
      expect(
        snapshot.supportedStates,
        containsAll([
          LaunchpadScreenState.loading,
          LaunchpadScreenState.empty,
          LaunchpadScreenState.error,
          LaunchpadScreenState.offline,
          LaunchpadScreenState.submitting,
          LaunchpadScreenState.success,
        ]),
      );
    },
  );

  testWidgets('SC-314 renders swap aggregator compare baseline', (
    tester,
  ) async {
    await pumpSwapAggregator(tester);

    expect(find.byType(LaunchpadSwapAggregatorPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadSwapAggregatorPage.tabsKey), findsOneWidget);
    expect(find.byKey(LaunchpadSwapAggregatorPage.inputKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadSwapAggregatorPage.bestRouteKey),
      findsOneWidget,
    );
    expect(find.byKey(LaunchpadSwapAggregatorPage.dexListKey), findsOneWidget);
    expect(find.byKey(LaunchpadSwapAggregatorPage.ctaKey), findsOneWidget);
    expect(find.text('Swap Aggregator'), findsOneWidget);
    expect(find.text('T\u1EEB'), findsOneWidget);
    expect(find.text('USDT'), findsWidgets);
    expect(find.text('ARB'), findsWidgets);
    expect(find.text('T\u1EF7 gi\u00E1 t\u1ED1t: Uniswap V3'), findsOneWidget);
    expect(find.text('Uniswap V3'), findsWidgets);
    expect(find.text('PancakeSwap'), findsOneWidget);
    expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
    expect(find.byType(VitNextActionCard), findsOneWidget);
    final panel = tester.widget<VitHighRiskStatePanel>(
      find.byType(VitHighRiskStatePanel),
    );
    expect(panel.state, VitHighRiskUiState.riskReview);
    expect(panel.contractId, 'Launchpad swap route');
  });

  testWidgets('SC-314 first viewport reaches swap input', (tester) async {
    await pumpSwapAggregator(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-314 LaunchpadSwapAggregatorPage',
      semanticLabel: 'So sánh giá swap trên nhiều DEX',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadSwapAggregatorPage.inputKey),
      routeName: 'SC-314 LaunchpadSwapAggregatorPage',
      actionLabel: 'the swap input card',
    );
  });

  testWidgets('SC-314 expands route details and flips token direction', (
    tester,
  ) async {
    await pumpSwapAggregator(tester);

    await tester.tap(
      find.byKey(LaunchpadSwapAggregatorPage.dexToggleKey('uniswap')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Route'), findsOneWidget);
    expect(find.text('WETH'), findsOneWidget);
    expect(find.text('Security: High'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadSwapAggregatorPage.flipKey));
    await tester.pumpAndSettle();
    expect(find.text('@2456.32 ARB'), findsOneWidget);
  });

  testWidgets('SC-314 switches history and settings tabs', (tester) async {
    await pumpSwapAggregator(tester);

    await tester.tap(find.text('L\u1ECBch s\u1EED'));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadSwapAggregatorPage.historyKey), findsOneWidget);
    expect(find.text('Giao d\u1ECBch g\u1EA7n \u0111\u00E2y'), findsOneWidget);
    expect(find.text('USDT \u2192 ARB'), findsOneWidget);

    await tester.tap(find.text('C\u00E0i \u0111\u1EB7t'));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadSwapAggregatorPage.settingsKey), findsOneWidget);
    expect(
      find.text('\u0110\u1ED9 tr\u01B0\u1EE3t gi\u00E1 (%)'),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(LaunchpadSwapAggregatorPage.slippageKey('1.0')),
    );
    await tester.pumpAndSettle();
    expect(find.text('1.0%'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadSwapAggregatorPage.autoRefreshKey));
    await tester.pumpAndSettle();
    final switchWidget = tester.widget<Switch>(
      find.byKey(LaunchpadSwapAggregatorPage.autoRefreshKey),
    );
    expect(switchWidget.value, isFalse);
  });

  testWidgets('SC-314 floating CTA submits swap and shows acknowledgement', (
    tester,
  ) async {
    await pumpSwapAggregator(tester);

    await tester.tap(find.byKey(LaunchpadSwapAggregatorPage.ctaKey));
    await tester.pumpAndSettle();

    expect(
      find.text('\u0110\u00E3 t\u1EA1o y\u00EAu c\u1EA7u swap'),
      findsOneWidget,
    );
    expect(find.text('Swap 1000 USDT qua Uniswap V3.'), findsOneWidget);
    expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
  });

  testWidgets('SC-314 header back returns to launchpad', (tester) async {
    await pumpSwapAggregator(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
