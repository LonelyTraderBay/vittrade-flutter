import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/schedule/dca_schedule_config_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpScheduleConfig(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaScheduleConfig,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-172 mock repository exposes schedule config BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getScheduleConfig();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-schedule-config');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.strategy, DcaScheduleStrategy.hybrid);
    expect(snapshot.timePreference, DcaScheduleTimePreference.any);
    expect(snapshot.maxDelayHours, 6);
    expect(snapshot.maxAdvanceHours, 6);
    expect(snapshot.volatilityThreshold, 3);
    expect(snapshot.gasPriceThreshold, 30);
    expect(snapshot.enabled, isTrue);
    expect(snapshot.strategies.map((strategy) => strategy.strategy), [
      DcaScheduleStrategy.fixed,
      DcaScheduleStrategy.volatility,
      DcaScheduleStrategy.gasOptimized,
      DcaScheduleStrategy.volume,
      DcaScheduleStrategy.hybrid,
    ]);
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

  test('SC-172 keeps the Home-standard page foundation contract', () {
    final pageSource = File(
      'lib/features/dca/presentation/phone/pages/schedule/dca_schedule_config_page.dart',
    ).readAsStringSync();
    final source = [
      pageSource,
      File(
        'lib/features/dca/presentation/widgets/schedule/dca_schedule_strategy_time.dart',
      ).readAsStringSync(),
      File(
        'lib/features/dca/presentation/widgets/schedule/dca_schedule_limits_enable.dart',
      ).readAsStringSync(),
    ].join('\n');

    expect(source, contains('VitInsetScrollView'));
    expect(source, contains('VitContentPadding.compact'));
    expect(source, contains('VitDensity.compact'));
    expect(
      pageSource,
      isNot(contains('DcaSpacingTokens.dcaBottomInsetPadding')),
    );
    expect(pageSource, isNot(contains('SingleChildScrollView')));
  });

  testWidgets('SC-172 renders smart scheduling form with trade nav active', (
    tester,
  ) async {
    await pumpScheduleConfig(tester);

    expect(find.byType(DCAScheduleConfigPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Smart Scheduling'), findsOneWidget);
    expect(find.text('Lịch trình thông minh'), findsOneWidget);
    expect(find.text('Chiến lược'), findsOneWidget);
    expect(find.text('Hybrid'), findsOneWidget);
    expect(find.text('Khung giờ ưu tiên'), findsOneWidget);
    expect(find.byKey(DCAScheduleConfigPage.saveKey), findsOneWidget);
  });

  testWidgets('SC-172 strategy, time preference and switch update state', (
    tester,
  ) async {
    await pumpScheduleConfig(tester);

    await tester.tap(
      find.byKey(DCAScheduleConfigPage.strategyKey(DcaScheduleStrategy.fixed)),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Cố định'), findsWidgets);
    expect(find.textContaining('không tối ưu'), findsWidgets);

    await tester.tap(
      find.byKey(
        DCAScheduleConfigPage.timeKey(DcaScheduleTimePreference.morning),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(DCAScheduleConfigPage.enabledKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCAScheduleConfigPage.enabledKey));
    await tester.pumpAndSettle();
    expect(find.byKey(DCAScheduleConfigPage.enabledKey), findsOneWidget);
  });

  testWidgets('SC-172 save routes to schedule analytics route', (tester) async {
    await pumpScheduleConfig(tester);

    await tester.ensureVisible(find.byKey(DCAScheduleConfigPage.saveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCAScheduleConfigPage.saveKey));
    await tester.pumpAndSettle();

    expect(find.text('Configuration not found'), findsOneWidget);
  });

  testWidgets('SC-172 360px viewport follows Home rhythm', (tester) async {
    await pumpScheduleConfig(tester, viewport: const Size(360, 800));

    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;
    final heroRect = tester.getRect(find.byType(VitCard).first);
    final strategyTop = tester
        .getTopLeft(
          find.byKey(
            DCAScheduleConfigPage.strategyKey(DcaScheduleStrategy.hybrid),
          ),
        )
        .dy;
    final timeHeaderTop = tester.getTopLeft(find.text('Khung giờ ưu tiên')).dy;

    expect(heroRect.left, lessThanOrEqualTo(24));
    expect(heroRect.width, greaterThanOrEqualTo(312));
    expect(strategyTop, lessThan(navTop - 56));
    expect(timeHeaderTop, lessThan(navTop));
  });
}
