import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/research/dca_dynamic_amount_page.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/hub/dca_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDynamicAmount(
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
            initialLocation: AppRoutePaths.dcaDynamicAmount,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-175 mock repository exposes dynamic amount BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getDynamicAmount();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-dynamic-amount');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.activeStrategy, DcaDynamicStrategy.volatility);
    expect(snapshot.adjustment.adjustedAmountVnd, 500000);
    expect(snapshot.volatilityHistory.length, 10);
    expect(snapshot.amountHistory.length, 6);
    expect(snapshot.configItems.length, 6);
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

  test('SC-175 keeps the Home-standard page foundation contract', () {
    final pageSource = File(
      'lib/features/dca/presentation/phone/pages/research/dca_dynamic_amount_page.dart',
    ).readAsStringSync();
    final source = [
      pageSource,
      File(
        'lib/features/dca/presentation/phone/pages/research/dca_dynamic_amount_page_hero_and_strategy.dart',
      ).readAsStringSync(),
      File(
        'lib/features/dca/presentation/phone/pages/research/dca_dynamic_amount_page_history_and_config.dart',
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

  testWidgets('SC-175 renders dynamic amount default volatility view', (
    tester,
  ) async {
    await pumpDynamicAmount(tester);

    expect(find.byType(DCADynamicAmountPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Dynamic Amount'), findsOneWidget);
    expect(find.text('500K'), findsWidgets);
    expect(find.text('Volatility'), findsWidgets);
    expect(find.text('Biến động & Hệ số'), findsOneWidget);
    expect(find.text('Lịch sử điều chỉnh'), findsOneWidget);
    expect(find.text('Cấu hình Volatility'), findsOneWidget);
    expect(find.byKey(DCADynamicAmountPage.applyKey), findsOneWidget);
  });

  testWidgets('SC-175 switches strategy and apply returns to DCA dashboard', (
    tester,
  ) async {
    await pumpDynamicAmount(tester);

    await tester.ensureVisible(
      find.byKey(
        DCADynamicAmountPage.strategyKey(DcaDynamicStrategy.performance),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(
        DCADynamicAmountPage.strategyKey(DcaDynamicStrategy.performance),
      ),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.text('Cấu hình Hiệu suất'), findsOneWidget);
    expect(find.text('600K'), findsWidgets);

    await tester.ensureVisible(find.byKey(DCADynamicAmountPage.applyKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DCADynamicAmountPage.applyKey));
    await tester.pumpAndSettle();

    expect(find.byType(DCAPage), findsOneWidget);
  });

  testWidgets('SC-175 first viewport reaches dynamic strategy controls', (
    tester,
  ) async {
    await pumpDynamicAmount(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-175 DCADynamicAmountPage',
      semanticLabel:
          'Điều chỉnh số tiền DCA linh hoạt theo biến động thị trường',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DCADynamicAmountPage.settingsKey),
      routeName: 'SC-175 DCADynamicAmountPage',
      actionLabel: 'dynamic amount settings action',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(
        DCADynamicAmountPage.strategyKey(DcaDynamicStrategy.volatility),
      ),
      routeName: 'SC-175 DCADynamicAmountPage',
      actionLabel: 'active volatility strategy chip',
    );
  });

  testWidgets('SC-175 360px viewport follows Home rhythm', (tester) async {
    await pumpDynamicAmount(tester, viewport: const Size(360, 800));

    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;
    final heroRect = tester.getRect(find.byType(VitCard).first);
    final strategyTop = tester
        .getTopLeft(
          find.byKey(
            DCADynamicAmountPage.strategyKey(DcaDynamicStrategy.volatility),
          ),
        )
        .dy;
    final chartTitleTop = tester.getTopLeft(find.text('Biến động & Hệ số')).dy;

    expect(heroRect.left, lessThanOrEqualTo(24));
    expect(heroRect.width, greaterThanOrEqualTo(312));
    expect(strategyTop, lessThan(navTop - 56));
    expect(chartTitleTop, lessThan(navTop));
  });
}
