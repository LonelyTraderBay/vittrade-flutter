import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/auto_compound_settings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

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
            initialLocation: AppRoutePaths.earnSavingsAutoCompound,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-341 mock repository exposes auto-compound BE draft', () async {
    final snapshot = await const MockAutoCompoundSettingsRepository()
        .getSettings();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-auto-compound');
    expect(snapshot.actionDraft, contains('PATCH /earn/savings/auto-compound'));
    expect(snapshot.title, 'Lãi kép tự động');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.positions, hasLength(3));
    expect(snapshot.positions.first.autoCompound, isTrue);
    expect(snapshot.frequencies.map((item) => item.id), [
      'daily',
      'weekly',
      'monthly',
    ]);
    expect(snapshot.note, contains('sản phẩm linh hoạt'));
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

  testWidgets('SC-341 renders auto-compound baseline', (tester) async {
    await pumpAutoCompound(tester);

    expect(find.byType(AutoCompoundSettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lãi kép tự động'), findsOneWidget);
    expect(find.byKey(AutoCompoundSettingsPage.summaryKey), findsOneWidget);
    expect(find.text('Auto-Compound Overview'), findsOneWidget);
    expect(find.text('2/3'), findsOneWidget);
    expect(find.text('\$17.64'), findsOneWidget);
    expect(find.text('Vị thế tiết kiệm'), findsOneWidget);
    expect(
      find.byKey(AutoCompoundSettingsPage.positionKey('cp1')),
      findsOneWidget,
    );
    expect(
      find.byKey(AutoCompoundSettingsPage.positionKey('cp2')),
      findsOneWidget,
    );
    expect(find.text('USDT Linh hoạt'), findsOneWidget);
    expect(find.text('BTC Linh hoạt'), findsOneWidget);
    expect(find.textContaining('Auto-compound đang tắt'), findsOneWidget);
    expect(find.byKey(AutoCompoundSettingsPage.calculatorKey), findsOneWidget);
  });

  testWidgets('SC-341 first viewport reaches first position', (tester) async {
    await pumpAutoCompound(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-341 AutoCompoundSettingsPage',
      semanticLabel: 'Lãi kép tự động',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(AutoCompoundSettingsPage.positionKey('cp1')),
      routeName: 'SC-341 AutoCompoundSettingsPage',
      actionLabel: 'the first auto-compound position',
    );
  });

  testWidgets('SC-341 toggle enables disabled BTC compound state', (
    tester,
  ) async {
    await pumpAutoCompound(tester);

    await tester.tap(find.byKey(AutoCompoundSettingsPage.toggleKey('cp2')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Auto-compound đang tắt'), findsNothing);
    expect(find.text('1.83% APY'), findsOneWidget);
    expect(find.textContaining('+0.03% APY từ compound'), findsOneWidget);
  });

  testWidgets('SC-341 settings sheet saves and shows confirmation', (
    tester,
  ) async {
    await pumpAutoCompound(tester);

    await tester.tap(
      find.byKey(AutoCompoundSettingsPage.settingsButtonKey('cp1')),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Cài đặt lãi kép'), findsOneWidget);
    expect(
      find.byKey(AutoCompoundSettingsPage.frequencyKey('daily')),
      findsOneWidget,
    );
    expect(
      find.byKey(AutoCompoundSettingsPage.frequencyKey('weekly')),
      findsOneWidget,
    );
    expect(
      find.byKey(AutoCompoundSettingsPage.thresholdKey(0.5)),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(AutoCompoundSettingsPage.saveButtonKey),
    );
    await tester.tap(find.byKey(AutoCompoundSettingsPage.saveButtonKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(AutoCompoundSettingsPage.successToastKey),
      findsOneWidget,
    );
    expect(find.text('Đã lưu cài đặt'), findsOneWidget);
  });

  testWidgets('SC-341 info sheet explains compound rules', (tester) async {
    await pumpAutoCompound(tester);

    await tester.tap(find.byKey(AutoCompoundSettingsPage.infoButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(AutoCompoundSettingsPage.infoSheetKey), findsOneWidget);
    expect(find.text('Lãi kép là gì?'), findsOneWidget);
    expect(find.text('APY thực tế cao hơn'), findsOneWidget);
    expect(find.textContaining('không hỗ trợ compound giữa kỳ'), findsWidgets);
  });

  testWidgets('SC-341 header back returns to savings overview', (tester) async {
    await pumpAutoCompound(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
