import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_auto_compound_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpAutoCompound(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnAutoCompound,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-363 mock repository exposes auto-compound BE draft', () async {
    final snapshot = await const MockStakingAutoCompoundRepository()
        .getAutoCompound();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-auto-compound');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('auto-compound-settings'));
    expect(snapshot.title, 'Auto-Compound');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.positions, hasLength(4));
    expect(snapshot.positions.first.product, 'USDT Flexible');
    expect(
      snapshot.positions.where((position) => position.autoCompound),
      hasLength(2),
    );
    expect(snapshot.frequencies.map((frequency) => frequency.id), [
      'daily',
      'weekly',
      'monthly',
    ]);
    expect(snapshot.contractNotes, contains('riskData'));
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

  testWidgets('SC-363 renders staking auto-compound baseline', (tester) async {
    await pumpAutoCompound(tester);

    expect(find.byType(StakingAutoCompoundPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Auto-Compound'), findsOneWidget);
    expect(find.byKey(StakingAutoCompoundPage.infoKey), findsOneWidget);
    expect(find.text('Tự động Tái đầu tư'), findsOneWidget);
    expect(find.byKey(StakingAutoCompoundPage.summaryKey), findsOneWidget);
    expect(find.text('2/4'), findsOneWidget);
    expect(find.byKey(StakingAutoCompoundPage.settingsKey), findsOneWidget);
    expect(find.byKey(StakingAutoCompoundPage.thresholdKey), findsOneWidget);
    expect(
      find.byKey(StakingAutoCompoundPage.gasOptimizationKey),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingAutoCompoundPage.positionKey('p1')),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingAutoCompoundPage.positionKey('p2')),
      findsOneWidget,
    );
    expect(find.text('USDT Flexible'), findsOneWidget);
    expect(find.text('BTC Fixed 90D'), findsOneWidget);
  });

  testWidgets('SC-363 settings update frequency and threshold state', (
    tester,
  ) async {
    await pumpAutoCompound(tester);

    await tester.tap(
      find.byKey(StakingAutoCompoundPage.frequencyKey('weekly')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hàng tuần'), findsAtLeastNWidgets(2));

    await tester.enterText(
      find.byKey(StakingAutoCompoundPage.thresholdKey),
      '25',
    );
    await tester.pumpAndSettle();

    expect(find.text('\$25'), findsOneWidget);
    expect(find.text('Chỉ tái đầu tư khi phần thưởng >= \$25'), findsOneWidget);

    await tester.tap(find.byKey(StakingAutoCompoundPage.gasOptimizationKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingAutoCompoundPage.gasOptimizationKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-363 toggles a disabled staking position', (tester) async {
    await pumpAutoCompound(tester);

    await tester.ensureVisible(
      find.byKey(StakingAutoCompoundPage.toggleKey('p2')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingAutoCompoundPage.toggleKey('p2')));
    await tester.pumpAndSettle();

    expect(find.text('3/4'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(StakingAutoCompoundPage.positionKey('p2')),
        matching: find.text('Auto-compound đang bật • Hàng ngày'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('SC-363 simulation recalculates and save confirms', (
    tester,
  ) async {
    await pumpAutoCompound(tester);

    await tester.ensureVisible(
      find.byKey(StakingAutoCompoundPage.simulationKey),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(StakingAutoCompoundPage.principalKey), findsOneWidget);
    expect(find.byKey(StakingAutoCompoundPage.apyKey), findsOneWidget);
    expect(find.byKey(StakingAutoCompoundPage.monthsKey), findsOneWidget);
    expect(find.text('\$1,077.63'), findsOneWidget);
    expect(find.text('\$1,075.00'), findsOneWidget);
    expect(find.text('+\$2.63'), findsOneWidget);

    await tester.enterText(
      find.byKey(StakingAutoCompoundPage.principalKey),
      '2000',
    );
    await tester.pumpAndSettle();
    expect(find.text('\$2,155.27'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingAutoCompoundPage.saveButtonKey),
    );
    await tester.tap(find.byKey(StakingAutoCompoundPage.saveButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingAutoCompoundPage.successToastKey), findsOneWidget);
  });

  testWidgets('SC-363 header back returns to staking hub', (tester) async {
    await pumpAutoCompound(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
