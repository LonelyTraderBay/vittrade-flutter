import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_auto_rebalance_page.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRebalance(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsRebalance,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-344 mock repository exposes rebalance BE draft', () async {
    final snapshot = await const MockSavingsAutoRebalanceRepository()
        .getRebalance();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-rebalance');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Tái cân bằng');
    expect(snapshot.subtitle, 'Auto-rebalance portfolio');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs, ['Tổng quan', 'Chiến lược', 'Lịch sử', 'Cài đặt']);
    expect(snapshot.defaultStrategyId, 'balanced');
    expect(snapshot.positions, hasLength(4));
    expect(snapshot.strategies, hasLength(3));
    expect(snapshot.driftHistory, hasLength(10));
    expect(snapshot.history, hasLength(5));
    expect(snapshot.settings.driftThreshold, 5);
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-344 renders auto rebalance overview baseline', (
    tester,
  ) async {
    await pumpRebalance(tester);

    expect(find.byType(SavingsAutoRebalancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tái cân bằng'), findsOneWidget);
    expect(find.text(kSavingsToolsHeaderSubtitle), findsOneWidget);
    expect(find.byKey(SavingsAutoRebalancePage.allocationKey), findsOneWidget);
    expect(find.text('Hiện tại vs Mục tiêu'), findsOneWidget);
    expect(find.text('Drift 11.9%'), findsOneWidget);
    expect(find.byKey(SavingsAutoRebalancePage.driftStatusKey), findsOneWidget);
    expect(find.text('Cần tái cân bằng'), findsOneWidget);
    expect(find.byKey(SavingsAutoRebalancePage.driftChartKey), findsOneWidget);
    expect(find.text('Lịch sử Drift'), findsOneWidget);
    expect(find.byKey(SavingsAutoRebalancePage.autoStatusKey), findsOneWidget);
    expect(find.text('Tự động tái cân bằng'), findsOneWidget);
    expect(find.byKey(SavingsAutoRebalancePage.statsKey), findsOneWidget);
    expect(find.text('Xem trước'), findsOneWidget);
  });

  testWidgets('SC-344 first viewport reaches preview action', (tester) async {
    await pumpRebalance(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-344 SavingsAutoRebalancePage',
      semanticLabel: 'Tái cân bằng',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SavingsAutoRebalancePage.previewButtonKey),
      routeName: 'SC-344 SavingsAutoRebalancePage',
      actionLabel: 'the rebalance preview action',
    );
  });

  testWidgets('SC-344 supports strategy tab state changes', (tester) async {
    await pumpRebalance(tester);

    await tester.tap(find.text('Chiến lược').first);
    await tester.pumpAndSettle();

    expect(find.text('Chiến lược đề xuất'), findsOneWidget);
    expect(
      find.byKey(SavingsAutoRebalancePage.strategyKey('growth')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(SavingsAutoRebalancePage.strategyKey('growth')),
    );
    await tester.pumpAndSettle();

    expect(find.text('5.22%'), findsWidgets);
  });

  testWidgets('SC-344 preview action opens confirmation sheet', (tester) async {
    await pumpRebalance(tester);

    await tester.tap(find.byKey(SavingsAutoRebalancePage.previewButtonKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsAutoRebalancePage.previewSheetKey),
      findsOneWidget,
    );
    expect(find.text('Xem trước tái cân bằng'), findsOneWidget);
    expect(find.text('Xác nhận tái cân bằng'), findsOneWidget);
  });

  testWidgets('SC-344 header back returns to savings overview', (tester) async {
    await pumpRebalance(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
