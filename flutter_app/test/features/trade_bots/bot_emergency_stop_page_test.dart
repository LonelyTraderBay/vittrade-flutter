import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_emergency_stop_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/hub/trading_bots_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpEmergencyStop(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotEmergencyStop,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-121 mock repository exposes emergency stop BE draft', () async {
    final repo = const MockTradeBotsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getBotEmergencyStop();
    final result = await repo.submitBotEmergencyStop(
      const TradeBotEmergencyStopDraft(
        reasonId: 'crash',
        closePositions: true,
        confirmed: true,
      ),
    );

    expect(snapshot.warningTitle, 'DỪNG KHẨN CẤP');
    expect(snapshot.bots, hasLength(3));
    expect(snapshot.reasons.map((item) => item.id), [
      'crash',
      'bug',
      'unauthorized',
      'drawdown',
      'other',
    ]);
    expect(snapshot.completionPath, '/trade/bots');
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-emergency-stop');
    expect(snapshot.actionDraft, contains('POST /bots/create'));
    expect(result.status, 'accepted');
    expect(result.stoppedBotCount, 3);
    expect(result.redirectPath, '/trade/bots');
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

  testWidgets('SC-121 renders emergency stop baseline in Trade shell', (
    tester,
  ) async {
    await pumpEmergencyStop(tester);

    expect(find.byType(BotEmergencyStopPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Dừng khẩn cấp'), findsOneWidget);
    expect(find.text('DỪNG KHẨN CẤP'), findsOneWidget);
    expect(find.text('Bot cần dừng (3)'), findsOneWidget);
    expect(find.text('DCA Bot #1'), findsOneWidget);
    expect(find.text('Lý do dừng khẩn cấp'), findsOneWidget);

    final button = tester.widget<VitCtaButton>(
      find.byKey(BotEmergencyStopPage.submitKey),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('SC-121 enables destructive action after reason and confirm', (
    tester,
  ) async {
    await pumpEmergencyStop(tester);

    await tester.tap(find.byKey(BotEmergencyStopPage.reasonKey('crash')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(BotEmergencyStopPage.confirmationKey),
    );
    await tester.tap(find.byKey(BotEmergencyStopPage.confirmationKey));
    await tester.pumpAndSettle();

    final button = tester.widget<VitCtaButton>(
      find.byKey(BotEmergencyStopPage.submitKey),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets(
    'SC-121 submit shows acknowledgement then returns to trading bots',
    (tester) async {
      await pumpEmergencyStop(tester);

      await tester.tap(find.byKey(BotEmergencyStopPage.reasonKey('crash')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(BotEmergencyStopPage.confirmationKey),
      );
      await tester.tap(find.byKey(BotEmergencyStopPage.confirmationKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(BotEmergencyStopPage.submitKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(BotEmergencyStopPage.dialogConfirmKey));
      await tester.pumpAndSettle();

      expect(find.text('Đã dừng khẩn cấp'), findsOneWidget);
      expect(find.text('Đã dừng 3 bot đang chạy.'), findsOneWidget);
      expect(find.byType(TradingBotsPage), findsNothing);

      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();

      expect(find.byType(TradingBotsPage), findsOneWidget);
    },
  );

  testWidgets('SC-121 first viewport keeps emergency action visible', (
    tester,
  ) async {
    await pumpEmergencyStop(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-121 BotEmergencyStopPage',
      semanticLabel: 'Dừng khẩn cấp toàn bộ bot giao dịch',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(const Key('sc121_bot_emergency_stop_warning')),
      routeName: 'SC-121 BotEmergencyStopPage',
      actionLabel: 'the emergency warning panel',
    );
  });
}
