import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/dashboard/bot_drawdown_analyzer_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotDrawdownAnalyzer(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotDrawdownAnalyzer,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-129 mock repository exposes drawdown analyzer BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotDrawdownAnalyzer();

    expect(snapshot.summary.maxDrawdownPct, -10.3);
    expect(snapshot.summary.avgDrawdownPct, -5.2);
    expect(snapshot.summary.drawdownDays, 9);
    expect(snapshot.underwaterPoints, hasLength(15));
    expect(snapshot.durationBuckets, hasLength(4));
    expect(snapshot.events, hasLength(5));
    expect(snapshot.insights, hasLength(4));
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-drawdown-analyzer');
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
    expect(snapshot.actionDraft, contains('POST /bots/create'));
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-129 renders drawdown analyzer baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotDrawdownAnalyzer(tester);

    expect(find.byType(BotDrawdownAnalyzerPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Phân tích sụt giảm vốn'), findsNWidgets(2));
    expect(find.text('Sụt tối đa'), findsOneWidget);
    expect(find.text('-10.3%'), findsWidgets);
    expect(find.text('Vốn trong giai đoạn sụt giảm'), findsOneWidget);
    expect(find.text('Phân bố thời gian sụt giảm vốn'), findsOneWidget);
    expect(find.text('Các đợt sụt giảm vốn lớn'), findsOneWidget);
    expect(find.text('Phân tích sụt giảm vốn'), findsNWidgets(2));
  });

  testWidgets('SC-129 first viewport reaches full drawdown summary', (
    tester,
  ) async {
    await pumpBotDrawdownAnalyzer(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BotDrawdownAnalyzerPage',
      semanticLabel: 'Phân tích mức sụt giảm vốn của bot',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Tần suất sụt giảm'),
      minVisibleHeight: 12,
      targetLabel: 'full drawdown summary',
      reason:
          'Drawdown analyzer should expose the complete compact summary '
          'metric grid above bottom navigation.',
    );
  });
}
