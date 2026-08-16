import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/safety/copy_safety_center_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/safety/safety_education_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopySafetyCenter(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopySafetyCenter,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-083 mock repository exposes copy safety center BE draft', () async {
    final snapshot = await const MockTradeCopyTradingRepository(
      loadDelay: Duration.zero,
    ).getCopySafetyCenter();

    expect(snapshot.defaultTabId, 'verification');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'verification',
      'metrics',
      'guidelines',
      'tools',
      'enforcement',
    ]);
    expect(snapshot.verificationTiers.map((tier) => tier.tier), [
      'Basic',
      'Verified',
      'Pro',
    ]);
    expect(snapshot.trustMetrics, hasLength(4));
    expect(snapshot.safetyTools.map((tool) => tool.routePath), [
      '/trade/copy-trading',
      '/trade/copy-trading/safety',
      null,
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

  testWidgets('SC-083 renders verification baseline inside the Trade shell', (
    tester,
  ) async {
    await pumpCopySafetyCenter(tester);

    expect(find.byType(CopySafetyCenterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trung tâm an toàn'), findsOneWidget);
    expect(find.text('Your Safety is Our Priority'), findsOneWidget);
    expect(find.text('Provider verification tiers explained:'), findsOneWidget);
    expect(find.text('Basic'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);
    expect(find.text('Pro'), findsOneWidget);
  });

  testWidgets('SC-083 first viewport reaches safety tabs', (tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopySafetyCenter,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-083 CopySafetyCenterPage',
      semanticLabel: 'Trung tâm an toàn sao chép giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(CopySafetyCenterPage.tabKey('verification')),
      targetLabel: 'the safety tabs',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-083 metrics tab expands trust metric details', (
    tester,
  ) async {
    await pumpCopySafetyCenter(tester);

    await tester.tap(CopySafetyCenterPage.tabKey('metrics').asFinder());
    await tester.pumpAndSettle();
    await tester.tap(CopySafetyCenterPage.metricKey('Sharpe Ratio').asFinder());
    await tester.pumpAndSettle();

    expect(find.textContaining('Good Range'), findsOneWidget);
    expect(
      find.textContaining('> 1.5 (excellent), 1.0-1.5 (good)'),
      findsOneWidget,
    );
    expect(find.textContaining('Why It Matters'), findsOneWidget);
  });

  testWidgets('SC-083 tools wire safe outgoing navigation edges', (
    tester,
  ) async {
    await pumpCopySafetyCenter(tester);

    await tester.tap(CopySafetyCenterPage.tabKey('tools').asFinder());
    await tester.pumpAndSettle();
    await tester.tap(CopySafetyCenterPage.toolKey('block').asFinder());
    await tester.pumpAndSettle();
    expect(find.byType(CopyTradingPage), findsOneWidget);

    await pumpCopySafetyCenter(tester);
    await tester.tap(CopySafetyCenterPage.tabKey('tools').asFinder());
    await tester.pumpAndSettle();
    await tester.tap(CopySafetyCenterPage.toolKey('report').asFinder());
    await tester.pumpAndSettle();
    expect(find.byType(SafetyEducationPage), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
