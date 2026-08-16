import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dca/data/dca_repository.dart';
import 'package:vit_trade_flutter/features/dca/presentation/phone/pages/schedule/dca_smart_rules_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSmartRules(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.dcaSmartRules,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-179 mock repository exposes smart rules BE draft', () async {
    final snapshot = await const MockDcaRepository(
      loadDelay: Duration.zero,
    ).getSmartRules();

    expect(snapshot.endpoint, '/api/mobile/dca/dca-smart-rules');
    expect(snapshot.actionDraft, 'POST /dca/plans|rebalance|schedule');
    expect(snapshot.smartRules.length, 4);
    expect(snapshot.activeRules, 3);
    expect(snapshot.totalTriggers, 6);
    expect(snapshot.successPercent, 95);
    expect(snapshot.templates.length, 6);
    expect(snapshot.history.length, 3);
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

  testWidgets('SC-179 renders my rules baseline', (tester) async {
    await pumpSmartRules(tester);

    expect(find.byType(DCASmartRulesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Smart DCA Rules'), findsOneWidget);
    expect(find.text('Luat cua toi'), findsOneWidget);
    expect(find.text('Smart Rules'), findsOneWidget);
    expect(find.text('Cac luat hien co'), findsOneWidget);
    expect(
      find.byKey(DCASmartRulesPage.ruleKey('rule-buy-dip')),
      findsOneWidget,
    );
    expect(find.text('Buy the Dip -10%'), findsOneWidget);
    expect(find.byKey(DCASmartRulesPage.createRuleKey), findsOneWidget);
  });

  testWidgets('SC-179 supports templates and history tabs', (tester) async {
    await pumpSmartRules(tester);

    await tester.tap(find.byKey(DCASmartRulesPage.tabKey('templates')));
    await tester.pumpAndSettle();
    expect(find.text('Rule Templates'), findsOneWidget);
    expect(find.text('Entry Rules'), findsOneWidget);
    expect(find.text('Buy Major Dips'), findsOneWidget);

    await tester.tap(find.byKey(DCASmartRulesPage.tabKey('history')));
    await tester.pumpAndSettle();
    expect(find.text('Rule Trigger History'), findsOneWidget);
    expect(find.text('Performance Impact'), findsOneWidget);
    expect(find.text('Total Saved'), findsOneWidget);
  });

  testWidgets('SC-179 template Use button shows a coming-soon notice sheet', (
    tester,
  ) async {
    await pumpSmartRules(tester);

    await tester.tap(find.byKey(DCASmartRulesPage.tabKey('templates')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Use').first);
    await tester.tap(find.text('Use').first);
    await tester.pumpAndSettle();

    expect(find.text('Áp dụng mẫu quy tắc sẽ sớm ra mắt.'), findsOneWidget);
  });
}
