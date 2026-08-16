import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_multi_asset_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpMultiAsset(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaMultiAsset,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-177 mock repository exposes multi-asset BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getMultiAsset();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-multi-asset');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.totalBudgetUsd, 1000);
    expect(snapshot.activeFrequency, DcaMultiAssetFrequency.monthly);
    expect(snapshot.rebalanceEnabled, isTrue);
    expect(snapshot.rebalanceThresholdPercent, 5);
    expect(snapshot.allocations.map((asset) => asset.symbol), [
      'BTC',
      'ETH',
      'BNB',
      'SOL',
    ]);
    expect(snapshot.performance.length, 6);
    expect(snapshot.totalInvestedUsd, 12000);
    expect(snapshot.currentValueUsd, 13200);
    expect(snapshot.totalReturnPercent, 10);
    expect(snapshot.needsRebalance, isFalse);
    expect(snapshot.dcaPlans, isEmpty);
    expect(snapshot.schedules, isEmpty);
    expect(snapshot.rules, isEmpty);
    expect(snapshot.portfolioTargets, isEmpty);
    expect(snapshot.backtests, isEmpty);
    expect(
      snapshot.supportedStates,
      containsAll([
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-177 renders setup baseline', (tester) async {
    await pumpMultiAsset(tester);

    expect(find.byType(DCAMultiAssetPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Multi-Asset DCA'), findsOneWidget);
    expect(find.text('Cài đặt'), findsOneWidget);
    expect(find.text('Total Budget per Period'), findsOneWidget);
    expect(find.byKey(DCAMultiAssetPage.budgetFieldKey), findsOneWidget);
    expect(find.text('Phân bổ tài sản'), findsOneWidget);
    expect(find.byKey(DCAMultiAssetPage.assetKey('BTC')), findsOneWidget);
    expect(find.byKey(DCAMultiAssetPage.addAssetKey), findsOneWidget);
    expect(find.text('Auto Rebalancing'), findsOneWidget);
    expect(find.byKey(DCAMultiAssetPage.thresholdFieldKey), findsOneWidget);
  });

  testWidgets('SC-177 toggles rebalance field', (tester) async {
    await pumpMultiAsset(tester);

    await tester.ensureVisible(
      find.byKey(DCAMultiAssetPage.rebalanceToggleKey),
    );
    await tester.tap(find.byKey(DCAMultiAssetPage.rebalanceToggleKey));
    await tester.pumpAndSettle();

    expect(find.byKey(DCAMultiAssetPage.thresholdFieldKey), findsNothing);
  });

  testWidgets('SC-177 first viewport reaches setup controls', (tester) async {
    await pumpMultiAsset(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-177 DCAMultiAssetPage',
      semanticLabel:
          'Thiết lập DCA đa tài sản – phân bổ ngân sách, tần suất và tự động cân bằng',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DCAMultiAssetPage.tabKey('setup')),
      routeName: 'SC-177 DCAMultiAssetPage',
      actionLabel: 'setup tab',
    );
  });

  testWidgets('SC-177 supports assets and performance tabs', (tester) async {
    await pumpMultiAsset(tester);

    await tester.tap(find.byKey(DCAMultiAssetPage.tabKey('assets')));
    await tester.pumpAndSettle();
    expect(find.text('Portfolio Overview'), findsOneWidget);
    expect(find.text('Chi tiết tài sản'), findsOneWidget);
    expect(find.text(r'+$1200'), findsOneWidget);

    await tester.tap(find.byKey(DCAMultiAssetPage.tabKey('performance')));
    await tester.pumpAndSettle();
    expect(find.text('Investment Growth by Asset'), findsOneWidget);
    expect(find.text('Asset Performance'), findsOneWidget);
    expect(find.text('Diversification Score'), findsOneWidget);
  });
}
