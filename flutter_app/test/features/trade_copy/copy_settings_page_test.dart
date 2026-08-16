import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_settings_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopySettings(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopySettings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-067 mock repository exposes copy settings BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getCopySettings();
    final updated = snapshot.settings.copyWith(defaultCopyRatio: 60);
    final result = await repo.patchCopySettings(updated);

    expect(snapshot.trade.copyProviders, isNotEmpty);
    expect(snapshot.settings.defaultCopyMode, TradeCopySettingsMode.fixed);
    expect(snapshot.settings.defaultCopyRatio, 50);
    expect(snapshot.settings.defaultStopLoss, 10);
    expect(snapshot.settings.defaultTakeProfit, 20);
    expect(snapshot.settings.enableCircuitBreaker, isTrue);
    expect(snapshot.settings.notifyRiskAlerts, isTrue);
    expect(result.status, 'saved');
    expect(result.settings.defaultCopyRatio, 60);
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-067 renders CopySettingsPage inside the Trade shell', (
    tester,
  ) async {
    await pumpCopySettings(tester);

    expect(find.byType(CopySettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Cài đặt Copy Trading'), findsOneWidget);
    expect(find.text('Cài đặt mặc định'), findsOneWidget);
    expect(find.text('Copy Mode mặc định'), findsOneWidget);
    expect(find.text('Mirror'), findsOneWidget);
    expect(find.text('Fixed'), findsOneWidget);
    expect(find.text('Smart'), findsOneWidget);
    expect(find.text('Copy Ratio mặc định'), findsOneWidget);
    expect(find.text('-10%'), findsOneWidget);
    expect(find.text('+20%'), findsOneWidget);
    expect(find.text('Giới hạn rủi ro'), findsOneWidget);
    expect(find.text('Circuit Breaker'), findsOneWidget);
  });

  testWidgets('SC-067 first viewport reaches risk limits section', (
    tester,
  ) async {
    await pumpCopySettings(tester);

    expectFirstViewportVisible(
      tester,
      find.text('Giới hạn rủi ro'),
      targetLabel: 'risk limits section',
    );
  });

  testWidgets('SC-067 copy mode buttons update fixed-ratio visibility', (
    tester,
  ) async {
    await pumpCopySettings(tester);

    await tester.tap(
      find.byKey(CopySettingsPage.modeKey(TradeCopySettingsMode.smart)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Copy Ratio mặc định'), findsNothing);

    await tester.tap(
      find.byKey(CopySettingsPage.modeKey(TradeCopySettingsMode.fixed)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Copy Ratio mặc định'), findsOneWidget);
  });

  testWidgets('SC-067 toggles circuit breaker and notification channels', (
    tester,
  ) async {
    await pumpCopySettings(tester);

    await tester.ensureVisible(find.byKey(CopySettingsPage.circuitBreakerKey));
    await tester.tap(find.byKey(CopySettingsPage.circuitBreakerKey));
    await tester.pumpAndSettle();

    expect(find.text('Ngưỡng kích hoạt'), findsNothing);

    await tester.ensureVisible(find.byKey(CopySettingsPage.emailChannelKey));
    await tester.tap(find.byKey(CopySettingsPage.emailChannelKey));
    await tester.pumpAndSettle();

    expect(find.text('Email'), findsWidgets);
  });

  testWidgets('SC-067 save action shows saved state', (tester) async {
    await pumpCopySettings(tester);

    await tester.ensureVisible(find.byKey(CopySettingsPage.saveKey));
    await tester.tap(find.byKey(CopySettingsPage.saveKey));
    await tester.pump();
    // Repo's default 300ms simulated network delay must elapse before the
    // save() Future resolves — advance the fake clock without running the
    // full pumpAndSettle (which would also fire the 2s "hide saved" Timer
    // and make the assertion below flaky).
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Đã lưu!'), findsOneWidget);
  });

  testWidgets('SC-067 back returns to SC-063 CopyTradingPage', (tester) async {
    await pumpCopySettings(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(CopySettingsPage), findsNothing);
  });
}
