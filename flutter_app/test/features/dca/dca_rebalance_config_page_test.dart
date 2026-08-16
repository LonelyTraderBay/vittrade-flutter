import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/portfolio/dca_rebalance_config_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRebalanceConfig(
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
            initialLocation: AppRoutePaths.dcaRebalanceConfig,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-170 mock repository exposes rebalance config BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getRebalanceConfig();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-rebalance-config');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.targets.map((target) => target.symbol), [
      'BTC',
      'ETH',
      'USDT',
    ]);
    expect(snapshot.strategy, DcaRebalanceStrategy.threshold);
    expect(
      snapshot.supportedStates,
      containsAll([
        DcaScreenState.loading,
        DcaScreenState.empty,
        DcaScreenState.error,
        DcaScreenState.offline,
        DcaScreenState.submitting,
        DcaScreenState.success,
      ]),
    );
  });

  test('SC-170 keeps the Home-standard page foundation contract', () {
    final pageSource = File(
      'lib/features/dca/presentation/phone/pages/portfolio/dca_rebalance_config_page.dart',
    ).readAsStringSync();
    final source = [
      pageSource,
      File(
        'lib/features/dca/presentation/phone/pages/portfolio/dca_rebalance_config_page_allocation_strategy.dart',
      ).readAsStringSync(),
      File(
        'lib/features/dca/presentation/phone/pages/portfolio/dca_rebalance_config_page_settings_and_preview.dart',
      ).readAsStringSync(),
    ].join('\n');

    expect(source, contains('VitInsetScrollView'));
    expect(source, contains('VitContentPadding.compact'));
    expect(source, contains('VitDensity.compact'));
    expect(pageSource, isNot(contains('SingleChildScrollView')));
  });

  testWidgets('SC-170 renders Auto-Rebalance form with trade nav active', (
    tester,
  ) async {
    await pumpRebalanceConfig(tester);

    expect(find.byType(DCARebalanceConfigPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Auto-Rebalance'), findsOneWidget);
    expect(find.text('Tự động cân bằng danh mục'), findsOneWidget);
    expect(find.text('Phân bổ mục tiêu'), findsOneWidget);
    expect(find.text('BTC'), findsWidgets);
    expect(find.text('Chiến lược'), findsOneWidget);
    expect(find.byKey(DCARebalanceConfigPage.previewKey), findsOneWidget);
    expect(find.byKey(DCARebalanceConfigPage.saveKey), findsOneWidget);
  });

  testWidgets('SC-170 first viewport reaches first allocation slider', (
    tester,
  ) async {
    await pumpRebalanceConfig(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-170 DCARebalanceConfigPage',
      semanticLabel: 'Cấu hình tự động cân bằng lại danh mục DCA',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DCARebalanceConfigPage.targetSliderKey('target-btc')),
      routeName: 'SC-170 DCARebalanceConfigPage',
      actionLabel: 'the first target allocation slider',
    );
  });

  testWidgets('SC-170 360px viewport follows Home rhythm', (tester) async {
    await pumpRebalanceConfig(tester, viewport: const Size(360, 800));

    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;
    final heroRect = tester.getRect(find.byType(VitCard).first);
    final firstSliderBottom = tester
        .getBottomLeft(
          find.byKey(DCARebalanceConfigPage.targetSliderKey('target-btc')),
        )
        .dy;
    final toleranceTop = tester.getTopLeft(find.text('Dung sai').first).dy;

    expect(heroRect.left, lessThanOrEqualTo(24));
    expect(heroRect.width, greaterThanOrEqualTo(312));
    expect(firstSliderBottom, lessThan(navTop));
    expect(toleranceTop, lessThan(navTop - 24));
  });

  testWidgets('SC-170 strategy and advanced controls update local state', (
    tester,
  ) async {
    await pumpRebalanceConfig(tester);

    await tester.ensureVisible(
      find.byKey(
        DCARebalanceConfigPage.strategyKey(DcaRebalanceStrategy.periodic),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(
        DCARebalanceConfigPage.strategyKey(DcaRebalanceStrategy.periodic),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tần suất'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(DCARebalanceConfigPage.advancedToggleKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCARebalanceConfigPage.advancedToggleKey));
    await tester.pumpAndSettle();
    expect(find.text('Giao dịch tối thiểu'), findsOneWidget);
    expect(find.text('Tự động thực thi'), findsOneWidget);
  });

  testWidgets('SC-170 preview confirms to dashboard placeholder edge', (
    tester,
  ) async {
    await pumpRebalanceConfig(tester);

    await tester.ensureVisible(find.byKey(DCARebalanceConfigPage.previewKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCARebalanceConfigPage.previewKey));
    await tester.pumpAndSettle();
    expect(find.byKey(DCARebalanceConfigPage.previewSheetKey), findsOneWidget);
    expect(find.text('Preview Simulation'), findsOneWidget);
    expect(find.text('Rebalance execution preview'), findsOneWidget);
    expect(find.text('Estimated fees'), findsOneWidget);
    expect(find.text('Risk check'), findsOneWidget);

    await tester.tap(find.byKey(DCARebalanceConfigPage.confirmSaveKey));
    await tester.pumpAndSettle();
    expect(find.text('Configuration not found'), findsOneWidget);
  });

  testWidgets(
    'SC-170 360px hybrid preview avoids layout overflow with large trades',
    (tester) async {
      final layoutErrors = <FlutterErrorDetails>[];
      final previousOnError = FlutterError.onError;
      FlutterError.onError = layoutErrors.add;
      addTearDown(() => FlutterError.onError = previousOnError);

      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(360, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final base = await const MockDcaRepository(
        loadDelay: Duration.zero,
      ).getRebalanceConfig();
      final largeTradeSnapshot = DcaRebalanceConfigSnapshot(
        endpoint: base.endpoint,
        actionDraft: base.actionDraft,
        supportedStates: base.supportedStates,
        totalPortfolioUsd: 25000000,
        driftThreshold: base.driftThreshold,
        minTradeAmountUsd: 1,
        strategy: base.strategy,
        frequency: base.frequency,
        targets: base.targets,
        strategyOptions: base.strategyOptions,
        frequencyOptions: base.frequencyOptions,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            dcaRebalanceConfigProvider.overrideWith(
              (ref) => largeTradeSnapshot,
            ),
          ],
          child: VitTradeApp(
            routerConfig: createAppRouter(
              initialLocation: AppRoutePaths.dcaRebalanceConfig,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(
          DCARebalanceConfigPage.strategyKey(DcaRebalanceStrategy.hybrid),
        ),
      );
      await tester.tap(
        find.byKey(
          DCARebalanceConfigPage.strategyKey(DcaRebalanceStrategy.hybrid),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Drift'), findsOneWidget);
      expect(find.text('Tần suất'), findsOneWidget);
      expect(find.text('Ngưỡng drift'), findsOneWidget);

      await tester.ensureVisible(find.byKey(DCARebalanceConfigPage.previewKey));
      await tester.tap(find.byKey(DCARebalanceConfigPage.previewKey));
      await tester.pumpAndSettle();

      expect(
        find.byKey(DCARebalanceConfigPage.previewSheetKey),
        findsOneWidget,
      );
      expect(find.textContaining('Mua \$'), findsWidgets);

      final exceptions = <Object?>[];
      Object? exception = tester.takeException();
      while (exception != null) {
        exceptions.add(exception);
        exception = tester.takeException();
      }
      expect(exceptions, isEmpty);

      final overflowErrors = layoutErrors
          .where(
            (details) => details.exceptionAsString().contains('overflowed'),
          )
          .toList();
      expect(overflowErrors, isEmpty);
    },
  );
}
