import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/analytics/performance_attribution_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPerformanceAttribution(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyPerformanceAttribution(
              'copy001',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-075 mock repository exposes attribution BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getPerformanceAttribution(copyId: 'copy001');

    expect(snapshot.copyId, 'copy001');
    expect(snapshot.totalReturnPct, 9.2);
    expect(snapshot.alphaPct, -4.1);
    expect(snapshot.beta, 1.15);
    expect(snapshot.rSquared, .72);
    expect(snapshot.returns, hasLength(30));
    expect(snapshot.drawdowns, hasLength(30));
    expect(snapshot.monteCarloPaths, hasLength(3));
    expect(snapshot.correlationPoints, hasLength(10));
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

  testWidgets('SC-075 renders attribution in the Trade shell', (tester) async {
    await pumpPerformanceAttribution(tester);

    expect(find.byType(PerformanceAttributionPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích hiệu suất'), findsOneWidget);
    expect(find.text('Total Return'), findsOneWidget);
    expect(find.text('+9.2%'), findsOneWidget);
    expect(find.text('-4.1%'), findsNWidgets(2));
    expect(find.text('Returns Decomposition'), findsOneWidget);
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });

  testWidgets('SC-075 first viewport reaches attribution tabs', (tester) async {
    await pumpPerformanceAttribution(tester);

    expectActionableInFirstViewport(
      tester,
      find.byKey(PerformanceAttributionPage.tabKey('drawdown')),
      routeName: 'PerformanceAttributionPage',
      actionLabel: 'drawdown attribution tab',
    );
  });

  testWidgets('SC-075 switches drawdown and projection tabs', (tester) async {
    await pumpPerformanceAttribution(tester);

    await tester.tap(find.byKey(PerformanceAttributionPage.tabKey('drawdown')));
    await tester.pumpAndSettle();
    expect(find.text('Underwater Chart'), findsOneWidget);
    expect(find.text('Max Drawdown'), findsOneWidget);

    await tester.tap(
      find.byKey(PerformanceAttributionPage.tabKey('projection')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Monte Carlo Simulation (30 ngày)'), findsOneWidget);
    expect(find.text('50th Percentile'), findsOneWidget);

    await tester.tap(
      find.byKey(PerformanceAttributionPage.tabKey('correlation')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Daily Returns Correlation'), findsOneWidget);
    expect(find.text('Correlation coefficient (R)'), findsOneWidget);
  });
}
