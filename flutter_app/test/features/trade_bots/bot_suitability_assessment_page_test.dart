import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_suitability_assessment_page.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/hub/trading_bots_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSuitability(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotSuitabilityAssessment,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-119 mock repository exposes bot suitability BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotSuitabilityAssessment();

    expect(snapshot.questions, hasLength(8));
    expect(snapshot.questions.first.id, 'q1');
    expect(snapshot.questions.first.options, hasLength(4));
    expect(snapshot.maxScore, 24);
    expect(snapshot.pass.title, 'Phù hợp để dùng Bot giao dịch');
    expect(snapshot.warning.title, 'Nên thận trọng');
    expect(snapshot.fail.title, 'Không khuyến nghị');
    expect(snapshot.completionPath, AppRoutePaths.tradeBots);
    expect(
      snapshot.endpoint,
      '/api/mobile/trade/trade-bots-suitability-assessment',
    );
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

  testWidgets('SC-119 renders first assessment question in Trade shell', (
    tester,
  ) async {
    await pumpSuitability(tester);

    expect(find.byType(BotSuitabilityAssessmentPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đánh giá mức độ phù hợp'), findsOneWidget);
    expect(find.text('Question 1 of 8'), findsOneWidget);
    expect(find.text('0% Complete'), findsOneWidget);
    expect(
      find.text('Bạn đã giao dịch tiền mã hoá được bao lâu?'),
      findsOneWidget,
    );
    expect(find.text('Chưa từng giao dịch / Dưới 3 tháng'), findsOneWidget);
    expect(find.byKey(BotSuitabilityAssessmentPage.infoKey), findsOneWidget);
  });

  testWidgets('SC-119 first viewport reaches the first answer option', (
    tester,
  ) async {
    await pumpSuitability(tester);

    expectActionableInFirstViewport(
      tester,
      find.byKey(BotSuitabilityAssessmentPage.optionKey('q1', 'a')),
      routeName: 'BotSuitabilityAssessmentPage',
      actionLabel: 'first answer option',
    );
  });

  testWidgets('SC-119 pass result continues to Trading Bots', (tester) async {
    await pumpSuitability(tester);

    for (var index = 1; index <= 8; index += 1) {
      await tester.tap(
        find.byKey(BotSuitabilityAssessmentPage.optionKey('q$index', 'd')),
      );
      await tester.pumpAndSettle();
    }

    expect(find.text('Kết quả đánh giá'), findsOneWidget);
    expect(find.text('Phù hợp để dùng Bot giao dịch'), findsOneWidget);
    expect(find.text('24 / 24'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(BotSuitabilityAssessmentPage.resultCtaKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BotSuitabilityAssessmentPage.resultCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradingBotsPage), findsOneWidget);
  });
}
