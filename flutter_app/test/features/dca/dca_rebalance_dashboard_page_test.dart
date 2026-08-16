import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_rebalance_config_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_rebalance_dashboard_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpRebalanceDashboard(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaRebalanceDashboard,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-171 mock repository exposes missing-config BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getRebalanceDashboard('config001');

    expect(snapshot.endpoint, '/api/mobile/dca/dca-rebalance-config001');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.configId, 'config001');
    expect(snapshot.configFound, isFalse);
    expect(snapshot.message, 'Configuration not found');
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

  test('SC-171 keeps the Home-standard page foundation contract', () {
    final pageSource = File(
      'lib/features/dca/presentation/phone/pages/portfolio/dca_rebalance_dashboard_page.dart',
    ).readAsStringSync();

    expect(pageSource, contains('VitInsetScrollView'));
    expect(pageSource, contains('VitContentPadding.compact'));
    expect(pageSource, contains('VitDensity.compact'));
    expect(pageSource, isNot(contains('SingleChildScrollView')));
  });

  testWidgets('SC-171 renders Flutter missing config state', (tester) async {
    await pumpRebalanceDashboard(tester);

    expect(find.byType(DCARebalanceDashboardPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(
      find.byKey(DCARebalanceDashboardPage.missingConfigKey),
      findsOneWidget,
    );
    expect(find.text('Configuration not found'), findsOneWidget);
    expect(find.text('Thiết lập cân bằng'), findsOneWidget);
    expect(find.byKey(DCARebalanceDashboardPage.configureKey), findsOneWidget);
  });

  testWidgets('SC-171 configure CTA opens rebalance config edge', (
    tester,
  ) async {
    await pumpRebalanceDashboard(tester);

    await tester.tap(find.byKey(DCARebalanceDashboardPage.configureKey));
    await tester.pumpAndSettle();
    expect(find.byType(DCARebalanceConfigPage), findsOneWidget);
    expect(find.text('Auto-Rebalance'), findsOneWidget);
  });

  testWidgets('SC-171 edit and history edges resolve to real pages', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaRebalanceEdit('config001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DCARebalanceConfigPage), findsOneWidget);
    expect(find.text('Auto-Rebalance'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaRebalanceHistory('config001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DCARebalanceDashboardPage), findsOneWidget);
    expect(find.text('Configuration not found'), findsOneWidget);
  });
}
